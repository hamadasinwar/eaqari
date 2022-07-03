import 'package:flutter/material.dart';

import '../../models/address.dart';
import '../../models/real_state.dart';

class Constants {

  static const offerId = "new_offer";
  static const messageId = "new_message";

  static const personPlaceHolder = "https://firebasestorage.googleapis.com/v0/b/carbon-hulling-276811.appspot.com/o/assets%2Fperson.jpg?alt=media&token=bd111004-5df5-43e4-9f05-a870fd2c912e";

  static final GlobalKey<ScaffoldMessengerState> snackBarKey = GlobalKey<ScaffoldMessengerState>();

  static final dummyData = RealState(
    name: "شقة للإيجار",
    area: 120,
    bathroomsNum: 1,
    bedroomsNum: 3,
    livingRoomsNum: 1,
    category: "1",
    details: "",
    hasKitchen: true,
    type: "للإيجار",
    address: Address(apartmentNum: "123", floorNum: "2", state: "غزة", street: "الوحدة", place: "بجوار"),
    images: ["https://i.pinimg.com/564x/c6/5d/8d/c65d8dac60ec2420ff4921c358076955.jpg"],
  );

  static showLoaderDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: Row(
        children: [
          CircularProgressIndicator(color: Theme.of(context).primaryColor),
          Container(
            margin: const EdgeInsets.only(right: 15),
            child: const Text("جارِ التحميل..."),
          ),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
