import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yalla_talk_app/firebase_options.dart';
import 'package:yalla_talk_app/pages/home/layout_app.dart';
import 'package:yalla_talk_app/pages/auth/welcome_page.dart';
import 'package:yalla_talk_app/provider/provider_app.dart';
import 'package:yalla_talk_app/routes/routes.dart';
import 'package:yalla_talk_app/supabase/supabase_helper.dart';

void main() async {
   WidgetsFlutterBinding.ensureInitialized();

     SupabaseHelper.init();

 
  // Initialize Firebase with the default options for the current platform
  // This is necessary to ensure that Firebase is set up before the app runs.
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const YallaTalk());
}

class YallaTalk extends StatelessWidget {
  const YallaTalk({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: ChangeNotifierProvider(
        create: (context) => ProviderApp(),
        child: Consumer<ProviderApp>(
          builder: (context, value, child) =>
           MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Yalla Talk',
            themeMode: value.themeMode,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Color(value.mainColor)),
            ),
            darkTheme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: Color(value.mainColor),
                brightness: Brightness.dark,
              ),
            ),
            routes: AppRoutes.routes,
            //initialRoute: WelcomePage.id,
            home: StreamBuilder(
              stream: FirebaseAuth.instance.userChanges(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return const LayoutApp();
                } else {
                  return const WelcomePage();
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
