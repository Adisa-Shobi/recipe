class SearchRecipeDto {
  SearchRecipeDto({
    required this.id,
    required this.title,
    required this.image,
    required this.imageType,
  });
  final int id;
  final String title;
  final String image;
  final String imageType;

  factory SearchRecipeDto.fromJson(Map<String, dynamic> json) {
    return SearchRecipeDto(
      id: json['id'],
      title: json['title'],
      image: json['image'],
      imageType: json['imageType'],
    );
  }

  static Function(Map<String, dynamic>) getListParser(String key) {
    return (
      Map<String, dynamic> json,
    ) {
      final results = json[key] as List;
      if (results.isEmpty) return [];
      return results.map((e) => SearchRecipeDto.fromJson(e)).toList();
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'image': image,
      'imageType': imageType,
    };
  }
}
