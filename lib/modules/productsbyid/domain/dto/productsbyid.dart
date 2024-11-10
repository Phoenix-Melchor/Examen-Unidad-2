class ProductDetail {
  final int id;
  final String title;
  final String description;
  final double price;
  final int stock;
  final String image;

  ProductDetail({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.stock,
    required this.image,
  });

  factory ProductDetail.fromJson(Map<String, dynamic> json) {
    return ProductDetail(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      price: json['price'].toDouble(),
      stock: json['stock'],
      image: json['thumbnail'],
    );
  }
}