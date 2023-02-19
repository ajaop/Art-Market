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
