import 'package:flutter/material.dart';
import 'package:handyman_provider_flutter/models/booking_detail_response.dart';
import 'package:handyman_provider_flutter/utils/common.dart';
import 'package:handyman_provider_flutter/utils/constant.dart';
import 'package:handyman_provider_flutter/widgets/app_widgets.dart';
import 'package:nb_utils/nb_utils.dart';

class ReviewListWidget extends StatelessWidget {
  final RatingData ratingData;

  ReviewListWidget({required this.ratingData});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.only(bottom: 8),
      width: context.width(),
      decoration: boxDecorationDefault(color: context.cardColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              cachedImage(ratingData.profileImage, height: 50, width: 50, fit: BoxFit.cover).cornerRadiusWithClipRRect(40),
              16.width,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(ratingData.customerName.validate(), style: boldTextStyle(size: 14), maxLines: 1, overflow: TextOverflow.ellipsis).flexible(),
                      Row(
                        children: [
                          Image.asset('images/setting_icon/ic_star_fill.png', height: 16, color: getRatingBarColor(ratingData.rating.validate().toInt())),
                          4.width,
                          Text(ratingData.rating.validate().toStringAsFixed(1).toString(), style: boldTextStyle(color: getRatingBarColor(ratingData.rating.validate().toInt()), size: 14)),
                        ],
                      ),
                    ],
                  ),
                  ratingData.createdAt.validate().isNotEmpty
                      ? Text(formatDate('${DateTime.parse(ratingData.createdAt.validate())}', format: DATE_FORMAT_4), style: secondaryTextStyle(size: 14))
                      : SizedBox(),
                  if (ratingData.review != null) Text(ratingData.review.validate(), style: secondaryTextStyle()).paddingTop(8)
                ],
              ).flexible(),
            ],
          ),
        ],
      ),
    );
  }
}
