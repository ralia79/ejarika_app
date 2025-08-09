import 'dart:async';
import 'package:ejarika_app/models/item.dart';
import 'package:ejarika_app/utils/colors.dart';
import 'package:ejarika_app/widgets/chat_card.dart';
import 'package:flutter/material.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({Key? key}) : super(key: key);

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  List<Item> allItems = [];
  bool fetchingData = true;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _loadItems() async {
    setState(() {
      fetchingData = true;
    });
    try {
      // TODO: fetch all chats
      // setState(() {
      //   allItems = items;
      //   filteredItems = items;
      //   hasError = false;
      // });

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
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: AppColors.primary,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Column(
          children: [
            if (fetchingData && !hasError)
              SizedBox(
                child: CircularProgressIndicator(
                  color: AppColors.secondary,
                  strokeWidth: 1,
                ),
                height: 20,
                width: 20,
              ),
            if (hasError)
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
                      child: fetchingData
                          ? const SizedBox(
                        child: CircularProgressIndicator(strokeWidth: 1),
                        height: 10,
                        width: 10,
                      )
                          : const Text('دوباره تلاش کنید'),
                    ),
                  ],
                ),
              ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: _loadItems,
                color: AppColors.primary,
                child: ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: allItems.length,
                  itemBuilder: (ctx, index) {
                    final item = allItems[index];
                    return ChatCard(item: item);
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