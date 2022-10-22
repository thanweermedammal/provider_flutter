import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:handyman_provider_flutter/components/back_widget.dart';
import 'package:handyman_provider_flutter/components/booking_history_component.dart';
import 'package:handyman_provider_flutter/main.dart';
import 'package:handyman_provider_flutter/models/booking_detail_response.dart';
import 'package:handyman_provider_flutter/models/service_model.dart';
import 'package:handyman_provider_flutter/networks/rest_apis.dart';
import 'package:handyman_provider_flutter/provider/services/service_detail_screen.dart';
import 'package:handyman_provider_flutter/utils/colors.dart';
import 'package:handyman_provider_flutter/utils/common.dart';
import 'package:handyman_provider_flutter/utils/constant.dart';
import 'package:handyman_provider_flutter/utils/extensions/context_ext.dart';
import 'package:handyman_provider_flutter/utils/model_keys.dart';
import 'package:handyman_provider_flutter/widgets/app_widgets.dart';
import 'package:nb_utils/nb_utils.dart';

class CommonBookingDetailScreen extends StatefulWidget {
  final int? bookingId;

  CommonBookingDetailScreen({required this.bookingId});

  @override
  CommonBookingDetailScreenState createState() => CommonBookingDetailScreenState();
}

class CommonBookingDetailScreenState extends State<CommonBookingDetailScreen> {
  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    //
  }

  Widget serviceDetailWidget({required BookingDetail bookingDetail, required Service serviceDetail}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(serviceDetail.name!.validate(), style: boldTextStyle(size: 20)),
            16.height,
            if ((bookingDetail.date.validate().isNotEmpty))
              Row(
                children: [
                  Text("${context.translate.lblDate} : ", style: boldTextStyle()),
                  Text(
                    formatDate(bookingDetail.date.validate(), format: DATE_FORMAT_2),
                    style: secondaryTextStyle(),
                  ),
                ],
              ),
            8.height,
            if ((bookingDetail.date.validate().isNotEmpty))
              Row(
                children: [
                  Text("${context.translate.lblTime} : ", style: boldTextStyle()),
                  Text(
                    formatDate(bookingDetail.date.validate(), format: DATE_FORMAT_3),
                    style: secondaryTextStyle(),
                  ),
                ],
              ),
          ],
        ).expand(),
        cachedImage(
          serviceDetail.attchments!.isNotEmpty ? serviceDetail.attchments!.first.url.validate() : "",
          fit: BoxFit.cover,
          height: 90,
          width: 90,
        ).cornerRadiusWithClipRRect(8),
      ],
    ).onTap(() {
      ServiceDetailScreen(
        serviceId: bookingDetail.serviceId.validate(),
      ).launch(context, pageRouteAnimation: PageRouteAnimation.Slide);
    });
  }

  Widget _buildReasonWidget({required BookingDetailResponse snap}) {
    if (((snap.bookingDetail!.status == BookingStatusKeys.cancelled || snap.bookingDetail!.status == BookingStatusKeys.rejected || snap.bookingDetail!.status == BookingStatusKeys.failed) &&
        ((snap.bookingDetail!.reason != null && snap.bookingDetail!.reason!.isNotEmpty))))
      return Container(
        padding: EdgeInsets.all(16),
        color: redColor.withOpacity(0.1),
        width: context.width(),
        child: Text(
          '${context.translate.lblReason}: ${snap.bookingDetail!.reason.validate()}',
          style: primaryTextStyle(color: redColor, size: 18),
        ),
      );

    return SizedBox();
  }

  Widget _action({required BookingDetailResponse bookDetail}) {
    return Container();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    Widget buildBodyWidget(AsyncSnapshot<BookingDetailResponse> snap) {
      if (snap.hasError) {
        return Text(snap.error.toString()).center();
      } else if (snap.hasData) {
        return Stack(
          children: [
            Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildReasonWidget(snap: snap.data!),
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                        width: context.height(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            8.height,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  context.translate.lblBookingID,
                                  style: boldTextStyle(size: 16, color: appStore.isDarkMode ? white : gray.withOpacity(0.8)),
                                ),
                                Text('#' + snap.data!.bookingDetail!.id.toString().validate(), style: boldTextStyle(color: primaryColor, size: 18)),
                              ],
                            ),
                            16.height,
                            Divider(height: 0),
                            24.height,
                            serviceDetailWidget(serviceDetail: snap.data!.service!, bookingDetail: snap.data!.bookingDetail!)
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Positioned(
                  bottom: 16,
                  left: 16,
                  right: 16,
                  child: _action(bookDetail: snap.data!),
                )
              ],
            ),
            Observer(
              builder: (context) => LoaderWidget().visible(appStore.isLoading),
            )
          ],
        );
      }
      return LoaderWidget().center();
    }

    return FutureBuilder<BookingDetailResponse>(
      future: bookingDetail({
        CommonKeys.bookingId: widget.bookingId.toString(),
      }),
      builder: (context, snap) {
        return RefreshIndicator(
          onRefresh: () async {
            setState(() {});
            return await 2.seconds.delay;
          },
          child: Scaffold(
            appBar: appBarWidget(snap.hasData ? snap.data!.bookingDetail!.statusLabel.validate() : "",
                color: context.primaryColor,
                textColor: Colors.white,
                showBack: true,
                backWidget: BackWidget(),
                actions: [
                  TextButton(
                    onPressed: () {
                      showModalBottomSheet(
                        backgroundColor: Colors.transparent,
                        context: context,
                        isScrollControlled: true,
                        isDismissible: true,
                        builder: (_) {
                          return DraggableScrollableSheet(
                            initialChildSize: 0.50,
                            minChildSize: 0.2,
                            maxChildSize: 1,
                            builder: (context, scrollController) => BookingHistoryComponent(
                              data: snap.data!.bookingActivity!.reversed.toList(),
                              scrollController: scrollController,
                            ),
                          );
                        },
                      );
                    },
                    child: Text(context.translate.lblCheckStatus, style: boldTextStyle(color: white)),
                  ).paddingRight(8),
                ]),
            body: buildBodyWidget(snap),
          ),
        );
      },
    );
  }
}
