import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class ArtItems {
  final String artType;
  final String imageUrl;
  final String artName;
  final int artPrice;
  final String docId;

  ArtItems(
      {required this.artType,
      required this.imageUrl,
      required this.artName,
      required this.artPrice,
      required this.docId});

  Map<String, dynamic> toMap() {
    return {
      'ArtType': artType,
      'ImageUrl': imageUrl,
      'ArtName': artName,
      'ArtPrice': artPrice
    };
  }

  ArtItems.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
      : artType = doc.data()!["ArtType"],
        imageUrl = doc.data()!["ImageUrl"],
        artName = doc.data()!["Name"],
        artPrice = doc.data()!["Price"],
        docId = doc.id;
}
