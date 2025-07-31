class MessagesModel {
  final String message;
  final String id;

  MessagesModel({required this.message, required this.id});

  factory MessagesModel.fromjson(jsonData) {
    return MessagesModel(message: jsonData["message"],id: jsonData["id"]);
  }
}
