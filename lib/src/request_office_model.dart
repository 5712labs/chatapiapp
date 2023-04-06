import 'dart:convert';

import 'package:google_maps_cluster_manager/google_maps_cluster_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Users {
  Users({
    required this.id,
    required this.name,
  });

  int id;
  String name;
}

class Categories {
  Categories({
    required this.id,
    required this.name,
  });

  int id;
  String name;
}

class RequestOffice with ClusterItem {
  int id;
  String name;
  String address;
  int price;
  double lat;
  double lng;
  LatLng latLng;
  String description;
  Users users;
  Categories categories;
  DateTime updatedAt;

  RequestOffice(
    this.id,
    this.name,
    this.address,
    this.price,
    this.lat,
    this.lng,
    this.latLng,
    this.description,
    this.users,
    this.categories,
    this.updatedAt,
  );

  Map<String, dynamic> toMap() {
    return {
      'data': {
        'name': name,
        'address': address,
        'price': price,
        'lat': lat,
        'lng': lng,
        'latLng': latLng,
        'description': description,
        'users': {'id': users.id},
        'categories': {'id': categories.id},
        // 'updatedAt': updatedAt,
      }
    };
  }

  @override
  String toString() {
    return 'Place $name';
  }

  @override
  LatLng get location => latLng;
  String toJson() => json.encode(toMap());
}
