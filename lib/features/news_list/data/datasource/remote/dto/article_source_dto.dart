class ArticleSourceDto {
  ArticleSourceDto({
    String? id,
    String? name,
  }) {
    _id = id;
    _name = name;
  }

  ArticleSourceDto.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
  }

  String? _id;
  String? _name;

  ArticleSourceDto copyWith({
    String? id,
    String? name,
  }) =>
      ArticleSourceDto(
        id: id ?? _id,
        name: name ?? _name,
      );

  String? get id => _id;

  String? get name => _name;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    return map;
  }
}
