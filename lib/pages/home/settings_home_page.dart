import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:yalla_talk_app/pages/auth/welcome_page.dart';
import 'package:yalla_talk_app/pages/settings/profile_page.dart';
import 'package:yalla_talk_app/pages/settings/qr_code_page.dart';
import 'package:yalla_talk_app/provider/provider_app.dart';
import 'package:yalla_talk_app/utils/photo_view_page.dart';

class SettingsHomePage extends StatefulWidget {
  const SettingsHomePage({super.key});

  @override
  State<SettingsHomePage> createState() => _SettingsHomePageState();
}

class _SettingsHomePageState extends State<SettingsHomePage> {
  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<ProviderApp>(context);
    return Scaffold(
      appBar: AppBar(title: Text("Settings")),

      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            
            children: [
              StreamBuilder(
                stream: FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).snapshots(),
                builder: (context, asyncSnapshot) {
                   if(asyncSnapshot.hasData) {
                     return ListTile(
                    minLeadingWidth: 30,
                    title: Text(asyncSnapshot.data!["name"]),
                    leading: asyncSnapshot.data!["image"] == ""
                        ? CircleAvatar(
                            radius: 30,
                            child: Icon(Iconsax.user, size: 30),
                            
                          )
                        : GestureDetector(
                          onTap: () => Navigator.pushNamed(
                        context,PhotoViewPage.id,arguments: asyncSnapshot.data!["image"]
                      ),
                          child: CircleAvatar(
                              radius: 30,
                              backgroundImage: NetworkImage(asyncSnapshot.data!["image"]),
                            
                              
                            ),
                        ),
                    trailing: IconButton(
                      icon: Icon(Iconsax.scan_barcode),
                      onPressed: () {
                        Navigator.pushNamed(context, QRCodePage.id, arguments: asyncSnapshot.data!["email"]);
                      },
                    ),
                  );
                   }
                   else {
                     return Center(child: CircularProgressIndicator());
                   }
                }
              ),
              SizedBox(height: 20),
              
              Card(
                child: ListTile(
                  onTap: () => Navigator.pushNamed(context, ProfilePage.id),
                  title: Text("Profile"),
                  leading: Icon(Iconsax.user),
                  trailing: Icon(Iconsax.arrow_right),
                ),
              ),
              Card(
                child: ListTile(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          content: SingleChildScrollView(
                            child: MaterialPicker(
                              pickerColor: Color(prov.mainColor),
                              onColorChanged: (value) {
                                prov.changeMainColor(value.toARGB32());
                              },
                            ),
                          ),
                          actions: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text("Done"),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  title: Text("Theme"),
                  leading: Icon(Iconsax.colorfilter),
                  trailing: Icon(Iconsax.arrow_right),
                ),
              ),
              Card(
                child: ListTile(
                  title: Text("Dark Mode"),
                  leading: Icon(Iconsax.moon),
                  trailing: Switch(
                    value: prov.themeMode == ThemeMode.dark,
                    onChanged: (value) {
                      prov.changeTheme(value);
                    },
                  ),
                ),
              ),
              Card(
                child: ListTile(
                  onTap: () async {
                      await FirebaseAuth.instance.signOut();
                      // ignore: use_build_context_synchronously
                      if(mounted) Navigator.pushNamedAndRemoveUntil(context, WelcomePage.id, (route) => false);
                  },
                  title: Text("sign out"),
                  leading: Icon(Iconsax.logout),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
