import 'package:art_market/ArtItems.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Orders {
  final DateTime orderDate;
  final String status;
  final String totalAmt;
  final Future<List<ArtItems>> artItems;

  Orders(
      {required this.orderDate,
      required this.status,
      required this.totalAmt,
      required this.artItems});

  Orders.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
      : orderDate = doc.data()!["OrderDate"].toDate(),
        status = doc.data()!["Status"],
        totalAmt = doc.data()!["TotalAmount"],
        artItems = doc.reference.collection("Items").get().then((value) => value
            .docs
            .map((docSnapshot) =>
                ArtItems.fromOrdersDocumentSnapshot(docSnapshot))
            .toList());
}
