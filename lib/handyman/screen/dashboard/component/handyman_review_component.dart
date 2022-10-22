import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:handyman_provider_flutter/components/all_review_component.dart';
import 'package:handyman_provider_flutter/main.dart';
import 'package:handyman_provider_flutter/models/handyman_review_response.dart';
import 'package:handyman_provider_flutter/utils/extensions/context_ext.dart';
import 'package:handyman_provider_flutter/widgets/app_widgets.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../widget/handyman_review_list_widget.dart';

class HandymanReviewComponent extends StatefulWidget {
  final List<HandymanReview>? handyman_reviews;

  HandymanReviewComponent({this.handyman_reviews});

  @override
  _HandymanReviewComponentState createState() => _HandymanReviewComponentState();
}

class _HandymanReviewComponentState extends State<HandymanReviewComponent> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(context.translate.review, style: boldTextStyle()),
                if (widget.handyman_reviews!.length > 4)
                  Text(context.translate.viewAll, style: secondaryTextStyle()).onTap(() {
                    AllReviewComponent(handymanReviews: widget.handyman_reviews.validate()).launch(context);
                  }),
              ],
            ).paddingSymmetric(horizontal: 16),
            if (widget.handyman_reviews!.length < 4) 16.height,
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.only(left: 8, right: 8, bottom: 8, top: 16),
              itemCount: widget.handyman_reviews!.length,
              itemBuilder: (context, index) {
                HandymanReview data = widget.handyman_reviews![index];

                return ReviewListWidget(handymanReview: data);
              },
            ),
            Observer(
              builder: (_) => Text(
                context.translate.lblNoReviewYet,
                style: secondaryTextStyle(),
              ).center().visible(!appStore.isLoading && widget.handyman_reviews!.isEmpty),
            ),
          ],
        ),
        Observer(
          builder: (_) => LoaderWidget().center().visible(appStore.isLoading),
        ),
      ],
    );
  }
}
