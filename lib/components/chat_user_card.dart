import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:test_case3/model/chatUsersModel.dart';
class ChatUserCard extends StatefulWidget {

  final ChatUser user;

  const ChatUserCard({super.key,required this.user});

  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard> {
  @override
  Widget build(BuildContext context) {
    var mq= MediaQuery.of(context);
    var height;
    return Card(
      child: InkWell(
          onTap: (){},
          child: ListTile(
            leading: ClipRRect(
              borderRadius:BorderRadius.circular(50),

              child: CachedNetworkImage(
                imageUrl: (widget.user.image),
                // placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) =>
                    const CircleAvatar(child: Icon(CupertinoIcons.person),),
              ),
            ),
            title: Text(widget.user.username),
            subtitle: Text(widget.user.bio),
            trailing: Container(
              width: 15,
              height: 15,
              decoration: BoxDecoration(color:Colors.green[400],borderRadius:BorderRadius.circular(10)),
            ),
          )
      ),
    );
  }
}
