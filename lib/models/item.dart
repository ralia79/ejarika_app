import 'package:ejarika_app/models/category.dart';
import 'package:ejarika_app/models/city.dart';
import 'package:ejarika_app/models/user.dart';

class Item {
  final int id;
  final bool isActive;
  final String title;
  final String description;
  final String phone;
  final List<String> images;
  final String mainImage;
  final double price;
  final String address;
  final String? createdAt;
  final String? approvedDate;
  final String? updatedAt;
  final User user;
  final Category category;
  final City city;

  Item({
    required this.id,
    required this.isActive,
    required this.title,
    required this.description,
    required this.phone,
    required this.images,
    required this.mainImage,
    required this.price,
    required this.address,
    this.createdAt,
    this.approvedDate,
    this.updatedAt,
    required this.user,
    required this.category,
    required this.city,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'],
      isActive: json['isActive'],
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      phone: json['phone'] ?? '',
      images: List<String>.from(json['images'] ?? []),
      mainImage: json['mainImage'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      address: json['address'] ?? '',
      createdAt: json['createdAt'],
      approvedDate: json['approvedDate'],
      updatedAt: json['updatedAt'],
      user: User.fromJson(json['user']),
      category: Category.fromJson(json['category']),
      city: City.fromJson(json['city']),
    );
  }

  @override
  String toString() {
    return '''
Item(
  id: $id,
  isActive: $isActive,
  title: $title,
  description: $description,
  phone: $phone,
  images: $images,
  mainImage: $mainImage,
  price: $price,
  address: $address,
  createdAt: $createdAt,
  approvedDate: $approvedDate,
  updatedAt: $updatedAt,
  user: $user,
  category: $category,
  city: $city
)
''';
  }
}
