import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:handyman_provider_flutter/components/all_review_component.dart';
import 'package:handyman_provider_flutter/components/back_widget.dart';
import 'package:handyman_provider_flutter/components/price_widget.dart';
import 'package:handyman_provider_flutter/components/read_more_text.dart'
    as read;
import 'package:handyman_provider_flutter/handyman/screen/widget/handyman_review_list_widget.dart';
import 'package:handyman_provider_flutter/main.dart';
import 'package:handyman_provider_flutter/models/handyman_review_response.dart';
import 'package:handyman_provider_flutter/models/service_detail_response.dart';
import 'package:handyman_provider_flutter/networks/rest_apis.dart';
import 'package:handyman_provider_flutter/provider/services/widgets/service_faq_widget.dart';
import 'package:handyman_provider_flutter/screens/gallery_List_Screen.dart';
import 'package:handyman_provider_flutter/utils/app_common.dart';
import 'package:handyman_provider_flutter/utils/colors.dart';
import 'package:handyman_provider_flutter/utils/extensions/context_ext.dart';
import 'package:handyman_provider_flutter/utils/images.dart';
import 'package:handyman_provider_flutter/utils/model_keys.dart';
import 'package:handyman_provider_flutter/widgets/app_widgets.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../screens/zoom_image_screen.dart';
import 'add_service_screen.dart';

class ServiceDetailScreen extends StatefulWidget {
  final int? serviceId;

  ServiceDetailScreen({this.serviceId});

  @override
  ServiceDetailScreenState createState() => ServiceDetailScreenState();
}

class ServiceDetailScreenState extends State<ServiceDetailScreen> {
  TextEditingController reviewCont = TextEditingController();

  ServiceDetailResponse serviceDetailData = ServiceDetailResponse();
  ServiceDetail serviceDetail = ServiceDetail();

  PageController _pageController = PageController(initialPage: 0);
  int selectIndex = 0;
  List<String> galleryImages = [];
  List<String> addressList = [];
  List<ServiceFaq> serviceFaq = [];

  num discountPrice = 0;
  num totalAmount = 0;

  @override
  void initState() {
    super.initState();
    afterBuildCreated(() {
      init();
    });
  }

  Future<void> init() async {
    appStore.setLoading(true);
    await 1.seconds.delay;

    setStatusBarColor(Colors.transparent);

    Map req = {
      CommonKeys.serviceId: widget.serviceId,
    };

    getServiceDetail(req).then((value) {
      appStore.setLoading(false);

      serviceDetailData = value;

      serviceFaq.clear();
      serviceFaq.addAll(value.serviceFaq.validate());

      addressList =
          serviceDetailData.serviceDetail!.serviceAddressMapping!.map((e) {
        return e.providerAddressMapping!.address.validate();
      }).toList();

      galleryImages =
          serviceDetailData.serviceDetail!.imageAttchments.validate();

      setState(() {});
    }).catchError((e) {
      appStore.setLoading(false);
      toast(e.toString(), print: true);
    });
  }

  void removeService() {
    deleteService(serviceDetailData.serviceDetail!.id.validate()).then((value) {
      appStore.setLoading(true);
      finish(context, true);
    }).catchError((e) {
      appStore.setLoading(false);
      toast(e.toString(), print: true);
    });
  }

  Widget durationWidget() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('${context.translate.hintDuration} :',
            style: primaryTextStyle(size: 14)),
        Text(
          '${serviceDetailData.serviceDetail!.duration.validate()} ${context.translate.lblHr}',
          style: boldTextStyle(color: primaryColor),
        ),
      ],
    )
        .visible(serviceDetailData.serviceDetail!.duration != null)
        .paddingSymmetric(horizontal: 16);
  }

  Widget customerReviewWidget() {
    if (serviceDetailData.ratingData!.isEmpty) return SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(context.translate.review, style: boldTextStyle()),
            if (serviceDetailData.ratingData!.length > 4)
              TextButton(
                onPressed: () {
                  AllReviewComponent(
                          handymanReviews:
                              serviceDetailData.ratingData.validate())
                      .launch(context);
                },
                child: Text(context.translate.viewAll,
                    style: secondaryTextStyle()),
              )
          ],
        ),
        if (serviceDetailData.ratingData!.length < 4) 16.height,
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(vertical: 6),
          itemCount: serviceDetailData.ratingData!.take(4).length,
          itemBuilder: (context, index) {
            HandymanReview data = serviceDetailData.ratingData![index];

            return ReviewListWidget(handymanReview: data);
          },
        ),
      ],
    )
        .paddingSymmetric(horizontal: 16)
        .visible(serviceDetailData.serviceDetail!.totalRating != null);
  }

  //confirmation Alert
  Future<void> confirmationDialog(BuildContext context) async {
    showConfirmDialogCustom(
      context,
      primaryColor: primaryColor,
      positiveText: context.translate.lblYes,
      negativeText: context.translate.lblNo,
      onAccept: (context) async {
        if (!appStore.isTester) {
          appStore.setLoading(true);
          removeService();
        } else {
          toast(context.translate.lblUnAuthorized);
        }
      },
      title: context.translate.confirmationRequestTxt,
    );
  }

  @override
  void dispose() {
    super.dispose();
    setStatusBarColor(Colors.transparent);
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: serviceDetailData.serviceDetail != null &&
              serviceDetailData.serviceDetail!.isFeatured.validate(value: 0) ==
                  1
          ? FloatingActionButton(
              elevation: 0.0,
              child: Image.asset(featured, height: 22, width: 22, color: white),
              backgroundColor: primaryColor,
              onPressed: () {
                toast(context.translate.lblFeatureProduct);
              },
            )
          : Offstage(),
      body: RefreshIndicator(
        onRefresh: () async {
          return await init();
        },
        child: Stack(
          children: [
            serviceDetailData.serviceDetail != null
                ? SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            if (galleryImages.isNotEmpty)
                              SizedBox(
                                height: 400,
                                child: PageView(
                                  children: List.generate(
                                    galleryImages.length,
                                    (index) {
                                      return cachedImage(
                                        galleryImages[index],
                                        fit: BoxFit.cover,
                                      ).onTap(() {
                                        ZoomImageScreen(
                                                galleryImages: galleryImages,
                                                index: index)
                                            .launch(context);
                                      });
                                    },
                                  ),
                                  controller: _pageController,
                                  onPageChanged: (index) {
                                    selectIndex = index;
                                    setState(() {});
                                  },
                                ),
                              )
                            else
                              SizedBox(height: 400, child: cachedImage("")),
                            Positioned(
                                top: context.statusBarHeight + 8,
                                left: 8,
                                child: BackWidget()),
                            Positioned(
                              right: 8,
                              top: context.statusBarHeight + 8,
                              child: Container(
                                padding: EdgeInsets.all(0),
                                decoration: boxDecorationRoundedWithShadow(8,
                                    backgroundColor: primaryColor),
                                child: PopupMenuButton(
                                  icon: Icon(Icons.more_horiz,
                                      size: 24, color: white),
                                  padding: EdgeInsets.all(8),
                                  onSelected: (selection) {
                                    if (selection == 1) {
                                      AddServiceScreen(
                                              data: serviceDetailData
                                                  .serviceDetail)
                                          .launch(context)
                                          .then((value) {
                                        if (value ?? false) {
                                          init();
                                        }
                                      });
                                    } else if (selection == 2) {
                                      confirmationDialog(context);
                                    }
                                  },
                                  itemBuilder: (context) => [
                                    PopupMenuItem(
                                        child: Text(context.translate.lblEdit,
                                            style: boldTextStyle()),
                                        value: 1),
                                    PopupMenuItem(
                                        child: Text(context.translate.lblDelete,
                                            style: boldTextStyle()),
                                        value: 2)
                                  ],
                                ),
                              ),
                            ),
                            if (galleryImages.isNotEmpty &&
                                galleryImages.length != 1)
                              Positioned(
                                bottom: 100,
                                left: 16,
                                right: 16,
                                child: Align(
                                  alignment: Alignment.bottomCenter,
                                  child: DotIndicator(
                                    pageController: _pageController,
                                    pages: galleryImages,
                                    indicatorColor: primaryColor,
                                    unselectedIndicatorColor:
                                        grey.withOpacity(0.9),
                                    currentBoxShape: BoxShape.rectangle,
                                    boxShape: BoxShape.rectangle,
                                    borderRadius: radius(2),
                                    currentBorderRadius: radius(3),
                                    currentDotSize: 18,
                                    currentDotWidth: 6,
                                    dotSize: 6,
                                  ),
                                ),
                              ),
                            Positioned(
                              bottom: -100,
                              left: 16,
                              right: 16,
                              child: Container(
                                padding: EdgeInsets.all(16),
                                decoration: cardDecoration(context),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (serviceDetailData
                                        .serviceDetail!.subCategoryName
                                        .validate()
                                        .isNotEmpty)
                                      Text(
                                          '${serviceDetailData.serviceDetail!.categoryName} > ${serviceDetailData.serviceDetail!.subCategoryName}',
                                          style: boldTextStyle(
                                              size: 14, color: primaryColor))
                                    else
                                      Text(
                                          '${serviceDetailData.serviceDetail!.categoryName}',
                                          style: boldTextStyle(
                                              size: 14, color: primaryColor)),
                                    6.height,
                                    Marquee(
                                      directionMarguee:
                                          DirectionMarguee.oneDirection,
                                      child: Text(
                                        '${serviceDetailData.serviceDetail!.name.validate()}',
                                        style: boldTextStyle(size: 20),
                                      ),
                                    ),
                                    16.height,
                                    Row(
                                      children: [
                                        PriceWidget(
                                          price: serviceDetailData
                                              .serviceDetail!.price
                                              .validate(),
                                          size: 24,
                                          color: primaryColor,
                                          isHourlyService: serviceDetailData
                                              .serviceDetail!.isHourlyService,
                                        ),
                                        8.width,
                                        if (serviceDetailData
                                                .serviceDetail!.discount
                                                .validate() !=
                                            0)
                                          Text(
                                            '(${serviceDetailData.serviceDetail!.discount.validate()}% ${context.translate.lblOff})',
                                            style: boldTextStyle(
                                                color: Colors.green),
                                          ),
                                      ],
                                    ),
                                    8.height,
                                    if (serviceDetailData
                                        .serviceDetail!.duration
                                        .validate()
                                        .isNotEmpty)
                                      TextIcon(
                                        edgeInsets: EdgeInsets.symmetric(
                                            horizontal: 0, vertical: 8),
                                        text:
                                            '${context.translate.hintDuration}',
                                        expandedText: true,
                                        textStyle: boldTextStyle(),
                                        suffix: Text(
                                          "${serviceDetailData.serviceDetail!.duration.validate()} ${context.translate.lblHours}",
                                          style: boldTextStyle(),
                                        ),
                                      ),
                                    TextIcon(
                                      text: '${context.translate.lblRating}',
                                      edgeInsets: EdgeInsets.symmetric(
                                          horizontal: 0, vertical: 4),
                                      textStyle: boldTextStyle(),
                                      expandedText: true,
                                      suffix: Row(
                                        children: [
                                          Image.asset(
                                              'images/setting_icon/ic_star_fill.png',
                                              height: 20,
                                              color: rattingColor),
                                          //Icon(Icons.star, color: rattingColor, size: 20),
                                          4.width,
                                          Text(
                                              "${serviceDetailData.serviceDetail!.totalRating.validate().toStringAsFixed(1)}",
                                              style: boldTextStyle()),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        115.height,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(context.translate.hintDescription,
                                    style: boldTextStyle())
                                .visible(galleryImages.isNotEmpty),
                            12.height,
                            serviceDetailData.serviceDetail!.description
                                    .validate()
                                    .isNotEmpty
                                ? ReadMoreText(
                                    serviceDetailData.serviceDetail!.description
                                        .validate(),
                                    style: secondaryTextStyle(),
                                    textAlign: TextAlign.justify,
                                  )
                                : Text(
                                        context.translate
                                            .lblNoDescriptionAvailable,
                                        style: secondaryTextStyle())
                                    .center()
                                    .paddingOnly(top: 16),
                          ],
                        ).paddingAll(16),
                        24.height,
                        if (galleryImages.isNotEmpty)
                          Container(
                            color: context.cardColor,
                            padding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                        '${context.translate.lblGallery} (${galleryImages.length.toString()})',
                                        style: boldTextStyle()),
                                    if (galleryImages.length > 4)
                                      TextButton(
                                        onPressed: () {
                                          GalleryListScreen(
                                                  galleryImages: galleryImages)
                                              .launch(context);
                                        },
                                        child: Text(context.translate.viewAll,
                                            style: secondaryTextStyle()),
                                      )
                                  ],
                                ),
                                16.height,
                                Wrap(
                                  spacing: 16,
                                  runSpacing: 16,
                                  children: List.generate(
                                    galleryImages.take(3).length,
                                    (index) {
                                      return cachedImage(
                                        galleryImages[index],
                                        height: 110,
                                        width: context.width() * 0.33 - 24,
                                        fit: BoxFit.cover,
                                      ).onTap(() {
                                        ZoomImageScreen(
                                                galleryImages: galleryImages,
                                                index: index)
                                            .launch(context);
                                      }).cornerRadiusWithClipRRect(8);
                                    },
                                  ),
                                ),
                                8.height,
                              ],
                            ),
                          ),
                        if (serviceFaq.validate().isNotEmpty)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              16.height,
                              Text(context.translate.lblFAQs,
                                      style: boldTextStyle())
                                  .paddingOnly(left: 16),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                itemCount: serviceFaq.length,
                                itemBuilder: (_, index) {
                                  return ServiceFaqWidget(
                                      serviceFaq: serviceFaq[index]);
                                },
                              ),
                            ],
                          ),
                        28.height,
                        customerReviewWidget(),
                      ],
                    ).paddingOnly(bottom: 100),
                  )
                : SizedBox(),
            Observer(
              builder: (_) =>
                  LoaderWidget().center().visible(appStore.isLoading),
            ),
          ],
        ),
      ),
    );
  }
}
