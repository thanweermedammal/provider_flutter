import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:handyman_provider_flutter/fragments/booking_fragment.dart';
import 'package:handyman_provider_flutter/fragments/notification_fragment.dart';
import 'package:handyman_provider_flutter/handyman/screen/fragment/handyman_fragment.dart';
import 'package:handyman_provider_flutter/handyman/screen/fragment/handyman_profile_fragment.dart';
import 'package:handyman_provider_flutter/main.dart';
import 'package:handyman_provider_flutter/screens/chat/user_chat_list_screen.dart';
import 'package:handyman_provider_flutter/utils/colors.dart';
import 'package:handyman_provider_flutter/utils/constant.dart';
import 'package:handyman_provider_flutter/utils/extensions/context_ext.dart';
import 'package:handyman_provider_flutter/utils/extensions/string_extension.dart';
import 'package:handyman_provider_flutter/utils/images.dart';
import 'package:nb_utils/nb_utils.dart';

class HandyDashboardScreen extends StatefulWidget {
  final int? index;

  HandyDashboardScreen({this.index});

  @override
  _HandyDashboardScreenState createState() => _HandyDashboardScreenState();
}

class _HandyDashboardScreenState extends State<HandyDashboardScreen> {
  int currentIndex = 0;

  List<Widget> fragmentList = [
    HandymanFragment(),
    BookingFragment(),
    NotificationFragment(),
    ProfileFragment(),
  ];

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    setStatusBarColor(primaryColor);

    afterBuildCreated(() async {
      if (getIntAsync(THEME_MODE_INDEX) == ThemeModeSystem) {
        appStore.setDarkMode(context.platformBrightness() == Brightness.dark);
      }

      window.onPlatformBrightnessChanged = () async {
        if (getIntAsync(THEME_MODE_INDEX) == ThemeModeSystem) {
          appStore.setDarkMode(context.platformBrightness() == Brightness.light);
        }
      };
    });

    LiveStream().on(HandyBoardStream, (index) {
      currentIndex = index as int;
      setState(() {});
    });

    LiveStream().on(handymanAllBooking, (index) {
      currentIndex = index as int;
      setState(() {});
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    super.dispose();
    LiveStream().dispose(HandyBoardStream);
    LiveStream().dispose(handymanAllBooking);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: fragmentList[currentIndex],
      appBar: appBarWidget(
        [
          context.translate.lblHandymanDashboard,
          context.translate.lblBooking,
          context.translate.notification,
          context.translate.lblProfile,
        ][currentIndex],
        color: primaryColor,
        elevation: 0.0,
        textColor: Colors.white,
        showBack: false,
        actions: [
          IconButton(
            icon: Image.asset(chat, height: 20, width: 20, color: white),
            onPressed: () async {
              UserChatListScreen().launch(context);
            },
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: ic_home.iconImage(color: appTextSecondaryColor),
            label: 'Dashboard',
            activeIcon: ic_fill_home.iconImage(color: primaryColor),
          ),
          BottomNavigationBarItem(
            icon: total_booking.iconImage(color: appTextSecondaryColor),
            label: 'Bookings',
            activeIcon: fill_ticket.iconImage(color: primaryColor),
          ),
          BottomNavigationBarItem(
            icon: ic_notification.iconImage(color: appTextSecondaryColor),
            label: 'Notifications',
            activeIcon: ic_fill_notification.iconImage(color: primaryColor),
          ),
          BottomNavigationBarItem(
            icon: ic_profile2.iconImage(color: appTextSecondaryColor),
            label: 'Profile',
            activeIcon: ic_fill_profile.iconImage(color: primaryColor),
          ),
        ],
        onTap: (index) {
          currentIndex = index;
          setState(() {});
        },
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
      ),
    );
  }
}
