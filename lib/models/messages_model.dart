class MessagesModel {
   String? message;
   String? id;
   String? createdAt;
    String? toId;
    String? fromId;
  String? type;
  String? read;


  MessagesModel({
    required this.id,
    required this.message,
    required this.createdAt,
    required this.toId,
    required this.fromId,
    required this.type,
    required this.read,
   
  });

  factory MessagesModel.fromJson(jsonData) {
    return MessagesModel(
      id: jsonData["id"],
      message: jsonData["message"],
      toId: jsonData["toId"],
      fromId:  jsonData["fromId"],
      type: jsonData["type"],
      createdAt: jsonData["created_at"],
      read: jsonData["read"],
      
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'message': message,
      'toId': toId,  
      'fromId': fromId,
      'type': type,
      'created_at': createdAt,
      'read': read,
      
    };
  }

  }




