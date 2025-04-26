class Item {
  final int id;
  final bool isActive;
  final String title;
  final String description;
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
}

class User {
  final int id;
  final String login;
  final String firstName;
  final String lastName;
  final String email;

  User({
    required this.id,
    required this.login,
    required this.firstName,
    required this.lastName,
    required this.email,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      login: json['login'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      email: json['email'] ?? '',
    );
  }
}

class Category {
  final int id;
  final String name;

  Category({required this.id, required this.name});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'] ?? '',
    );
  }
}

class City {
  final int id;
  final String name;
  final double latitude;
  final double longitude;

  City({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
  });

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      id: json['id'],
      name: json['name'] ?? '',
      latitude: (json['latitude'] ?? 0).toDouble(),
      longitude: (json['longitude'] ?? 0).toDouble(),
    );
  }
}
