import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:handyman_provider_flutter/fragments/booking_fragment.dart';
import 'package:handyman_provider_flutter/fragments/notification_fragment.dart';
import 'package:handyman_provider_flutter/main.dart';
import 'package:handyman_provider_flutter/provider/fragments/home_fragment.dart';
import 'package:handyman_provider_flutter/provider/fragments/payment_fragment.dart';
import 'package:handyman_provider_flutter/provider/fragments/profile_fragment.dart';
import 'package:handyman_provider_flutter/screens/chat/user_chat_list_screen.dart';
import 'package:handyman_provider_flutter/utils/colors.dart';
import 'package:handyman_provider_flutter/utils/constant.dart';
import 'package:handyman_provider_flutter/utils/extensions/context_ext.dart';
import 'package:handyman_provider_flutter/utils/extensions/string_extension.dart';
import 'package:handyman_provider_flutter/utils/images.dart';
import 'package:nb_utils/nb_utils.dart';

class DashboardScreen extends StatefulWidget {
  final int? index;

  DashboardScreen({this.index});

  @override
  DashboardScreenState createState() => DashboardScreenState();
}

class DashboardScreenState extends State<DashboardScreen> {
  int currentIndex = 0;

  DateTime? currentBackPressTime;

  List<Widget> fragmentList = [
    HomeFragment(),
    BookingFragment(),
    PaymentFragment(),
    NotificationFragment(),
  ];

  List<String> screenName = [];

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    afterBuildCreated(
      () async {
        if (getIntAsync(THEME_MODE_INDEX) == ThemeModeSystem) {
          appStore.setDarkMode(context.platformBrightness() == Brightness.dark);
        }

        window.onPlatformBrightnessChanged = () async {
          if (getIntAsync(THEME_MODE_INDEX) == ThemeModeSystem) {
            appStore.setDarkMode(context.platformBrightness() == Brightness.light);
          }
        };
      },
    );

    LiveStream().on(providerAllBooking, (index) {
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
    LiveStream().dispose(providerAllBooking);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        DateTime now = DateTime.now();

        if (currentBackPressTime == null || now.difference(currentBackPressTime!) > Duration(seconds: 2)) {
          currentBackPressTime = now;
          toast(context.translate.lblCloseAppMsg);
          return Future.value(false);
        }
        return Future.value(true);
      },
      child: Scaffold(
        body: fragmentList[currentIndex],
        appBar: appBarWidget(
          [
            context.translate.lblProviderDashboard,
            context.translate.lblBooking,
            context.translate.lblPayment,
            context.translate.notification,
          ][currentIndex],
          color: primaryColor,
          textColor: Colors.white,
          showBack: false,
          actions: [
            IconButton(
              icon: chat.iconImage(color: white, size: 20),
              onPressed: () async {
                UserChatListScreen().launch(context);
              },
            ),
            IconButton(
              icon: ic_profile2.iconImage(color: white, size: 20),
              onPressed: () async {
                ProfileFragment().launch(context);
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
              icon: unfill_wallet.iconImage(color: appTextSecondaryColor),
              label: 'Payment',
              activeIcon: ic_fill_wallet.iconImage(color: primaryColor),
            ),
            BottomNavigationBarItem(
              icon: ic_notification.iconImage(color: appTextSecondaryColor),
              label: 'Notifications',
              activeIcon: ic_fill_notification.iconImage(color: primaryColor),
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
      ),
    );
  }
}
