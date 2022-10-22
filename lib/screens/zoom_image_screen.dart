import 'package:flutter/material.dart';
import 'package:handyman_provider_flutter/components/back_widget.dart';
import 'package:handyman_provider_flutter/utils/extensions/context_ext.dart';
import 'package:handyman_provider_flutter/widgets/app_widgets.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class ZoomImageScreen extends StatefulWidget {
  final int index;
  final List<String>? galleryImages;

  ZoomImageScreen({required this.index, this.galleryImages});

  @override
  _ZoomImageScreenState createState() => _ZoomImageScreenState();
}

class _ZoomImageScreenState extends State<ZoomImageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: appBarWidget(
        context.translate.lblGallery,
        textColor: Colors.white,
        color: context.primaryColor,
        backWidget: BackWidget(),
      ),
      body: PhotoViewGallery.builder(
        scrollPhysics: BouncingScrollPhysics(),
        enableRotation: false,
        backgroundDecoration: BoxDecoration(color: Colors.black),
        pageController: PageController(initialPage: widget.index),
        builder: (BuildContext context, int index) {
          return PhotoViewGalleryPageOptions(
            imageProvider: Image.network(widget.galleryImages![index], errorBuilder: (context, error, stackTrace) => placeHolderWidget()).image,
            initialScale: PhotoViewComputedScale.contained,
            minScale: PhotoViewComputedScale.contained,
            errorBuilder: (context, error, stackTrace) => placeHolderWidget(),
            heroAttributes: PhotoViewHeroAttributes(tag: widget.galleryImages![index]),
          );
        },
        itemCount: widget.galleryImages!.length,
        loadingBuilder: (context, event) => LoaderWidget(),
      ),
    );
  }
}
