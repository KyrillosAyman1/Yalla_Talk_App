import 'package:flutter/material.dart';
import 'package:yalla_talk_app/firebase/fire_data.dart';
import 'package:yalla_talk_app/models/group_model.dart';

class WelcomeMessageGroup extends StatelessWidget {
  const WelcomeMessageGroup({super.key, required this.groupModel});
 final GroupModel groupModel;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FireData().sendGroupMessage(
          message: "Hello Friends..👋",
          groupId: groupModel.id,
          type: "text",
        );
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("👋", style: Theme.of(context).textTheme.displayMedium),
              SizedBox(height: 10),
              Text(
                "Say Hello Friends..",
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
