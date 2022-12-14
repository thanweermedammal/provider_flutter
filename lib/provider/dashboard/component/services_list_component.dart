import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:handyman_provider_flutter/main.dart';
import 'package:handyman_provider_flutter/models/service_model.dart';
import 'package:handyman_provider_flutter/provider/dashboard/widgets/service_widget.dart';
import 'package:handyman_provider_flutter/provider/services/service_detail_screen.dart';
import 'package:handyman_provider_flutter/provider/services/service_list_screen.dart';
import 'package:handyman_provider_flutter/utils/common.dart';
import 'package:handyman_provider_flutter/utils/extensions/context_ext.dart';
import 'package:nb_utils/nb_utils.dart';

class ServiceListComponent extends StatelessWidget {
  final List<Service> list;

  ServiceListComponent({required this.list});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(context.translate.lblService, style: boldTextStyle(size: 18)),
            if (list.length > 4)
              TextButton(
                onPressed: () {
                  ServiceListScreen().launch(context);
                },
                child: Text(context.translate.viewAll, style: secondaryTextStyle()),
              )
          ],
        ),
        16.height,
        Stack(
          children: [
            Wrap(
              spacing: 16.0,
              runSpacing: 16.0,
              children: List.generate(
                list.take(4).length,
                (index) {
                  return ServiceComponent(data: list[index], width: context.width() * 0.5 - 24).onTap(() async {
                    await ServiceDetailScreen(
                      serviceId: list[index].id.validate(),
                    ).launch(context, pageRouteAnimation: PageRouteAnimation.Slide);
                  }, borderRadius: radius());
                },
              ),
            ),
            Observer(builder: (context) => noDataFound(context).center().visible(!appStore.isLoading && list.validate().isEmpty)),
          ],
        )
      ],
    ).paddingSymmetric(horizontal: 16, vertical: 16);
  }
}
