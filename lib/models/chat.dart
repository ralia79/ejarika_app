import 'package:ejarika_app/models/item.dart';

import 'user.dart';
import 'message.dart';

class Chat {
  final int? id;
  final User? user;
  final List<Message>? messages;
  final Item? advertisement;

  Chat({
    this.id,
    this.user,
    this.messages = const [],
    this.advertisement,
  });

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      id: json['id'] ?? 0,
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      messages: json['messages'] != null
          ? (json['messages'] as List)
              .map((m) => Message.fromJson(m))
              .toList()
          : [],
      advertisement: json['advertisement'] != null
          ? Item.fromJson(json['advertisement'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user': user?.toJson(),
      'messages': messages?.map((m) => m.toJson()).toList(),
      'advertisement': advertisement?.toJson(),
    };
  }
}
