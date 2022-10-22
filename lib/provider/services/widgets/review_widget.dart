import 'package:flutter/material.dart';
import 'package:handyman_provider_flutter/models/booking_detail_response.dart';
import 'package:handyman_provider_flutter/utils/common.dart';
import 'package:handyman_provider_flutter/utils/constant.dart';
import 'package:handyman_provider_flutter/widgets/disabled_rating_bar_widget.dart';
import 'package:nb_utils/nb_utils.dart';

class ReviewWidget extends StatelessWidget {
  final RatingData data;
  final bool isCustomer;

  ReviewWidget({required this.data, this.isCustomer = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(16),
      width: context.width(),
      decoration: boxDecorationDefault(color: context.cardColor),
      //margin: EdgeInsets.only(top: 12, bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          circleImage(image: isCustomer ? data.profileImage.validate() : data.profileImage.validate(), size: 70),
          12.width,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${data.customerName.validate()}', style: boldTextStyle()).expand(),
                  8.width,
                  Text(formatDate(data.createdAt.validate(), format: DATE_FORMAT_4), style: primaryTextStyle(size: 14)),
                ],
              ),
              // 4.height,
              // Text(data.service_name.validate(), style: primaryTextStyle(), maxLines: 1, overflow: TextOverflow.ellipsis),
              8.height,
              DisabledRatingBarWidget(rating: data.rating.validate()),
              if (data.review.validate().isNotEmpty) Text('${data.review.validate()}', style: primaryTextStyle()).paddingTop(8),
            ],
          ).expand(),
        ],
      ),
    );
  }
}
