import 'package:flutter/material.dart';
import 'package:handyman_provider_flutter/main.dart';
import 'package:handyman_provider_flutter/utils/colors.dart';
import 'package:handyman_provider_flutter/utils/extensions/context_ext.dart';
import 'package:nb_utils/nb_utils.dart';

class ExperienceWidget extends StatefulWidget {
  const ExperienceWidget({Key? key}) : super(key: key);

  @override
  _ExperienceWidgetState createState() => _ExperienceWidgetState();
}

class _ExperienceWidgetState extends State<ExperienceWidget> {
  String temp = '';
  int value = 0;

  @override
  void initState() {
    super.initState();
    afterBuildCreated(() {
      init();
    });
  }

  void init() async {
    Duration duration = DateTime.now().difference(DateTime.parse(appStore.createdAt));

    if (duration.inDays < 365) {
      temp = context.translate.lblDay;
      value = duration.inDays;
    } else if (duration.inDays >= 365) {
      temp = context.translate.lblYear;
      value = (duration.inDays / 365).floor();
    }

    setState(() {});
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    if (temp.isNotEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("$value", style: boldTextStyle(color: primaryColor, size: 18)),
          8.height,
          Text(
            "$temp${context.translate.lblOf} \n${context.translate.lblExperience}",
            style: secondaryTextStyle(),
            textAlign: TextAlign.center,
          ),
        ],
      );
    } else {
      return SizedBox();
    }
  }
}
