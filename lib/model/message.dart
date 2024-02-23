import 'package:cloud_firestore/cloud_firestore.dart';

class Message{
  final String senderId;
  final String senderEmail;
  final String receiverId;
  final String message;
  final String timestamp;

  Message({
    required this.senderEmail,
    required this.senderId,
    required this.receiverId,
    required this.message,
    required this.timestamp,});

//   convert to a map thats how its saved in firebase
 Map<String, dynamic> toMap() {
  return{
    'senderId':senderId,
    'senderEmail':senderEmail,
    'receiverId':receiverId,
    'message':message,
    'timestamp':timestamp,
  };
}
}