import 'package:flutter/material.dart';
import 'package:Ejarika/services/ad_service.dart';
import '../models/item.dart';
import '../utils/colors.dart';

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

class _AdContent extends StatelessWidget {
  final Item item;

  const _AdContent({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Image Section
        Image.network(
          item.images.isNotEmpty ? item.images[0] : '',
          width: double.infinity,
          height: 250,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(
            color: Colors.grey[300],
            height: 250,
            alignment: Alignment.center,
            child: const Icon(Icons.broken_image, color: Colors.grey),
          ),
        ),

        // Details Section
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
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
                  style: TextStyle(fontSize: 16, color: Colors.grey),
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
              ],
            ),
          ),
        ),

        // Action Buttons
        _ActionButtons(),
      ],
    );
  }

  String _formatPrice(double price) {
    return "${price.toStringAsFixed(0).replaceAllMapped(
          RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
          (match) => '${match[1]},',
        )} تومان";
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

class _ActionButtons extends StatelessWidget {
  const _ActionButtons({Key? key}) : super(key: key);

  void _showContactInfo() {
    // Implement contact info logic
    print('Showing contact info');
  }

  void _startChat() {
    // Implement chat logic
    print('Starting chat');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: _showContactInfo,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: const Text(
                'اطلاعات تماس',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: _startChat,
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
