

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:yalla_talk_app/firebase/fire_auth.dart';
import 'package:yalla_talk_app/models/user_model.dart';
import 'package:yalla_talk_app/pages/home/chats_home_page.dart';
import 'package:yalla_talk_app/pages/home/contact_home_page.dart';
import 'package:yalla_talk_app/pages/home/group_home_page.dart';
import 'package:yalla_talk_app/pages/home/settings_home_page.dart';
import 'package:yalla_talk_app/provider/provider_app.dart';

class LayoutApp extends StatefulWidget {
  const LayoutApp({super.key});
  static String id = 'layout_app';
  @override
  State<LayoutApp> createState() => _LayoutAppState();
}

class _LayoutAppState extends State<LayoutApp> {
  int currentIndex = 0;
  PageController pageController = PageController();
  final List<String> labels = ["Chats   ", "  Groups", "Contacts", "Settings"];
  @override
  void initState() {
    Provider.of<ProviderApp>(context, listen: false).getValuesPref();
    Provider.of<ProviderApp>(context, listen: false).getUserDetails();
    SystemChannels.lifecycle.setMessageHandler((message) {

        if(message.toString() =="AppLifecycleState.resumed"){
          FireAuth().updateActivated(true);
        }
        else if(message.toString() =="AppLifecycleState.paused" || message.toString() =="AppLifecycleState.inactive"){
          FireAuth().updateActivated(false);
        }
        
      return Future.value(message);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    UserModel? me = Provider.of<ProviderApp>(context).me;
    return Scaffold(
      body: me == null
          ? const Center(child: CircularProgressIndicator())
          : PageView(
              onPageChanged: (value) {
                setState(() {
                  currentIndex = value;
                  
                });
              },
              controller: pageController,
              children: const [
                ChatsHomePage(),
                GroupHomePage(),
                ContactHomePage(),
                SettingsHomePage(),
              ],
            ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CurvedNavigationBar(
            height: 50,
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            color: Theme.of(context).colorScheme.onPrimary,
            index: currentIndex,
            onTap: (value) {
              setState(() {
                currentIndex = value;
                pageController.jumpToPage(value);
              });
            },
            items: const [
              Icon(Icons.message, size: 28),
              Icon(Icons.groups_2_outlined, size: 28),
              Icon(Icons.person, size: 28),
              Icon(Iconsax.setting, size: 28),
            ],
          ),
          Container(
            color: Theme.of(context).colorScheme.onPrimary,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                Spacer(),
                Text("   Chats    "),
                Spacer(flex: 2),
                Text("Groups"),
                Spacer(flex: 2),
                Text("Contacts"),
                Spacer(flex: 2),
                Text("Settings"),
                Spacer(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
