import 'package:ejarika_app/models/chat.dart';
import 'package:ejarika_app/models/message.dart';
import 'package:ejarika_app/services/ad_service.dart';
import 'package:ejarika_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class ChatDetailScreen extends StatefulWidget {
  final int chatId;

  const ChatDetailScreen({Key? key, required this.chatId}) : super(key: key);

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final TextEditingController _controller = TextEditingController();
  final AdService _adService = AdService();
  Chat? chat;
  List<Message> messages = [];
  bool loading = true;
  bool sending = false;

  @override
  void initState() {
    super.initState();
    _fetchChat();
  }

  Future<void> _fetchChat() async {
    setState(() {
      loading = true;
    });

    try {
      Chat fetchedChat = await _adService.fetchChatById(widget.chatId);
      if (!mounted) return;
      setState(() {
        chat = fetchedChat;
        messages = fetchedChat.messages ?? [];
      });
    } catch (e) {
      print("Failed to load chat: $e");
      if (!mounted) return;
      setState(() {
        chat = null;
      });
    } finally {
      if (!mounted) return;
      setState(() {
        loading = false;
      });
    }
  }

  Future<void> _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty || chat == null) return;

    setState(() {
      sending = true;
    });

    try {
      // Message newMessage = await _adService.sendMessage(
      //   chatId: chat!.id!,
      //   message: text,
      // );
      Message newMessage = new Message(id: 1, message: text);

      setState(() {
        messages.add(newMessage);
        _controller.clear();
      });
    } catch (e) {
      print("Failed to send message: $e");
    } finally {
      if (!mounted) return;
      setState(() {
        sending = false;
      });
    }
  }

  Widget _buildMessage(Message msg) {
    bool isMe = msg.user?.id == chat?.user?.id;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          color: isMe ? AppColors.primary : Colors.grey[300],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          msg.message,
          style: TextStyle(color: isMe ? Colors.white : Colors.black),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Scaffold(
        appBar: AppBar(
          title:
              Text("در حال بارگذاری...", style: TextStyle(color: Colors.white)),
          backgroundColor: AppColors.primary,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      );
    }

    if (chat == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text("چت یافت نشد", style: TextStyle(color: Colors.white)),
          backgroundColor: AppColors.primary,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: Center(
          child: Text("چت مورد نظر پیدا نشد یا خطایی رخ داده است."),
        ),
      );
    }

    final ad = chat!.advertisement;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(ad?.title ?? "آگهی",
                style: TextStyle(fontSize: 18, color: Colors.white)),
          ],
        ),
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(vertical: 8),
              itemCount: messages.length,
              itemBuilder: (ctx, index) {
                final msg = messages[index];
                return _buildMessage(msg);
              },
            ),
          ),
          Divider(height: 1),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            color: Colors.transparent,
            child: Row(
              textDirection: TextDirection.rtl,
              children: [
                IconButton(
                  icon: sending
                      ? SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.rotationY(math.pi),
                          child: IconButton(
                            icon: Icon(Icons.send, color: AppColors.primary),
                            onPressed: _sendMessage,
                          ),
                        ),
                  onPressed: sending ? null : _sendMessage,
                ),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) => _sendMessage(),
                    decoration: InputDecoration(
                      hintText: "پیام خود را بنویسید...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
