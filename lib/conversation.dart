import 'message.dart';

class Conversation {
  final List<dynamic> users;
  final Message lastMessage;
  String id;
  final Map<dynamic, dynamic> messageRead;

  Conversation({
    this.users,
    this.id,
    this.messageRead,
    this.lastMessage,
  });
}