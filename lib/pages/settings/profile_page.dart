import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:yalla_talk_app/firebase/fire_data.dart';
import 'package:yalla_talk_app/models/user_model.dart';
import 'package:yalla_talk_app/provider/provider_app.dart';
import 'package:yalla_talk_app/supabase/supa_storage.dart';
import 'package:yalla_talk_app/utils/date_time.dart';
import 'package:yalla_talk_app/utils/photo_view_page.dart';
import 'package:yalla_talk_app/widgets/custom_button.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});
  static String id = 'Profile_Page';

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController aboutController = TextEditingController();
  UserModel? me;
  String _image = "";
  bool nameEdit = false;
  bool aboutEdit = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    me = Provider.of<ProviderApp>(context, listen: false).me;
    nameController.text = me!.name!;
    aboutController.text = me!.about!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Profile")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: StreamBuilder(
            stream: FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).snapshots(),
            builder: (context, asyncSnapshot) {
              if(asyncSnapshot.hasData) {
                return Column(
                //crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                         asyncSnapshot.data!["image"] == "" ?
                        CircleAvatar(
                          radius: 70,
                          child: Icon(Iconsax.user, size: 70),
                        ):GestureDetector(
                          onTap: () => Navigator.pushNamed(
                            context,PhotoViewPage.id,arguments: me!.image
                          ),
                          child: CircleAvatar(
                            radius: 70,
                            backgroundImage:NetworkImage(asyncSnapshot.data!["image"]),
                          ),
                        ),
                        
                        Positioned(
                          bottom: -5,
                          right: -5,
                          child: IconButton.filled(
                            onPressed: () async {
                              ImagePicker imagePicker = ImagePicker();
                              XFile? image = await imagePicker.pickImage(
                                source: ImageSource.gallery,
                              );
                              if (image != null) {
                                setState(() {
                                  _image = image.path;
                                });
                                SupaStorage().updateProfileImage(
                                  file:File(image.path),
                                );
                              }
                            },
                            icon: Icon(Iconsax.edit),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 5,),
                   TextButton(onPressed: (){
                    FireData().deleteProfileImage();
                   }, child: Text("Delete Photo")),
                  SizedBox(height: 5,),
                  Card(
                    child: ListTile(
                      leading: Icon(Iconsax.user_octagon),
                      trailing: IconButton(
                        onPressed: () {
                          setState(() {
                            nameEdit = true;
                          });
                        },
                        icon: Icon(Iconsax.edit),
                      ),
                      title: TextField(
                        controller: nameController,
                        enabled: nameEdit,
                        decoration: InputDecoration(
                          label: Text("Name"),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  Card(
                    child: ListTile(
                      leading: Icon(Iconsax.information),
                      trailing: IconButton(
                        onPressed: () {
                          setState(() {
                            aboutEdit = true;
                          });
                        },
                        icon: Icon(Iconsax.edit),
                      ),
                      title: TextField(
                        controller: aboutController,
                        enabled: aboutEdit,
                        decoration: InputDecoration(
                          label: Text("About"),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  Card(
                    child: ListTile(
                      leading: Icon(Icons.email_outlined),
                      title: Text("Email"),
                      subtitle: Text(me!.email!),
                    ),
                  ),
                  Card(
                    child: ListTile(
                      leading: Icon(Icons.calendar_month_rounded),
                      title: Text("Joined on"),
                      subtitle: Text(
                          "${MyDateTime.getDateAndTimeString(time: me!.createdAt!)} at ${MyDateTime.getDateTimeString(time: me!.createdAt!)}"),
                    ),
                  ),
                  SizedBox(height: 20),
                  CustomButton(
                    text: "Save",
                    colors: [
                      Theme.of(context).colorScheme.primaryContainer,
                      Theme.of(context).colorScheme.primary,
                    ],
                    onTap: () {
                      if (nameController.text.isNotEmpty &&
                          aboutController.text.isNotEmpty) {
                        FireData().editProfile(
                          name: nameController.text,
                          about: aboutController.text,
                        
                        );
                        setState(() {
                          nameEdit = false;
                          aboutEdit = false;
                        });
                      }
                    },
                  ),
                ],
              );
              }
              return Center(child: CircularProgressIndicator());
            }
          ),
        ),
      ),
    );
  }
}


/**import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:yalla_talk_app/firebase/fire_data.dart';
import 'package:yalla_talk_app/models/user_model.dart';
import 'package:yalla_talk_app/provider/provider_app.dart';
import 'package:yalla_talk_app/supabase/supa_storage.dart';
import 'package:yalla_talk_app/utils/date_time.dart';
import 'package:yalla_talk_app/utils/photo_view_page.dart';
import 'package:yalla_talk_app/widgets/custom_button.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});
  static String id = 'Profile_Page';

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController aboutController = TextEditingController();
  UserModel? me;
  String _image = "";
  bool nameEdit = false;
  bool aboutEdit = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    me = Provider.of<ProviderApp>(context, listen: false).me;
    nameController.text = me!.name!;
    aboutController.text = me!.about!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Profile")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: StreamBuilder(
            stream: FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).snapshots(),
            builder: (context, asyncSnapshot) {
              if(asyncSnapshot.hasData) {
                return Column(
                //crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        _image ==""? me!.image==""?
                        CircleAvatar(
                          radius: 70,
                          child: Icon(Iconsax.user, size: 70),
                        ):GestureDetector(
                          onTap: () => Navigator.pushNamed(
                            context,PhotoViewPage.id,arguments: me!.image
                          ),
                          child: CircleAvatar(
                            radius: 70,
                            backgroundImage:NetworkImage(me!.image!),
                          ),
                        )
                        : CircleAvatar(
                          radius: 70,
                          backgroundImage:FileImage(File(_image)),
                        ),
              
                        Positioned(
                          bottom: -5,
                          right: -5,
                          child: IconButton.filled(
                            onPressed: () async {
                              ImagePicker imagePicker = ImagePicker();
                              XFile? image = await imagePicker.pickImage(
                                source: ImageSource.gallery,
                              );
                              if (image != null) {
                                setState(() {
                                  _image = image.path;
                                });
                                SupaStorage().updateProfileImage(
                                  file:File(image.path),
                                );
                              }
                            },
                            icon: Icon(Iconsax.edit),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 5,),
                   TextButton(onPressed: (){
                    FireData().deleteProfileImage();
                   }, child: Text("Delete Photo")),
                  SizedBox(height: 5,),
                  Card(
                    child: ListTile(
                      leading: Icon(Iconsax.user_octagon),
                      trailing: IconButton(
                        onPressed: () {
                          setState(() {
                            nameEdit = true;
                          });
                        },
                        icon: Icon(Iconsax.edit),
                      ),
                      title: TextField(
                        controller: nameController,
                        enabled: nameEdit,
                        decoration: InputDecoration(
                          label: Text("Name"),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  Card(
                    child: ListTile(
                      leading: Icon(Iconsax.information),
                      trailing: IconButton(
                        onPressed: () {
                          setState(() {
                            aboutEdit = true;
                          });
                        },
                        icon: Icon(Iconsax.edit),
                      ),
                      title: TextField(
                        controller: aboutController,
                        enabled: aboutEdit,
                        decoration: InputDecoration(
                          label: Text("About"),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  Card(
                    child: ListTile(
                      leading: Icon(Icons.email_outlined),
                      title: Text("Email"),
                      subtitle: Text(me!.email!),
                    ),
                  ),
                  Card(
                    child: ListTile(
                      leading: Icon(Icons.calendar_month_rounded),
                      title: Text("Joined on"),
                      subtitle: Text(
                          "${MyDateTime.getDateAndTimeString(time: me!.createdAt!)} at ${MyDateTime.getDateTimeString(time: me!.createdAt!)}"),
                    ),
                  ),
                  SizedBox(height: 20),
                  CustomButton(
                    text: "Save",
                    colors: [
                      Theme.of(context).colorScheme.primaryContainer,
                      Theme.of(context).colorScheme.primary,
                    ],
                    onTap: () {
                      if (nameController.text.isNotEmpty &&
                          aboutController.text.isNotEmpty) {
                        FireData().editProfile(
                          name: nameController.text,
                          about: aboutController.text,
                        
                        );
                        setState(() {
                          nameEdit = false;
                          aboutEdit = false;
                        });
                      }
                    },
                  ),
                ],
              );
              }
              return Center(child: CircularProgressIndicator());
            }
          ),
        ),
      ),
    );
  }
}
 */