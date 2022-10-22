import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:handyman_provider_flutter/main.dart';
import 'package:handyman_provider_flutter/models/dashboard_response.dart';
import 'package:handyman_provider_flutter/networks/rest_apis.dart';
import 'package:handyman_provider_flutter/provider/dashboard/component/chart_component.dart';
import 'package:handyman_provider_flutter/provider/dashboard/component/commission_component.dart';
import 'package:handyman_provider_flutter/provider/dashboard/component/handyman_list_component.dart';
import 'package:handyman_provider_flutter/provider/dashboard/component/services_list_component.dart';
import 'package:handyman_provider_flutter/provider/dashboard/component/total_component.dart';
import 'package:handyman_provider_flutter/provider/subscription/pricing_plan_screen.dart';
import 'package:handyman_provider_flutter/utils/app_common.dart';
import 'package:handyman_provider_flutter/utils/common.dart';
import 'package:handyman_provider_flutter/utils/constant.dart';
import 'package:handyman_provider_flutter/utils/extensions/context_ext.dart';
import 'package:handyman_provider_flutter/widgets/app_widgets.dart';
import 'package:nb_utils/nb_utils.dart';

class HomeFragment extends StatefulWidget {
  @override
  _HomeFragmentState createState() => _HomeFragmentState();
}

class _HomeFragmentState extends State<HomeFragment> {
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    //
  }

  Widget _buildHeaderWidget(DashboardResponse data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        16.height,
        Text("${context.translate.lblHello}, ${appStore.userFullName}", style: boldTextStyle(size: 20)).paddingLeft(16),
        8.height,
        Text(context.translate.lblWelcomeBack, style: secondaryTextStyle(size: 16)).paddingLeft(16),
      ],
    );
  }

  Widget planBanner(DashboardResponse data) {
    if (data.isPlanExpired!) {
      return subSubscriptionPlanWidget(
        planBgColor: appStore.isDarkMode ? context.cardColor : Colors.red.shade50,
        planTitle: context.translate.lblPlanExpired,
        planSubtitle: context.translate.lblPlanSubTitle,
        planButtonTxt: context.translate.btnTxtBuyNow,
        btnColor: Colors.red,
        onTap: () {
          PricingPlanScreen().launch(context);
        },
      );
    } else if (data.userNeverPurchasedPlan!) {
      return subSubscriptionPlanWidget(
        planBgColor: appStore.isDarkMode ? context.cardColor : Colors.red.shade50,
        planTitle: context.translate.lblChooseYourPlan,
        planSubtitle: context.translate.lblRenewSubTitle,
        planButtonTxt: context.translate.btnTxtBuyNow,
        btnColor: Colors.red,
        onTap: () {
          PricingPlanScreen().launch(context);
        },
      );
    } else if (data.isPlanAboutToExpire!) {
      int days = getRemainingPlanDays();

      if (days != 0 && days <= planRemainingDays) {
        return subSubscriptionPlanWidget(
          planBgColor: appStore.isDarkMode ? context.cardColor : Colors.orange.shade50,
          planTitle: context.translate.lblReminder,
          planSubtitle: context.translate.planAboutToExpire(days),
          planButtonTxt: context.translate.lblRenew,
          btnColor: Colors.orange,
          onTap: () {
            PricingPlanScreen().launch(context);
          },
        );
      } else {
        return SizedBox();
      }
    } else {
      return SizedBox();
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        setState(() {});
        return await 2.seconds.delay;
      },
      child: Scaffold(
        body: Stack(
          children: [
            FutureBuilder<DashboardResponse>(
              future: providerDashboard(),
              builder: (context, snap) {
                if (snap.hasError) {
                  return Text(snap.error.toString()).center();
                } else if (snap.hasData) {
                  return SingleChildScrollView(
                    padding: EdgeInsets.only(bottom: 16),
                    physics: AlwaysScrollableScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if ((snap.data!.earningType == EARNING_TYPE_SUBSCRIPTION))
                          Observer(
                            builder: (context) {
                              return planBanner(snap.data!);
                            },
                          ),
                        Observer(builder: (_) => _buildHeaderWidget(snap.data!)),
                        if (snap.data!.earningType == EARNING_TYPE_COMMISSION) CommissionComponent(commission: snap.data!.commission!),
                        TotalComponent(snap: snap.data!),
                        8.height,
                        ChartComponent(),
                        16.height,
                        if (snap.data!.handyman.validate().isNotEmpty) HandymanListComponent(list: snap.data!.handyman.validate()),
                        if (snap.data!.service.validate().isNotEmpty) ServiceListComponent(list: snap.data!.service.validate()),
                      ],
                    ),
                  );
                }

                return snapWidgetHelper(snap, loadingWidget: LoaderWidget());
              },
            ),
            Observer(builder: (context) => LoaderWidget().visible(appStore.isLoading))
          ],
        ),
      ),
    );
  }
}
