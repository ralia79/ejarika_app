import 'dart:async';
import 'package:ejarika_app/models/item.dart';
import 'package:ejarika_app/services/ad_service.dart';
import 'package:ejarika_app/utils/colors.dart';
import 'package:ejarika_app/widgets/item_card.dart';
import 'package:flutter/material.dart';

class OwnFavScreen extends StatefulWidget {
  const OwnFavScreen({Key? key}) : super(key: key);

  @override
  State<OwnFavScreen> createState() => _OwnFavScreen();
}

class _OwnFavScreen extends State<OwnFavScreen> {
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
      List<Item> items = await adService.fetchOwnFavItems();
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
        title:
            const Text('علاقه مندی های من', style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Column(
          children: [
            if (fetchingData && !hasError)
              const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 1,
                ),
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
                              height: 10,
                              width: 10,
                              child: CircularProgressIndicator(strokeWidth: 1),
                            )
                          : const Text('دوباره تلاش کنید'),
                    ),
                  ],
                ),
              ),
            if (!hasError)
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _loadItems,
                  color: AppColors.primary,
                  child: allItems.isEmpty && !fetchingData
                      ? ListView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          children: const [
                            SizedBox(height: 150),
                            Center(
                              child: Text(
                                'هیچ آگهی‌ای در لیست علاقه‌مندی‌های شما وجود ندارد',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ],
                        )
                      : ListView.builder(
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
