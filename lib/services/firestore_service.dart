import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:graduation_project/models/message.dart';
import 'package:graduation_project/models/notification.dart';
import 'package:graduation_project/models/offer.dart';
import 'package:graduation_project/models/real_state.dart';
import 'package:graduation_project/services/auth_service.dart';
import 'package:graduation_project/services/notification_service.dart';
import 'package:graduation_project/utils/constants/constants.dart';
import '../models/category.dart';
import '../models/user.dart';

class FirestoreServices {
  static CollectionReference usersRef = FirebaseFirestore.instance.collection("users");
  static CollectionReference realStatesRef = FirebaseFirestore.instance.collection("realStates");
  static CollectionReference categoryRef = FirebaseFirestore.instance.collection("categories");
  static CollectionReference notificationRef = FirebaseFirestore.instance.collection("notification");

  Future<DocumentReference> signUp(MyUser user) async {
    return await usersRef.add(user.toMap());
  }

  static Future updateUser(MyUser user) async {
    return await usersRef.doc(user.id!).set(user.toMap());
  }

  Future<List<MyUser>> get users async {
    var u = await usersRef.get();

    return u.docs.map((doc) => MyUser(document: doc).fromFirebase()).toList();
  }

  static Stream<QuerySnapshot> get realStates {
    return realStatesRef.snapshots();
  }

  static Future<List<RealState>> get allRealStates async {
    var snapshot = await realStatesRef.get();
    var reals = snapshot.docs.map((doc) => RealState(document: doc).fromFirebase()).toList();
    for (var r in reals) {
      r.isFavorite = await isFavorite(r);
    }
    return reals;
  }

  static Stream<QuerySnapshot> get categories {
    return categoryRef.snapshots();
  }

  static Future<List<Category>> get allCategories async {
    var snapshot = await categoryRef.get();
    return snapshot.docs.map((doc) => Category(document: doc).formFirebase()).toList();
  }

  static Future<MyUser> getUser(String id) async {
    return MyUser(document: await usersRef.doc(id).get()).fromFirebase();
  }

  static Future<bool> addRealState(RealState realState) async {
    var result = false;
    await realStatesRef.add(realState.toMap())
        .whenComplete(() => result = true)
        .catchError((error) => result = false);
    return result;
  }

  static Future<bool> addFavorite(RealState realState) async {
    var result = false;
    await realStatesRef
        .doc(realState.id)
        .collection("favorites")
        .doc(AuthService.getCurrentUserID())
        .set({"isFavorite": true})
        .whenComplete(() => result = true)
        .catchError((error) {
          result = false;
        });
    return result;
  }

  static Future updateOffer(Offer offer, String state)async{
    var o = offer;
    o.state = state;
    await realStatesRef.doc(offer.realState)
        .collection("offers")
        .doc(offer.id).delete().whenComplete((){
      usersRef
          .doc(offer.user)
          .collection("offers")
          .doc(offer.realState)
          .set(o.toMap());
    });
  }

  static Future<bool> removeFavorite(RealState realState) async {
    var result = false;
    await realStatesRef
        .doc(realState.id)
        .collection("favorites")
        .doc(AuthService.getCurrentUserID())
        .set({"isFavorite": false})
        .whenComplete(() => result = true)
        .catchError((error) {
          result = false;
        });
    return result;
  }

  static Future<bool> isFavorite(RealState realState) async {
    var result = false;
    var d = await realStatesRef
        .doc(realState.id)
        .collection("favorites")
        .doc(AuthService.getCurrentUserID())
        .get();
    result = d.data()?["isFavorite"] ?? false;
    return result;
  }

  static Future addCategory(String str) async {
    await categoryRef.add({"category": str});
  }

  static Future updateUserImage(String image) async {
    usersRef.doc(AuthService.getCurrentUserID()).set(
      {"userImage": image},
    );
  }

  static Future<bool> sendMessage(MessageModel message) async {
    usersRef
        .doc(message.senderId)
        .collection("chats")
        .doc(message.receiverId)
        .collection("messages")
        .add(message.toMap())
        .then((value) {
      usersRef
          .doc(message.receiverId)
          .collection("chats")
          .doc(message.senderId)
          .collection("messages")
          .add(message.toMap())
          .then((value) async {
        var receiver = await getUser(message.receiverId ?? "");
        var notify = MyNotification(
          title: "رسالة جديدة",
          receiver: message.receiverId,
          action: message.senderId,
          content: message.text,
          icon: receiver.image,
          time: Timestamp.fromDate(DateTime.now()),
        );
        NotificationService.sendNotification(
          [receiver.token ?? ""],
          notify.content!,
          notify.title!,
          receiver.image ?? '',
          Constants.messageId,
        );
        await addNotification(notify);
        return true;
      }).catchError((error) {
        return false;
      });
    });
    return false;
  }

  static Future<bool> addOffer(Offer offer, RealState realState) async {
    var result = false;
    realStatesRef.doc(offer.realState)
        .collection("offers")
        .doc(AuthService.getCurrentUserID())
        .set(offer.toMap())
        .then((vv){
          usersRef.doc(AuthService.getCurrentUserID())
              .collection("offers")
              .doc(offer.realState)
              .set(offer.toMap())
              .then((value)async{
            result = true;
            var user = await getUser(offer.owner ?? "");
            var notify = MyNotification(
                title: "عرض جديد لعقارك!",
                content: "${realState.name} لديه عرض جديد",
                icon: user.image,
                receiver: offer.owner,
                action: offer.realState,
                time: offer.timestamp);
            NotificationService.sendNotification(
              [user.token ?? ""],
              notify.content!,
              notify.title!,
              realState.images?[0] ?? '',
              Constants.offerId,
            );
            await addNotification(notify);
          });
    })
        .catchError((error) {result = false;});

    return result;
  }

  static Future<bool> addNotification(MyNotification notification) async {
    var result = false;
    await usersRef.doc(notification.receiver)
        .collection("notifications")
        .add(notification.toMap())
        .whenComplete(() => result = true)
        .catchError((error) {
      result = false;
    });
    return result;
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> notifications(){
    return usersRef.doc(AuthService.getCurrentUserID())
        .collection("notifications")
        .orderBy("time")
        .snapshots();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getOffersFormMyRealStates(String? realState){
    return realStatesRef
        .doc(realState)
        .collection("offers")
        .snapshots();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getMyOffersToRealStates(){
    return usersRef
        .doc(AuthService.getCurrentUserID())
        .collection("offers")
        .snapshots();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getMessages(String receiver) {
    return usersRef
        .doc(AuthService.getCurrentUserID())
        .collection("chats")
        .doc(receiver)
        .collection("messages")
        .orderBy("dateTime")
        .snapshots();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getChatUsers() {
    return usersRef.doc(AuthService.getCurrentUserID()).collection("chats").snapshots();
  }
}
