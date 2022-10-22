import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:handyman_provider_flutter/auth/change_password_screen.dart';
import 'package:handyman_provider_flutter/auth/edit_profile_screen.dart';
import 'package:handyman_provider_flutter/components/experience_widget.dart';
import 'package:handyman_provider_flutter/components/theme_selection_dailog.dart';
import 'package:handyman_provider_flutter/main.dart';
import 'package:handyman_provider_flutter/networks/rest_apis.dart';
import 'package:handyman_provider_flutter/screens/about_us_screen.dart';
import 'package:handyman_provider_flutter/screens/languages_screen.dart';
import 'package:handyman_provider_flutter/utils/colors.dart';
import 'package:handyman_provider_flutter/utils/common.dart';
import 'package:handyman_provider_flutter/utils/configs.dart';
import 'package:handyman_provider_flutter/utils/extensions/context_ext.dart';
import 'package:handyman_provider_flutter/utils/images.dart';
import 'package:handyman_provider_flutter/widgets/app_widgets.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:package_info/package_info.dart';

class ProfileFragment extends StatefulWidget {
  @override
  _ProfileFragmentState createState() => _ProfileFragmentState();
}

class _ProfileFragmentState extends State<ProfileFragment> {
  UniqueKey keyForExperienceWidget = UniqueKey();

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    setStatusBarColor(primaryColor);
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Observer(
        builder: (_) => SingleChildScrollView(
          padding: EdgeInsets.only(top: context.statusBarHeight),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    color: primaryColor,
                    height: 300,
                    width: context.width(),
                    child: Column(
                      children: [
                        16.height,
                        if (appStore.userProfileImage.isNotEmpty)
                          Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              cachedImage(
                                appStore.userProfileImage,
                                height: 120,
                                width: 120,
                                fit: BoxFit.cover,
                              ).cornerRadiusWithClipRRect(60),
                              Positioned(
                                bottom: 0,
                                right: 8,
                                child: Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.all(6),
                                  decoration: boxDecorationDefault(
                                    shape: BoxShape.circle,
                                    color: primaryColor,
                                    border: Border.all(
                                        color: context.cardColor, width: 2),
                                  ),
                                  child: Icon(AntDesign.edit,
                                      color: white, size: 18),
                                ).onTap(() {
                                  HEditProfileScreen().launch(context,
                                      pageRouteAnimation:
                                          PageRouteAnimation.Slide);
                                }),
                              ),
                            ],
                          ),
                        24.height,
                        Text(appStore.userFullName,
                            style: boldTextStyle(color: white, size: 18)),
                        4.height,
                        Text(appStore.userEmail,
                            style: secondaryTextStyle(
                                color: white.withOpacity(0.8), size: 16)),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: -50,
                    left: 0,
                    right: 0,
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 28),
                      padding:
                          EdgeInsets.symmetric(horizontal: 40, vertical: 24),
                      decoration: boxDecorationWithRoundedCorners(
                          backgroundColor:
                              appStore.isDarkMode ? cardDarkColor : cardColor),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "${appStore.totalBooking.validate().toString()}",
                                style: boldTextStyle(
                                    color: primaryColor, size: 22),
                              ),
                              8.height,
                              Text(
                                "${context.translate.lblServices} \n${context.translate.lblDelivered}",
                                style: secondaryTextStyle(),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                          Container(
                              height: 45,
                              width: 1,
                              color: appTextSecondaryColor.withOpacity(0.4)),
                          ExperienceWidget(key: keyForExperienceWidget),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              80.height,
              SettingItemWidget(
                leading: Image.asset(language,
                    height: 18, width: 18, color: context.iconColor),
                title: context.translate.language,
                trailing: Icon(Icons.chevron_right,
                    color: appStore.isDarkMode ? white : gray.withOpacity(0.8),
                    size: 24),
                onTap: () {
                  LanguagesScreen().launch(context).then((value) {
                    keyForExperienceWidget = UniqueKey();
                  });
                },
              ),
              Divider(
                  height: 4,
                  endIndent: 16,
                  indent: 16,
                  color: gray.withOpacity(0.3)),
              SettingItemWidget(
                leading: Image.asset(
                  ic_theme,
                  height: 18,
                  width: 18,
                  color: appStore.isDarkMode ? white : gray.withOpacity(0.8),
                ),
                title: context.translate.appTheme,
                trailing: Icon(Icons.chevron_right,
                    color: appStore.isDarkMode ? white : gray.withOpacity(0.8),
                    size: 24),
                onTap: () async {
                  await showInDialog(
                    context,
                    builder: (context) => ThemeSelectionDaiLog(context),
                    contentPadding: EdgeInsets.zero,
                  );
                },
              ),
              Divider(
                  height: 4,
                  endIndent: 16,
                  indent: 16,
                  color: gray.withOpacity(0.3)),
              SettingItemWidget(
                leading: Image.asset(changePassword,
                    height: 18, width: 18, color: context.iconColor),
                title: context.translate.changePassword,
                trailing: Icon(Icons.chevron_right,
                    color: appStore.isDarkMode ? white : gray.withOpacity(0.8),
                    size: 24),
                onTap: () {
                  ChangePasswordScreen().launch(context,
                      pageRouteAnimation: PageRouteAnimation.Slide);
                },
              ),
              Divider(height: 0, thickness: 1, indent: 15.0, endIndent: 15.0)
                  .visible(appStore.isLoggedIn),
              SettingItemWidget(
                leading: Image.asset(about,
                    height: 18,
                    width: 18,
                    color: appStore.isDarkMode ? white : gray.withOpacity(0.8)),
                title: context.translate.lblAbout,
                trailing: Icon(Icons.chevron_right,
                    color: appStore.isDarkMode ? white : gray.withOpacity(0.8),
                    size: 24),
                onTap: () {
                  AboutUsScreen().launch(context,
                      pageRouteAnimation: PageRouteAnimation.Slide);
                },
              ),
              if (isIqonicProduct)
                // Column(
                //   children: [
                //     Divider(height: 0, thickness: 1, indent: 15.0, endIndent: 15.0).visible(appStore.isLoggedIn),
                //     SettingItemWidget(
                //       leading: Image.asset(purchase, height: 20, width: 20, color: appStore.isDarkMode ? white : gray.withOpacity(0.8)),
                //       title: context.translate.lblPurchaseCode,
                //       trailing: Icon(Icons.chevron_right, color: appStore.isDarkMode ? white : gray.withOpacity(0.8), size: 24),
                //       onTap: () {
                //         launchUrlCustomTab(PURCHASE_URL);
                //       },
                //     ),
                //   ],
                // ),
                20.height,
              TextButton(
                child: Text(context.translate.logout,
                    style: boldTextStyle(color: primaryColor, size: 18)),
                onPressed: () {
                  appStore.setLoading(false);
                  logout(context);
                },
              ).center().visible(appStore.isLoggedIn),
              FutureBuilder<PackageInfo>(
                future: PackageInfo.fromPlatform(),
                builder: (context, snap) {
                  if (snap.hasData) {
                    return Text(
                        "v${snap.data!.version.validate(value: '1.0.0')}",
                        style: secondaryTextStyle(size: 14));
                  }
                  return snapWidgetHelper(snap, loadingWidget: Offstage());
                },
              ).center(),
            ],
          ).paddingOnly(bottom: 24),
        ),
      ),
    );
  }
}
