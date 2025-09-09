import 'package:flutter/material.dart';
import 'package:yalla_talk_app/firebase/fire_data.dart';
import 'package:yalla_talk_app/models/group_model.dart';
import 'package:yalla_talk_app/pages/group/group_page.dart';
import 'package:yalla_talk_app/utils/date_time.dart';
import 'package:yalla_talk_app/utils/photo_view_page.dart';

class GroupCard extends StatelessWidget {
  const GroupCard({super.key, required this.groupModel});
  final GroupModel groupModel;

  @override
  Widget build(BuildContext context) {
  
    return Card(
      child: ListTile(
        onLongPress: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text("Delete group"),
              content: Text("Are you sure you want to delete this group?"),
              actions: [
                TextButton(
                  child: Text("Cancel"),
                  onPressed: () => Navigator.pop(context),
                ),
                TextButton(
                  child: Text("Delete"),
                  onPressed: () {
                    FireData().deleteGroup(groupId: groupModel.id);
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          );
        },
        onTap: () => Navigator.pushNamed(
          context,
          GroupPage.id,
          arguments: {  'groupModel': groupModel},
        ),
        leading: groupModel.image == "" ?
                        CircleAvatar(
                          radius: 25,
                          child: Icon(Icons.group, size: 25),
                        ):GestureDetector(
                          onTap: () => Navigator.pushNamed(
                            context,PhotoViewPage.id,arguments: groupModel.image
                          ),
                          child: CircleAvatar(
                            radius: 25,
                            backgroundImage:NetworkImage(groupModel.image),
                          ),
                        ),
        title: Text(groupModel.name),
        subtitle:  Text(groupModel.lastMessage,maxLines: 1,overflow: TextOverflow.ellipsis,),
        trailing: Column(children: [
           Text(
                    "${MyDateTime.getDateAndTimeString(time: groupModel.lastMessageTime.toString())} at ${MyDateTime.getDateTimeString(time: groupModel.lastMessageTime.toString())}",
                  ),
                  SizedBox(height: 10),
           /*Badge(
          label: Text(
            "5",
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
          ),
          largeSize: 25,
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        ),*/
        ],) 
      ),
    );
  }
}
