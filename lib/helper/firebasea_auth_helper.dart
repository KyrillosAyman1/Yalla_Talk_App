import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthHelper {
  static String handleLoginAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return "No user found for that email.";
      case 'wrong-password':
        return "Wrong password. Please try again.";
      case 'invalid-email':
        return "Invalid email format.";
      case "email-not-verified":
        return "⚠️ Please verify your email before logging in.";
      default:
        return "Error: ${e.message}";
    }
  }

  static String handleSignupAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'weak-password':
        return "Weak password";
      case 'email-already-in-use':
        return "Email already in use";
      default:
        return "Error: ${e.message}";
    }
  }
}
