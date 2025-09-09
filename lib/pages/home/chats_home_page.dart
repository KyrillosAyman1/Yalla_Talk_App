import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:yalla_talk_app/models/chats_model.dart';
import 'package:yalla_talk_app/pages/chat/widgets/chat_card.dart';
import 'package:yalla_talk_app/pages/home/widgets/add_friend.dart';

class ChatsHomePage extends StatefulWidget {
  const ChatsHomePage({super.key});

  @override
  State<ChatsHomePage> createState() => _ChatsHomePageState();
}

class _ChatsHomePageState extends State<ChatsHomePage> {
  TextEditingController emailFriendController = TextEditingController();
  Stream<QuerySnapshot> _getUserChats() {
  return FirebaseFirestore.instance
      .collection("rooms")
      .where("members", arrayContains: FirebaseAuth.instance.currentUser!.uid)
      .snapshots();
}

  @override
  void dispose() {
    emailFriendController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Chats"),),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: StreamBuilder(
          stream: _getUserChats(),
          builder: (context, asyncSnapshot) {
            if (asyncSnapshot.hasData) {
              List<ChatsModel> chatsList =
                  asyncSnapshot.data!.docs
                      .map((e) => ChatsModel.fromJson(e.data()))
                      .toList()
                    ..sort((a, b) {
                      return b.lastMessageTime!.compareTo(a.lastMessageTime!);
                    });
              if (chatsList.isEmpty) {
                return const Center(child: Text("No chats yet"));
              }
              if (asyncSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (asyncSnapshot.hasError) {
                return Center(child: Text("Error: ${asyncSnapshot.error}"));
              }

              return ListView.builder(
                itemCount: chatsList.length,
                itemBuilder: (context, index) {
                  return ChatCard(chatsModel: chatsList[index]);
                },
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            isScrollControlled: true,
            context: context,

            builder: (context) {
              return Padding(
                padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom, 
      ),
                child: AddFriend(emailFriendController: emailFriendController,createChat: true,),
              );
              
            },
          );
        },
        child: Icon(Icons.add_comment),
      ),
    );
  }
}
