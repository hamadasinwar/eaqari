import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:graduation_project/utils/constants/constants.dart';
import 'package:pinput/pin_put/pin_put.dart';
import '../models/user.dart';
import 'firestore_service.dart';
import 'dart:developer';

class AuthService{

  static String checkIsLoggedIn(){
    if(FirebaseAuth.instance.currentUser != null){
      return "main";
    }
    return "login";
  }

  static void logout(){
    FirebaseAuth.instance.signOut();
  }

  static void phoneAuth(BuildContext ctx, String verificationID, String pinCode) async {
    await FirebaseAuth.instance.signInWithCredential(
      PhoneAuthProvider.credential(
          verificationId: verificationID, smsCode: pinCode),
    );
  }

  static String? getCurrentUserID(){
    return FirebaseAuth.instance.currentUser?.uid;
  }

  static Future<String?> loginUser(MyUser myUser, BuildContext context, bool isNewAccount) async{
    String? uid;
    FirebaseAuth _auth = FirebaseAuth.instance;
    final controller = TextEditingController();
    _auth.verifyPhoneNumber(
      phoneNumber: myUser.phone!,
      timeout: const Duration(seconds: 90),
      verificationCompleted: (phoneAuthCredential) {},
      verificationFailed: (error) {
        SnackBar snackBar = SnackBar(
          content: Text(getErrorMessage(error.code), style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.red)),
          duration: const Duration(seconds: 5),
        );
        Constants.snackBarKey.currentState?.showSnackBar(snackBar);
        Navigator.pop(context);
      },
      codeSent: ( verificationId, forceResendingToken){
        Navigator.pop(context);
        showDialog(context: context, barrierDismissible: false, builder: (context) {
              return AlertDialog(
                backgroundColor: Colors.white,
                title: Text('ادخل رمز التحقق', style: Theme.of(context).textTheme.bodyMedium),
                content: SizedBox(
                  width: 400,
                  child: PinPut(
                    fieldsCount: 6,
                    textStyle:
                    const TextStyle(fontSize: 25.0, color: Colors.black),
                    eachFieldWidth: 40.0,
                    eachFieldHeight: 55.0,
                    controller: controller,
                    selectedFieldDecoration: decoration(context, Theme.of(context).primaryColor),
                    disabledDecoration: decoration(context, Colors.grey),
                    followingFieldDecoration: decoration(context, Theme.of(context).primaryColor),
                    submittedFieldDecoration: decoration(context, Theme.of(context).primaryColor),
                    pinAnimationType: PinAnimationType.fade,
                  ),
                ),
                actions: <Widget>[
                  ElevatedButton(
                    child: Text(
                      "تأكيد",
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: Colors.white, fontWeight: FontWeight.normal),
                    ),
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.resolveWith((states) => Theme.of(context).primaryColor)
                    ),
                    onPressed: () async{
                      final code = controller.text.trim();
                      AuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: code);
                      UserCredential result = await _auth.signInWithCredential(credential);
                      User? user = result.user;
                      uid = user?.uid;
                      if(user != null){
                        if(isNewAccount) {
                          var u = myUser;
                          u.id = user.uid;
                          u.phone = user.phoneNumber;
                          FirestoreServices.updateUser(myUser).then((value) {
                            Navigator.pop(context);
                            Navigator.of(context).pushReplacementNamed("main");
                          });
                        }else{
                          Navigator.pop(context);
                          Navigator.of(context).pushReplacementNamed("main");
                        }
                      }else{
                        SnackBar snackBar = SnackBar(
                          content: Text(getErrorMessage("error.code"), style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.red)),
                          duration: const Duration(seconds: 5),
                        );
                        Constants.snackBarKey.currentState?.showSnackBar(snackBar);
                        Navigator.pop(context);                      }
                    },
                  )
                ],
              );
            });
      },
      codeAutoRetrievalTimeout: (verificationId) {},
    );
    return uid;
  }

  static BoxDecoration decoration(BuildContext context, Color color) {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10.0),
      border: Border.all(
        color: Theme.of(context).primaryColor,
      ),
    );
  }

  static String getErrorMessage(String code){
    switch (code) {
      case "captcha-check-failed":
        return "invalid token";
      case "invalid-phone-number":
        return "رقم الموبايل خاطئ";
      case "user-disabled":
        return "هذا الحساب معطل";
      case "operation-not-allowed":
        return "هذه العملية غير مسموح بها";
      default:
        return "خطأ غير معروف";
    }
  }
}