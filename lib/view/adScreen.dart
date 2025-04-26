import 'package:Ejarika/services/ad_service.dart';
import 'package:flutter/material.dart';
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
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    _loadAdData();
  }

  Future<void> _loadAdData() async {
    setState(() => _isRefreshing = true);
    try {
      _adDataFuture = _adService.findItem(widget.adId);
      await _adDataFuture;
      print(_adDataFuture);
    } finally {
      if (mounted) {
        setState(() => _isRefreshing = false);
      }
    }
  }

  Widget _buildErrorWidget(String message, {VoidCallback? onRetry}) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
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
              child: const Text('تلاش مجدد',
                  style: TextStyle(color: Colors.white)),
            ),
        ],
      ),
    );
  }

  Widget _buildAdContent(Item item) {
    return Column(
      children: [
        // Image Section
        Image.network(
          item.mainImage,
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
                // Title and Location
                Text(
                  item.title,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  "لحظاتی پیش در مشهد، شهرک شهید رجایی",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const Divider(color: AppColors.primary, thickness: 1),

                // Exchange Info
                _buildDetailRow(
                  title: "مایل به معاوضه",
                  value: "نیستم",
                  valueColor: AppColors.secondary,
                ),
                const SizedBox(height: 12),

                // Price
                _buildDetailRow(
                  title: "قیمت",
                  value: _formatPrice(item.price),
                  valueStyle: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),

                // Description
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
        _buildActionButtons(),
      ],
    );
  }

  Widget _buildDetailRow({
    required String title,
    required String value,
    Color? valueColor,
    TextStyle? valueStyle,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontSize: 15)),
        Text(
          value,
          style: valueStyle?.copyWith(color: valueColor) ??
              TextStyle(fontSize: 15, color: valueColor),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () => _showContactInfo(),
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
              onPressed: () => _startChat(),
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

  String _formatPrice(double price) {
    return "${price.toStringAsFixed(0).replaceAllMapped(
          RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
          (match) => '${match[1]},',
        )} تومان";
  }

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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _isRefreshing ? null : _loadAdData,
          ),
        ],
      ),
      body: FutureBuilder<Item>(
        future: _adDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting &&
              !_isRefreshing) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return _buildErrorWidget(
              "مشکلی در بارگذاری اطلاعات پیش آمد.\n${snapshot.error}",
              onRetry: _loadAdData,
            );
          }

          if (!snapshot.hasData) {
            return _buildErrorWidget(
              "آگهی مورد نظر یافت نشد",
              onRetry: _loadAdData,
            );
          }

          return _buildAdContent(snapshot.data!);
        },
      ),
    );
  }
}
