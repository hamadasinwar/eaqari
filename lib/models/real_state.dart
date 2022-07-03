import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:graduation_project/models/address.dart';

class RealState {
  static const realStateID = 'id';
  static const realStateUserID = 'userId';
  static const realStateName = 'name';
  static const realStateCategory = 'category';
  static const realStatePrice = 'price';
  static const realStateDetails = 'details';
  static const realStateAddress = 'address';
  static const realStateArea = 'area';
  static const realStateBedroomsNum = 'bedroomsNum';
  static const realStateLivingRoomsNum = 'livingRoomsNum';
  static const realStateBathroomsNum = 'bathroomsNum';
  static const realStateType = 'type';
  static const realStateHasKitchen = 'hasKitchen';
  static const realStateImages = 'images';
  static const realStateFavorite = 'isFavorite';
  static const realStateLatLang = 'latLng';

  String? id;
  String? userId;
  String? name;
  String? category;
  int? price;
  String? details;
  Address? address;
  int? area;
  int? bedroomsNum;
  int? livingRoomsNum;
  int? bathroomsNum;
  String? type;
  bool? hasKitchen;
  List<String>? images;
  bool isFavorite;
  LatLng? location;
  DocumentSnapshot? document;

  RealState({
    this.id,
    this.userId,
    this.name,
    this.category,
    this.price,
    this.details,
    this.address,
    this.area,
    this.bedroomsNum,
    this.livingRoomsNum,
    this.bathroomsNum,
    this.type,
    this.hasKitchen,
    this.images,
    this.isFavorite = false,
    this.location,
    this.document,
  });

  Map<String, dynamic> toMap() {
    return {
      realStateUserID: userId,
      realStateName: name,
      realStateCategory: category,
      realStatePrice: price,
      realStateDetails: details,
      realStateAddress: address?.toMap(),
      realStateArea: area,
      realStateBedroomsNum: bedroomsNum,
      realStateLivingRoomsNum: livingRoomsNum,
      realStateBathroomsNum: bathroomsNum,
      realStateType: type,
      realStateHasKitchen: hasKitchen,
      realStateImages: images,
      realStateLatLang: location?.toJson(),
    };
  }

  RealState fromFirebase() {
    id = document?.id;
    userId = document?[realStateUserID];
    name = document?[realStateName];
    category = document?[realStateCategory];
    price = int.tryParse(document?[realStatePrice].toString()??'');
    details = document?[realStateDetails];
    address = Address.fromMap(document?[realStateAddress]);
    area = document?[realStateArea];
    bedroomsNum = document?[realStateBedroomsNum];
    livingRoomsNum = document?[realStateLivingRoomsNum];
    bathroomsNum = document?[realStateBathroomsNum];
    type = document?[realStateType];
    hasKitchen = document?[realStateHasKitchen];
    images = List.from(document?[realStateImages]);
    var point = List.from(document?[realStateLatLang]);
    location = LatLng(point.first??0.0, point.last??0.0);

    return this;
  }
}
