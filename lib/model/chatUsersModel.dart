

class ChatUser {
  // constructor
  ChatUser({
    required this.uid,
    required this.bio,
    required this.email,
    required this.username,
    required this.image,
  });
  // fields declared
  late final String uid;
  late final String bio;
  late final String email;
  late final String username;
  late final String image;

  // function called when the data comes
  ChatUser.fromJson(Map<String, dynamic> json){
    uid = json['uid'] ;
    bio = json['bio'] ?? "";
    email = json['email'];
    username = json['username'];
    image = json['image'] ?? "";
  }



  // to send data to server we use this function
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['uid'] = uid;
    data['bio'] = bio;
    data['email'] = email;
    data['username'] = username;
    data['image'] = image;
    return data;
  }
}