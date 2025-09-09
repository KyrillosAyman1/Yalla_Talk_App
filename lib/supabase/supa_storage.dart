import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:yalla_talk_app/firebase/fire_data.dart';

class SupaStorage {
  final SupabaseClient supabase = Supabase.instance.client;

  /// Upload image to Supabase Storage
Future  sendImage({
    required File file,
    required String roomId,
    required String uId,
  }) async {
    try {
      // ✅ لو roomId طلع list خليه string
      final safeRoomId = roomId.replaceAll(RegExp(r'[^a-zA-Z0-9_-]'), "_");

      // استخراج الامتداد
      final ext = file.path.split('.').last;
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.$ext';
      final filePath = 'rooms/$safeRoomId/$fileName';

      // رفع الصورة
      await supabase.storage.from('images').upload(filePath, file);

      // الحصول على رابط التحميل العام
      final imageUrl = supabase.storage.from('images').getPublicUrl(filePath);

      // إرسال الرسالة مع لينك الصورة
      FireData().sendMessage(
        friendId: uId,
        message: imageUrl,
        roomId: roomId,
        type: "image",
      );
    } catch (e) {
      //print('❌ Error uploading image: $e');
      return null;
    }
  }

  Future  updateProfileImage({required File file}) async {
    try {
      String uId = FirebaseAuth.instance.currentUser!.uid;

      // استخراج الامتداد
      final ext = file.path.split('.').last;
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.$ext';
      final filePath = 'rooms/$uId/$fileName';

      // رفع الصورة
      await supabase.storage.from('images').upload(filePath, file);

      // الحصول على رابط التحميل العام
      final imageUrl = supabase.storage.from('images').getPublicUrl(filePath);

      // إرسال الرسالة مع لينك الصورة
     await FirebaseFirestore.instance.collection("users").doc(uId).update({
        "image": imageUrl,
      });
    } catch (e) {
     // print('❌ Error uploading image: $e');
      return null;
    }
  }


   sendGroupImage({
    required File file,
    required String groupId,
    
  }) async {
    try {
      // ✅ لو roomId طلع list خليه string
      final safeRoomId = groupId.replaceAll(RegExp(r'[^a-zA-Z0-9_-]'), "_");

      // استخراج الامتداد
      final ext = file.path.split('.').last;
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.$ext';
      final filePath = 'groups/$safeRoomId/$fileName';

      // رفع الصورة
      await supabase.storage.from('images').upload(filePath, file);

      // الحصول على رابط التحميل العام
      final imageUrl = supabase.storage.from('images').getPublicUrl(filePath);

      // إرسال الرسالة مع لينك الصورة
      FireData().sendGroupMessage(
        message: imageUrl,
        groupId: groupId,
        type: "image",
      );
    } catch (e) {
      //print('❌ Error uploading image: $e');
      return null;
    }
  }

Future  updateGroupImage({required File file, required String groupId}) async {
    try {
   
      // استخراج الامتداد
      final ext = file.path.split('.').last;
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.$ext';
      final filePath = 'groups/$groupId/$fileName';

      // رفع الصورة
      await supabase.storage.from('images').upload(filePath, file);

      // الحصول على رابط التحميل العام
      final imageUrl = supabase.storage.from('images').getPublicUrl(filePath);

      // إرسال الرسالة مع لينك الصورة
     await FirebaseFirestore.instance.collection("groups").doc(groupId).update({
        "image": imageUrl,
      });
    } catch (e) {
      //print('❌ Error uploading image: $e');
      return null;
    }
  }

}
