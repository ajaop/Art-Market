import 'package:cloud_firestore/cloud_firestore.dart';

class ArtItems {
  final String artType;
  final String imageUrl;
  final String artName;
  final int artPrice;
  final String docId;
  final int quantity;

  ArtItems(
      {required this.artType,
      required this.imageUrl,
      required this.artName,
      required this.artPrice,
      required this.docId,
      required this.quantity});

  Map<String, dynamic> toMap() {
    return {
      'ArtType': artType,
      'ImageUrl': imageUrl,
      'ArtName': artName,
      'ArtPrice': artPrice
    };
  }

  Map<String, dynamic> cartToMap() {
    return {
      'ArtType': artType,
      'ImageUrl': imageUrl,
      'ArtName': artName,
      'ArtPrice': artPrice,
      'Quantity': quantity
    };
  }

  ArtItems.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
      : artType = doc.data()!["ArtType"],
        imageUrl = doc.data()!["ImageUrl"],
        artName = doc.data()!["Name"],
        artPrice = doc.data()!["Price"],
        docId = doc.id,
        quantity = doc.data()?["Quantity"] ?? 0;

  ArtItems.fromOrdersDocumentSnapshot(
      DocumentSnapshot<Map<String, dynamic>> doc)
      : artType = doc.data()!["ArtType"],
        imageUrl = doc.data()!["ImageUrl"],
        artName = doc.data()!["ArtName"],
        artPrice = doc.data()!["ArtPrice"],
        docId = doc.id,
        quantity = doc.data()?["Quantity"] ?? 0;

  ArtItems.fromCartDocumentSnapshot(
      DocumentSnapshot<Map<String, dynamic>> doc, qty)
      : artType = doc.data()!["ArtType"],
        imageUrl = doc.data()!["ImageUrl"],
        artName = doc.data()!["Name"],
        artPrice = doc.data()!["Price"],
        docId = doc.id,
        quantity = qty ?? 0;
}
