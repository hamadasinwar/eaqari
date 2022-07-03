import 'package:cloud_firestore/cloud_firestore.dart';

class Address {
  static const realStateState = 'state';
  static const realStateStreet = 'street';
  static const realStatePlace = 'place';
  static const realStateFloorNum = 'floorNum';
  static const realStateApartmentNum = 'apartmentNum';

  String? state;
  String? street;
  String? place;
  String? floorNum;
  String? apartmentNum;
  DocumentSnapshot? document;

  Address({this.place, this.state, this.street, this.floorNum, this.apartmentNum, this.document});

  Map<String, String?> toMap() {
    return {
      realStateState: state,
      realStateStreet: street,
      realStatePlace: place,
      realStateFloorNum: floorNum,
      realStateApartmentNum: apartmentNum,
    };
  }

  factory Address.fromMap(Map<String, dynamic> json) => Address(
    state: json[realStateState],
    street: json[realStateStreet],
    place: json[realStatePlace],
    floorNum: json[realStateFloorNum],
    apartmentNum: json[realStateApartmentNum],
  );

  Address fromFirebase(){
    state = document?[realStateState];
    street = document?[realStateStreet];
    place = document?[realStatePlace];
    floorNum = document?[realStateFloorNum];
    apartmentNum = document?[realStateApartmentNum];
    return this;
  }

  @override
  String toString(){
    return "${state??''} - ${street??''} - ${place??''}";
  }
}
