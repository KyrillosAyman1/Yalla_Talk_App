import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:yalla_talk_app/firebase/fire_data.dart';
import 'package:yalla_talk_app/helper/custom_show_dialog.dart';
import 'package:yalla_talk_app/models/user_model.dart';
import 'package:yalla_talk_app/pages/chat/profile_details.dart';
import 'package:yalla_talk_app/utils/date_time.dart';

class AppBarChatPage extends StatelessWidget implements PreferredSizeWidget {
  final UserModel userModel;
  final String roomId;
  final List<String> selectedMessages;
  final List<String> copyedMessages;
  final VoidCallback onUpdateSelection;

  const AppBarChatPage({
    super.key,
    required this.userModel,
    required this.roomId,
    required this.selectedMessages,
    required this.copyedMessages,
    required this.onUpdateSelection,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      titleSpacing: -20,
      title: ListTile(
        onTap: () {
          Navigator.pushNamed(context, ProfileDetails.id, arguments: userModel);
        },
        leading: userModel.image == ""
            ? const CircleAvatar(radius: 20, child: Icon(Iconsax.user))
            : CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(userModel.image!),
              ),
        title: Text(
          userModel.name!,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("users")
              .doc(userModel.id)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Text(
                snapshot.data!.data()!["online"]
                    ? "Online"
                    : "last ssen ${MyDateTime.getDateAndTimeString(time: userModel.lastSeen!)} at ${MyDateTime.getDateTimeString(time: userModel.lastSeen!)}",

                style: Theme.of(context).textTheme.labelSmall,
                maxLines: 2,
                overflow: TextOverflow.visible,
                textAlign: TextAlign.start,
              );
            }
            return const SizedBox();
          },
        ),
      ),
      actions: selectedMessages.isEmpty
          ? [
              IconButton(
                onPressed: () {
                  customShowDialog(
                    context: context,
                    title: "📞 Call",
                    content: "🚀 Stay tuned — feature coming soon",
                  );
                },
                icon: Icon(Iconsax.call),
              ),
              IconButton(
                onPressed: () {
                  customShowDialog(
                    context: context,
                    title: "🎥 Video Call",
                    content: "🚀 Stay tuned — feature coming soon",
                  );
                },
                icon: Icon(Iconsax.video),
              ),
              // IconButton(onPressed: () {}, icon: Icon(Icons.more_vert_rounded)),
              IconButton(
                onPressed: () {
                  customShowDialog(
                    context: context,
                    title: "⋮ More",
                    content: "🚀 Stay tuned — feature coming soon",
                  );
                },
                icon: const Icon(Icons.more_vert_rounded),
              ),
            ]
          : [
              IconButton(
                onPressed: () {
                  Clipboard.setData(
                    ClipboardData(text: copyedMessages.join("\n")),
                  );
                  onUpdateSelection();
                },
                icon: const Icon(Iconsax.copy),
              ),
              IconButton(
                onPressed: () {
                  FireData().deleteMessage(
                    roomId: roomId,
                    messages: selectedMessages,
                  );
                  onUpdateSelection();
                },
                icon: const Icon(Iconsax.trash),
              ),
            ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
