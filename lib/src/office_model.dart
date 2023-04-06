import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter/services.dart' show rootBundle;

// flutter pub run build_runner build : 1회 빌드
// flutter pub run build_runner watch : 파일 변경이 발생하면 빌드
// 만약 오류가 난다면
// flutter clean
// flutter pub run build_runner clean
// flutter pub get && flutter pub run build_runner build -—delete-conflicting-outputs

part 'office_model.g.dart';

// OfficeModel officeModelFromJson(String str) => OfficeModel.fromJson(json.decode(str));
// String officeModelToJson(OfficeModel data) => json.encode(data.toJson());

@JsonSerializable()
class OfficeModel {
  OfficeModel({
    required this.data,
    // required this.meta,
  });

  List<OfficeData> data;
  // Meta meta;

  // factory OfficeModel.fromJson(Map<String, dynamic> json) =>
  //     _$OfficeModelFromJson(json);
  // Map<String, dynamic> toJson() => _$OfficeModelToJson(this);

  factory OfficeModel.fromJson(Map<String, dynamic> json) => OfficeModel(
        data: List<OfficeData>.from(
            json["data"].map((x) => OfficeData.fromJson(x))),
        // meta: Meta.fromJson(json["meta"]),
      );

  // Map<String, dynamic> toJson() => {
  //       "data": List<dynamic>.from(data.map((x) => x.toJson())),
  //       // "meta": meta.toJson(),
  //     };
}

@JsonSerializable()
class OfficeData {
  OfficeData({
    required this.id,
    required this.attributes,
  });

  int id;
  OfficeAttributes attributes;

  factory OfficeData.fromJson(Map<String, dynamic> json) => OfficeData(
        id: json["id"],
        attributes: OfficeAttributes.fromJson(json["attributes"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "attributes": attributes.toJson(),
      };
}

@JsonSerializable()
class OfficeAttributes {
  OfficeAttributes({
    required this.address,
    required this.name,
    required this.price,
    required this.lat,
    required this.lng,
    required this.createdAt,
    required this.updatedAt,
    required this.publishedAt,
    required this.description,
    required this.users,
    required this.categories,
  });

  String address;
  String name;
  String price;
  double lat;
  double lng;
  DateTime createdAt;
  DateTime updatedAt;
  DateTime publishedAt;
  String description;
  Users users;
  Categories categories;

  factory OfficeAttributes.fromJson(Map<String, dynamic> json) =>
      OfficeAttributes(
        address: json["address"],
        name: json["name"],
        price: json["price"],
        lat: json["lat"],
        lng: json["lng"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        publishedAt: DateTime.parse(json["publishedAt"]),
        description: json["description"],
        users: Users.fromJson(json["users"]),
        categories: Categories.fromJson(json["categories"]),
      );

  Map<String, dynamic> toJson() => {
        "address": address,
        "name": name,
        "price": price,
        "lat": lat,
        "lng": lng,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "publishedAt": publishedAt.toIso8601String(),
        "description": description,
        "users": users.toJson(),
        "categories": categories.toJson(),
      };
}

@JsonSerializable()
class Categories {
  Categories({
    required this.data,
  });

  List<CategoriesData> data;

  factory Categories.fromJson(Map<String, dynamic> json) => Categories(
        data: List<CategoriesData>.from(
            json["data"].map((x) => CategoriesData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

@JsonSerializable()
class CategoriesData {
  CategoriesData({
    required this.id,
    required this.attributes,
    this.selectedFilter = true,
  });

  int id;
  CategoriesAttributes attributes;
  bool selectedFilter;

  factory CategoriesData.fromJson(Map<String, dynamic> json) => CategoriesData(
        id: json["id"],
        attributes: CategoriesAttributes.fromJson(json["attributes"]),
        // selectedFilter: json["selectedFilter"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "attributes": attributes.toJson(),
        // "selectedFilter": selectedFilter,
      };
}

@JsonSerializable()
class CategoriesAttributes {
  CategoriesAttributes({
    required this.name,
    required this.createdAt,
    required this.updatedAt,
    required this.publishedAt,
  });

  String name;
  DateTime createdAt;
  DateTime updatedAt;
  DateTime publishedAt;

  factory CategoriesAttributes.fromJson(Map<String, dynamic> json) =>
      CategoriesAttributes(
        name: json["name"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        publishedAt: DateTime.parse(json["publishedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "publishedAt": publishedAt.toIso8601String(),
      };
}

@JsonSerializable()
class Users {
  Users({
    required this.data,
  });

  UserData data;

  factory Users.fromJson(Map<String, dynamic> json) => Users(
        data: UserData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
      };
}

@JsonSerializable()
class UserData {
  UserData({
    required this.id,
    required this.attributes,
  });

  int id;
  UserAttributes attributes;

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
        id: json["id"],
        attributes: UserAttributes.fromJson(json["attributes"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "attributes": attributes.toJson(),
      };
}

@JsonSerializable()
class UserAttributes {
  UserAttributes({
    required this.username,
    required this.email,
    required this.provider,
    required this.confirmed,
    required this.blocked,
    required this.createdAt,
    required this.updatedAt,
  });

  String username;
  String email;
  String provider;
  bool confirmed;
  bool blocked;
  DateTime createdAt;
  DateTime updatedAt;

  factory UserAttributes.fromJson(Map<String, dynamic> json) => UserAttributes(
        username: json["username"],
        email: json["email"],
        provider: json["provider"],
        confirmed: json["confirmed"],
        blocked: json["blocked"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "username": username,
        "email": email,
        "provider": provider,
        "confirmed": confirmed,
        "blocked": blocked,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
      };
}

@JsonSerializable()
class Meta {
  Meta({
    required this.pagination,
  });

  Pagination pagination;

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
        pagination: Pagination.fromJson(json["pagination"]),
      );

  Map<String, dynamic> toJson() => {
        "pagination": pagination.toJson(),
      };
}

@JsonSerializable()
class Pagination {
  Pagination({
    required this.page,
    required this.pageSize,
    required this.pageCount,
    required this.total,
  });

  int page;
  int pageSize;
  int pageCount;
  int total;

  factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
        page: json["page"],
        pageSize: json["pageSize"],
        pageCount: json["pageCount"],
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "page": page,
        "pageSize": pageSize,
        "pageCount": pageCount,
        "total": total,
      };
}

Future<List<CategoriesData>> getCategories() async {
  final url = '${dotenv.get('API_URL')}/Categories';
  try {
    final response = await http.get(Uri.parse(url));
    final datas = Categories.fromJson(json.decode(response.body));
    return datas.data;
  } catch (e) {
    print(e);
    return <CategoriesData>[];
  }
}

Future<List<OfficeData>> getOffices() async {
  final url = '${dotenv.get('API_URL')}/offices?populate=*';
  try {
    final response = await http.get(Uri.parse(url));
    final datas = OfficeModel.fromJson(json.decode(response.body));
    return datas.data;
  } catch (e) {
    print(e);
    return <OfficeData>[];
  }
}

Future<List<OfficeData>> getFilterOffices(LatLngBounds bounds) async {
  // const url =
  // /offices?filters[lat][\$eq]=36.4364209168021&populate=*;
  // /offices?filters[lat][$gte]=34.56367442372536&filters[lng][$gte]=125.2107518707192&filters[lat][$lte]=39.15827305765862&filters[lng][$lte]=128.4022801910317

  var url = '${dotenv.get('API_URL')}/offices';
  url =
      '$url?filters[lat][\$gte]=${bounds.southwest.latitude}&filters[lng][\$gte]=${bounds.southwest.longitude}';
  url =
      '$url&filters[lat][\$lte]=${bounds.northeast.latitude}&filters[lng][\$lte]=${bounds.northeast.longitude}';
  url = '$url&populate=*';
  print(url);

  try {
    final response = await http.get(Uri.parse(url));
    final datas = OfficeModel.fromJson(json.decode(response.body));
    return datas.data;
  } catch (e) {
    print(e);
    return <OfficeData>[];
  }
}
