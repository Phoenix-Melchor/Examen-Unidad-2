class SearchResult {
  final int id;
  final String title;
  final double price;
  final String thumbnail;

  SearchResult({
    required this.id,
    required this.title,
    required this.price,
    required this.thumbnail,
  });

  factory SearchResult.fromJson(Map<String, dynamic> json) {
    return SearchResult(
      id: json['id'],
      title: json['title'],
      price: (json['price'] as num).toDouble(),
      thumbnail: json['thumbnail'] ?? '',
    );
  }
}
