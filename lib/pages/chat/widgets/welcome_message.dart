import 'package:flutter/material.dart';
import 'package:yalla_talk_app/firebase/fire_data.dart';
import 'package:yalla_talk_app/models/user_model.dart';

class WelcomeMessage extends StatelessWidget {
  final UserModel userModel;
  final String roomId;

  const WelcomeMessage({
    super.key,
    required this.userModel,
    required this.roomId,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () {
          FireData().sendMessage(
            message: "Hello ${userModel.name}..👋",
            roomId: roomId,
            friendId: userModel.id!,
            type: "text",
          );
        },
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("👋", style: TextStyle(fontSize: 40)),
                const SizedBox(height: 10),
                Text(
                  "Say Hello ${userModel.name}..",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
