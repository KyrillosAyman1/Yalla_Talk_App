class GroupModel {
  String id;
  String name;
  String image;
  List members;
  List adminsId;
  String createdAt;
  String lastMessage;
  String lastMessageTime;

  GroupModel({
    required this.id,
    required this.name,
    required this.members,
    required this.adminsId,
    required this.image,
    required this.createdAt,
    required this.lastMessage,
    required this.lastMessageTime,
  });

  factory GroupModel.fromJson(jsonData) {
    return GroupModel(
      id: jsonData["id"]??"",
      name: jsonData["name"]??"",
      members: jsonData["members"]??[],
      adminsId: jsonData["admin_ids"]??[],
      image: jsonData["image"]??"",
      createdAt: jsonData["created_at"]??"",
      lastMessage: jsonData["last_message"]?? "",
      lastMessageTime: jsonData["last_message_time"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'members': members,
      'admin_ids': adminsId,
      'image': image,
      'created_at': createdAt,
      'last_message': lastMessage,
      'last_message_time': lastMessageTime,
    };
  }
}
