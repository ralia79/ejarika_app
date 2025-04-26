class Item {
  final int id;
  final String title;
  final String description;
  final String imageUrl;
  final double price;
  final String createdAt;
  final String updatedAt;

  Item(
      {required this.id,
      required this.title,
      required this.description,
      required this.imageUrl,
      required this.price,
      required this.createdAt,
      required this.updatedAt});

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      imageUrl: json['imageUrl'] ?? '',
      price: json['price'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
}
