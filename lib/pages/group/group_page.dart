import 'package:flutter/material.dart';

import 'package:yalla_talk_app/models/group_model.dart';

import 'package:yalla_talk_app/pages/group/widgets/app_bar_group_page.dart';

import 'package:yalla_talk_app/pages/group/widgets/group_input.dart';
import 'package:yalla_talk_app/pages/group/widgets/messages_list_group.dart';

class GroupPage extends StatefulWidget {
  const GroupPage({super.key});
  static const String id = "group_page";

  @override
  State<GroupPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<GroupPage> {
  final scrollController = ScrollController();
  TextEditingController messageController = TextEditingController();
  List<String> selectedMessages = [];
  List<String> copyedMessages = [];

  @override
  Widget build(BuildContext context) {
    var arguments = ModalRoute.of(context)!.settings.arguments as Map;
    var groupModel = arguments["groupModel"] as GroupModel;

    return Scaffold(
      resizeToAvoidBottomInset: true,

      appBar: AppBarGroupPage(
        groupModel: groupModel,
        copiedMessages: copyedMessages,
        selsectedMessages: selectedMessages,
        onClearSelection: () {
          setState(() {
            selectedMessages = [];
            copyedMessages = [];
          });
        },
      ),

      body: Column(
        children: [
          MessagesListGroup(
            copiedMessages: copyedMessages,
            selectedMessages: selectedMessages,
            groupModel: groupModel,
            scrollController: scrollController,
            onUpdateSelection: (sel, copy) {
              setState(() {
                selectedMessages = sel;
                copyedMessages = copy;
              });
            },
          ),

          GroupInput(
            messageController: messageController,
            scrollController: scrollController,
            groupModel: groupModel,
          ),
        ],
      ),
    );
  }
}
