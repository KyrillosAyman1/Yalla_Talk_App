
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yalla_talk_app/models/user_model.dart';

class ProviderApp with ChangeNotifier {
  ThemeMode themeMode = ThemeMode.system;
  int mainColor = 0xffff1a237e;
  UserModel? me;
  

  getUserDetails() async {
    String myUid = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance
        .collection("users")
        .doc(myUid)
        .get()
        .then((onValue) {
          if (onValue.exists) {
            me = UserModel.fromJson(onValue.data()!);
          }
          else{
            Center(child: CircularProgressIndicator());
          }
        } );
    notifyListeners();
  }

  changeTheme(bool isDark) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    sharedPreferences.setBool('dark', themeMode == ThemeMode.dark);
    notifyListeners();
  }

  void changeMainColor(int color) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    mainColor = color;
    sharedPreferences.setInt('color', mainColor);
    notifyListeners();
  }

  getValuesPref() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    bool isDark = sharedPreferences.getBool('dark') ?? false;
    mainColor = sharedPreferences.getInt('color') ?? 0xffff1a237e;
    themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}





  /*bool get isDarkMode {
    if (themeMode == ThemeMode.system) {
      final brightness =
          WidgetsBinding.instance.platformDispatcher.platformBrightness;
      return brightness == Brightness.dark;
    } else {
      return themeMode == ThemeMode.dark;
    }
  }*/