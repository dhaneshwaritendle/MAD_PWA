import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService extends ChangeNotifier {
//   instance of auth
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

// instance of firestore
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;



// sign user in
  Future<UserCredential> signInWithEmailandPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);

      // Create user document if not exists
      if (!await _userDocumentExists(userCredential.user!.email!)) {
        await _createUserDocument(
            userCredential.user!.email!, email.split('@')[0]);
      }

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

// create new user
  Future<UserCredential> signUpWithEmailandPassword(
      String email, password) async {
    try {

      if(await _userDocumentExists(email)){
        throw Exception("user already exists");
      }
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      // after creating the user, create a new document for the user in the usrs collection
      _fireStore.collection('Users').doc(userCredential.user!.uid).set(
        {
          'uid': userCredential.user!.uid,
          'email': email,
          'username': email.split('@')[0],
          'bio': 'Empty bio...',
        },
      );

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  // after creating user create new document in cloud infrastructre called users
  Future<void> _createUserDocument(String email, String uid) async {

    await _fireStore.collection("Users").doc(email).set({
      'username': email.split('@')[0],
      'email': email,
      'bio': 'Empty bio...',
    });
  }



//   checks if the document is already made
  Future<bool> _userDocumentExists(String email) async {
    final docSnapshot = await _fireStore.collection("Users").doc(email).get();
    return docSnapshot.exists;
  }

// sign user out
  Future<void> signOut() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    if (googleSignIn.currentUser != null) {
      await googleSignIn.signOut();
    }
    return await FirebaseAuth.instance.signOut();
  }

  //   Google Sign In
  Future<UserCredential?> signInWithGoogle() async {
    try {
      // check for internet
      await InternetAddress.lookup('google.com');

      // Initialize GoogleSignIn
      final GoogleSignIn googleSignIn = GoogleSignIn();

      // Sign out if a user is already signed in
      await googleSignIn.signOut();

      // begin interactive  sign in process
      final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

      if (gUser == null) {
        // User canceled the sign-in process
        return null;
      }

      // obtain auth details from request
      final GoogleSignInAuthentication gAuth = await gUser.authentication;

      // create new credential for user
      final credential = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken,
        idToken: gAuth.idToken,
      );

      final userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      if (!await _userDocumentExists(gUser.email)) {
        await _createUserDocument(gUser.email!, gUser.email!.split('@')[0]);
      }

      // finally lets sign in
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      // TODO
      log('\n_signInWithGoogle: $e');
      return null;
    }
  }
}
