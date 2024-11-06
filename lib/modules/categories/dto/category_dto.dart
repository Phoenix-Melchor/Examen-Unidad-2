class CategoryDTO {
  final String name;

  CategoryDTO({required this.name});

  factory CategoryDTO.fromJson(Map<String, dynamic> json) {
    return CategoryDTO(name: json['name']);
  }

  Map<String, dynamic> toJson() {
    return {'name': name};
  }
}
