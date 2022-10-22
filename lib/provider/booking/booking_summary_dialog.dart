import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:handyman_provider_flutter/components/price_widget.dart';
import 'package:handyman_provider_flutter/main.dart';
import 'package:handyman_provider_flutter/models/booking_list_response.dart';
import 'package:handyman_provider_flutter/networks/rest_apis.dart';
import 'package:handyman_provider_flutter/utils/colors.dart';
import 'package:handyman_provider_flutter/utils/common.dart';
import 'package:handyman_provider_flutter/utils/constant.dart';
import 'package:handyman_provider_flutter/utils/extensions/context_ext.dart';
import 'package:handyman_provider_flutter/utils/model_keys.dart';
import 'package:handyman_provider_flutter/widgets/app_widgets.dart';
import 'package:nb_utils/nb_utils.dart';

class BookingSummaryDialog extends StatefulWidget {
  final BookingData? bookingDataList;
  final int? bookingId;
  final Function? onUpdate;

  BookingSummaryDialog({this.bookingDataList, this.onUpdate, this.bookingId});

  @override
  _BookingSummaryDialogState createState() => _BookingSummaryDialogState();
}

class _BookingSummaryDialogState extends State<BookingSummaryDialog> {
  void updateBooking() {
    var request = {
      CommonKeys.id: widget.bookingId.validate(),
      BookingUpdateKeys.status: BookingStatusKeys.accept,
    };
    appStore.setLoading(true);

    bookingUpdate(request).then((res) async {
      finish(context);

      LiveStream().emit(LiveStreamUpdateBookings);

      appStore.setLoading(false);
    }).catchError((e) {
      finish(context);
      appStore.setLoading(false);
      toast(e.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: context.height() * 0.8,
      width: context.width(),
      color: Colors.transparent,
      child: Stack(
        children: [
          Container(
            decoration: boxDecorationDefault(
              color: context.cardColor,
              borderRadius: radius(),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  decoration: boxDecorationWithRoundedCorners(
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
                    backgroundColor: primaryColor,
                  ),
                  padding: EdgeInsets.only(left: 24, right: 8, bottom: 8, top: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(context.translate.lblBookingSummary, style: boldTextStyle(color: white, size: 18)),
                      IconButton(
                        onPressed: () {
                          finish(context);
                        },
                        icon: Icon(Icons.close, size: 22, color: white),
                      ),
                    ],
                  ),
                ),
                SingleChildScrollView(
                  padding: EdgeInsets.only(right: 16, left: 16, top: 16, bottom: 74),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (widget.bookingDataList!.image_attchments.validate().isNotEmpty)
                        Column(
                          children: [
                            cachedImage(
                              widget.bookingDataList!.image_attchments!.isNotEmpty ? widget.bookingDataList!.image_attchments!.first.validate() : "",
                              fit: BoxFit.cover,
                              height: 150,
                              width: context.width(),
                            ).cornerRadiusWithClipRRect(defaultRadius),
                            24.height,
                          ],
                        ),
                      Text(widget.bookingDataList!.service_name.validate(), style: boldTextStyle(size: 18)),
                      8.height,
                      Row(
                        children: [
                          PriceWidget(
                            price: calculateTotalAmount(
                              servicePrice: widget.bookingDataList!.price.validate(),
                              qty: widget.bookingDataList!.quantity.validate(),
                              couponData: widget.bookingDataList!.couponData != null ? widget.bookingDataList!.couponData : null,
                              taxes: widget.bookingDataList!.taxes.validate(),
                              serviceDiscountPercent: widget.bookingDataList!.discount.validate(),
                            ),
                            isHourlyService: widget.bookingDataList!.isHourlyService,
                            color: context.primaryColor,
                            size: 18,
                          ),
                          8.width,
                          if (widget.bookingDataList!.discount.validate() != 0)
                            Row(
                              children: [
                                Text('(${widget.bookingDataList!.discount}%', style: boldTextStyle(size: 14, color: Colors.green)),
                                Text(' 0ff)', style: boldTextStyle(size: 14, color: Colors.green)),
                              ],
                            ),
                        ],
                      ),
                      24.height,
                      if (widget.bookingDataList!.date.validate().isNotEmpty)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(context.translate.lblDate, style: boldTextStyle()),
                            Text(
                              formatDate(widget.bookingDataList!.date.validate(), format: DATE_FORMAT_2),
                              style: secondaryTextStyle(),
                              textAlign: TextAlign.right,
                            ),
                          ],
                        ),
                      8.height,
                      Divider(thickness: 1),
                      8.height,
                      if (widget.bookingDataList!.date.validate().isNotEmpty)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(context.translate.lblTime, style: boldTextStyle()),
                            Text(
                              formatDate(widget.bookingDataList!.date.validate(), format: DATE_FORMAT_3),
                              style: secondaryTextStyle(),
                              textAlign: TextAlign.right,
                            ),
                          ],
                        ),
                      8.height,
                      Divider(thickness: 1),
                      8.height,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(context.translate.lblLocation, style: boldTextStyle()).expand(),
                          Text(
                            widget.bookingDataList!.address.validate(),
                            style: secondaryTextStyle(),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.right,
                          ).expand(),
                        ],
                      ),
                      8.height,
                      Divider(thickness: 1),
                      8.height,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(context.translate.lblServiceStatus, style: boldTextStyle()),
                          Text(widget.bookingDataList!.status_label.validate(), style: secondaryTextStyle()),
                        ],
                      ),
                      8.height,
                      Divider(thickness: 1),
                      8.height,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(context.translate.quantity, style: boldTextStyle()),
                          Text(
                            widget.bookingDataList!.quantity.validate().toString().isNotEmpty ? '*' + widget.bookingDataList!.quantity.validate().toString() : context.translate.notAvailable,
                            style: secondaryTextStyle(),
                          ),
                        ],
                      ),
                      8.height,
                      Divider(thickness: 1),
                      8.height,
                      if (widget.bookingDataList!.payment_status.validate().isNotEmpty)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(context.translate.paymentStatus, style: boldTextStyle()),
                            Text(widget.bookingDataList!.payment_status.validate(), style: secondaryTextStyle()),
                          ],
                        ),
                      if (widget.bookingDataList!.payment_status.validate().isNotEmpty) 32.height,
                    ],
                  ),
                ).expand(),
              ],
            ),
          ),
          Positioned(
            bottom: 24,
            left: 16,
            right: 16,
            child: AppButton(
              color: primaryColor,
              padding: EdgeInsets.symmetric(vertical: 16),
              elevation: 0,
              onTap: () {
                updateBooking();
              },
              child: Text(context.translate.confirm, style: boldTextStyle(color: white)),
            ),
          ),
          Observer(
            builder: (context) {
              return LoaderWidget().withSize(height: 60, width: 60).center().visible(appStore.isLoading);
            },
          )
        ],
      ),
    );
  }
}
