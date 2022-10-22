import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:handyman_provider_flutter/components/back_widget.dart';
import 'package:handyman_provider_flutter/main.dart';
import 'package:handyman_provider_flutter/models/service_address_response.dart';
import 'package:handyman_provider_flutter/models/user_list_response.dart';
import 'package:handyman_provider_flutter/networks/rest_apis.dart';
import 'package:handyman_provider_flutter/utils/colors.dart';
import 'package:handyman_provider_flutter/utils/common.dart';
import 'package:handyman_provider_flutter/utils/constant.dart';
import 'package:handyman_provider_flutter/utils/extensions/context_ext.dart';
import 'package:handyman_provider_flutter/utils/extensions/string_extension.dart';
import 'package:handyman_provider_flutter/utils/images.dart';
import 'package:handyman_provider_flutter/utils/model_keys.dart';
import 'package:handyman_provider_flutter/widgets/app_widgets.dart';
import 'package:nb_utils/nb_utils.dart';

class RegisterUserFormComponent extends StatefulWidget {
  final String? user_type;
  final UserListData? data;
  final bool isUpdate;

  RegisterUserFormComponent({this.user_type, this.data, this.isUpdate = false});

  @override
  RegisterUserFormComponentState createState() => RegisterUserFormComponentState();
}

class RegisterUserFormComponentState extends State<RegisterUserFormComponent> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController fNameCont = TextEditingController();
  TextEditingController lNameCont = TextEditingController();
  TextEditingController emailCont = TextEditingController();
  TextEditingController userNameCont = TextEditingController();
  TextEditingController mobileCont = TextEditingController();
  TextEditingController passwordCont = TextEditingController();
  TextEditingController cPasswordCont = TextEditingController();

  FocusNode fNameFocus = FocusNode();
  FocusNode lNameFocus = FocusNode();
  FocusNode emailFocus = FocusNode();
  FocusNode userNameFocus = FocusNode();
  FocusNode mobileFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();
  FocusNode cPasswordFocus = FocusNode();

  List<AddressResponse> serviceAddressList = [];
  AddressResponse? selectedServiceAddress;

  int? serviceAddressId;

  bool afterInit = false;

  @override
  void initState() {
    super.initState();
    init();
    afterBuildCreated(() {
      appStore.setLoading(true);
    });
  }

  Future<void> init() async {
    await getAddressList();

    if (widget.data != null) {
      fNameCont.text = widget.data!.firstName.validate();
      lNameCont.text = widget.data!.lastName.validate();
      emailCont.text = widget.data!.email.validate();
      userNameCont.text = widget.data!.username.validate();
      mobileCont.text = widget.data!.contactNumber.validate();
      serviceAddressId = widget.data!.serviceAddressId.validate();
    }
  }

  Future<void> getAddressList() async {
    getAddresses(providerId: appStore.userId).then((value) {
      appStore.setLoading(false);
      serviceAddressList.addAll(value.addressResponse!);

      serviceAddressList.forEach((e) {
        if (e.id == serviceAddressId) {
          selectedServiceAddress = e;
          log(selectedServiceAddress!.id.validate());
        }
      });
      afterInit = true;
      setState(() {});
    }).catchError((e) {
      appStore.setLoading(false);
      toast(e.toString(), print: true);
    });
  }

  Future<void> register() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      hideKeyboard(context);
      String? type = widget.user_type;

      var request = {
        if (widget.isUpdate) CommonKeys.id: widget.data!.id,
        UserKeys.firstName: fNameCont.text,
        UserKeys.lastName: lNameCont.text,
        UserKeys.userName: userNameCont.text,
        UserKeys.userType: type,
        UserKeys.providerId: appStore.userId,
        UserKeys.status: UserStatusCode,
        UserKeys.contactNumber: mobileCont.text,
        if (serviceAddressId != null && serviceAddressId != -1) UserKeys.serviceAddressId: serviceAddressId.validate(),
        UserKeys.email: emailCont.text,
        if (!widget.isUpdate) UserKeys.password: passwordCont.text
      };
      appStore.setLoading(true);
      if (widget.isUpdate) {
        await updateProfile(request).then((res) async {
          toast(res.message.validate());
          finish(context, true);
        }).catchError((e) {
          toast(e.toString());
        });
      } else {
        await registerUser(request).then((res) async {
          toast(res.message.validate());
          finish(context, true);
        }).catchError((e) {
          toast(e.toString());
        });
      }
      appStore.setLoading(false);
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: context.cardColor,
        appBar: appBarWidget(
          widget.isUpdate ? context.translate.lblUpdate : context.translate.lblAddHandyman,
          textColor: white,
          color: context.primaryColor,
          backWidget: BackWidget(),
          showBack: true,
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Form(
                key: formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    16.height,
                    AppTextField(
                      textFieldType: TextFieldType.NAME,
                      controller: fNameCont,
                      focus: fNameFocus,
                      nextFocus: lNameFocus,
                      decoration: inputDecoration(
                        context,
                        hint: context.translate.hintFirstNameTxt,
                        fillColor: context.scaffoldBackgroundColor,
                      ),
                      suffix: profile.iconImage(size: 10).paddingAll(14),
                    ),
                    16.height,
                    AppTextField(
                      textFieldType: TextFieldType.NAME,
                      controller: lNameCont,
                      focus: lNameFocus,
                      nextFocus: userNameFocus,
                      decoration: inputDecoration(
                        context,
                        hint: context.translate.hintLastNameTxt,
                        fillColor: context.scaffoldBackgroundColor,
                      ),
                      suffix: profile.iconImage(size: 10).paddingAll(14),
                    ),
                    16.height,
                    AppTextField(
                      textFieldType: TextFieldType.USERNAME,
                      controller: userNameCont,
                      focus: userNameFocus,
                      nextFocus: emailFocus,
                      decoration: inputDecoration(
                        context,
                        hint: context.translate.hintUserNameTxt,
                        fillColor: context.scaffoldBackgroundColor,
                      ),
                      suffix: profile.iconImage(size: 10).paddingAll(14),
                    ),
                    16.height,
                    AppTextField(
                      textFieldType: TextFieldType.EMAIL,
                      controller: emailCont,
                      focus: emailFocus,
                      nextFocus: mobileFocus,
                      decoration: inputDecoration(
                        context,
                        hint: context.translate.hintEmailAddressTxt,
                        fillColor: context.scaffoldBackgroundColor,
                      ),
                      suffix: ic_message.iconImage(size: 10).paddingAll(14),
                    ),
                    16.height,
                    AppTextField(
                      textFieldType: TextFieldType.PHONE,
                      controller: mobileCont,
                      focus: mobileFocus,
                      nextFocus: passwordFocus,
                      decoration: inputDecoration(
                        context,
                        hint: context.translate.hintContactNumberTxt,
                        fillColor: context.scaffoldBackgroundColor,
                      ),
                      suffix: calling.iconImage(size: 10).paddingAll(14),
                    ),
                    16.height,
                    DropdownButtonFormField<AddressResponse>(
                      decoration: inputDecoration(
                        context,
                        hint: context.translate.lblAddress,
                        fillColor: context.scaffoldBackgroundColor,
                      ),
                      isExpanded: true,
                      dropdownColor: context.cardColor,
                      value: selectedServiceAddress != null ? selectedServiceAddress : null,
                      items: serviceAddressList.map((data) {
                        return DropdownMenuItem<AddressResponse>(
                          value: data,
                          child: Text(
                            data.address.validate(),
                            style: primaryTextStyle(),
                          ),
                        );
                      }).toList(),
                      onChanged: (AddressResponse? value) async {
                        selectedServiceAddress = value;
                        serviceAddressId = selectedServiceAddress!.id.validate();
                        setState(() {});
                      },
                    ).visible(serviceAddressList.isNotEmpty),
                    16.height.visible(!widget.isUpdate),
                    AppTextField(
                      textFieldType: TextFieldType.PASSWORD,
                      controller: passwordCont,
                      focus: passwordFocus,
                      decoration: inputDecoration(
                        context,
                        hint: context.translate.hintPass,
                        fillColor: context.scaffoldBackgroundColor,
                      ),
                      onFieldSubmitted: (s) {
                        if (getStringAsync(USER_EMAIL) != DEFAULT_PROVIDER_EMAIL) {
                          register();
                        } else {
                          toast(context.translate.lblUnAuthorized);
                        }
                      },
                    ).visible(!widget.isUpdate),
                    24.height,
                    AppButton(
                      text: context.translate.btnSave,
                      height: 40,
                      color: primaryColor,
                      textStyle: primaryTextStyle(color: white),
                      width: context.width() - context.navigationBarHeight,
                      onTap: () {
                        if (!appStore.isTester) {
                          register();
                        } else {
                          toast(context.translate.lblUnAuthorized);
                        }
                      },
                    ),
                    16.height,
                  ],
                ),
              ),
            ),
            Observer(builder: (_) => LoaderWidget().center().visible(appStore.isLoading)),
          ],
        ),
      ),
    );
  }
}
