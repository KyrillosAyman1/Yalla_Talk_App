import 'package:flutter/material.dart';
import 'package:yalla_talk_app/constants.dart';
import 'package:yalla_talk_app/models/messages_model.dart';

class ChatFriendBuble extends StatelessWidget {
  const ChatFriendBuble({super.key,required this.messagesModel});
  final MessagesModel messagesModel;
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10,),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
            bottomLeft: Radius.circular(20),
          ),
          color: kSecondaryColor,

        ),

        child: Text(
          messagesModel.message,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
