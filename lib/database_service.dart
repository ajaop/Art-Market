import 'package:art_market/ArtItems.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DatabaseService {
  FirebaseFirestore _db = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  User? user;

  DatabaseService() {
    user = auth.currentUser;
  }

  Future<String> getImageText(context, _messengerKey) async {
    String firstName, lastName, imageText = '';
    await FirebaseFirestore.instance
        .collection("users")
        .where('userId', isEqualTo: user!.uid)
        .limit(1)
        .get()
        .then((value) => value.docs.forEach((doc) {
              lastName = doc.data()['lastname'].toString();
              firstName = doc.data()['firstname'].toString();
              imageText = (lastName[0] + firstName[0]).toUpperCase();
            }))
        .onError((error, stackTrace) => displayError(error, _messengerKey));

    return imageText;
  }

  Future<List<ArtItems>> retrieveArt() async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await _db.collection("arts").get();

    return snapshot.docs
        .map((docSnapshot) => ArtItems.fromDocumentSnapshot(docSnapshot))
        .toList();
  }

  Future<List<ArtItems>> retrieveArtBySketches() async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await _db
        .collection("arts")
        .where('ArtType', isEqualTo: 'Sketch')
        .get();

    return snapshot.docs
        .map((docSnapshot) => ArtItems.fromDocumentSnapshot(docSnapshot))
        .toList();
  }

  Future<List<ArtItems>> retrieveArtByPaintings() async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await _db
        .collection("arts")
        .where('ArtType', isEqualTo: 'Painting')
        .get();

    return snapshot.docs
        .map((docSnapshot) => ArtItems.fromDocumentSnapshot(docSnapshot))
        .toList();
  }

  Future<List<ArtItems>> retrieveFavouriteArt() async {
    List<ArtItems> favouriteItems = [];

    await _db
        .collection('users')
        .doc(user!.uid)
        .collection('LikedArt')
        .get()
        .then(
      (value) async {
        for (var docSnapshot in value.docs) {
          final artId = docSnapshot.data()['ArtId'];

          DocumentSnapshot<Map<String, dynamic>> snapshot =
              await _db.collection("arts").doc(artId).get();

          favouriteItems.add(ArtItems.fromDocumentSnapshot(snapshot));
        }
        return favouriteItems;
      },
    );

    return favouriteItems;
  }

  Future addItemToLIked(itemId, itemName, _messangerKey) async {
    final User? user = auth.currentUser;
    if (user!.uid.isNotEmpty) {
      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('LikedArt')
            .doc(itemId)
            .set({
          'ArtId': itemId,
          'ArtName': itemName,
          'DateAdded': DateTime.now()
        });
      } catch (e) {
        displayError(e.toString(), _messangerKey);
      }
    }
  }

  Future removeItemFromLIked(itemId, _messangerKey) async {
    final User? user = auth.currentUser;

    if (user!.uid.isNotEmpty) {
      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('LikedArt')
            .doc(itemId)
            .delete();
      } catch (e) {
        displayError(e.toString(), _messangerKey);
      }
    }
  }

  Future<List<ArtItems>> retrieveCart() async {
    List<ArtItems> cartItems = [];

    await _db.collection('users').doc(user!.uid).collection('Cart').get().then(
      (value) async {
        for (var docSnapshot in value.docs) {
          final artId = docSnapshot.data()['ArtId'];

          DocumentSnapshot<Map<String, dynamic>> snapshot =
              await _db.collection("arts").doc(artId).get();

          cartItems.add(ArtItems.fromDocumentSnapshot(snapshot));
        }
        return cartItems;
      },
    );

    return cartItems;
  }

  Future addItemToCart(itemId, itemName, _messangerKey) async {
    final User? user = auth.currentUser;
    if (user!.uid.isNotEmpty) {
      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('Cart')
            .doc(itemId)
            .set({
          'ArtId': itemId,
          'ArtName': itemName,
          'DateAdded': DateTime.now()
        });
      } catch (e) {
        displayError(e.toString(), _messangerKey);
      }
    }
  }

  Future removeItemFromCart(itemId, _messangerKey) async {
    final User? user = auth.currentUser;

    if (user!.uid.isNotEmpty) {
      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('Cart')
            .doc(itemId)
            .delete();
      } catch (e) {
        displayError(e.toString(), _messangerKey);
      }
    }
  }

  Future<bool> checkIfItemIsLIked(String itemId) async {
    final dynamic values = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('LikedArt')
        .doc(itemId)
        .get();

    return values.exists;
  }

  void displayError(errorMessage, _messangerKey) {
    _messangerKey.currentState!.showSnackBar(SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.red[600],
        elevation: 0,
        content: Text(
          errorMessage,
          textAlign: TextAlign.center,
        )));
  }
}
