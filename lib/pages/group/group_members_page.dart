import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:yalla_talk_app/firebase/fire_data.dart';
import 'package:yalla_talk_app/models/group_model.dart';
import 'package:yalla_talk_app/models/user_model.dart';
import 'package:yalla_talk_app/pages/group/edit_group_page.dart';

class GroupMembersPage extends StatefulWidget {
  const GroupMembersPage({super.key});
  static String id = 'group_members_page';

  @override
  State<GroupMembersPage> createState() => _GroupMembersPageState();
}

class _GroupMembersPageState extends State<GroupMembersPage> {
  @override
  Widget build(BuildContext context) {
    var arguments = ModalRoute.of(context)!.settings.arguments as Map;
    var groupModel = arguments["groupModel"] as GroupModel;
    bool meIsAdmin = groupModel.adminsId.contains(
      FirebaseAuth.instance.currentUser!.uid,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text("Group Members"),
        actions: [
          meIsAdmin
              ? IconButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      EditGroupPage.id,
                      arguments: {'groupModel': groupModel},
                    );
                  },
                  icon: Icon(Iconsax.user_edit),
                )
              : SizedBox(),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("users")
              .where("id", whereIn: groupModel.members)
              .snapshots(),
          builder: (context, asyncSnapshot) {
            if (asyncSnapshot.hasData) {
              List<UserModel> groupMembersList =
                  asyncSnapshot.data!.docs
                      .map((e) => UserModel.fromJson(e.data()))
                      .toList()
                    ..sort(
                      (a, b) => a.name!.toLowerCase().compareTo(
                        b.name!.toLowerCase(),
                      ),
                    );
              return ListView.builder(
                itemCount: groupMembersList.length,
                itemBuilder: (context, index) {
                  bool isAdmin = groupModel.adminsId.contains(
                    groupMembersList[index].id,
                  );
                  bool isMe =
                      groupMembersList[index].id ==
                      FirebaseAuth.instance.currentUser!.uid;
                  return Card(
                    child: ListTile(
                      title: Text(groupMembersList[index].name!),
                      subtitle: isAdmin
                          ? Text("Admin", style: TextStyle(color: Colors.green))
                          : Text("Member"),
                      trailing: SizedBox(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            meIsAdmin && !isMe
                                ? IconButton(
                                    onPressed: () {
                                      isAdmin
                                          ? FireData()
                                                .removeAdmin(
                                                  groupId: groupModel.id,
                                                  memberId:
                                                      groupMembersList[index]
                                                          .id!,
                                                )
                                                .then(
                                                  (value) => setState(() {
                                                    groupModel.adminsId.remove(
                                                      groupMembersList[index]
                                                          .id,
                                                    );
                                                  }),
                                                )
                                          : FireData()
                                                .promoreAdmin(
                                                  groupId: groupModel.id,
                                                  memberId:
                                                      groupMembersList[index]
                                                          .id!,
                                                )
                                                .then(
                                                  (value) => setState(() {
                                                    groupModel.adminsId.add(
                                                      groupMembersList[index]
                                                          .id,
                                                    );
                                                  }),
                                                );
                                    },
                                    icon: Icon(
                                      Iconsax.user_tick,
                                      color: isAdmin
                                          ? Colors.green
                                          : Colors.grey,
                                    ),
                                  )
                                : SizedBox(),

                            meIsAdmin && !isMe
                                ? IconButton(
                                    onPressed: () {
                                      FireData().removeMember(
                                        groupId: groupModel.id,
                                        memberId: groupMembersList[index].id!,
                                      );
                                      setState(() {
                                        groupModel.members.remove(
                                          groupMembersList[index].id,
                                        );
                                        groupMembersList[index];
                                      });
                                    },
                                    icon: Icon(Iconsax.trash),
                                  )
                                : SizedBox(),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
