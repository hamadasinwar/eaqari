import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  static const messageSenderId = 'senderId';
  static const messageReceiverId = 'receiverId';
  static const messageDateTime = 'dateTime';
  static const messageText = 'text';

  String? senderId;
  String? receiverId;
  Timestamp? dateTime;
  String? text;
  DocumentSnapshot? document;

  MessageModel({
    this.senderId,
    this.receiverId,
    this.dateTime,
    this.text,
    this.document
  });

  factory MessageModel.fromMap(Map<String, dynamic> json) => MessageModel(
        senderId: json[messageSenderId],
        receiverId: json[messageReceiverId],
        dateTime: json[messageDateTime],
        text: json[messageText],
      );

  MessageModel fromFirebase() {
    senderId = document?[messageSenderId].toString();
    receiverId = document?[messageReceiverId].toString();
    dateTime = document?[messageDateTime];
    text = document?[messageText].toString();
    return this;
  }

  Map<String, dynamic> toMap() {
    return {
      messageSenderId: senderId,
      messageReceiverId: receiverId,
      messageDateTime: dateTime,
      messageText: text,
    };
  }
}
