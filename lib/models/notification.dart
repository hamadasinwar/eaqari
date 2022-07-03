import 'package:cloud_firestore/cloud_firestore.dart';

class MyNotification{
  static const notificationTitle = 'title';
  static const notificationContent = 'content';
  static const notificationTime = 'time';
  static const notificationIcon = 'icon';
  static const notificationReceiver = 'receiver';
  static const notificationAction = 'action';

  String? title;
  String? content;
  Timestamp? time;
  String? icon;
  String? receiver;
  String? action;
  DocumentSnapshot? document;

  MyNotification({this.title, this.content, this.time, this.icon, this.receiver, this.action, this.document});

  Map<String, dynamic> toMap() {
    return {
      notificationTitle: title,
      notificationContent: content,
      notificationTime: time,
      notificationIcon: icon,
      notificationReceiver: receiver,
      notificationAction: action,
    };
  }

  factory MyNotification.fromMap(Map<String, dynamic> json) => MyNotification(
    title: json[notificationTitle],
    content: json[notificationContent],
    time: json[notificationTime],
    icon: json[notificationIcon],
    receiver: json[notificationReceiver],
    action: json[notificationAction],
  );

  MyNotification fromFirebase(){
    title = document?[notificationTitle];
    content = document?[notificationContent];
    time = document?[notificationTime];
    icon = document?[notificationIcon];
    receiver = document?[notificationReceiver];
    action = document?[notificationAction];
    return this;
  }
}