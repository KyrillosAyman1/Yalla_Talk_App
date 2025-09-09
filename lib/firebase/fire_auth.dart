import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:yalla_talk_app/models/user_model.dart';

class FireAuth {
  static FirebaseAuth auth = FirebaseAuth.instance;
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  static User user = FirebaseAuth.instance.currentUser!;
  static Future createUser() async {
    UserModel userModel = UserModel(
      id: user.uid,
      name: user.displayName ?? '',
      email: user.email ?? '',
      about: "Hello, I am using Yalla Talk",
      image: '',
      createdAt: DateTime.now().millisecondsSinceEpoch.toString(),
      lastSeen: DateTime.now().millisecondsSinceEpoch.toString(),
      pushToken: '',
      online: true,
      myfriends: [],
    );
    await firestore.collection('users').doc(user.uid).set(userModel.toJson());
  }

  /*Future<void> signInUser({
    required String? email,
    required String? password,
  }) async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email!.trim(),
      password: password!.trim(),
    );
  }*/

  Future<void> signInUser({
  required String? email,
  required String? password,
}) async {
  UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
    email: email!.trim(),
    password: password!.trim(),
  );

  if (!userCredential.user!.emailVerified) {
    await FirebaseAuth.instance.signOut();
    throw FirebaseAuthException(
      code: "email-not-verified",
      message: "⚠️ Please verify your email before logging in.",
    );
  }
}


  Future updateActivated(bool online) async {
    await firestore.collection("users").doc(user.uid).update({
      "online": online,
      "last_seen": DateTime.now().millisecondsSinceEpoch.toString(),
    });
  }

   /*static Future<void> signupUser({ required String? email, required String? password}) async {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email!.trim(),
      password: password!.trim(),
    );
  }*/

  static Future<void> signupUser({
  required String? email,
  required String? password,
}) async {
  UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
    email: email!.trim(),
    password: password!.trim(),
  );

  // إرسال إيميل التفعيل
  await userCredential.user!.sendEmailVerification();
}

}
