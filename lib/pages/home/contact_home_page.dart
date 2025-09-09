import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import 'package:yalla_talk_app/models/user_model.dart';
import 'package:yalla_talk_app/pages/contacts/widgets/contact_card.dart';

import 'package:yalla_talk_app/pages/home/widgets/add_friend.dart';

class ContactHomePage extends StatefulWidget {
  const ContactHomePage({super.key});

  @override
  State<ContactHomePage> createState() => _ContactHomePageState();
}

class _ContactHomePageState extends State<ContactHomePage> {
  final TextEditingController emailFriendController = TextEditingController();
  final TextEditingController searchControl = TextEditingController();
  bool isSearch = false;

  @override
  void dispose() {
    emailFriendController.dispose();
    searchControl.dispose();
    super.dispose();
  }

  Stream<List<UserModel>> _getMyContacts() {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .snapshots()
        .asyncMap((snapshot) async {
          final List myContactIds = snapshot.data()?["my_friends"] ?? [];
          if (myContactIds.isEmpty) return [];

          final querySnapshot = await FirebaseFirestore.instance
              .collection("users")
              .where("id", whereIn: myContactIds)
              .get();

          return querySnapshot.docs
              .map((e) => UserModel.fromJson(e.data()))
              .toList();
        });
  }

  List<UserModel> _filterContacts(List<UserModel> contacts) {
    final text = searchControl.text.toLowerCase();
    if (text.isEmpty) return contacts;

    return contacts.where((c) => c.name!.toLowerCase().contains(text)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: isSearch
            ? Card(
                child: TextField(
                  controller: searchControl,
                  autofocus: true,
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    hintText: "Enter Your Friend Name",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              )
            : const Text("My Contacts"),
        actions: [
          IconButton(
            icon: Icon(isSearch ? Iconsax.close_circle : Iconsax.user_search),
            onPressed: () {
              setState(() {
                if (isSearch) searchControl.clear();
                isSearch = !isSearch;
              });
            },
          ),
        ],
      ),
      body: StreamBuilder<List<UserModel>>(
        stream: _getMyContacts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          final contacts = _filterContacts(snapshot.data ?? []);
          if (contacts.isEmpty) {
            return const Center(child: Text("No contacts yet"));
          }

          return ListView.builder(
            itemCount: contacts.length,
            itemBuilder: (context, index) {
              return ContactCard(myContact: contacts[index]);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            builder: (context) {
              return Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: AddFriend(emailFriendController: emailFriendController),
              );
            },
          );
        },
        child: const Icon(Iconsax.user_add),
      ),
    );
  }
}
