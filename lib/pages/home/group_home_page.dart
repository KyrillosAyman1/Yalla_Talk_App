import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:yalla_talk_app/models/group_model.dart';

import 'package:yalla_talk_app/pages/group/creat_group_page.dart';
import 'package:yalla_talk_app/pages/group/widgets/group_card.dart';

class GroupHomePage extends StatefulWidget {
  const GroupHomePage({super.key});

  @override
  State<GroupHomePage> createState() => _ChatsHomePageState();
}

class _ChatsHomePageState extends State<GroupHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Groups")),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("groups")
              .where(
                "members",
                arrayContains: FirebaseAuth.instance.currentUser!.uid,
              )
              .snapshots(),
          builder: (context, asyncSnapshot) {
            if (asyncSnapshot.hasData) {
             List<GroupModel>  myGroups =
                  asyncSnapshot.data!.docs
                      .map((e) => GroupModel.fromJson(e.data()))
                      .toList()
                    ..sort(
                      (a, b) => b.lastMessageTime.compareTo(a.lastMessageTime),
                    );
              if (myGroups.isEmpty) {
                return const Center(child: Text("No groups yet"));
              }

              return ListView.builder(
                itemCount: myGroups.length,
                itemBuilder: (context, index) {
                  return GroupCard(groupModel: myGroups[index]);
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
          Navigator.pushNamed(
            context,
            CreatGroupPage.id,
            
          );
        },
        child: Icon(Icons.group_add_outlined),
      ),
    );
  }
}
