import 'dart:convert';

import 'package:ejarika_app/models/chat.dart';
import 'package:ejarika_app/models/user.dart';
import 'package:ejarika_app/services/ad_service.dart';
import 'package:ejarika_app/widgets/image_slider.dart';
import 'package:flutter/material.dart';
import '../models/item.dart';
import '../utils/colors.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdScreen extends StatefulWidget {
  final String adId;

  const AdScreen({Key? key, required this.adId}) : super(key: key);

  @override
  State<AdScreen> createState() => _AdScreenState();
}

class _AdScreenState extends State<AdScreen> {
  late Future<Item> _adDataFuture;
  final AdService _adService = AdService();

  @override
  void initState() {
    super.initState();
    _loadAdData();
  }

  void _loadAdData() {
    setState(() {
      _adDataFuture = _adService.findItem(widget.adId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: FutureBuilder<Item>(
        future: _adDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return _ErrorWidget(
              message: "مشکلی در بارگذاری اطلاعات پیش آمد.\n${snapshot.error}",
              onRetry: _loadAdData,
            );
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return _ErrorWidget(
              message: "آگهی مورد نظر یافت نشد",
              onRetry: _loadAdData,
            );
          }

          final item = snapshot.data!;
          return _AdContent(item: item);
        },
      ),
    );
  }
}

class _AdContent extends StatefulWidget {
  final Item item;
  const _AdContent({Key? key, required this.item}) : super(key: key);

  @override
  State<_AdContent> createState() => _AdContentState();
}

class _AdContentState extends State<_AdContent> {
  void changeFav() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString('user_data');

    try {
      if (userData != null) {
        final Map<String, dynamic> userMap = json.decode(userData);

        final user = User.fromJson(userMap);

        setState(() {
          widget.item.favorite = !widget.item.favorite;
        });

        Object result = await AdService().changeFavorite(user, widget.item);
        print(result);
      } else {
        print('user data not found !!!');
      }
    } catch (e) {
      setState(() {
        widget.item.favorite = !widget.item.favorite;
      });
      print('faild to change status: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            ImageSliderScreen(images: item.images),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.title,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item.address,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: changeFav,
                        icon: Icon(item.favorite
                            ? Icons.bookmark
                            : Icons.bookmark_border),
                        color: item.favorite ? AppColors.primary : Colors.grey,
                      ),
                    ],
                  ),
                  const Divider(color: AppColors.primary, thickness: 1),
                  const SizedBox(height: 12),
                  _DetailRow(
                    title: "قیمت",
                    value: _formatPrice(item.price),
                    valueStyle: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    "توضیحات",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item.description,
                    style: const TextStyle(
                      fontSize: 15,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _ActionButtons(item: item),
    );
  }

  String _formatPrice(double price) {
    return "${price.toStringAsFixed(0).replaceAllMapped(
          RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
          (match) => '${match[1]},',
        )} تومان";
  }
}

class _ActionButtons extends StatelessWidget {
  final Item item;
  _ActionButtons({Key? key, required this.item}) : super(key: key);

  final AdService adService = AdService();
  bool creatingChat = false;

  void launchDialer(String phoneNumber) async {
    final Uri telUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(telUri)) {
      await launchUrl(telUri);
    } else {
      throw 'Could not launch $telUri';
    }
  }

  void _showContactInfo(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'اطلاعات تماس',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.phone, color: AppColors.primary),
                onTap: () => launchDialer(item.phone),
                title: Text(
                  item.phone,
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _startChat(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString('user_data');
    if (userData != null) {
      final Map<String, dynamic> userMap = json.decode(userData);
      final user = User.fromJson(userMap);
      creatingChat = true;
      Chat newChat = new Chat(id: null, user: user, advertisement: item);
      var result = await adService.createNewChat(newChat);
      // TODO: goto chat detail screen
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        color: Colors.white,
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => _showContactInfo(context),
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text(
                  'اطلاعات تماس',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: () => _startChat(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text(
                  'چت',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String title;
  final String value;
  final TextStyle? valueStyle;

  const _DetailRow({
    Key? key,
    required this.title,
    required this.value,
    this.valueStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontSize: 15)),
        Text(
          value,
          style: valueStyle ?? const TextStyle(fontSize: 15),
        ),
      ],
    );
  }
}

class _ErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const _ErrorWidget({Key? key, required this.message, this.onRetry})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              style: const TextStyle(fontSize: 16, color: Colors.black),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            if (onRetry != null)
              ElevatedButton(
                onPressed: onRetry,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                ),
                child: const Text(
                  'تلاش مجدد',
                  style: TextStyle(color: Colors.white),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
