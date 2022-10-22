import 'package:flutter/material.dart';
import 'package:handyman_provider_flutter/components/register_user_form_component.dart';
import 'package:handyman_provider_flutter/main.dart';
import 'package:handyman_provider_flutter/models/dashboard_response.dart';
import 'package:handyman_provider_flutter/models/user_data.dart';
import 'package:handyman_provider_flutter/models/user_list_response.dart';
import 'package:handyman_provider_flutter/networks/rest_apis.dart';
import 'package:handyman_provider_flutter/screens/chat/user_chat_screen.dart';
import 'package:handyman_provider_flutter/utils/colors.dart';
import 'package:handyman_provider_flutter/utils/common.dart';
import 'package:handyman_provider_flutter/utils/constant.dart';
import 'package:handyman_provider_flutter/utils/extensions/context_ext.dart';
import 'package:handyman_provider_flutter/utils/extensions/string_extension.dart';
import 'package:handyman_provider_flutter/utils/images.dart';
import 'package:handyman_provider_flutter/utils/model_keys.dart';
import 'package:handyman_provider_flutter/widgets/app_widgets.dart';
import 'package:nb_utils/nb_utils.dart';

class HandymanWidget extends StatefulWidget {
  const HandymanWidget({
    Key? key,
    this.data,
    required this.width,
    this.data1,
  }) : super(key: key);

  final Handyman? data;
  final double width;
  final UserListData? data1;

  @override
  State<HandymanWidget> createState() => _HandymanWidgetState();
}

class _HandymanWidgetState extends State<HandymanWidget> {
  Future<void> changeStatus(int? id, int status) async {
    appStore.setLoading(true);

    Map request = {CommonKeys.id: id, UserKeys.status: status};

    await updateHandymanStatus(request).then((value) {
      appStore.setLoading(false);

      toast(value.message.toString(), print: true);

      setState(() {});
    }).catchError((e) {
      appStore.setLoading(false);

      toast(e.toString(), print: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: widget.width,
          decoration: boxDecorationWithRoundedCorners(borderRadius: radius(), backgroundColor: appStore.isDarkMode ? cardDarkColor : white),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: boxDecorationWithRoundedCorners(
                  borderRadius: BorderRadius.only(topRight: Radius.circular(8), topLeft: Radius.circular(8)),
                  backgroundColor: primaryColor.withOpacity(0.2),
                ),
                child: cachedImage(
                  widget.data!.profileImage!.isNotEmpty ? widget.data!.profileImage.validate() : '',
                  width: context.width(),
                  height: 110,
                  fit: BoxFit.cover,
                ).cornerRadiusWithClipRRectOnly(topRight: 8, topLeft: 8),
              ),
              Column(
                children: [
                  Text(
                    widget.data!.displayName.validate(),
                    style: boldTextStyle(size: 14),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ).center(),
                  16.height,
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (widget.data!.contactNumber.validate().isNotEmpty)
                        TextIcon(
                          onTap: () {
                            launchCall(widget.data!.contactNumber.validate());
                          },
                          prefix: Container(
                            padding: EdgeInsets.all(8),
                            decoration: boxDecorationWithRoundedCorners(
                              boxShape: BoxShape.circle,
                              backgroundColor: primaryColor.withOpacity(0.1),
                            ),
                            child: Image.asset(calling, color: primaryColor, height: 14, width: 14),
                          ),
                        ),
                      if (widget.data!.email.validate().isNotEmpty)
                        TextIcon(
                          onTap: () {
                            launchMail(widget.data!.email.validate());
                          },
                          prefix: Container(
                            padding: EdgeInsets.all(8),
                            decoration: boxDecorationWithRoundedCorners(
                              boxShape: BoxShape.circle,
                              backgroundColor: primaryColor.withOpacity(0.1),
                            ),
                            child: ic_message.iconImage(size: 14, color: primaryColor),
                          ),
                        ),
                      if (widget.data!.contactNumber.validate().isNotEmpty)
                        TextIcon(
                          onTap: () async {
                            log(widget.data!.email);
                            UserData user = await userService.getUser(email: widget.data!.email.validate()).catchError((e) {
                              log(e.toString());
                            });
                            UserChatScreen(receiverUser: user).launch(context);
                          },
                          prefix: Container(
                            padding: EdgeInsets.all(8),
                            decoration: boxDecorationWithRoundedCorners(
                              boxShape: BoxShape.circle,
                              backgroundColor: primaryColor.withOpacity(0.1),
                            ),
                            child: Image.asset(textMsg, color: primaryColor, height: 14, width: 14),
                          ),
                        ),
                    ],
                  ),
                ],
              ).paddingSymmetric(vertical: 16),
            ],
          ),
        ).onTap(
          () {
            UserListData user = UserListData(
              id: widget.data!.id,
              firstName: widget.data!.firstName,
              lastName: widget.data!.lastName,
              username: widget.data!.username,
              providerId: widget.data!.providerId,
              status: widget.data!.status,
              description: widget.data!.description,
              userType: widget.data!.userType,
              email: widget.data!.email,
              contactNumber: widget.data!.contactNumber,
              countryId: widget.data!.countryId,
              stateId: widget.data!.stateId,
              cityId: widget.data!.cityId,
              cityName: widget.data!.cityName,
              address: widget.data!.address,
              providertypeId: widget.data!.providertypeId,
              providertype: widget.data!.providertype,
              isFeatured: widget.data!.isFeatured,
              displayName: widget.data!.displayName,
              createdAt: widget.data!.createdAt,
              updatedAt: widget.data!.updatedAt,
              profileImage: widget.data!.profileImage,
              timeZone: widget.data!.timeZone,
              lastNotificationSeen: widget.data!.lastNotificationSeen,
              serviceAddressId: widget.data!.serviceAddressId,
            );
            RegisterUserFormComponent(
              user_type: UserTypeHandyman,
              data: user,
              isUpdate: true,
            ).launch(context, pageRouteAnimation: PageRouteAnimation.Slide);
          },
          borderRadius: radius(),
        ),
        Positioned(
          right: 8,
          top: 8,
          child: Container(
            padding: EdgeInsets.all(8),
            decoration: boxDecorationWithRoundedCorners(
              boxShape: BoxShape.circle,
              backgroundColor: context.cardColor,
            ),
            alignment: Alignment.center,
            child: !widget.data!.isActive ? Image.asset(block, width: 18, height: 18) : Image.asset(unBlock, width: 18, height: 18),
          ).onTap(
            () {
              if (appStore.userEmail != DEFAULT_PROVIDER_EMAIL) {
                widget.data!.isActive = !widget.data!.isActive;
                if (!widget.data!.isActive) {
                  changeStatus(widget.data!.id, 1);
                } else {
                  changeStatus(widget.data!.id, 0);
                }
              } else {
                toast(context.translate.lblUnAuthorized);
              }

              setState(() {});
            },
          ),
        )
      ],
    );
  }
}
