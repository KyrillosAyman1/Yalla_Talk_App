

class UserModel {
  String? id;
  String? name;
  String? email;
  String? about;
  String? image;
  String? createdAt;
  String? lastSeen;
  String? pushToken;
  bool? online;
  List? myfriends;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.about,
    required this.image,
    required this.createdAt,
    required this.lastSeen,
    required this.pushToken,
    required this.online,
    required this.myfriends

  });

  factory UserModel.fromJson(jsonData) {
    return UserModel(
      id: jsonData["id"],
      name: jsonData["name"],
      email: jsonData["email"],
      about:  jsonData["about"],
      image: jsonData["image"],
      createdAt: jsonData["created_at"],
      lastSeen: jsonData["last_seen"],
      pushToken: jsonData["push_token"],
      online: jsonData["online"],
       myfriends: jsonData["my_friends"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'about': about,
      'image': image,
      'created_at': createdAt,
      'last_seen': lastSeen,
      'push_token': pushToken,
      'online': online,
      'my_friends': myfriends
    };
  }

  }



