import 'package:flutter/material.dart';
import 'package:handyman_provider_flutter/components/back_widget.dart';
import 'package:handyman_provider_flutter/models/booking_detail_response.dart';
import 'package:handyman_provider_flutter/models/provider_info_model.dart';
import 'package:handyman_provider_flutter/models/service_model.dart';
import 'package:handyman_provider_flutter/networks/rest_apis.dart';
import 'package:handyman_provider_flutter/provider/review/rating_view_all_screen.dart';
import 'package:handyman_provider_flutter/provider/services/widgets/review_widget.dart';
import 'package:handyman_provider_flutter/utils/common.dart';
import 'package:handyman_provider_flutter/utils/extensions/context_ext.dart';
import 'package:handyman_provider_flutter/utils/extensions/string_extension.dart';
import 'package:handyman_provider_flutter/utils/images.dart';
import 'package:handyman_provider_flutter/widgets/app_widgets.dart';
import 'package:handyman_provider_flutter/widgets/disabled_rating_bar_widget.dart';
import 'package:nb_utils/nb_utils.dart';

class HandymanInfoScreen extends StatefulWidget {
  final int? handymanId;
  final Service? service;

  HandymanInfoScreen({this.handymanId, this.service});

  @override
  HandymanInfoScreenState createState() => HandymanInfoScreenState();
}

class HandymanInfoScreenState extends State<HandymanInfoScreen> {
  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  Widget aboutWidget({required String desc}) {
    return Text(desc.validate(), style: boldTextStyle());
  }

  Widget emailWidget({required HandymanData data}) {
    return Container(
      decoration: boxDecorationDefault(color: context.cardColor),
      padding: EdgeInsets.all(16),
      width: context.width(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(context.translate.lblEmail, style: boldTextStyle(size: 16)),
              8.height,
              Text(data.email.validate(), style: secondaryTextStyle()),
              24.height,
            ],
          ).onTap(() {
            launchMail(" ${data.email.validate()}");
          }),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(context.translate.hintContactNumber, style: boldTextStyle(size: 16)),
              8.height,
              Text(data.contactNumber.validate(), style: secondaryTextStyle()),
              24.height,
            ],
          ).onTap(() {
            launchCall(data.contactNumber.validate());
          }),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(context.translate.lblMemberSince, style: boldTextStyle(size: 16)),
              8.height,
              Text("${DateTime.parse(data.createdAt.validate()).year}", style: secondaryTextStyle()),
            ],
          ).onTap(() {
            //
          }),
        ],
      ),
    );
  }

  Widget handymanWidget({required HandymanInfoResponse data}) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: boxDecorationDefault(color: context.cardColor, border: Border.all(color: context.dividerColor, width: 1)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (data.handymanData!.profileImage.validate().isNotEmpty) circleImage(image: data.handymanData!.profileImage.validate(), size: 65),
              16.width,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(data.handymanData!.username.validate(), style: boldTextStyle(size: 18)),
                  10.height,
                  if (data.handymanData!.email.validate().isNotEmpty)
                    Row(
                      children: [
                        ic_message.iconImage(size: 16),
                        6.width,
                        Text(data.handymanData!.email.validate(), style: secondaryTextStyle()).flexible(),
                      ],
                    ),
                  8.height,
                  DisabledRatingBarWidget(rating: data.handymanData!.handyman_rating.validate().toDouble(), size: 14),
                ],
              ).expand(),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget buildBodyWidget(AsyncSnapshot<HandymanInfoResponse> snap) {
      if (snap.hasError) {
        return Text(snap.error.toString()).center();
      } else if (snap.hasData) {
        log(snap.data!.toJson());
        return Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // BasicInfoComponent(0,customerData: snap.data.!,service: widget.service),
                  handymanWidget(data: snap.data!),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(context.translate.lblAbout, style: boldTextStyle(size: 18)),
                      16.height,
                      if (snap.data!.handymanData!.description.validate().isNotEmpty) aboutWidget(desc: snap.data!.handymanData!.description.validate()),
                      emailWidget(data: snap.data!.handymanData!),
                      Row(
                        children: [
                          Text(context.translate.review, style: boldTextStyle(size: 18)).expand(),
                          TextButton(
                            onPressed: () {
                              RatingViewAllScreen(serviceId: widget.service!.id!).launch(context);
                            },
                            child: Text(context.translate.lblAllReview, style: secondaryTextStyle()),
                          )
                        ],
                      ),
                      snap.data!.handymanRatingReview.validate().isNotEmpty
                          ? ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              padding: EdgeInsets.symmetric(vertical: 6),
                              itemCount: snap.data!.handymanRatingReview.validate().length,
                              itemBuilder: (context, index) => ReviewWidget(data: snap.data!.handymanRatingReview.validate()[index], isCustomer: true),
                            )
                          : Text(context.translate.lblNoReviewYet, style: secondaryTextStyle()).center().paddingOnly(top: 16),
                    ],
                  ).paddingAll(16),
                ],
              ),
            ),
          ],
        );
      }
      return LoaderWidget().center();
    }

    return FutureBuilder<HandymanInfoResponse>(
      future: getProviderDetail(widget.handymanId.validate()),
      builder: (context, snap) {
        return Scaffold(
          appBar: appBarWidget(
            snap.hasData ? snap.data!.handymanData!.displayName.validate() : "",
            textColor: white,
            elevation: 1.5,
            color: context.primaryColor,
            backWidget: BackWidget(),
          ),
          body: buildBodyWidget(snap),
        );
      },
    );
  }
}
