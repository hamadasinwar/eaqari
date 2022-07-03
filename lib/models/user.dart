
import 'package:cloud_firestore/cloud_firestore.dart';

class MyUser{

  static const userID = 'userID';
  static const userName = 'username';
  static const userPhone = 'userPhone';
  static const userPassword = 'userPassword';
  static const userState = 'userState';
  static const userAddress = 'userAddress';
  static const userImage = 'userImage';
  static const userToken = 'userToken';

  String? id;
  String? name;
  String? phone;
  String? state;
  String? address;
  String? password;
  String? image;
  String? token;
  DocumentSnapshot? document;

  MyUser({this.id, this.name, this.phone, this.state, this.document, this.address,this.token ,  this.password, this.image});

  factory MyUser.fromMap(Map<String, dynamic> json) =>MyUser(
    id: json[userID],
    name: json[userName],
    phone: json[userPhone],
    password: json[userPassword],
    state: json[userState],
    address: json[userAddress],
    image: json[userImage],
    token: json[userToken],
  );

  MyUser fromFirebase(){
    id = document?.id;
    name = document?[userName].toString();
    phone = document?[userPhone].toString();
    password = document?[userPassword].toString();
    address = document?[userAddress].toString();
    image = document?[userImage].toString();
    token = document?[userToken].toString();
    return this;
  }

  Map<String, String?> toMap(){
    return{
      userName: name,
      userPhone: phone,
      userPassword: password,
      userAddress: address,
      userImage: image,
      userToken: token,
    };
  }
}