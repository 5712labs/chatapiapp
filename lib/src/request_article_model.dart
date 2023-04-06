import 'dart:convert';

class RequestArticle {
  final String title;
  final String description;

  RequestArticle(this.title, this.description);

  Map<String, dynamic> toMap() {
    return {
      'data': {
        'title': title,
        'description': description,
      }
    };
  }

  factory RequestArticle.fromMap(Map<String, dynamic> map) {
    return RequestArticle(
      map['title'] ?? '',
      // map['stock']?..toInt() ?? 0,
      // map['price']?.toInt() ?? 0,
      map['description'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory RequestArticle.fromJson(String source) =>
      RequestArticle.fromMap(json.decode(source));
}
