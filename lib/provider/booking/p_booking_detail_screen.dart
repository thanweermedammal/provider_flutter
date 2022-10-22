import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:handyman_provider_flutter/components/back_widget.dart';
import 'package:handyman_provider_flutter/components/basic_info_component.dart';
import 'package:handyman_provider_flutter/components/booking_history_component.dart';
import 'package:handyman_provider_flutter/components/countdown_widget.dart';
import 'package:handyman_provider_flutter/main.dart';
import 'package:handyman_provider_flutter/models/booking_detail_response.dart';
import 'package:handyman_provider_flutter/models/service_detail_response.dart';
import 'package:handyman_provider_flutter/models/service_model.dart';
import 'package:handyman_provider_flutter/models/user_data.dart';
import 'package:handyman_provider_flutter/networks/rest_apis.dart';
import 'package:handyman_provider_flutter/provider/handyman/assign_handyman_Dialog.dart';
import 'package:handyman_provider_flutter/provider/handyman/handyman_info_screen.dart';
import 'package:handyman_provider_flutter/provider/review/rating_view_all_screen.dart';
import 'package:handyman_provider_flutter/provider/services/service_detail_screen.dart';
import 'package:handyman_provider_flutter/utils/colors.dart';
import 'package:handyman_provider_flutter/utils/common.dart';
import 'package:handyman_provider_flutter/utils/constant.dart';
import 'package:handyman_provider_flutter/utils/extensions/context_ext.dart';
import 'package:handyman_provider_flutter/utils/model_keys.dart';
import 'package:handyman_provider_flutter/utils/widget/service_proof_list_widget.dart';
import 'package:handyman_provider_flutter/widgets/app_widgets.dart';
import 'package:handyman_provider_flutter/widgets/price_common_widget.dart';
import 'package:handyman_provider_flutter/widgets/review_list_widget.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';

class BookingDetailScreen extends StatefulWidget {
  final int? bookingId;

  BookingDetailScreen({this.bookingId});

  @override
  BookingDetailScreenState createState() => BookingDetailScreenState();
}

class BookingDetailScreenState extends State<BookingDetailScreen> {
  BookingDetailResponse? bookingDetailResponse;
  CouponData? couponData;
  BookingDetail _bookingDetail = BookingDetail();
  UserData _customer = UserData();
  ProviderData providerData = ProviderData();
  Service service = Service();

  List<BookingActivity> bookingActivity = [];
  List<UserData> handymanData = [];
  List<Attachments>? attachments = [];
  List<ServiceProof> serviceProofList = [];

  String? positiveBtnTxt = '';
  String? negativeBtnTxt = '';

  String? startDateTime = '';
  String? timeInterval = '0';
  String? endDateTime = '';
  String? paymentStatus = '';

  String data = "";

  bool visibleBottom = false;
  bool isAssigned = false;

  //live stream
  bool? clicked = false;
  int tabIndex = -1;

  @override
  void initState() {
    super.initState();
    afterBuildCreated(() {
      appStore.setLoading(true);
      init();
    });
  }

  Future<void> init() async {
    setStatusBarColor(primaryColor);
    await loadBookingDetail();
  }

  Future<void> loadBookingDetail() async {
    Map request = {CommonKeys.bookingId: widget.bookingId.toString()};

    await bookingDetail(request).then((value) {
      bookingDetailResponse = value;
      _bookingDetail = value.bookingDetail!;
      _customer = value.customer!;
      attachments = value.service!.attchments;
      providerData = value.providerData!;
      service = value.service!;
      handymanData = value.handymanData!;

      calculateTotalAmount(
        serviceDiscountPercent: bookingDetailResponse!.service!.discount.validate(),
        qty: bookingDetailResponse!.bookingDetail!.quantity.validate(),
        detail: bookingDetailResponse!.service,
        servicePrice: bookingDetailResponse!.service!.price.validate(),
        taxes: bookingDetailResponse!.bookingDetail!.taxes.validate(),
        couponData: bookingDetailResponse!.couponData,
      ).toStringAsFixed(decimalPoint);

      if (_bookingDetail.status == BookingStatusKeys.accept) {
        positiveBtnTxt = context.translate.lblReady;
        negativeBtnTxt = context.translate.lblCancel;
      }

      if (value.couponData != null) couponData = value.couponData;
      if (value.serviceProof != null) serviceProofList = value.serviceProof.validate();
      bookingActivity = value.bookingActivity!;

      if (handymanData.isNotEmpty) {
        isAssigned = true;
      }
      setBottom();
      setState(() {});
      appStore.setLoading(false);
    }).catchError((e) {
      appStore.setLoading(false);
    });
  }

  //set bottom
  void setBottom() {
    setState(() {
      if (_bookingDetail.status == BookingStatusKeys.pending) {
        positiveBtnTxt = context.translate.accept;
        negativeBtnTxt = context.translate.decline;
        visibleBottom = true;
      } else if (_bookingDetail.status == BookingStatusKeys.accept) {
        positiveBtnTxt = context.translate.lblAssignHandyman;
        visibleBottom = true;
      } else {
        visibleBottom = false;
      }
    });
  }

  Future<void> updateBooking(int? bookingId, String updateReason, String updatedStatus) async {
    DateTime now = DateTime.now();
    if (updatedStatus == BookingStatusKeys.rejected) {
      startDateTime = _bookingDetail.startAt.validate().isNotEmpty ? _bookingDetail.startAt.validate() : _bookingDetail.date.validate();
      endDateTime = DateFormat('yyyy-MM-dd kk:mm:ss').format(now);
      timeInterval = _bookingDetail.durationDiff.toString();
      paymentStatus = _bookingDetail.paymentStatus.validate();
      //
    }
    var request = {
      CommonKeys.id: bookingId,
      BookingUpdateKeys.startAt: startDateTime,
      BookingUpdateKeys.endAt: endDateTime,
      BookingUpdateKeys.durationDiff: timeInterval,
      BookingUpdateKeys.reason: updateReason,
      BookingUpdateKeys.status: updatedStatus,
      BookingUpdateKeys.paymentStatus: paymentStatus
    };
    log(request);
    await bookingUpdate(request).then((res) async {
      await loadBookingDetail();

      LiveStream().emit(LiveStreamUpdateBookings);
    }).catchError((e) {
      toast(e.toString(), print: true);
      appStore.setLoading(false);
    });
  }

  //confirmation Alert
  Future<void> confirmationRequestDialog(BuildContext context, String status) async {
    showConfirmDialogCustom(
      context,
      primaryColor: primaryColor,
      positiveText: context.translate.lblYes,
      negativeText: context.translate.lblNo,
      onAccept: (context) async {
        if (status == BookingStatusKeys.pending) {
          appStore.setLoading(true);
          updateBooking(_bookingDetail.id, '', BookingStatusKeys.accept);
        } else if (status == BookingStatusKeys.rejected) {
          updateBooking(_bookingDetail.id, '', BookingStatusKeys.rejected);
        }
      },
      title: context.translate.confirmationRequestTxt,
    );
  }

  Future<void> assignBookingDialog(BuildContext context, int? bookingId, int? addressId) async {
    showDialog(
      context: context,
      builder: (context) {
        return AssignHandymanDialog(
          bookingId: bookingId,
          serviceAddressId: addressId,
          onUpdate: () {
            isAssigned = true;
            loadBookingDetail();

            LiveStream().emit(LiveStreamUpdateBookings);

            setState(() {});
          },
        );
      },
    );
  }

  Widget _buildCounterWidget({required BookingDetailResponse value}) {
    if (value.bookingDetail!.isHourlyService &&
        (value.bookingDetail!.status == BookingStatusKeys.inProgress ||
            value.bookingDetail!.status == BookingStatusKeys.hold ||
            value.bookingDetail!.status == BookingStatusKeys.complete ||
            value.bookingDetail!.status == BookingStatusKeys.onGoing))
      return Column(
        children: [
          16.height,
          CountdownWidget(bookingDetailResponse: value),
        ],
      );
    else
      return Offstage();
  }

  Widget _buildReasonWidget({required BookingDetailResponse snap}) {
    if (((snap.bookingDetail!.status == BookingStatusKeys.cancelled || snap.bookingDetail!.status == BookingStatusKeys.rejected || snap.bookingDetail!.status == BookingStatusKeys.failed) &&
        ((snap.bookingDetail!.reason != null && snap.bookingDetail!.reason!.isNotEmpty))))
      return Container(
        padding: EdgeInsets.all(16),
        color: redColor.withOpacity(0.08),
        width: context.width(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(getReasonText(context, snap.bookingDetail!.status.validate()), style: primaryTextStyle(color: redColor, size: 18)),
            6.height,
            Text('${snap.bookingDetail!.reason.validate()}', style: secondaryTextStyle()),
          ],
        ),
      );

    return SizedBox();
  }

  Widget customerReviewWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        16.height,
        if (bookingDetailResponse!.ratingData!.isNotEmpty)
          Row(
            children: [
              Text('${context.translate.review}', style: boldTextStyle(size: 18)).expand(),
              TextButton(
                onPressed: () {
                  RatingViewAllScreen(serviceId: bookingDetailResponse!.service!.id!).launch(context);
                },
                child: Text(context.translate.viewAll, style: secondaryTextStyle()),
              ),
            ],
          ),
        8.height,
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: bookingDetailResponse!.ratingData!.length,
          itemBuilder: (context, index) {
            RatingData data = bookingDetailResponse!.ratingData![index];

            return ReviewListWidget(ratingData: data);
          },
        ),
      ],
    );
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        return await init();
      },
      child: Scaffold(
        appBar: bookingDetailResponse != null
            ? appBarWidget(
                _bookingDetail.statusLabel.validate(),
                showBack: true,
                titleTextStyle: boldTextStyle(size: 18, color: Colors.white),
                color: context.primaryColor,
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
                              data: bookingActivity.reversed.toList(),
                              scrollController: scrollController,
                            ),
                          );
                        },
                      );
                    },
                    child: Text(context.translate.lblCheckStatus, style: boldTextStyle(color: white)),
                  ).paddingRight(8),
                ],
              )
            : null,
        body: Observer(
          builder: (_) => Stack(
            children: [
              if (widget.bookingId != null && bookingDetailResponse != null)
                SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      _buildReasonWidget(snap: bookingDetailResponse!),
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
                                Text('#' + widget.bookingId.toString().validate(), style: boldTextStyle(color: primaryColor, size: 18)),
                              ],
                            ),
                            16.height,
                            Divider(height: 0),
                            16.height,
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(_bookingDetail.serviceName.validate(), style: boldTextStyle(size: 20)),
                                    16.height,
                                    Row(
                                      children: [
                                        Text("${context.translate.lblDate}: ", style: secondaryTextStyle()),
                                        _bookingDetail.date.validate().isNotEmpty
                                            ? Text(
                                                formatDate(_bookingDetail.date.validate(), format: DATE_FORMAT_2),
                                                style: boldTextStyle(size: 14),
                                              )
                                            : SizedBox(),
                                      ],
                                    ).visible(_bookingDetail.date.validate().isNotEmpty),
                                    8.height,
                                    if (_bookingDetail.date.validate().isNotEmpty)
                                      Row(
                                        children: [
                                          Text("${context.translate.lblTime}: ", style: secondaryTextStyle()),
                                          _bookingDetail.date.validate().isNotEmpty
                                              ? Text(formatDate(_bookingDetail.date.validate(), format: DATE_FORMAT_3), style: boldTextStyle(size: 14))
                                              : SizedBox(),
                                        ],
                                      ),
                                  ],
                                ).expand(),
                                cachedImage(
                                  attachments!.isNotEmpty ? attachments!.first.url.validate() : "",
                                  fit: BoxFit.cover,
                                  height: 80,
                                  width: 80,
                                ).cornerRadiusWithClipRRect(8),
                              ],
                            ).onTap(
                              () {
                                ServiceDetailScreen(
                                  serviceId: _bookingDetail.serviceId.validate(),
                                ).launch(context, pageRouteAnimation: PageRouteAnimation.Slide);
                              },
                              splashColor: transparentColor,
                              highlightColor: transparentColor,
                            ),
                            16.height,
                            Divider(height: 0),
                            _buildCounterWidget(value: bookingDetailResponse!),
                            /*if (bookingDetailResponse!.bookingDetail != null)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  16.height,
                                  Text(context.translate.hintDescription, style: boldTextStyle(size: 18)),
                                  16.height,
                                  bookingDetailResponse!.bookingDetail!.description.validate().isNotEmpty
                                      ? ReadMoreText(
                                          bookingDetailResponse!.bookingDetail!.description.validate(),
                                          style: secondaryTextStyle(),
                                          textAlign: TextAlign.justify,
                                        )
                                      : Text(context.translate.lblNoDescriptionAvailable, style: secondaryTextStyle()),
                                  16.height,
                                ],
                              ),*/
                            if (serviceProofList.isNotEmpty) ServiceProofListWidget(serviceProofList: serviceProofList),
                            if (handymanData.isNotEmpty && appStore.userType != UserTypeHandyman)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  24.height,
                                  Text(context.translate.lblAboutHandyman, style: boldTextStyle(size: 18)),
                                  16.height,
                                  Container(
                                    decoration: boxDecorationWithRoundedCorners(
                                      backgroundColor: context.cardColor,
                                      borderRadius: BorderRadius.all(Radius.circular(16)),
                                    ),
                                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                                    child: Column(
                                      children: handymanData.map((e) {
                                        return BasicInfoComponent(1, handymanData: e, service: service).paddingOnly(bottom: 24).onTap(() {
                                          HandymanInfoScreen(handymanId: e.id, service: service).launch(context).then((value) => null);
                                        });
                                      }).toList(),
                                    ),
                                  ),
                                ],
                              ),
                            24.height,
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                aboutCustomerWidget(context: context, bookingDetail: _bookingDetail),
                                16.height,
                                Container(
                                  decoration: boxDecorationWithRoundedCorners(
                                    backgroundColor: context.cardColor,
                                    borderRadius: BorderRadius.all(Radius.circular(16)),
                                  ),
                                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                                  child: BasicInfoComponent(
                                    0,
                                    customerData: _customer,
                                    service: service,
                                    bookingDetail: _bookingDetail,
                                  ),
                                ),
                              ],
                            ),
                            24.height,
                            if (_bookingDetail.paymentId.validate() != 0 && _bookingDetail.paymentStatus.validate().isNotEmpty)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(context.translate.lblPaymentDetail, style: boldTextStyle(size: 18)),
                                  16.height,
                                  Container(
                                    decoration: boxDecorationWithRoundedCorners(
                                      backgroundColor: context.cardColor,
                                      borderRadius: BorderRadius.all(Radius.circular(16)),
                                    ),
                                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        if (_bookingDetail.paymentId.validate() != 0)
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(context.translate.lblId, style: boldTextStyle()),
                                              Text("#" + _bookingDetail.paymentId.toString(), style: secondaryTextStyle()),
                                            ],
                                          ),
                                        4.height,
                                        Divider(),
                                        4.height,
                                        if (_bookingDetail.paymentMethod.validate().isNotEmpty)
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(context.translate.lblMethod, style: boldTextStyle()),
                                              Text(
                                                (_bookingDetail.paymentMethod != null ? _bookingDetail.paymentMethod.toString() : context.translate.notAvailable).capitalizeFirstLetter(),
                                                style: secondaryTextStyle(),
                                              ),
                                            ],
                                          ),
                                        4.height,
                                        Divider().visible(_bookingDetail.paymentMethod != null),
                                        4.height,
                                        if (_bookingDetail.paymentStatus.validate().isNotEmpty)
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(context.translate.lblStatus, style: boldTextStyle()),
                                              Text(
                                                (_bookingDetail.paymentStatus != null ? _bookingDetail.paymentStatus.toString() : context.translate.pending).capitalizeFirstLetter(),
                                                style: secondaryTextStyle(size: 14),
                                              ),
                                            ],
                                          ),
                                      ],
                                    ),
                                  ),
                                  28.height,
                                ],
                              ),
                            if (bookingDetailResponse!.bookingDetail != null)
                              PriceCommonWidget(
                                bookingDetail: bookingDetailResponse!.bookingDetail!,
                                serviceDetail: bookingDetailResponse!.service!,
                                taxes: bookingDetailResponse!.bookingDetail!.taxes.validate(),
                                couponData: bookingDetailResponse!.couponData != null ? bookingDetailResponse!.couponData! : null,
                              ),
                            if (bookingDetailResponse!.service!.totalRating != null && bookingDetailResponse!.ratingData!.isNotEmpty) customerReviewWidget(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              LoaderWidget().center().visible(appStore.isLoading),
            ],
          ),
        ),
        bottomNavigationBar: Container(
          height: 74,
          padding: EdgeInsets.all(16.0),
          alignment: Alignment.center,
          decoration: boxDecorationRoundedWithShadow(
            defaultRadius.toInt(),
            backgroundColor: context.cardColor,
          ),
          child: _bookingDetail.status == BookingStatusKeys.pending
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    statusButton(
                      context.width() / 2.5,
                      positiveBtnTxt.validate(),
                      primaryColor,
                      Colors.white,
                      onTap: (() {
                        if (_bookingDetail.status == BookingStatusKeys.pending) confirmationRequestDialog(context, BookingStatusKeys.pending);
                      }),
                    ),
                    8.width,
                    statusButton(
                      context.width() / 2.5,
                      negativeBtnTxt.validate(),
                      context.cardColor,
                      primaryColor,
                      onTap: (() {
                        confirmationRequestDialog(context, BookingStatusKeys.rejected);
                      }),
                    ),
                  ],
                )
              : _bookingDetail.status == BookingStatusKeys.accept
                  ? isAssigned
                      ? Text(context.translate.lblAssigned, style: boldTextStyle()).center()
                      : statusButton(
            context.width(),
                          context.translate.lblAssignHandyman,
                          context.primaryColor,
                          Colors.white,
                          onTap: () {
                            appStore.setLoading(true);
                            assignBookingDialog(context, _bookingDetail.id, _bookingDetail.booking_address_id);
                          },
                        )
                  : SizedBox(),
        ).visible(bookingDetailResponse != null && visibleBottom),
      ),
    );
  }
}
