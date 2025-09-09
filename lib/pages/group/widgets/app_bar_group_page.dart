import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:yalla_talk_app/firebase/fire_data.dart';
import 'package:yalla_talk_app/helper/custom_show_dialog.dart';
import 'package:yalla_talk_app/models/group_model.dart';
import 'package:yalla_talk_app/pages/group/group_members_page.dart';
import 'package:yalla_talk_app/utils/photo_view_page.dart';

class AppBarGroupPage extends StatelessWidget implements PreferredSizeWidget {
  const AppBarGroupPage({super.key, required this.groupModel,required this.selsectedMessages,required this.copiedMessages,required this.onClearSelection});
  final GroupModel groupModel;
   final List<String> selsectedMessages;
   final List<String> copiedMessages ;
     final VoidCallback onClearSelection;

   
  @override

  Widget build(BuildContext context) {
    return AppBar(
    
    titleSpacing: -20,
      title: ListTile(
        onTap: () {
            Navigator.pushNamed(
              context,
              GroupMembersPage.id,
              arguments: {"groupModel": groupModel},
            );
          },
        leading: groupModel.image == "" ?
                        CircleAvatar(
                          radius: 20,
                          child: Icon(Icons.group, size: 20),
                        ):GestureDetector(
                          onTap: () => Navigator.pushNamed(
                            context,PhotoViewPage.id,arguments: groupModel.image
                          ),
                          child: CircleAvatar(
                            radius: 20,
                            backgroundImage:NetworkImage(groupModel.image),
                          ),
                        ),
        title: Text(groupModel.name), 
        subtitle:  StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("users")
                .where("id", whereIn: groupModel.members)
                .snapshots(),
            builder: (context, asyncSnapshot) {
              if (asyncSnapshot.hasData) {
                List membersName = [];
                for (var element in asyncSnapshot.data!.docs) {
                  membersName.add(element.data()["name"]);
                }
                return Text(
                  membersName.join(", "),
                  style: Theme.of(context).textTheme.labelLarge,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ), 
      ),
      
       
      actions: selsectedMessages.isNotEmpty?[
                 IconButton(
                onPressed: () {
                  Clipboard.setData(
                    ClipboardData(text: copiedMessages.join("\n")),
                  );
                  onClearSelection();
                },
                icon: const Icon(Iconsax.copy),
              ),
              IconButton(
                onPressed: () async{
                 await  FireData().deleteGroupMessage(
                    groupId: groupModel.id,
                    messages: selsectedMessages,
                  );
                  onClearSelection();
                },
                icon: const Icon(Iconsax.trash),
              ),

      ]: [
        IconButton(onPressed: () {
                            customShowDialog(
                               context:context, title: "📞 Call", content: "🚀 Stay tuned — feature coming soon");
        }, icon: Icon(Iconsax.call)),
        IconButton(onPressed: () {
           customShowDialog(context: context, title: "🎥 Video Call",content: "🚀 Stay tuned — feature coming soon");
        }, icon: Icon(Iconsax.video)),
        // IconButton(onPressed: () {}, icon: Icon(Icons.more_vert_rounded)),
          IconButton(
                onPressed: () {
                  customShowDialog(context: context,title: "⋮ More", content: "🚀 Stay tuned — feature coming soon");
                },
                icon: const Icon(Icons.more_vert_rounded),
              ),
        //IconButton(onPressed: () {}, icon: Icon(Iconsax.copy)),
        // IconButton(onPressed: () {}, icon: Icon(Iconsax.trash)),
      ] 
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
