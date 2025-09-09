import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:yalla_talk_app/firebase/fire_data.dart';
import 'package:yalla_talk_app/models/group_model.dart';
import 'package:yalla_talk_app/models/user_model.dart';
import 'package:yalla_talk_app/supabase/supa_storage.dart';
import 'package:yalla_talk_app/utils/photo_view_page.dart';
import 'package:yalla_talk_app/widgets/custom_text_form_field.dart';

class EditGroupPage extends StatefulWidget {
  const EditGroupPage({super.key});
  static String id = 'edit_group_page';

  @override
  State<EditGroupPage> createState() => _CreatGroupPageState();
}

class _CreatGroupPageState extends State<EditGroupPage> {
  List members = [];
  List myContacts = [];
  GroupModel? groupModel;
  //String _image = "";

  TextEditingController groupcontroller = TextEditingController();
  @override
  @override
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (groupModel == null) {
      // عشان متتعملش كل مرة
      final args = ModalRoute.of(context)!.settings.arguments as Map;
      groupModel = args["groupModel"] as GroupModel;

      groupcontroller.text = groupModel!.name; // مثلًا تحط الاسم القديم
      // members = List.from(groupModel!.members); // لو عندك أعضاء محفوظين
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Edit Gruop")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection("groups")
                          .doc(groupModel!.id)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return snapshot.data!["image"] == ""
                              ? CircleAvatar(
                                  radius: 40,
                                  child: Icon(Icons.group, size: 40),
                                )
                              : GestureDetector(
                                  onTap: () => Navigator.pushNamed(
                                    context,
                                    PhotoViewPage.id,
                                    arguments: snapshot.data!["image"],
                                  ),
                                  child: CircleAvatar(
                                    radius: 40,
                                    backgroundImage: NetworkImage(
                                      snapshot.data!["image"],
                                    ),
                                  ),
                                );
                        } else {
                          return CircularProgressIndicator();
                        }
                      },
                    ),
                    Positioned(
                      bottom: -10,
                      right: -10,
                      child: IconButton(
                        onPressed: () async {
                          ImagePicker imagePicker = ImagePicker();
                          XFile? image = await imagePicker.pickImage(
                            source: ImageSource.gallery,
                          );
                          if (image != null) {
                           /* setState(() {
                              _image = image.path;
                            });*/
                            SupaStorage().updateGroupImage(
                              file: File(image.path),
                              groupId: groupModel!.id,
                            );
                          }
                        },
                        icon: Icon(Icons.add_a_photo),
                      ),
                    ),
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
            TextButton(
              onPressed: () {
                FireData().deleteGroupImage(groupId: groupModel!.id);
              },
              child: Text("Delete Image"),
            ),

            Divider(),
            SizedBox(height: 20),
            Row(
              children: [
                SizedBox(width: 15),
                Text("Members", style: Theme.of(context).textTheme.titleLarge),
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
                    myContacts = asyncSnapshot.data!.data()!["my_friends"];
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
                                  .where(
                                    (element) => !groupModel!.members.contains(
                                      element.id,
                                    ),
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          FireData().editGroup(
            groupId: groupModel!.id,
            groupName: groupcontroller.text,
            members: members,
          );

          Navigator.pop(context);
        },
        label: Text("Done"),
        icon: Icon(Iconsax.tick_circle),
      ),
    );
  }
}
