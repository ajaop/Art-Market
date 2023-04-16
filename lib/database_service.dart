import 'package:art_market/ArtItems.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'Orders.dart';

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

  Future<String> getUserDetails(context, _messengerKey) async {
    String firstName = "", lastName = "", fullName = "";

    await FirebaseFirestore.instance
        .collection("users")
        .where('userId', isEqualTo: user!.uid)
        .limit(1)
        .get()
        .then((value) => value.docs.forEach((doc) {
              lastName = doc.data()['lastname'].toString();
              firstName = doc.data()['firstname'].toString();
              String fullName = lastName + " " + firstName;
            }))
        .onError((error, stackTrace) => displayError(error, _messengerKey));

    return fullName;
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
          final quantity = docSnapshot.data()['Quantity'];

          DocumentSnapshot<Map<String, dynamic>> snapshot =
              await _db.collection("arts").doc(artId).get();

          cartItems.add(ArtItems.fromCartDocumentSnapshot(snapshot, quantity));
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
          'Quantity': 1,
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

  Future editQuantityInCart(itemId, qty, _messangerKey) async {
    final User? user = auth.currentUser;

    if (user!.uid.isNotEmpty) {
      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('Cart')
            .doc(itemId)
            .update({'Quantity': qty});
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

  Future<bool> checkIfItemIsInCart(String itemId) async {
    final dynamic values = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('Cart')
        .doc(itemId)
        .get();

    return values.exists;
  }

  Future<bool> addToOrders(itemsList, amount, _messangerKey) async {
    final User? user = auth.currentUser;

    if (user!.uid.isNotEmpty) {
      try {
        String id = FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('Orders')
            .doc()
            .id;
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('Orders')
            .doc(id)
            .set(
          {
            'TotalAmount': amount,
            'OrderDate': DateTime.now(),
            'Status': 'Ordered',
          },
        ).then((value) async {
          for (ArtItems artItem in itemsList) {
            await FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .collection('Orders')
                .doc(id)
                .collection('Items')
                .doc()
                .set(artItem.toMap());
          }
        }).then((value) async {
          await deleteCart(_messangerKey);
        });
        return true;
      } catch (e) {
        displayError(e.toString(), _messangerKey);
        return false;
      }
    }

    return false;
  }

  Future deleteCart(_messangerKey) async {
    final User? user = auth.currentUser;

    if (user!.uid.isNotEmpty) {
      try {
        var collection = FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('Cart');
        var snapshots = await collection.get();
        for (var doc in snapshots.docs) {
          await doc.reference.delete();
        }
      } catch (e) {
        displayError(e.toString(), _messangerKey);
      }
    }
  }

  Future<List<Orders>> retrieveOrders() async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await _db.collection('users').doc(user!.uid).collection('Orders').get();

    return snapshot.docs
        .map((docSnapshot) => Orders.fromDocumentSnapshot(docSnapshot))
        .toList();
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
