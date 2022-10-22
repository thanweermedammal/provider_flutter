import 'package:flutter/material.dart';
import 'package:handyman_provider_flutter/components/back_widget.dart';
import 'package:handyman_provider_flutter/handyman/screen/widget/handyman_review_list_widget.dart';
import 'package:handyman_provider_flutter/models/handyman_review_response.dart';
import 'package:handyman_provider_flutter/utils/extensions/context_ext.dart';
import 'package:nb_utils/nb_utils.dart';

class AllReviewComponent extends StatefulWidget {
  final List<HandymanReview>? handymanReviews;

  AllReviewComponent({this.handymanReviews});

  @override
  _AllReviewComponentState createState() => _AllReviewComponentState();
}

class _AllReviewComponentState extends State<AllReviewComponent> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(
        context.translate.lblAllReview,
        textColor: white,
        color: context.primaryColor,
        backWidget: BackWidget(),
        showBack: true,
      ),
      body: ListView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.all(16),
        itemCount: widget.handymanReviews.validate().length,
        itemBuilder: (context, index) {
          HandymanReview data = widget.handymanReviews![index];

          return ReviewListWidget(handymanReview: data);
        },
      ),
    );
  }
}
