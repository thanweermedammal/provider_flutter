import 'package:flutter/material.dart';
import 'package:handyman_provider_flutter/components/price_widget.dart';
import 'package:handyman_provider_flutter/main.dart';
import 'package:handyman_provider_flutter/models/service_model.dart';
import 'package:handyman_provider_flutter/utils/colors.dart';
import 'package:handyman_provider_flutter/utils/common.dart';
import 'package:handyman_provider_flutter/utils/constant.dart';
import 'package:handyman_provider_flutter/widgets/app_widgets.dart';
import 'package:handyman_provider_flutter/widgets/disabled_rating_bar_widget.dart';
import 'package:nb_utils/nb_utils.dart';

class ServiceComponent extends StatelessWidget {
  final Service data;
  final double width;

  ServiceComponent({required this.data, required this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: boxDecorationWithRoundedCorners(
        borderRadius: radius(),
        backgroundColor: appStore.isDarkMode ? cardDarkColor : cardColor,
      ),
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.bottomLeft,
            children: [
              cachedImage(
                data.image_attchments!.isNotEmpty ? data.image_attchments!.first.validate() : "",
                fit: BoxFit.cover,
                height: 180,
                width: context.width(),
              ).cornerRadiusWithClipRRectOnly(topRight: defaultRadius.toInt(), topLeft: defaultRadius.toInt()),
              Positioned(
                top: 12,
                left: 12,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                  constraints: BoxConstraints(maxWidth: context.width() * 0.3),
                  decoration: boxDecorationWithShadow(
                    backgroundColor: context.cardColor.withOpacity(0.9),
                    borderRadius: radius(24),
                  ),
                  child: Marquee(
                    directionMarguee: DirectionMarguee.oneDirection,
                    child: Text(
                      "${data.categoryName.validate()}".toUpperCase(),
                      style: boldTextStyle(color: appStore.isDarkMode ? white : primaryColor, size: 12),
                    ).paddingSymmetric(horizontal: 8, vertical: 4),
                  ),
                ),
              ),
              Positioned(
                bottom: -16,
                right: 12,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  width: 120,
                  alignment: Alignment.center,
                  decoration: boxDecorationWithShadow(
                    backgroundColor: primaryColor,
                    borderRadius: radius(24),
                    border: Border.all(color: white, width: 2),
                  ),
                  child: Marquee(
                    directionMarguee: DirectionMarguee.oneDirection,
                    child: PriceWidget(
                      price: data.price!,
                      isHourlyService: data.type == ServiceTypeHourly,
                      color: Colors.white,
                      size: 14,
                      hourlyTextColor: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              16.height,
              DisabledRatingBarWidget(rating: data.totalRating.validate().toDouble().toDouble(), size: 14),
              16.height,
              Marquee(
                child: Text(data.name.validate(), style: boldTextStyle(size: 16)),
                directionMarguee: DirectionMarguee.oneDirection,
              ),
              16.height,
              Row(
                children: [
                  circleImage(image: data.providerImage.validate(), size: 30),
                  8.width,
                  if (data.providerName.validate().isNotEmpty)
                    Text(
                      data.providerName.validate(),
                      style: secondaryTextStyle(),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ).expand()
                ],
              ),
              10.height,
            ],
          ).paddingSymmetric(horizontal: 12, vertical: 12),
        ],
      ),
    );
  }
}
