import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:yalla_talk_app/models/group_model.dart';
import 'package:yalla_talk_app/models/messages_model.dart';
import 'package:yalla_talk_app/pages/group/widgets/group_chat_buble.dart';
import 'package:yalla_talk_app/pages/group/widgets/welcome_message_group.dart';

class MessagesListGroup extends StatelessWidget {
  const MessagesListGroup({
    super.key,
    required this.groupModel,
    required this.scrollController,
    required this.selectedMessages,
    required this.copiedMessages,
    required this.onUpdateSelection,
  });
  final GroupModel groupModel;
  final ScrollController scrollController;
  final List<String> selectedMessages;
  final List<String> copiedMessages;
  final Function(List<String>, List<String>) onUpdateSelection;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("groups")
            .doc(groupModel.id)
            .collection("messages")
            .snapshots(),
        builder: (context, asyncSnapshot) {
          if (asyncSnapshot.hasData) {
            List<MessagesModel> messagesList =
                asyncSnapshot.data!.docs
                    .map((doc) => MessagesModel.fromJson(doc.data()))
                    .toList()
                  ..sort((a, b) => b.createdAt!.compareTo(a.createdAt!));

            return messagesList.isNotEmpty
                ? ListView.builder(
                    cacheExtent: 2000,
                    
                    reverse: true,
                    controller: scrollController,
                    itemCount: messagesList.length,
                    itemBuilder: (context, index) {
                      final message = messagesList[index];
                      return GestureDetector(
                        onTap: () {
                          if (selectedMessages.isNotEmpty) {
                            final sel = [...selectedMessages];
                            final copy = [...copiedMessages];

                            if (sel.contains(message.id)) {
                              sel.remove(message.id);
                            } else {
                              sel.add(message.id!);
                              if (message.type == "text")
                                {copy.add(message.message!);}
                            }
                            onUpdateSelection(sel, copy);
                          }
                        },
                        onLongPress: () {
                          final sel = [...selectedMessages];
                          final copy = [...copiedMessages];
                          sel.add(message.id!);
                          if (message.type == "text")
                            {copy.add(message.message!);}
                          onUpdateSelection(sel, copy);
                        },
                        child: GroupChatBuble(
                          messagesModel: messagesList[index],
                          roomId: groupModel.id,
                          isSelected:   selectedMessages.contains(message.id),
                        ),
                      );
                    },
                  )
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [ WelcomeMessageGroup(groupModel: groupModel)],
                  );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
