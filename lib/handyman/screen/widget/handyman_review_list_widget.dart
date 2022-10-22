import 'package:flutter/material.dart';
import 'package:handyman_provider_flutter/models/handyman_review_response.dart';
import 'package:handyman_provider_flutter/utils/common.dart';
import 'package:handyman_provider_flutter/utils/constant.dart';
import 'package:handyman_provider_flutter/widgets/app_widgets.dart';
import 'package:nb_utils/nb_utils.dart';

class ReviewListWidget extends StatelessWidget {
  final HandymanReview? handymanReview;

  ReviewListWidget({this.handymanReview});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(16),
      width: context.width(),
      decoration: boxDecorationDefault(color: context.cardColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              cachedImage(isUserTypeProvider ? handymanReview!.profile_image : handymanReview!.customer_profile_image, height: 50, width: 50, fit: BoxFit.cover).cornerRadiusWithClipRRect(40),
              16.width,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(handymanReview!.customer_name.validate(), style: boldTextStyle(size: 14), maxLines: 1, overflow: TextOverflow.ellipsis).flexible(),
                      Row(
                        children: [
                          Image.asset('images/setting_icon/ic_star_fill.png', height: 18, color: getRatingBarColor(handymanReview!.rating.validate().toInt())),
                          4.width,
                          Text(handymanReview!.rating.validate().toStringAsFixed(1).toString(), style: boldTextStyle(color: getRatingBarColor(handymanReview!.rating.validate().toInt()), size: 14)),
                        ],
                      ),
                    ],
                  ),
                  handymanReview!.created_at.validate().isNotEmpty
                      ? Text(formatDate('${DateTime.parse(handymanReview!.created_at.validate())}', format: DATE_FORMAT_4), style: secondaryTextStyle(size: 14))
                      : SizedBox(),
                  8.height,
                  Text('Service: ${handymanReview!.service_name.validate()}', style: secondaryTextStyle(), maxLines: 1, overflow: TextOverflow.ellipsis),
                  4.height,
                  if (handymanReview!.review != null) Text(handymanReview!.review.validate(), style: primaryTextStyle())
                ],
              ).flexible(),
            ],
          ),
        ],
      ),
    );
  }
}
