import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:yalla_talk_app/firebase/fire_data.dart';
import 'package:yalla_talk_app/helper/show_snack_bar.dart';
import 'package:yalla_talk_app/models/user_model.dart';
import 'package:yalla_talk_app/widgets/custom_text_form_field.dart';

class CreatGroupPage extends StatefulWidget {
  const CreatGroupPage({super.key});
  static String id = 'creat_group_page';

  @override
  State<CreatGroupPage> createState() => _CreatGroupPageState();
}

class _CreatGroupPageState extends State<CreatGroupPage> {
  TextEditingController groupcontroller = TextEditingController();
  List members = [];
  List myContacts = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Create Group")),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Row(
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                   
                  ],
                ),
                SizedBox(width: 16),
                Expanded(
                  child: CustomTextFormField(
                    controller: groupcontroller,
                    hintText: "Enter Your Group Name",
                    labelText: "Group Name",
                    iconData: Icons.group,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Divider(),
            SizedBox(height: 20),
            Row(
              children: [
                SizedBox(width: 15),
                Text("Your Contacts", style: Theme.of(context).textTheme.titleLarge),
                Spacer(),
                Text(
                  "${members.length}",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                SizedBox(width: 40),
              ],
            ),
            SizedBox(height: 10),
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("users")
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .snapshots(),
                builder: (context, asyncSnapshot) {
                  if (asyncSnapshot.hasData) {
                    myContacts = asyncSnapshot.data!.data()!["my_friends"]??[];
                    if (myContacts.isEmpty) {
                      return const Center(child: Text("No contacts yet"));
                    }

                    return StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection("users")
                          .where(
                            "id",
                            whereIn: myContacts.isEmpty ? [] : myContacts,
                          )
                          .snapshots(),
                      builder: (context, asyncSnapshot) {
                        if (asyncSnapshot.hasData) {
                          final List<UserModel> myContacts =
                              asyncSnapshot.data!.docs
                                  .map((e) => UserModel.fromJson(e.data()))
                                  .where(
                                    (element) =>
                                        element.id !=
                                        FirebaseAuth.instance.currentUser!.uid,
                                  )
                                  .toList()
                                ..sort(
                                  (a, b) => a.name!.toLowerCase().compareTo(
                                    b.name!.toLowerCase(),
                                  ),
                                );
                          return ListView.builder(
                            itemCount: myContacts.length,
                            itemBuilder: (context, index) {
                              return Card(
                                child: CheckboxListTile(
                                  title: Text(myContacts[index].name!),
                                  value: members.contains(myContacts[index].id),
                                  onChanged: (value) {
                                    setState(() {
                                      if (members.contains(
                                        myContacts[index].id,
                                      )) {
                                        members.remove(myContacts[index].id);
                                      } else {
                                        members.add(myContacts[index].id);
                                      }
                                    });
                                  },
                                ),
                              );
                            },
                          );
                        } else {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      },
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: members.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: () {
                if (groupcontroller.text.isNotEmpty) {
                  FireData().createGroup(
                    groupName: groupcontroller.text,
                    members: members,
                  );
                  Navigator.pop(context);
                  members = [];
                } else {
                  customShowSnackBar(context: context, message: "Enter Group Name");
                }
              },
              label: Text("Done"),
              icon: Icon(Iconsax.tick_circle),
            )
          : SizedBox(),
    );
  }
}
