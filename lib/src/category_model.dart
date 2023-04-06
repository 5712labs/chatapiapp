class CategoryList {
  final int id;
  Attributes attributes;

  CategoryList({
    required this.id,
    required this.attributes,
  });

  static CategoryList fromJson(json) => CategoryList(
        id: json['id'],
        attributes: Attributes.fromJson(json['attributes']),
      );
}

class Attributes {
  final String name;
  const Attributes({
    required this.name,
  });

  static Attributes fromJson(json) => Attributes(
        name: json['name'],
      );
}
