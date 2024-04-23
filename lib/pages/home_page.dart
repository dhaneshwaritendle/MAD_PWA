import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_case3/components/chat_user_card.dart';
import 'package:test_case3/model/chatUsersModel.dart';
import 'package:test_case3/pages/chat_page.dart';
import 'package:test_case3/pages/profile_page.dart';
import 'package:test_case3/services/auth/auth_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // instance of auth
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // list pf users
  List<ChatUser> list = [];

  // sign user out
  void signOut() {
    final authService = Provider.of<AuthService>(context, listen: false);
    authService.signOut();
  }

  //profile page
  void profile() {
    //   go to profile page
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ProfilePage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: const Icon(CupertinoIcons.home),
          title: const Text('Home '),
          actions: [
            //search
            IconButton(
                onPressed: () {}, icon: const Icon(CupertinoIcons.search)),
            //profile

            //   sign out button
            IconButton(onPressed: signOut, icon: const Icon(Icons.logout))
          ],
        ),
        // body: _buildUserList(),

        body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("users").snapshots(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              // case value:data is loading
              case ConnectionState.waiting:
              case ConnectionState.none:
                return const Center(child: CircularProgressIndicator());

              case ConnectionState.active:
              case ConnectionState.done:
                final data = snapshot.data?.docs;
                list = data?.map((e) => ChatUser.fromJson(e.data())).toList() ??
                    [];
                if(list.isNotEmpty) {
                  return ListView.builder(
                      itemCount: list.length,
                      itemBuilder: (context, index) {
                        return ChatUserCard(
                          user: list[index],
                        );
                      });
                }else{
                  return const Center(
                    child: Text('No connection Found!',
                        style: TextStyle(fontSize: 20)),
                  );
                }
            }


          },
        ),
        bottomNavigationBar: BottomNavigationBar(
            selectedItemColor: Colors.deepPurple[500],
            unselectedItemColor: Colors.grey.shade600,
            selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
            unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
            type: BottomNavigationBarType.fixed,
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.message),
                label: "Chats",
              ),
              // BottomNavigationBarItem(
              //   icon: Icon(Icons.group_work),
              //   label: ("Channels"),
              // ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.account_box,
                ),
                label: "Profile",
              ),
            ],
            onTap: (int index) {
              if (index == 1) {
                // Assuming "Profile" tab is at index 1
                profile();
              }
              ;
            }));
  }

// build a list of users except for the current loggged in user
//   Widget _buildUserList() {
//     return StreamBuilder<QuerySnapshot>(
//       stream: FirebaseFirestore.instance.collection('Users').snapshots(),
//       builder: (context, snapshot) {
//         if (snapshot.hasError) {
//           return const Text('error');
//         }
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Text('Loading...');
//         }
//         return ListView(
//           children: snapshot.data!.docs
//               .map<Widget>((doc) => _buildUserListItem(doc))
//               .toList(),
//         );
//       },
//     );
//   }

// build individual user list items
//   Widget _buildUserListItem(DocumentSnapshot document) {
//     Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
//
// // display all users except current user
//     if (_auth.currentUser!.email != data['email']) {
//       return ListTile(
//         title: Text(data['username']),
//         onTap: () {
//           //   pass the clicked users uid to the chat page
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => ChatPage(
//                 receiverUserID: data['uid'],
//                 receiveruserEmail: data['email'],
//               ),
//             ),
//           );
//         },
//       );
//     } else {
// //   return empty container
//       return Container();
//     }
//   }
}
