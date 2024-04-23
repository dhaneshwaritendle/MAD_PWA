import 'dart:ffi';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:test_case3/components/text_box.dart';
import 'package:test_case3/utils/utils.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Create an instance of the ProfileService
  final currentUser = FirebaseAuth.instance.currentUser!;
  // all users
  final usersCollection = FirebaseFirestore.instance.collection("Users");

  // image profile
  void selectImage() async{
    Uint8List img = await pickImage(ImageSource.gallery);
  }
  // edit field
  Future<void> editField(String field) async {
    String newValue = "";
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: Text(
          "Edit " + field,
          style: TextStyle(
            color: Colors.white70,
          ),
        ),
        content: TextField(
          autofocus: true,
          style: TextStyle(color: Colors.white70),
          decoration: InputDecoration(
            hintText: "Enter New $field",
            hintStyle: TextStyle(color: Colors.white70),
          ),
          onChanged: (value) {
            newValue = value;
          },
        ),
        actions: [
          //   cancel button
          TextButton(
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () => Navigator.pop(context),
          ),
          //   save button
          TextButton(
            child: Text(
              'Save',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () => Navigator.of(context).pop(newValue),
          ),
        ],
      ),
    );
  //   update in firestone
    if(newValue.trim().length > 0){
    //   only update firebase
      await usersCollection.doc(currentUser.email).update({field: newValue});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo.shade50,
      appBar: AppBar(
        title: Text(
          "Profile Page",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple,
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection("Users")
            .doc(currentUser.email)
            .snapshots(),
        builder: (context, snapshot) {
          // get user data
          if (snapshot.hasData) {
            final userData = snapshot.data!.data() as Map<String, dynamic>;

            //   list view
            return ListView(
              children: [
                SizedBox(
                  height: 50,
                ),

                //   profile pic
                Center(
                  child: Stack(
                    children: [

                        CircleAvatar(
                          radius: 64,
                          backgroundImage: NetworkImage('https://www.iconpacks.net/icons/1/free-user-icon-295-thumb.png')
                        ),
                      Positioned(
                        child: IconButton(onPressed: selectImage,
                        icon: Icon(Icons.add_a_photo),
                        ),
                        bottom: -10,
                        left: 80,
                      )
                    ],
                  ),
                ),

                const SizedBox(
                  height: 10,
                ),

                //   user email
                Text(
                  currentUser!.email!,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey[700]),
                ),
                const SizedBox(
                  height: 10,
                ),
                // user details
                Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: Text(
                    'My Details',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ),
                // username
                MyTextBox(
                  text: userData['username'],
                  sectionName: 'UserName',
                  onPressed: () => editField('username'),
                ),

                // user bio
                MyTextBox(
                  text: userData['bio'],
                  sectionName: 'Status',
                  onPressed: () => editField('bio'),
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('error${snapshot}'),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
