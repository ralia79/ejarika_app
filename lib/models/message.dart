import 'user.dart';
import 'chat.dart';

class Message {
  int? id;
  String? message;
  DateTime? sendDate;
  User? user;
  Chat? chat;

  Message({
    this.id,
    this.message,
    this.sendDate,
    this.user,
    this.chat,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'] ?? 0,
      message: json['message'] ?? '',
      sendDate:
          json['sendDate'] != null ? DateTime.parse(json['sendDate']) : null,
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      chat: json['chat'] != null ? Chat.fromJson(json['chat']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'message': message,
      'sendDate': sendDate?.toIso8601String(),
      'user': user?.toJson(),
      'chat': chat?.toJson(),
    };
  }
}
