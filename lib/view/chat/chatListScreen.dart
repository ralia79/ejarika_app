import 'dart:async';
import 'package:ejarika_app/models/chat.dart';
import 'package:ejarika_app/services/adService.dart';
import 'package:ejarika_app/utils/colors.dart';
import 'package:ejarika_app/widgets/chatCard.dart';
import 'package:flutter/material.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({Key? key}) : super(key: key);

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  List<Chat> allChats = [];
  bool fetchingData = true;
  bool hasError = false;
  final AdService adService = AdService();

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  Future<void> _loadItems() async {
    allChats = [];
    setState(() {
      fetchingData = true;
      hasError = false;
    });

    try {
      List<Chat> chats = await adService.fetchOwnChats();
      if (!mounted) return;
      setState(() {
        allChats = chats;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        hasError = true;
      });
      print('Failed to load items: $e');
    } finally {
      if (!mounted) return;
      setState(() {
        fetchingData = false;
      });
    }

    setState(() {
      fetchingData = true;
      hasError = false;
    });
    try {
      List<Chat> chats = await adService.fetchOwnChats();
      setState(() {
        allChats = chats;
      });
    } catch (e) {
      setState(() {
        hasError = true;
      });
      print('Failed to load items: $e');
    } finally {
      setState(() {
        fetchingData = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('گفتگو های من', style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Column(
          children: [
            if (fetchingData)
              Expanded(
                child: Center(
                  child: CircularProgressIndicator(
                    color: AppColors.secondary,
                    strokeWidth: 1,
                  ),
                ),
              )
            else if (hasError)
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text('خطایی پیش آمده است !'),
                    const SizedBox(height: 10),
                    OutlinedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      onPressed: _loadItems,
                      child: const Text('دوباره تلاش کنید'),
                    ),
                  ],
                ),
              )
            else if (allChats.isEmpty)
              const Expanded(
                child: Center(
                  child: Text('شما هیچ گفتگویی ندارید'),
                ),
              )
            else
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _loadItems,
                  color: AppColors.primary,
                  child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: allChats.length,
                    itemBuilder: (ctx, index) {
                      final chat = allChats[index];
                      return ChatCard(chat: chat);
                    },
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
