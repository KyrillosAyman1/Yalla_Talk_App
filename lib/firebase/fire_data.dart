import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';
import 'package:yalla_talk_app/models/chats_model.dart';
import 'package:yalla_talk_app/models/group_model.dart';
import 'package:yalla_talk_app/models/messages_model.dart';

class FireData {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final String myUid = FirebaseAuth.instance.currentUser!.uid;

  Future creatChatRoom({required String email}) async {
    QuerySnapshot frinedEmail = await firestore
        .collection("users")
        .where("email", isEqualTo: email)
        .get();

    if (frinedEmail.docs.isNotEmpty) {
      String friendId = frinedEmail.docs.first.id;
      List<String> members = [myUid, friendId]..sort((a, b) => a.compareTo(b));
      QuerySnapshot roomExist = await firestore
          .collection("rooms")
          .where("members", isEqualTo: members)
          .get();

      if (roomExist.docs.isEmpty) {
        ChatsModel chatsModel = ChatsModel(
          id: members.toString(),
          createdAt: DateTime.now().millisecondsSinceEpoch.toString(),
          lastMessage: "",
          lastMessageTime: DateTime.now().millisecondsSinceEpoch.toString(),
          members: members,
        );

        await firestore
            .collection("rooms")
            .doc(members.toString())
            .set(chatsModel.toJson());
      }
    } else {
      //print("No user found with this email");
    }
  }
  Future deleteRoom({required String roomId}) async {
    await firestore.collection("rooms").doc(roomId).delete();
  }

  Future addContact({required String email}) async {
    QuerySnapshot frinedEmail = await firestore
        .collection("users")
        .where("email", isEqualTo: email)
        .get();

    if (frinedEmail.docs.isNotEmpty) {
      String friendId = frinedEmail.docs.first.id;

      firestore.collection("users").doc(myUid).update({
        "my_friends": FieldValue.arrayUnion([friendId]),
      });
    }
  }
   Future deleteContact({required String friendId}) async {
     firestore.collection("users").doc(myUid).update({
       "my_friends": FieldValue.arrayRemove([friendId]),
     });
   }
  Future sendMessage({
    required String message,
    required String roomId,
    required String friendId,
    String? type,
  }) async {
    String msgId = const Uuid().v1();
    MessagesModel messagesModel = MessagesModel(
      id: msgId,
      message: message,
      createdAt: DateTime.now().millisecondsSinceEpoch.toString(),
      toId: friendId,
      fromId: myUid,
      type: type ?? "text",
      read: "",
    );

    await firestore
        .collection("rooms")
        .doc(roomId)
        .collection("messages")
        .doc(msgId)
        .set(messagesModel.toJson());

    await firestore.collection("rooms").doc(roomId).update({
      "last_message": type == "text" ? message : "Image 📸",
      "last_message_time": DateTime.now().millisecondsSinceEpoch.toString(),
    });
  }

  Future readMessage({required String roomId, required String msgId}) async {
    await firestore
        .collection("rooms")
        .doc(roomId)
        .collection("messages")
        .doc(msgId)
        .update({"read": DateTime.now().millisecondsSinceEpoch.toString()});
  }

  /*  Future deleteMessage({
    required String roomId,
    required List<String> messages,
  }) async {
    for (var msg in messages) {
      await firestore
          .collection("rooms")
          .doc(roomId)
          .collection("messages")
          .doc(msg)
          .delete();

      final messages = await firestore
          .collection("rooms")
          .doc(roomId)
          .collection("messages")
          .get();
      if (messages.docs.isEmpty) {
        await firestore.collection("rooms").doc(roomId).update({
          "last_message": "",
        });
      }
    }
  }
*/
  Future deleteMessage({
    required String roomId,
    required List<String> messages,
  }) async {
    for (var msg in messages) {
      await firestore
          .collection("rooms")
          .doc(roomId)
          .collection("messages")
          .doc(msg)
          .update({"message": "Message deleted", "type": "text"});

      final messages = await firestore
          .collection("rooms")
          .doc(roomId)
          .collection("messages")
          .get();
      if (messages.docs.isEmpty) {
        await firestore.collection("rooms").doc(roomId).update({
          "last_message": "",
        });
      }
    }
  }

  Future deleteProfileImage() async {
    await firestore.collection("users").doc(myUid).update({"image": ""});
  }

  Future deleteGroupImage({required String groupId}) async {
    await firestore.collection("groups").doc(groupId).update({"image": ""});
  }

  Future createGroup({required String groupName, required List members}) async {
    String groupId = const Uuid().v1();
    members.add(myUid);
    GroupModel groupModel = GroupModel(
      id: groupId,
      name: groupName,
      members: members,
      adminsId: [myUid],
      image: "",
      createdAt: DateTime.now().millisecondsSinceEpoch.toString(),
      lastMessage: "",
      lastMessageTime: DateTime.now().millisecondsSinceEpoch.toString(),
    );

    await firestore.collection("groups").doc(groupId).set(groupModel.toJson());
  }
   Future deleteGroup({required String groupId}) async {
     await firestore.collection("groups").doc(groupId).delete();
   }
  Future sendGroupMessage({
    required String message,
    required String groupId,
    String? type,
  }) async {
    String msgId = const Uuid().v1();
    MessagesModel messagesModel = MessagesModel(
      id: msgId,
      message: message,
      createdAt: DateTime.now().millisecondsSinceEpoch.toString(),
      toId: "",
      fromId: myUid,
      type: type ?? "text",
      read: "",
    );

    await firestore
        .collection("groups")
        .doc(groupId)
        .collection("messages")
        .doc(msgId)
        .set(messagesModel.toJson());

    await firestore.collection("groups").doc(groupId).update({
      "last_message": type == "text" ? message : "Image 📸",
      "last_message_time": DateTime.now().millisecondsSinceEpoch.toString(),
    });
  }

  Future deleteGroupMessage({
    required String groupId,
    required List<String> messages,
  })async {
    for (var msg in messages) {
      await firestore
          .collection("groups")
          .doc(groupId)
          .collection("messages")
          .doc(msg)
          .update({"message": "Message deleted", "type": "text"});

      final messages = await firestore
          .collection("groups")
          .doc(groupId)
          .collection("messages")
          .get();
      if (messages.docs.isEmpty) {
        await firestore.collection("groups").doc(groupId).update({
          "last_message": "",
        });
      }
    }
  }
  Future editGroup({
    required String groupId,
    required String groupName,
    required List members,
  }) async {
    await firestore.collection("groups").doc(groupId).update({
      "name": groupName,
      "members": FieldValue.arrayUnion(members),
    });
  }

  Future removeMember({
    required String groupId,
    required String memberId,
  }) async {
    await firestore.collection("groups").doc(groupId).update({
      "members": FieldValue.arrayRemove([memberId]),
    });
  }

  Future promoreAdmin({
    required String groupId,
    required String memberId,
  }) async {
    await firestore.collection("groups").doc(groupId).update({
      "admin_ids": FieldValue.arrayUnion([memberId]),
    });
  }

  Future removeAdmin({
    required String groupId,
    required String memberId,
  }) async {
    await firestore.collection("groups").doc(groupId).update({
      "admin_ids": FieldValue.arrayRemove([memberId]),
    });
  }

  Future editProfile({required String name, required String about}) async {
    await firestore.collection("users").doc(myUid).update({
      "name": name,
      "about": about,
    });
  }

  Future<DocumentSnapshot?> getUserByEmail(String email) async {
    final query = await FirebaseFirestore.instance
        .collection("users")
        .where("email", isEqualTo: email)
        .limit(1)
        .get();

    if (query.docs.isEmpty) {
      return null;
    } else {
      return query.docs.first;
    }
  }

  }
