import 'package:flutter/material.dart';
import 'package:yalla_talk_app/models/user_model.dart';
import 'package:yalla_talk_app/pages/chat/widgets/app_bar_chat_page.dart';
import 'package:yalla_talk_app/pages/chat/widgets/chat_input.dart';
import 'package:yalla_talk_app/pages/chat/widgets/messages_list.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});
  static const String id = "chat_page";

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final scrollController = ScrollController();

  TextEditingController messageController = TextEditingController();
  List<String> selectedMessages = [];
  List<String> copyedMessages = [];
  bool showScrollToBottom = false;
  @override
  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      // لو المستخدم مش في آخر الليست => خلي الزرار يظهر
      if (scrollController.offset > 100 && !showScrollToBottom) {
        setState(() => showScrollToBottom = true);
      }
      // لو رجع تاني لآخر الليست => خلي الزرار يختفي
      else if (scrollController.offset <= 100 && showScrollToBottom) {
        setState(() => showScrollToBottom = false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var arguments = ModalRoute.of(context)!.settings.arguments as Map;
    var roomId = arguments["roomId"];
    var userModel = arguments["userModel"] as UserModel;

    return Scaffold(
      resizeToAvoidBottomInset: true,

      appBar: AppBarChatPage(
        userModel: userModel,
        roomId: roomId,
        selectedMessages: selectedMessages,
        copyedMessages: copyedMessages,
        onUpdateSelection: () {
          setState(() {
            selectedMessages = [];
            copyedMessages = [];
          });
        },
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: MessagesList(
                  roomId: roomId,
                  userModel: userModel,
                  scrollController: scrollController,
                  selectedMessages: selectedMessages,
                  copyedMessages: copyedMessages,
                  onUpdateSelection: (sel, copy) {
                    setState(() {
                      selectedMessages = sel;
                      copyedMessages = copy;
                    });
                  },
                ),
              ),

              ChatInput(
                controller: messageController,
                scrollController: scrollController,
                roomId: roomId,
                friendId: userModel.id!,
              ),
            ],
          ),
          showScrollToBottom
              ? Positioned(
                  left: 10,
                  bottom: 100,
                  child: IconButton.filledTonal(
                    onPressed: () {
                      scrollController.jumpTo(0);
                    },
                    icon: Icon(
                      Icons.keyboard_double_arrow_down_outlined,
                      size: 20,
                    ),
                  ),
                )
              : SizedBox(),
        ],
      ),
    );
  }
}
