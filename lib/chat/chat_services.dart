import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:test_case3/model/message.dart';

class ChatService extends ChangeNotifier {

  // get instance of auth and firestore
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // SEND MESSSAGES
  Future<void> sendMessage(String receiverId, String message) async{
  //   get current user info
  final String currentUserId = _firebaseAuth.currentUser!.uid;
  final String currentUserEmail = _firebaseAuth.currentUser!.email.toString();
  final Timestamp timestamp = Timestamp.now();

  //   create a new message
  Message newMessage = Message(
      senderEmail: currentUserEmail,
      senderId: currentUserId,
      receiverId: receiverId,
      message: message,
      timestamp: timestamp.toString());

  //   construct chat room id from current user id and receiver id
  List<String> ids = [currentUserId,receiverId];
  ids.sort();
  String chatRoomId = ids.join("_");//combine ids into a single string to

  //   add new messages to data base
  await _firestore
  .collection('chat_rooms')
  .doc(chatRoomId)
  .collection('messages')
  .add(newMessage.toMap());
  }
  // GET MESSAGES
  Stream<QuerySnapshot> getMessages(String userId,String otherUserId){

    List<String> ids = [userId,otherUserId];
    ids.sort();
    String chatRoomId = ids.join("_");

    return _firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp',descending: false)
        .snapshots();
  }
  }

