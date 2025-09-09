import 'dart:io';

import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:yalla_talk_app/firebase/fire_data.dart';
import 'package:yalla_talk_app/helper/custom_show_dialog.dart';
import 'package:yalla_talk_app/models/group_model.dart';
import 'package:yalla_talk_app/supabase/supa_storage.dart';
import 'package:yalla_talk_app/utils/constants.dart';

class GroupInput extends StatelessWidget {
  const GroupInput({super.key, required this.messageController, required this.scrollController, required this.groupModel});
  final TextEditingController messageController;
 final ScrollController scrollController;
 final GroupModel groupModel;
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
                controller: messageController,
                onSubmitted: (value) {
                  if (value.isNotEmpty) {
                    FireData().sendGroupMessage(
                      message: messageController.text,
                      groupId: groupModel.id,
                      type: "text",
                    );
                  }
                  messageController.clear();
                  scrollController.jumpTo(0);
                },

                decoration: InputDecoration(
                  hintText: "Send Message..",
                  prefixIcon: IconButton(
                    onPressed: () {
                       customShowDialog(context: context,title: "Emoji",content:  "🚀 Stay tuned — feature coming soon");
                    },
                    icon: Icon(Iconsax.emoji_happy5),
                  ),
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {
                          _pickImage();
                        },
                        icon: Icon(Icons.camera_alt_outlined),
                      ),
                      IconButton(
                        onPressed: () {
                           customShowDialog(context:  context, title:  "Files", content: "🚀 Stay tuned — feature coming soon");
                        },
                        icon: Icon(Icons.attach_file),
                      ),
                    ],
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: kPrimaryColor),
                  ),
                  
                ),
              ),
            ),
          ),
          IconButton.filled(
            onPressed: () {
              if (messageController.text.isNotEmpty) {
                FireData().sendGroupMessage(
                  message: messageController.text,
                  groupId: groupModel.id,
                  type: "text",
                );
              }
              messageController.clear();
              scrollController.jumpTo(0);
            },
            icon: Icon(Iconsax.send_1),
          ),
        ],
      ),
    );
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      SupaStorage().sendGroupImage(
        file: File(image.path),
        groupId: groupModel.id,

      );
    }
  }
}
