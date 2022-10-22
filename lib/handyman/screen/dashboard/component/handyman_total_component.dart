import 'package:flutter/material.dart';
import 'package:handyman_provider_flutter/handyman/screen/widget/handyman_total_widget.dart';
import 'package:handyman_provider_flutter/main.dart';
import 'package:handyman_provider_flutter/models/handyman_dashboard_response.dart';
import 'package:handyman_provider_flutter/screens/total_earning_screen.dart';
import 'package:handyman_provider_flutter/utils/constant.dart';
import 'package:handyman_provider_flutter/utils/extensions/context_ext.dart';
import 'package:handyman_provider_flutter/utils/images.dart';
import 'package:nb_utils/nb_utils.dart';

class HandymanTotalComponent extends StatelessWidget {
  final HandymanDashBoardResponse snap;

  HandymanTotalComponent({required this.snap});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: [
        HandymanTotalWidget(
          title: context.translate.lblTotalRevenue,
          total: "${appStore.currencySymbol}${snap.total_revenue.validate().toStringAsFixed(decimalPoint).formatNumberWithComma()}",
          icon: percent_line,
        ).onTap(
          () {
            TotalEarningScreen().launch(context);
          },
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
        ),
        HandymanTotalWidget(
          title: context.translate.lblTotalService,
          total: snap.total_booking.validate().toString(),
          icon: total_services,
        ).onTap(
          () {
            LiveStream().emit(handymanAllBooking, 1);
          },
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
        ),
        HandymanTotalWidget(
          title: context.translate.lblUpcomingServices,
          total: snap.upcomming_booking.validate().toString(),
          icon: total_services,
        ).onTap(
          () {
            LiveStream().emit(HandyBoardStream, 1);
          },
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
        ),
        HandymanTotalWidget(
          title: context.translate.lblTodayServices,
          total: snap.today_booking.validate().toString(),
          icon: total_services,
        ).onTap(
          () {
            LiveStream().emit(handymanAllBooking, 1);
          },
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
        ),
      ],
    ).paddingAll(16);
  }
}
