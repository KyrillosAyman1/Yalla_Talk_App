

class ChatsModel {
  String? id;
  List? members;
  String? createdAt;
  String? lastMessage;
  String? lastMessageTime; 


  ChatsModel({
    required this.id,
    required this.createdAt,
    required this.members,
    required this.lastMessage,
    required this.lastMessageTime,
  });

  factory ChatsModel.fromJson(jsonData) {
    return ChatsModel(
      id: jsonData["id"],
      members: jsonData["members"],
      lastMessage: jsonData["last_message"],
      lastMessageTime: jsonData["last_message_time"],
      createdAt: jsonData["created_at"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'members': members,
      'last_message': lastMessage,  
      'last_message_time': lastMessageTime,
      'created_at': createdAt,
    };
  }

  }



