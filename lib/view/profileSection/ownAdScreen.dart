import 'dart:async';
import 'package:ejarika_app/models/item.dart';
import 'package:ejarika_app/services/adService.dart';
import 'package:ejarika_app/utils/colors.dart';
import 'package:ejarika_app/widgets/itemCard.dart';
import 'package:flutter/material.dart';

class OwnAdScreen extends StatefulWidget {
  const OwnAdScreen({Key? key}) : super(key: key);

  @override
  State<OwnAdScreen> createState() => _OwnAdScreen();
}

class _OwnAdScreen extends State<OwnAdScreen> {
  List<Item> allItems = [];
  final AdService adService = AdService();
  bool fetchingData = true;
  bool hasError = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadItems() async {
    setState(() {
      fetchingData = true;
    });
    try {
      List<Item> items = await adService.fetchOwnItems();
      setState(() {
        allItems = items;
        hasError = false;
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
        title: Text('آگهی های من', style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: Colors.white),
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
                  controller: _scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: allItems.length,
                  itemBuilder: (ctx, index) {
                    final item = allItems[index];
                    return ItemCard(item: item);
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
