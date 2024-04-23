
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:test_case3/chat/chat_services.dart';
import 'package:test_case3/components/chat_bubble.dart';
import 'package:test_case3/components/mytextfield.dart';

class ChatPage extends StatefulWidget {
  final String receiveruserEmail;
  final String receiverUserID;
  const ChatPage({super.key,
    required this.receiveruserEmail,
    required this.receiverUserID});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {

  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(
          widget.receiverUserID, _messageController.text);

      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo.shade900,
      appBar: AppBar(
          backgroundColor: Colors.deepPurple,
          title: Text(widget.receiveruserEmail)),
      body: Column(

        children: [

        //   messages
        Expanded(child: _buildMessageList(),),

        //   expanded

        //   user input
          _buildMessageInput(),

        ],
      )
    );
  }

//   build message list
  Widget _buildMessageList(){
    return StreamBuilder(stream: _chatService.getMessages(widget.receiverUserID, _firebaseAuth.currentUser!.uid),
        builder: (context,snapshot){
        if (snapshot.hasError){
          return Text ('Error${snapshot.error}');
        }
        if(snapshot.connectionState==ConnectionState.waiting){
          return const Text('Loading...');
        }
        return ListView(
          children: snapshot.data!.docs
              .map((document)=>_buildMessageItem(document))
              .toList(),
        );
        },);
  }

// build message item
  Widget _buildMessageItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;

    // Get the sender email or use a default value if it is null
    String senderEmail = data['senderEmail'] ?? 'Unknown';

    // align messages on left and right depending on sender and receiver
    var alignment = (data['senderId'] == _firebaseAuth.currentUser!.uid)
        ? Alignment.centerRight
        : Alignment.centerLeft;

    return Container(
      alignment: alignment,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: (data['senderId'] == _firebaseAuth.currentUser!.uid)
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          mainAxisAlignment: (data['senderId'] == _firebaseAuth.currentUser!.uid)
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
          children: [
            Text(senderEmail), // Use senderEmail here
            ChatBubble(message: data['message']),
          ],
        ),
      ),
    );
  }



// build message input
Widget _buildMessageInput(){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Row(
        children: [
        //   textfield
      Expanded(child: MyTextField(
        controller: _messageController,
        hintText: 'Enter message',
        obscureText: false,
      )),

        //   send button
           IconButton(onPressed: sendMessage, icon: Icon(
            Icons.arrow_upward,
            size: 40,
          ))

        ],
      ),
    );
}

}
