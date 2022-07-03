
import 'package:cloud_firestore/cloud_firestore.dart';

class Category {
  String? id;
  String? name;
  QueryDocumentSnapshot? document;

  Category({this.id, this.name, this.document});

  Category formFirebase() {
    id = document?.id;
    name = document?['category'].toString();
    return this;
  }
}
