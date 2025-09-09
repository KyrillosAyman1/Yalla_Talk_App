import 'package:flutter/material.dart';
import 'package:yalla_talk_app/pages/chat/profile_details.dart';
import 'package:yalla_talk_app/pages/home/layout_app.dart';
import 'package:yalla_talk_app/pages/auth/forget_page.dart';
import 'package:yalla_talk_app/pages/auth/login_page.dart';
import 'package:yalla_talk_app/pages/auth/signup_page.dart';
import 'package:yalla_talk_app/pages/auth/welcome_page.dart';
import 'package:yalla_talk_app/pages/chat/chat_page.dart';
import 'package:yalla_talk_app/pages/group/creat_group_page.dart';
import 'package:yalla_talk_app/pages/group/edit_group_page.dart';
import 'package:yalla_talk_app/pages/group/group_members_page.dart';
import 'package:yalla_talk_app/pages/group/group_page.dart';

import 'package:yalla_talk_app/pages/settings/profile_page.dart';
import 'package:yalla_talk_app/pages/settings/qr_code_page.dart';
import 'package:yalla_talk_app/utils/photo_view_page.dart';


    class AppRoutes {
  static final routes = <String, WidgetBuilder>{
    LoginPage.id: (context) => LoginPage(),
        SignupPage.id: (context) => SignupPage(),
        WelcomePage.id: (context) => const WelcomePage(),
        ChatPage.id: (context) => ChatPage(),
        ForgetPage.id: (context) => ForgetPage(),
        LayoutApp.id: (context) => LayoutApp(),
        GroupPage.id: (context) => GroupPage(),
        CreatGroupPage.id: (context) => CreatGroupPage(),
        GroupMembersPage.id:(context) => GroupMembersPage(),
        EditGroupPage.id:(context) => EditGroupPage(),
        ProfilePage.id:(context) => ProfilePage(),
       QRCodePage.id:(context) => QRCodePage(),
       PhotoViewPage.id:(context) => PhotoViewPage(),
       ProfileDetails.id:(context) => ProfileDetails(),
    
       
  };
}
