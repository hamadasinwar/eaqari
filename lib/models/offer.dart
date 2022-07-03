import 'package:cloud_firestore/cloud_firestore.dart';

class Offer {
  static const offerRealState = 'realState';
  static const offerUser = 'user';
  static const offerOwner = 'owner';
  static const offerState = 'state';
  static const offerTimestamp= 'timestamp';

  String? id;
  String? realState;
  String? user;
  String? owner;
  String? state;
  Timestamp? timestamp;
  DocumentSnapshot? document;

  Offer({this.id, this.realState, this.owner,  this.user, this.timestamp, this.document, this.state});

  Map<String, dynamic> toMap() {
    return {
      offerRealState: realState,
      offerUser: user,
      offerOwner: owner,
      offerState: state,
      offerTimestamp: timestamp,
    };
  }

  factory Offer.fromMap(Map<String, dynamic> json) => Offer(
    realState: json[offerRealState],
    user: json[offerUser],
    owner: json[offerOwner],
    state: json[offerState],
    timestamp: json[offerTimestamp],
  );

  Offer fromFirebase(){
    id = document?.id;
    realState = document?[offerRealState];
    user = document?[offerUser];
    owner = document?[offerOwner];
    state = document?[offerState];
    timestamp = document?[offerTimestamp];
    return this;
  }

}
