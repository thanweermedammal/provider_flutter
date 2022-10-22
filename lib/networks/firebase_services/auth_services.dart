import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:handyman_provider_flutter/auth/sign_in_screen.dart';
import 'package:handyman_provider_flutter/handyman/screen/dashboard/handyman_dashboard_screen.dart';
import 'package:handyman_provider_flutter/main.dart';
import 'package:handyman_provider_flutter/models/login_response.dart';
import 'package:handyman_provider_flutter/models/register_response.dart';
import 'package:handyman_provider_flutter/models/user_data.dart';
import 'package:handyman_provider_flutter/networks/rest_apis.dart';
import 'package:handyman_provider_flutter/provider/dashboard/dashboard_screen.dart';
import 'package:handyman_provider_flutter/utils/constant.dart';
import 'package:handyman_provider_flutter/utils/extensions/context_ext.dart';
import 'package:nb_utils/nb_utils.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class AuthServices {
  Future<void> updateUserData(UserData user) async {
    userService.updateDocument({
      'player_id': getStringAsync(PLAYERID),
      'updatedAt': Timestamp.now(),
    }, user.uid);
  }

  Future<void> signUpWithEmailPassword(context, {required RegisterData registerData, bool isLogin = true, LoginResponse? loginResponse}) async {
    //
    UserCredential? userCredential = await _auth.createUserWithEmailAndPassword(email: registerData.email.validate(), password: registerData.password.validate()).catchError((e) async {
      await _auth.signInWithEmailAndPassword(email: registerData.email.validate(), password: registerData.password.validate()).then((value) {
        //
        setRegisterData(
          context,
          currentUser: value.user!,
          registerData: registerData,
          userModel: UserData(
            uid: value.user!.uid,
            apiToken: registerData.api_token,
            contactNumber: registerData.contact_number,
            displayName: registerData.display_name,
            email: registerData.email,
            firstName: registerData.first_name,
            lastName: registerData.last_name,
            userType: registerData.user_type,
            username: registerData.username,
          ),
          isLogin: true,
        );
      }).catchError((e) {
        toast(e.toString());
      });
    });

    if (userCredential.user != null) {
      User currentUser = userCredential.user!;
      String displayName = registerData.first_name.validate() + registerData.last_name.validate();

      UserData userModel = UserData()
        ..uid = currentUser.uid
        ..email = currentUser.email
        ..contactNumber = registerData.contact_number
        ..firstName = registerData.first_name.validate()
        ..lastName = registerData.last_name.validate()
        ..username = registerData.username.validate()
        ..displayName = displayName
        ..userType = registerData.user_type.validate()
        ..createdAt = Timestamp.now().toDate().toString()
        ..updatedAt = Timestamp.now().toDate().toString()
        ..playerId = getStringAsync(PLAYERID);

      setRegisterData(context, currentUser: currentUser, registerData: registerData, userModel: userModel, isLogin: isLogin, loginResponse: loginResponse);
    }
  }

  Future<void> setRegisterData(BuildContext context, {required User currentUser, RegisterData? registerData, required UserData userModel, bool isLogin = true, LoginResponse? loginResponse}) async {
    await userService.addDocumentWithCustomId(currentUser.uid, userModel.toJson()).then((value) async {
      if (isLogin) {
        if (loginResponse != null) {
          loginResponse.data!.uid = value.id.validate();
          if (loginResponse.data!.status.validate() != 0) {
            /// Redirect on the base of User Role.
            if (loginResponse.data!.email == DEFAULT_PROVIDER_EMAIL || loginResponse.data!.email == DEFAULT_HANDYMAN_EMAIL) {
              appStore.setTester(true);
            }
            if (loginResponse.data!.userType == UserTypeProvider) {
              /// if User type id Provider
              if (loginResponse.data != null) await saveUserData(loginResponse.data!);
              DashboardScreen(index: 0).launch(context, isNewTask: true, pageRouteAnimation: PageRouteAnimation.Slide);
              toast(context.translate.loginSuccessfully);
            } else if (loginResponse.data!.userType == UserTypeHandyman) {
              /// if User type id Handyman
              if (loginResponse.data != null) await saveUserData(loginResponse.data!);
              HandyDashboardScreen().launch(context, isNewTask: true, pageRouteAnimation: PageRouteAnimation.Slide);
              toast(context.translate.loginSuccessfully);
            } else {
              toast(context.translate.cantLogin, print: true);
            }
          } else {
            appStore.setLoading(false);
            toast(context.translate.cantLogin, print: true);

            push(SignInScreen(), isNewTask: true, pageRouteAnimation: PageRouteAnimation.Slide);
          }
        }
      } else {
        appStore.setLoading(false);

        push(SignInScreen(), isNewTask: true, pageRouteAnimation: PageRouteAnimation.Slide);
      }
    }).catchError((e) {
      log(e.toString());

      throw USER_NOT_CREATED;
    });
  }

  Future<void> changePassword(String newPassword) async {
    await FirebaseAuth.instance.currentUser!.updatePassword(newPassword).then((value) async {
      await setValue(PASSWORD, newPassword);
    });
  }

  Future<void> signInWithEmailPassword(context, {required String email, required String password}) async {
    _auth.signInWithEmailAndPassword(email: email, password: password).then((value) async {
      final User user = value.user!;
      UserData userModel = await userService.getUser(email: user.email);
      await updateUserData(userModel);
    }).catchError((error) async {
      if (!await isNetworkAvailable()) {
        throw 'Please check network connection';
      }
      throw 'Enter valid email and password';
    });
  }
}
