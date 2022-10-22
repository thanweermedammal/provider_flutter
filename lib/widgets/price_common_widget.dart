import 'package:flutter/material.dart';
import 'package:handyman_provider_flutter/components/price_widget.dart';
import 'package:handyman_provider_flutter/main.dart';
import 'package:handyman_provider_flutter/models/booking_detail_response.dart';
import 'package:handyman_provider_flutter/models/booking_list_response.dart';
import 'package:handyman_provider_flutter/models/service_model.dart';
import 'package:handyman_provider_flutter/utils/colors.dart';
import 'package:handyman_provider_flutter/utils/common.dart';
import 'package:handyman_provider_flutter/utils/constant.dart';
import 'package:handyman_provider_flutter/utils/extensions/context_ext.dart';
import 'package:handyman_provider_flutter/utils/model_keys.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';

class PriceCommonWidget extends StatelessWidget {
  const PriceCommonWidget({
    Key? key,
    required this.bookingDetail,
    required this.serviceDetail,
    required this.taxes,
    required this.couponData,
  }) : super(key: key);

  final BookingDetail bookingDetail;
  final Service serviceDetail;
  final List<Taxes> taxes;
  final CouponData? couponData;

  String price(num price) {
    var formatter = NumberFormat('#,##,000.00');
    return formatter.format(price);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //price details

        Text(context.translate.lblPriceDetail, style: boldTextStyle(size: 18)),
        16.height,
        Container(
          padding: EdgeInsets.all(16),
          width: context.width(),
          decoration: boxDecorationWithRoundedCorners(backgroundColor: context.cardColor, borderRadius: radius()),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(context.translate.hintPrice, style: boldTextStyle()).expand(),
                  PriceWidget(price: serviceDetail.price.validate(), color: textSecondaryColorGlobal, isBoldText: false, size: 18).flexible(),
                ],
              ),
              if (bookingDetail.type == ServiceTypeFixed)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Divider(height: 26),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(context.translate.lblSubTotal, style: boldTextStyle()),
                        8.width,
                        Text(
                          '${appStore.currencySymbol}${price(serviceDetail.price.validate())} * ${bookingDetail.quantity} = ${appStore.currencySymbol}${(price(serviceDetail.price.validate() * bookingDetail.quantity.validate()))}',
                          style: secondaryTextStyle(size: 18),
                        ).flexible(),
                      ],
                    ),
                  ],
                ),
              if (taxes.isNotEmpty) Divider(height: 26),
              if (taxes.isNotEmpty)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(context.translate.lblTax, style: boldTextStyle()).expand(),
                    PriceWidget(price: serviceDetail.taxAmount.validate(), color: Colors.red, isBoldText: false, size: 18).flexible(),
                  ],
                ),
              if (serviceDetail.discountPrice.validate() != 0 && serviceDetail.discount.validate() != 0)
                Column(
                  children: [
                    Divider(height: 26),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(context.translate.hintDiscount, style: boldTextStyle()),
                            Text(
                              " (${serviceDetail.discount.validate()}% ${context.translate.lblOff})",
                              style: boldTextStyle(color: Colors.green),
                            ),
                          ],
                        ),
                        PriceWidget(
                          price: serviceDetail.discountPrice.validate(),
                          color: Colors.green,
                          isBoldText: false,
                          isDiscountedPrice: true,
                          size: 18,
                        ).flexible(),
                      ],
                    ),
                  ],
                ),
              if (couponData != null) Divider(height: 26),
              if (couponData != null)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(context.translate.lblCoupon, style: boldTextStyle()),
                        Text(" (${couponData!.code})", style: boldTextStyle(color: primaryColor)),
                      ],
                    ),
                    PriceWidget(
                      price: serviceDetail.couponDiscountAmount.validate(),
                      color: Colors.green,
                      isBoldText: false,
                      size: 18,
                    ).flexible(),
                  ],
                ),
              Divider(height: 26),
              Row(
                children: [
                  Text(context.translate.lblTotalAmount, style: boldTextStyle()).expand(),
                  if (bookingDetail.type == ServiceTypeHourly) Text('(${appStore.currencySymbol}${bookingDetail.price}/hr) ', style: secondaryTextStyle()),
                  PriceWidget(price: getTotalValue, color: primaryColor, size: 18),
                ],
              ),
              if (bookingDetail.type == ServiceTypeHourly && bookingDetail.status == BookingStatusKeys.complete)
                Align(
                  alignment: Alignment.centerRight,
                  child: Column(
                    children: [
                      6.height,
                      Text(
                        "${context.translate.lblOnBasisOf} ${calculateTimer(bookingDetail.durationDiff.validate().toInt())} ${getMinHour(durationDiff: bookingDetail.durationDiff.validate())}",
                        style: secondaryTextStyle(),
                        textAlign: TextAlign.right,
                      ),
                    ],
                  ),
                ),
            ],
          ),
        )
      ],
    );
  }

  num get getTotalValue {
    if (bookingDetail.type == ServiceTypeHourly && bookingDetail.status == BookingStatusKeys.complete) {
      return hourlyCalculation(
        price: calculateTotalAmount(
          serviceDiscountPercent: serviceDetail.discount.validate(),
          qty: bookingDetail.quantity!.toInt(),
          detail: serviceDetail,
          servicePrice: serviceDetail.price!,
          taxes: taxes,
          couponData: couponData,
        ),
        secTime: bookingDetail.durationDiff.validate().toInt(),
      );
    }
    return calculateTotalAmount(
      serviceDiscountPercent: serviceDetail.discount.validate(),
      qty: bookingDetail.quantity.validate().toInt(),
      detail: serviceDetail,
      servicePrice: serviceDetail.price!,
      taxes: taxes,
      couponData: couponData,
    );
  }

  String getMinHour({required String durationDiff}) {
    String totalTime = calculateTimer(durationDiff.toInt());
    List<String> totalHours = totalTime.split(":");
    if (totalHours.first == "00") {
      return "min";
    } else {
      return "hour";
    }
  }
}
