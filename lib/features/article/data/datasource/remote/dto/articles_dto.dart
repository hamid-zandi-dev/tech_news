import 'article_dto.dart';

class ArticlesDto {
  ArticlesDto({
    String? status,
    num? totalResults,
    List<ArticleDto>? articles,
  }) {
    _status = status;
    _totalResults = totalResults;
    _articles = articles;
  }

  ArticlesDto.fromJson(dynamic json) {
    _status = json['status'];
    _totalResults = json['totalResults'];
    if (json['articles'] != null) {
      _articles = [];
      json['articles'].forEach((v) {
        _articles?.add(ArticleDto.fromJson(v));
      });
    }
  }

  String? _status;
  num? _totalResults;
  List<ArticleDto>? _articles;

  ArticlesDto copyWith({
    String? status,
    num? totalResults,
    List<ArticleDto>? articles,
  }) =>
      ArticlesDto(
        status: status ?? _status,
        totalResults: totalResults ?? _totalResults,
        articles: articles ?? _articles,
      );

  String? get status => _status;

  num? get totalResults => _totalResults;

  List<ArticleDto>? get articles => _articles;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['totalResults'] = _totalResults;
    if (_articles != null) {
      map['articles'] = _articles?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}
