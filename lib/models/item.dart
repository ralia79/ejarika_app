import 'package:ejarika_app/models/category.dart';
import 'package:ejarika_app/models/city.dart';
import 'package:ejarika_app/models/user.dart';

class Item {
  int id;
  bool active;
  bool favorite;
  String title;
  String description;
  String phone;
  List<String> images;
  String mainImage;
  double price;
  String address;
  String? createdAt;
  String? approvedDate;
  String? updatedAt;
  User? user;
  Category? category;
  City? city;

  Item({
    required this.id,
    required this.active,
    required this.favorite,
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
      active: json['active'],
      favorite: json['favorite'],
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
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      category:
          json['category'] != null ? Category.fromJson(json['category']) : null,
      city: json['city'] != null ? City.fromJson(json['city']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'active': active,
      'favorite': favorite,
      'title': title,
      'description': description,
      'phone': phone,
      'images': images,
      'mainImage': mainImage,
      'price': price,
      'address': address,
      'createdAt': createdAt,
      'approvedDate': approvedDate,
      'updatedAt': updatedAt,
      'user': user?.toJson(),       
      'category': category?.toJson(),
      'city': city?.toJson(),      
    };
  }

  @override
  String toString() {
    return '''
Item(
  id: $id,
  active: $active,
  favorite: $favorite,
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
