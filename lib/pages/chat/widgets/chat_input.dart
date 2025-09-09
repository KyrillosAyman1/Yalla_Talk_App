import 'dart:io';

import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:yalla_talk_app/firebase/fire_data.dart';
import 'package:yalla_talk_app/helper/custom_show_dialog.dart';
import 'package:yalla_talk_app/supabase/supa_storage.dart';
import 'package:yalla_talk_app/utils/constants.dart';

class ChatInput extends StatelessWidget {
  final TextEditingController controller;
  final ScrollController scrollController;
  final String roomId;
  final String friendId;

  const ChatInput({
    super.key,
    required this.controller,
    required this.scrollController,
    required this.roomId,
    required this.friendId,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        children: [
          Expanded(
            child: Card(
              child: TextField(
                maxLines: 6,
                minLines: 1,
                controller: controller,
                onSubmitted: (value) => _sendMessage(value),
                decoration: InputDecoration(
                  hintText: "Send Message..",
                  prefixIcon: IconButton(
                    onPressed: () {
                        customShowDialog(context:  context,title: "Emoji", content: "🚀 Stay tuned — feature coming soon");

                    },
                    icon: const Icon(Iconsax.emoji_happy5),
                  ),
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: _pickImage,
                        icon: const Icon(Icons.camera_alt_outlined),
                      ),
                      IconButton(
                        onPressed: () {
                        customShowDialog( context: context, title: "Files", content:  "🚀 Stay tuned — feature coming soon");

                        },
                        icon: const Icon(Icons.attach_file),
                      ),
                    ],
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: kPrimaryColor),
                  ),
                ),
              ),
            ),
          ),
          IconButton.filled(
            onPressed: () => _sendMessage(controller.text),
            icon: const Icon(Iconsax.send_1),
          ),
        ],
      ),
    );
  }

  void _sendMessage(String value) {
    if (value.isNotEmpty) {
      FireData().sendMessage(message: value, roomId: roomId, friendId: friendId,type:"text",);
      controller.clear();
      if (scrollController.hasClients) {
        scrollController.jumpTo(0);
      }
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      SupaStorage().sendImage(
        file: File(image.path),
        roomId: roomId,
        uId: friendId,
      );
    }
  }
}
