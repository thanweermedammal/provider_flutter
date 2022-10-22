import 'package:flutter/material.dart';
import 'package:handyman_provider_flutter/components/back_widget.dart';
import 'package:handyman_provider_flutter/screens/zoom_image_screen.dart';
import 'package:handyman_provider_flutter/widgets/app_widgets.dart';
import 'package:nb_utils/nb_utils.dart';

class GalleryListScreen extends StatefulWidget {
  final List<String>? galleryImages;

  GalleryListScreen({this.galleryImages});

  @override
  _GalleryListScreenState createState() => _GalleryListScreenState();
}

class _GalleryListScreenState extends State<GalleryListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(
        "Gallery List",
        textColor: white,
        color: context.primaryColor,
        backWidget: BackWidget(),
      ),
      body: Wrap(
        spacing: 16,
        runSpacing: 16,
        children: List.generate(
          widget.galleryImages!.length,
          (index) {
            return cachedImage(
              widget.galleryImages![index],
              height: 110,
              width: context.width() * 0.33 - 20,
              fit: BoxFit.cover,
            ).cornerRadiusWithClipRRect(8).onTap(() {
              ZoomImageScreen(galleryImages: widget.galleryImages, index: index).launch(context);
            });
          },
        ),
      ).paddingAll(16),
    );
  }
}
