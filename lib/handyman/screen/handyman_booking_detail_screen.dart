import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:handyman_provider_flutter/components/back_widget.dart';
import 'package:handyman_provider_flutter/components/basic_info_component.dart';
import 'package:handyman_provider_flutter/components/booking_history_component.dart';
import 'package:handyman_provider_flutter/components/countdown_widget.dart';
import 'package:handyman_provider_flutter/handyman/service_proof_screen.dart';
import 'package:handyman_provider_flutter/main.dart';
import 'package:handyman_provider_flutter/models/booking_detail_response.dart';
import 'package:handyman_provider_flutter/models/service_detail_response.dart';
import 'package:handyman_provider_flutter/models/service_model.dart';
import 'package:handyman_provider_flutter/models/user_data.dart';
import 'package:handyman_provider_flutter/networks/rest_apis.dart';
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

class HBookingDetailScreen extends StatefulWidget {
  final int? bookingId;
  final String? customerAddress;

  HBookingDetailScreen({this.bookingId, this.customerAddress});

  @override
  HBookingDetailScreenState createState() => HBookingDetailScreenState();
}

class HBookingDetailScreenState extends State<HBookingDetailScreen> {
  BookingDetailResponse? bookingDetailResponse;

  BookingDetail _bookingDetail = BookingDetail();
  UserData _customer = UserData();
  Service service = Service();
  ProviderData providerData = ProviderData();

  List<Attachments>? attachments = [];
  List<UserData> handymanData = [];
  List<BookingActivity> bookingActivity = [];
  List<ServiceProof> serviceProofList = [];
  List<String>? serviceImages;

  CouponData? couponData;

  String? positiveBtnTxt = '';
  String? negativeBtnTxt = '';
  String? afterUpdateMessage = '';
  String? startDateTime = '';
  String? timeInterval = '0';
  String? endDateTime = '';
  String? paymentStatus = '';

  bool? confirmPaymentBtn = false;
  bool? confirmUpdate = false;
  bool hideBottom = false;
  bool afterInitVisible = false;
  bool? updated = false;
  bool isCompleted = false;

  //live stream
  bool? clicked = false;

  @override
  void initState() {
    super.initState();
    afterBuildCreated(() {
      appStore.setLoading(true);
      init();
    });
  }

  Future<void> init() async {
    loadBookingDetail();
  }

  Widget customerReviewWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(vertical: 6),
          itemCount: bookingDetailResponse!.ratingData!.length,
          itemBuilder: (context, index) {
            RatingData data = bookingDetailResponse!.ratingData![index];

            return ReviewListWidget(ratingData: data);
          },
        ),
      ],
    ).visible(bookingDetailResponse!.service!.totalRating != null);
  }

  Future<void> loadBookingDetail() async {
    Map request = {CommonKeys.bookingId: widget.bookingId.toString()};

    await bookingDetail(request).then((value) {
      bookingDetailResponse = value;
      _bookingDetail = value.bookingDetail!;

      _customer = value.customer!;
      providerData = value.providerData!;
      bookingActivity = value.bookingActivity!;
      attachments = value.service!.attchments;
      handymanData = value.handymanData!;
      service = value.service!;

      if (value.couponData != null) couponData = value.couponData;

      if (value.serviceProof != null) serviceProofList = value.serviceProof.validate();

      if (_bookingDetail.status == BookingStatusKeys.pending) {
        positiveBtnTxt = context.translate.accept;
        negativeBtnTxt = context.translate.decline;
        //
      } else if (_bookingDetail.status == BookingStatusKeys.accept) {
        positiveBtnTxt = context.translate.lblReady;
        negativeBtnTxt = context.translate.lblCancel;
        //
      } else if (_bookingDetail.status == BookingStatusKeys.onGoing) {
        afterUpdateMessage = context.translate.lblWaitingForResponse;
        updated = true;
        //
      } else if (_bookingDetail.status == BookingStatusKeys.hold ||
          _bookingDetail.status == BookingStatusKeys.rejected ||
          _bookingDetail.status == BookingStatusKeys.failed ||
          _bookingDetail.status == BookingStatusKeys.cancelled) {
        hideBottom = true;
      } else if (_bookingDetail.status == BookingStatusKeys.complete && _bookingDetail.paymentStatus == PENDING) {
        if (_bookingDetail.paymentMethod == COD && _bookingDetail.paymentStatus == PENDING) {
          confirmPaymentBtn = true;
          afterUpdateMessage = context.translate.lblConfirmPayment;
        } else {
          afterUpdateMessage = context.translate.lblWaitingForPayment;
        }
        updated = true;
        //
      } else if (_bookingDetail.status == BookingStatusKeys.complete && _bookingDetail.paymentStatus == PAID) {
        confirmPaymentBtn = false;
        updated = true;
        isCompleted = true;
      } else {
        updated = true;
      }
      setState(() {});
      appStore.setLoading(false);
      afterInitVisible = true;

      LiveStream().emit(LiveStreamUpdateBookings);
    }).catchError((e) {
      appStore.setLoading(false);
      log('ERROR:' + e.toString());
    });
  }

  Future<void> updateBooking(int? bookingId, String updateReason, String updatedStatus) async {
    DateTime now = DateTime.now();
    if (updatedStatus == BookingStatusKeys.inProgress) {
      startDateTime = DateFormat('yyyy-MM-dd kk:mm:ss').format(now);
      endDateTime = _bookingDetail.endAt.validate();
      timeInterval = _bookingDetail.durationDiff.validate().isEmptyOrNull ? "0" : _bookingDetail.durationDiff.validate();
      paymentStatus = _bookingDetail.paymentStatus.validate();
      //
    } else if (updatedStatus == BookingStatusKeys.hold) {
      String? currentDateTime = DateFormat('yyyy-MM-dd kk:mm:ss').format(now);
      startDateTime = _bookingDetail.startAt.validate();
      endDateTime = currentDateTime;
      var diff = DateTime.parse(currentDateTime).difference(DateTime.parse(_bookingDetail.startAt.validate())).inMinutes;
      num count = int.parse(_bookingDetail.durationDiff.validate()) + diff;
      timeInterval = count.toString();
      paymentStatus = _bookingDetail.paymentStatus.validate();
      //
    } else if (updatedStatus == BookingStatusKeys.complete) {
      if (_bookingDetail.paymentStatus == PENDING && _bookingDetail.paymentMethod == COD) {
        startDateTime = _bookingDetail.startAt.toString();
        endDateTime = _bookingDetail.endAt.toString();
        timeInterval = "0";
        paymentStatus = PAID;
        confirmPaymentBtn = false;
        isCompleted = true;
      } else {
        endDateTime = DateFormat('yyyy-MM-dd kk:mm:ss').format(now);
        startDateTime = _bookingDetail.startAt.validate();
        var diff = DateTime.parse(endDateTime.validate()).difference(DateTime.parse(_bookingDetail.startAt.validate())).inMinutes;
        num count = int.parse(_bookingDetail.durationDiff.validate()) + diff;
        timeInterval = count.toString();
        paymentStatus = _bookingDetail.paymentStatus.validate();
      }
      //
    } else if (updatedStatus == BookingStatusKeys.rejected || updatedStatus == BookingStatusKeys.cancelled) {
      startDateTime = _bookingDetail.startAt.validate().isNotEmpty ? _bookingDetail.startAt.validate() : _bookingDetail.date.validate();
      endDateTime = DateFormat('yyyy-MM-dd kk:mm:ss').format(now);
      timeInterval = _bookingDetail.durationDiff.toString();
      paymentStatus = _bookingDetail.paymentStatus.validate();
      //
    } else {
      //
    }
    setState(() {});

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
      appStore.setLoading(false);
      loadBookingDetail();
    }).catchError((e) {
      toast(e.toString(), print: true);
      appStore.setLoading(false);
    });
  }

  //cancel Booking
  void cancellationReasonDialog(String? label, String status) {
    TextEditingController _textFieldReason = TextEditingController();
    showInDialog(
      context,
      title: Text(label!, style: boldTextStyle(), textAlign: TextAlign.justify),
      barrierColor: Colors.black45,
      builder: (context) {
        return SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppTextField(
                onChanged: (value) {},
                controller: _textFieldReason,
                textFieldType: TextFieldType.MULTILINE,
                decoration: inputDecoration(context, hint: context.translate.lblGiveReason),
                minLines: 4,
                maxLines: 10,
              ),
              16.height,
              AppButton(
                color: primaryColor,
                height: 40,
                text: context.translate.lblOk,
                textStyle: boldTextStyle(color: Colors.white),
                width: context.width() - context.navigationBarHeight,
                shapeBorder: RoundedRectangleBorder(
                  borderRadius: radius(defaultAppButtonRadius),
                  side: BorderSide(color: viewLineColor),
                ),
                onTap: () {
                  _textFieldReason.text.isNotEmpty
                      ? setState(() {
                          updateBooking(_bookingDetail.id, _textFieldReason.text, status);
                          if (status == BookingStatusKeys.failed) {
                            afterUpdateMessage = context.translate.lblCancel;
                            updated = true;
                            clicked = true;
                          } else {
                            updated = false;
                          }
                        })
                      : toast(context.translate.lblGiveReason);
                  finish(context);
                },
              )
            ],
          ),
        );
      },
    );
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
          updateBooking(_bookingDetail.id, '', BookingStatusKeys.accept);
          setState(() {
            positiveBtnTxt = context.translate.lblReady;
            negativeBtnTxt = context.translate.lblCancel;

            clicked = true;
          });
          //
        } else if (status == BookingStatusKeys.accept) {
          updateBooking(_bookingDetail.id, '', BookingStatusKeys.onGoing);
          setState(() {
            afterUpdateMessage = context.translate.lblOnGoing;
            updated = true;
            clicked = true;
          });
          //
        } else if (status == BookingStatusKeys.complete) {
          setState(() {
            updateBooking(_bookingDetail.id, '', BookingStatusKeys.complete);
            afterUpdateMessage = context.translate.lblPaymentDone;
            updated = true;
            confirmPaymentBtn = false;
          });
        }
      },
      title: context.translate.confirmationRequestTxt,
    );
  }

  buttonHandle() {
    if (afterInitVisible && !hideBottom)
      return Container(
        height: 105,
        padding: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
        alignment: Alignment.center,
        decoration: boxDecorationRoundedWithShadow(defaultRadius.toInt(), backgroundColor: context.cardColor),
        child: Column(
          children: [
            if (updated == false)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  statusButton(context.width() / 2.5, positiveBtnTxt.validate(), primaryColor, Colors.white, onTap: (() {
                    setState(() {
                      if (_bookingDetail.status == BookingStatusKeys.pending) {
                        confirmationRequestDialog(context, BookingStatusKeys.pending);
                        //
                      } else if (_bookingDetail.status == BookingStatusKeys.accept) {
                        confirmationRequestDialog(context, BookingStatusKeys.accept);
                        //
                      }
                    });
                  })),
                  8.width,
                  statusButton(context.width() / 2.5, negativeBtnTxt.validate(), context.cardColor, primaryColor, onTap: (() {
                    setState(() {
                      cancellationReasonDialog(context.translate.hintRequired, _bookingDetail.statusLabel.validate() == PENDING ? BookingStatusKeys.rejected : BookingStatusKeys.cancelled);
                      //
                    });
                  })),
                ],
              ),
            if (confirmPaymentBtn == true)
              statusButton(
                context.width(),
                afterUpdateMessage.validate(),
                primaryColor,
                white,
                onTap: (() {
                  confirmationRequestDialog(context, BookingStatusKeys.complete);
                  //
                }),
              ),
            if (confirmPaymentBtn == false && isCompleted)
              AppButton(
                text: context.translate.lblServiceProof,
                color: primaryColor,
                height: 20,
                width: context.width(),
                onTap: () {
                  ServiceProofScreen(bookingDetail: bookingDetailResponse!).launch(context, pageRouteAnimation: PageRouteAnimation.Slide).then((value) => setState(() {}));
                },
              ),
            if (confirmPaymentBtn == false) TextIcon(textStyle: boldTextStyle(), text: afterUpdateMessage!),
          ],
        ),
      );
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
        return await loadBookingDetail();
      },
      child: Scaffold(
        appBar: appBarWidget(
          _bookingDetail.statusLabel.validate(),
          backWidget: BackWidget(),
          showBack: true,
          color: context.primaryColor,
          titleTextStyle: boldTextStyle(size: 18, color: Colors.white),
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
        ),
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
                                  height: 80,
                                  width: 80,
                                  fit: BoxFit.cover,
                                ).cornerRadiusWithClipRRect(8),
                              ],
                            ).onTap(
                              () {
                                ServiceDetailScreen(serviceId: _bookingDetail.serviceId.validate()).launch(context);
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
                                  bookingDetailResponse!.bookingDetail != null && bookingDetailResponse!.bookingDetail!.description.validate().isNotEmpty
                                      ? ReadMoreText(
                                          bookingDetailResponse!.bookingDetail!.description.validate(),
                                          style: secondaryTextStyle(),
                                          textAlign: TextAlign.justify,
                                        )
                                      : Text(context.translate.lblNoDescriptionAvailable, style: secondaryTextStyle())
                                ],
                              ),*/
                            if (serviceProofList.isNotEmpty) ServiceProofListWidget(serviceProofList: serviceProofList),
                            if (handymanData.isNotEmpty && appStore.userType != UserTypeHandyman)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  24.height,
                                  Text(context.translate.lblAboutHandyman, style: boldTextStyle(size: 16)),
                                  16.height,
                                  if (handymanData.isNotEmpty)
                                    Container(
                                      decoration: boxDecorationWithRoundedCorners(
                                        backgroundColor: context.cardColor,
                                        borderRadius: BorderRadius.all(Radius.circular(16)),
                                      ),
                                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                                      child: Column(
                                        children: handymanData.map((e) {
                                          return BasicInfoComponent(1, handymanData: e, service: service);
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
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      BasicInfoComponent(
                                        0,
                                        customerData: _customer,
                                        service: service,
                                        bookingDetail: _bookingDetail,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            28.height,
                            if (_bookingDetail.paymentId != null && _bookingDetail.paymentId != null && _bookingDetail.paymentStatus != null)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(context.translate.lblPaymentDetail, style: boldTextStyle(size: 16)),
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
                                        8.height,
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(context.translate.lblStatus, style: boldTextStyle()),
                                            Text(
                                              _bookingDetail.paymentStatus.validate(value: context.translate.pending).capitalizeFirstLetter(),
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
                            16.height,
                            if (bookingDetailResponse!.ratingData.validate().isNotEmpty) customerReviewWidget(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              Observer(builder: (context) => LoaderWidget().visible(appStore.isLoading))
            ],
          ),
        ),
        bottomNavigationBar: buttonHandle(),
      ),
    );
  }
}
