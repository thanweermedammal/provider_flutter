import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:handyman_provider_flutter/main.dart';
import 'package:handyman_provider_flutter/models/dashboard_response.dart';
import 'package:handyman_provider_flutter/provider/dashboard/widgets/handyman_widget.dart';
import 'package:handyman_provider_flutter/provider/handyman/handyman_list_screen.dart';
import 'package:handyman_provider_flutter/utils/common.dart';
import 'package:handyman_provider_flutter/utils/extensions/context_ext.dart';
import 'package:nb_utils/nb_utils.dart';

class HandymanListComponent extends StatelessWidget {
  final List<Handyman> list;

  HandymanListComponent({required this.list});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.cardColor,
      margin: EdgeInsets.only(top: 16),
      padding: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(context.translate.handyman, style: boldTextStyle(size: 18)),
              if (list.length > 4)
                TextButton(
                  onPressed: () {
                    HandymanListScreen(list: list).launch(context);
                  },
                  child: Text(context.translate.viewAll, style: secondaryTextStyle()),
                )
            ],
          ),
          16.height,
          Stack(
            children: [
              Wrap(
                spacing: 16,
                runSpacing: 16,
                children: List.generate(
                  list.take(4).length,
                  (index) {
                    return HandymanWidget(data: list[index], width: context.width() * 0.48 - 20);
                  },
                ),
              ),
              Observer(builder: (context) => noDataFound(context).center().visible(!appStore.isLoading && list.validate().isEmpty)),
            ],
          ),
        ],
      ),
    );
  }
}
