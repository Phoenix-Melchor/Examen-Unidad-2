class ProductDetail {
  final int id;
  final String title;
  final String description;
  final double price;
  final int stock;
  final String image;
  final List<Review> reviews;

  ProductDetail({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.stock,
    required this.image,
    required this.reviews,
  });

  factory ProductDetail.fromJson(Map<String, dynamic> json) {
    return ProductDetail(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      price: json['price'].toDouble(),
      stock: json['stock'],
      image: json['thumbnail'],
      reviews: (json['reviews'] as List<dynamic>).map((review) => Review.fromJson(review)).toList(),
    );
  }
}

class Review {
  final int rating;
  final String comment;
  final String reviewerName;
  final DateTime date;

  Review({
    required this.rating,
    required this.comment,
    required this.reviewerName,
    required this.date,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      rating: json['rating'],
      comment: json['comment'],
      reviewerName: json['reviewerName'],
      date: DateTime.parse(json['date']),
    );
  }
}
