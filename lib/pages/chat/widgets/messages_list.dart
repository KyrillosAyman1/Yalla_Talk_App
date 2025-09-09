import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:yalla_talk_app/models/messages_model.dart';
import 'package:yalla_talk_app/models/user_model.dart';
import 'package:yalla_talk_app/pages/chat/widgets/chat_buble.dart';
import 'package:yalla_talk_app/pages/chat/widgets/welcome_message.dart';
import 'package:yalla_talk_app/utils/date_time.dart';

class MessagesList extends StatelessWidget {
  final String roomId;
  final UserModel userModel;
  final List<String> selectedMessages;
  final List<String> copyedMessages;
  final Function(List<String>, List<String>) onUpdateSelection;
  final  ScrollController scrollController;

  const MessagesList({
    super.key,
    required this.roomId,
    required this.userModel,
    required this.selectedMessages,
    required this.copyedMessages,
    required this.onUpdateSelection,
    required this.scrollController,

  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("rooms")
          .doc(roomId)
          .collection("messages")
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<MessagesModel> messagesList =
              snapshot.data!.docs
                  .map((doc) => MessagesModel.fromJson(doc.data()))
                  .toList()
                ..sort((a, b) => b.createdAt!.compareTo(a.createdAt!));

          if (messagesList.isEmpty) {
            return _buildEmptyChat(context, userModel, roomId);
          }

          return ListView.builder(

            cacheExtent: 2000,
            controller: scrollController,
            reverse: true,
            itemCount: messagesList.length,
            itemBuilder: (context, index) {
              final message = messagesList[index];
             String newDate = "";
                                bool isSameDate = false;

                                if (index == 0) {
                                  newDate = "";
                                } else if (index == messagesList.length - 1) {
                                  newDate = MyDateTime.getDateAndTimeString(
                                    time: messagesList[index].createdAt!,
                                  );
                                } else {
                                  final DateTime date = MyDateTime.getDateTime(
                                    time: messagesList[index].createdAt!,
                                  );
                                  final DateTime preDate =
                                      MyDateTime.getDateTime(
                                        time:
                                            messagesList[index + 1].createdAt!,
                                      );
                                  isSameDate = date.isAtSameMomentAs(preDate);
                                  newDate = isSameDate
                                      ? ""
                                      : MyDateTime.getDateAndTimeString(
                                          time: messagesList[index].createdAt!,
                                        );
                                }

              return GestureDetector(
                onTap: () {
                      if(selectedMessages.isNotEmpty){
                         final sel = [...selectedMessages];
                  final copy = [...copyedMessages];
                  
                  if (sel.contains(message.id)) {
                    sel.remove(message.id);
                  } else {
                    sel.add(message.id!);
                    if (message.type == "text") copy.add(message.message!);
                  }
                  onUpdateSelection(sel, copy);
                      }
                 
                },
                onLongPress: () {
                 
                  final sel = [...selectedMessages];
                  final copy = [...copyedMessages];
                  sel.add(message.id!);
                  if (message.type == "text") copy.add(message.message!);
                  onUpdateSelection(sel, copy);
                },
                child: Column(
                  children: [
                    if (newDate.isNotEmpty)
                      Card(
                        color: Theme.of(context).colorScheme.inversePrimary,
                        child: Padding(
                          padding: const EdgeInsets.all(5),
                          child: Text(
                            newDate,
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                        ),
                      ),
                    ChatBuble(
                      messagesModel: message,
                      roomId: roomId,
                      isSelected: selectedMessages.contains(message.id),
                    ),
                  ],
                ),
              );
            },
          );
        }
        else {
           return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _buildEmptyChat(
    BuildContext context,
    UserModel userModel,
    String roomId,
  ) {
    return WelcomeMessage(userModel: userModel, roomId: roomId);
  }
}



