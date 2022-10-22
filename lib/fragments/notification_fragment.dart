import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:handyman_provider_flutter/handyman/screen/handyman_booking_detail_screen.dart';
import 'package:handyman_provider_flutter/main.dart';
import 'package:handyman_provider_flutter/models/notification_list_response.dart';
import 'package:handyman_provider_flutter/networks/rest_apis.dart';
import 'package:handyman_provider_flutter/provider/booking/p_booking_detail_screen.dart';
import 'package:handyman_provider_flutter/utils/common.dart';
import 'package:handyman_provider_flutter/utils/constant.dart';
import 'package:handyman_provider_flutter/utils/extensions/context_ext.dart';
import 'package:handyman_provider_flutter/utils/model_keys.dart';
import 'package:handyman_provider_flutter/widgets/app_widgets.dart';
import 'package:handyman_provider_flutter/widgets/notification_widget.dart';
import 'package:nb_utils/nb_utils.dart';

class NotificationFragment extends StatefulWidget {
  @override
  NotificationScreenState createState() => NotificationScreenState();
}

class NotificationScreenState extends State<NotificationFragment> {
  List<NotificationData> unReadNotificationList = [];
  List<NotificationData> readNotificationList = [];

  bool hasError = false;
  bool isApiCalled = false;

  @override
  void initState() {
    super.initState();
    afterBuildCreated(() {
      init();
    });
  }

  void init() async {
    getAllNotification();
  }

  Future<void> getAllNotification() async {
    appStore.setLoading(true);
    await getNotification({NotificationKey.type: ""}).then((value) {
      appStore.setLoading(false);
      isApiCalled = true;

      if (unReadNotificationList.isNotEmpty) {
        unReadNotificationList.clear();
      }
      if (readNotificationList.isNotEmpty) {
        readNotificationList.clear();
      }
      unReadNotificationList = value.notificationData!.where((element) => element.readAt == null).toList();
      readNotificationList = value.notificationData!.where((element) => element.readAt != null).toList();

      setState(() {});
    }).catchError((e) {
      appStore.setLoading(false);
      isApiCalled = true;

      toast(e.toString(), print: true);
      setState(() {});
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  Future<void> readNotification({String? id}) async {
    Map request = {CommonKeys.bookingId: id};

    //appStore.setLoading(true);

    await bookingDetail(request).then((value) {
      init();
    }).catchError((e) {
      toast(e.toString(), print: true);
    });

    //appStore.setLoading(false);
  }

  Widget listIterate(List<NotificationData> list) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: list.length,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        NotificationData data = list[index];

        return GestureDetector(
          onTap: () async {
            if (data.data!.type != ADD_WALLET && data.data!.type != UPDATE_WALLET && data.data!.type != WALLET_PAYOUT_TRANSFER) {
              readNotification(id: data.data!.id.toString());
            }

            if (isUserTypeHandyman) {
              HBookingDetailScreen(bookingId: data.data!.id).launch(context);
            } else if (isUserTypeProvider) {
              if (data.data!.type != ADD_WALLET && data.data!.type != UPDATE_WALLET && data.data!.type != WALLET_PAYOUT_TRANSFER) {
                BookingDetailScreen(bookingId: data.data!.id).launch(context);
              } else {
                init();
              }
            }
          },
          child: NotificationWidget(data: data),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => Scaffold(
        body: RefreshIndicator(
          onRefresh: () async {
            appStore.setLoading(true);
            getAllNotification();

            return await 2.seconds.delay;
          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(8, 0, 8, 16),
                child: Column(
                  children: [
                    if (unReadNotificationList.isNotEmpty)
                      Column(
                        children: [
                          Row(
                            children: [
                              Text(context.translate.lblUnreadNotification, style: boldTextStyle(color: appStore.isDarkMode ? white : black)).expand(),
                              TextButton(
                                onPressed: () async {
                                  appStore.setLoading(true);

                                  await getNotification({NotificationKey.type: MarkAsRead}).then((value) {
                                    getAllNotification();
                                  }).catchError((e) {
                                    log(e.toString());
                                  });

                                  appStore.setLoading(false);
                                },
                                child: Text(context.translate.lblMarkAllAsRead, style: primaryTextStyle(size: 12)),
                              )
                            ],
                          ),
                          listIterate(unReadNotificationList),
                        ],
                      ).paddingAll(8),
                    16.height,
                    if (readNotificationList.isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(context.translate.notification, style: boldTextStyle(color: appStore.isDarkMode ? white : black)).paddingAll(8),
                          8.height,
                          listIterate(readNotificationList),
                        ],
                      ),
                  ],
                ),
              ),
              LoaderWidget().visible(appStore.isLoading),
              Text(errorSomethingWentWrong, style: secondaryTextStyle()).center().visible(hasError),
              Observer(
                builder: (_) => noDataFound(context).center().visible(!appStore.isLoading && readNotificationList.isEmpty && isApiCalled),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
