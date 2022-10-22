import 'package:flutter/material.dart';
import 'package:handyman_provider_flutter/main.dart';
import 'package:handyman_provider_flutter/utils/colors.dart';
import 'package:handyman_provider_flutter/utils/configs.dart';
import 'package:handyman_provider_flutter/utils/constant.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

//region App Default Settings
void defaultSettings() {
  passwordLengthGlobal = 8;
  appButtonBackgroundColorGlobal = primaryColor;
  defaultRadius = 12;
  defaultAppButtonTextColorGlobal = Colors.white;
  defaultElevation = 0;
  defaultBlurRadius = 0;
  defaultSpreadRadius = 0;
}
//endregion

//region Set User Values when user is logged In
Future<void> setLoginValues() async {
  if (appStore.isLoggedIn) {
    await appStore.setUserId(getIntAsync(USER_ID), isInitializing: true);
    await appStore.setFirstName(getStringAsync(FIRST_NAME), isInitializing: true);
    await appStore.setLastName(getStringAsync(LAST_NAME), isInitializing: true);
    await appStore.setUserEmail(getStringAsync(USER_EMAIL), isInitializing: true);
    await appStore.setUserName(getStringAsync(USERNAME), isInitializing: true);
    await appStore.setContactNumber(getStringAsync(CONTACT_NUMBER), isInitializing: true);
    await appStore.setUserProfile(getStringAsync(PROFILE_IMAGE), isInitializing: true);
    await appStore.setCountryId(getIntAsync(COUNTRY_ID), isInitializing: true);
    await appStore.setStateId(getIntAsync(STATE_ID), isInitializing: true);
    await appStore.setUId(getStringAsync(UID), isInitializing: true);
    await appStore.setCityId(getIntAsync(CITY_ID), isInitializing: true);
    await appStore.setUserType(getStringAsync(USER_TYPE), isInitializing: true);
    await appStore.setServiceAddressId(getIntAsync(SERVICE_ADDRESS_ID), isInitializing: true);
    await appStore.setProviderId(getIntAsync(PROVIDER_ID), isInitializing: true);

    await appStore.setCurrencyCode(getStringAsync(CURRENCY_COUNTRY_CODE), isInitializing: true);
    await appStore.setCurrencyCountryId(getStringAsync(CURRENCY_COUNTRY_ID), isInitializing: true);
    await appStore.setCurrencySymbol(getStringAsync(CURRENCY_COUNTRY_SYMBOL), isInitializing: true);
    await appStore.setCreatedAt(getStringAsync(CREATED_AT), isInitializing: true);
    await appStore.setTotalBooking(getIntAsync(TOTAL_BOOKING), isInitializing: true);

    await appStore.setToken(getStringAsync(TOKEN), isInitializing: true);

    await appStore.setTester(getBoolAsync(IS_TESTER), isInitializing: true);
    await appStore.setPrivacyPolicy(getStringAsync(PRIVACY_POLICY), isInitializing: true);
    await appStore.setTermConditions(getStringAsync(TERM_CONDITIONS), isInitializing: true);
    await appStore.setInquiryEmail(getStringAsync(INQUIRY_EMAIL), isInitializing: true);
    await appStore.setHelplineNumber(getStringAsync(HELPLINE_NUMBER), isInitializing: true);
    await setSaveSubscription();
  }
}

Future<void> setSaveSubscription({int? isSubscribe, String? title, String? identifier, String? endAt}) async {
  await appStore.setPlanTitle(title ?? getStringAsync(PLAN_TITLE), isInitializing: title == null);
  await appStore.setIdentifier(identifier ?? getStringAsync(PLAN_IDENTIFIER), isInitializing: identifier == null);
  await appStore.setPlanEndDate(endAt ?? getStringAsync(PLAN_END_DATE), isInitializing: endAt == null);
  await appStore.setPlanSubscribeStatus(isSubscribe.validate() == 1, isInitializing: isSubscribe == null);
}

//endregion

//region OneSignal Setup
setOneSignal() async {
  OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);

  await OneSignal.shared.setAppId(ONESIGNAL_APP_ID).then((value) {
    OneSignal.shared.promptUserForPushNotificationPermission().then((accepted) {
      print("Accepted permission: $accepted");
    });

    OneSignal.shared.setNotificationWillShowInForegroundHandler((OSNotificationReceivedEvent? event) {
      return event?.complete(event.notification);
    });

    OneSignal.shared.getDeviceState().then((value) async {
      if (value!.userId.validate().isNotEmpty) await setValue(PLAYERID, value.userId.validate());
    });

    OneSignal.shared.disablePush(false);

    OneSignal.shared.consentGranted(true);
    OneSignal.shared.requiresUserPrivacyConsent();
    OneSignal.shared.consentGranted(true);
    OneSignal.shared.promptUserForPushNotificationPermission();

    OneSignal.shared.setSubscriptionObserver((changes) async {
      if (!changes.to.userId.isEmptyOrNull) await setValue(PLAYERID, changes.to.userId);
    });
  });
}

//endregion
Decoration cardDecoration(BuildContext context, {Color? color, bool showBorder = true}) {
  return boxDecorationWithRoundedCorners(
    borderRadius: radius(),
    backgroundColor: color ?? context.scaffoldBackgroundColor,
    border: showBorder ? Border.all(color: context.dividerColor, width: 1.5) : null,
  );
}

Decoration categoryDecoration(BuildContext context, {Color? color, bool showBorder = true}) {
  return boxDecorationWithRoundedCorners(
    borderRadius: radius(),
    backgroundColor: color ?? context.cardColor,
    border: showBorder ? Border.all(color: context.dividerColor, width: 1.5) : null,
  );
}

int getRemainingPlanDays() {
  if (appStore.planEndDate.isNotEmpty) {
    var now = DateTime.now();
    DateTime date = DateTime(now.year, now.month, now.day);
    DateTime endAt = DateFormat(DATE_FORMAT_7).parse(appStore.planEndDate);

    return (date.difference(endAt).inDays).abs();
  } else {
    return 0;
  }
}
