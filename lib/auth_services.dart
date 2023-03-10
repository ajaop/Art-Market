import 'package:art_market/signup.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'user_details.dart';

class AuthService {
  FirebaseFirestore _db = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  User? user;

  AuthService() {
    user = auth.currentUser;
  }

  Future<void> register(
      firstName, lastName, emailText, pass, context, _messangerKey) async {
    try {
      final credential = await auth
          .createUserWithEmailAndPassword(email: emailText, password: pass)
          .then((value) =>
              print('user with user id ${value.user!.uid} is logged in'));

      bool addData = await sendToDB(firstName, lastName, emailText);

      if (addData == true) {
        Navigator.of(context).pushNamedAndRemoveUntil(
            '/homepage', (Route<dynamic> route) => false);
      } else {
        error('Error signing up user.', _messangerKey);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        error('The password provided is too weak.', _messangerKey);
      } else if (e.code == 'email-already-in-use') {
        final User? user = auth.currentUser;
        if (user!.uid.isNotEmpty) {
          bool userExist = await doesUserExist(user.uid);
          if (userExist == true) {
            error('The account already exists for that email.', _messangerKey);
          } else {
            bool addData = await sendToDB(firstName, lastName, emailText);
            print('add data ${addData.toString()}');
            if (addData == true) {
              Navigator.of(context).pushNamedAndRemoveUntil(
                  '/homepage', (Route<dynamic> route) => false);
            } else {
              error('Error signing up user.', _messangerKey);
            }
          }
        } else {
          error('The account already exists for that email.', _messangerKey);
        }
      } else if (e.code == 'invalid-email') {
        error('Invalid Email', _messangerKey);
      } else {
        error(e.message, _messangerKey);
        print(e);
      }
    } catch (e) {
      error(e, _messangerKey);
    }
  }

  Future<void> login(username, pass, context, _messangerKey) async {
    final userDet = UserDetails(username, pass);

    try {
      final credential = await auth
          .signInWithEmailAndPassword(email: username, password: pass)
          .then((value) async {
        bool userExist = await doesUserExist(user!.uid);
        if (userExist == true) {
          Navigator.pushReplacementNamed(context, '/homepage');
        } else {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const SignUp(),
                  settings: RouteSettings(arguments: userDet)));
        }
      });

      dynamic id = user!.uid;
      print("User with $id is logged in");
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' ||
          e.code == 'wrong-password' ||
          e.code == 'invalid-email') {
        print('No user found');
        error('Wrong email or password.', _messangerKey);
      } else if (e.code == 'too-many-requests') {
        error(
            'Account has been temporarily disabled due to too many failed attempts.',
            _messangerKey);
      } else {
        print(e);
        error(e.message, _messangerKey);
      }
    }
  }

  Future<bool> sendToDB(firstname, lastname, email) async {
    final User? user = auth.currentUser;
    if (user!.uid.isNotEmpty) {
      try {
        DocumentReference<Map<String, dynamic>> users =
            FirebaseFirestore.instance.collection('users').doc(user.uid);

        await users.set({
          "firstname": firstname,
          "lastname": lastname,
          "email": email,
          "userId": user.uid,
          "accountCreationDate": DateTime.now()
        });
        return true;
      } catch (e) {
        return false;
      }
    }

    return false;
  }

  Future<bool> doesUserExist(String uid) async {
    final dynamic values = await FirebaseFirestore.instance
        .collection("users")
        .where('userId', isEqualTo: uid)
        .limit(1)
        .get();

    values.exists;
    if (values.size >= 1) {
      return true;
    } else {
      return false;
    }
  }

  void checkIfLoggedIn(context) {
    final User? user = auth.currentUser;

    if (user?.uid.isEmpty == null) {
      print("Log in");
    } else {
      SchedulerBinding.instance!.addPostFrameCallback((_) {
        Navigator.of(context).pushNamedAndRemoveUntil(
            '/homepage', (Route<dynamic> route) => false);
      });
    }
  }

  bool checkIfLoggedIn2(context) {
    final User? user = auth.currentUser;

    if (user?.uid.isEmpty == null) {
      return false;
    } else {
      return true;
    }
  }

  void error(errorMessage, _messangerKey) {
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
