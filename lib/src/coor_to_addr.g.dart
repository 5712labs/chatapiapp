// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coor_to_addr.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CoorToAddr _$CoorToAddrFromJson(Map<String, dynamic> json) => CoorToAddr(
      plusCode: PlusCode.fromJson(json['plusCode'] as Map<String, dynamic>),
      results: (json['results'] as List<dynamic>)
          .map((e) => Result.fromJson(e as Map<String, dynamic>))
          .toList(),
      status: json['status'] as String,
    );

Map<String, dynamic> _$CoorToAddrToJson(CoorToAddr instance) =>
    <String, dynamic>{
      'plusCode': instance.plusCode,
      'results': instance.results,
      'status': instance.status,
    };

PlusCode _$PlusCodeFromJson(Map<String, dynamic> json) => PlusCode(
      compoundCode: json['compoundCode'] as String,
      globalCode: json['globalCode'] as String,
    );

Map<String, dynamic> _$PlusCodeToJson(PlusCode instance) => <String, dynamic>{
      'compoundCode': instance.compoundCode,
      'globalCode': instance.globalCode,
    };

Result _$ResultFromJson(Map<String, dynamic> json) => Result(
      addressComponents: (json['addressComponents'] as List<dynamic>)
          .map((e) => AddressComponent.fromJson(e as Map<String, dynamic>))
          .toList(),
      formattedAddress: json['formattedAddress'] as String,
      geometry: Geometry.fromJson(json['geometry'] as Map<String, dynamic>),
      placeId: json['placeId'] as String,
      plusCode: json['plusCode'] == null
          ? null
          : PlusCode.fromJson(json['plusCode'] as Map<String, dynamic>),
      types: (json['types'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$ResultToJson(Result instance) => <String, dynamic>{
      'addressComponents': instance.addressComponents,
      'formattedAddress': instance.formattedAddress,
      'geometry': instance.geometry,
      'placeId': instance.placeId,
      'plusCode': instance.plusCode,
      'types': instance.types,
    };

AddressComponent _$AddressComponentFromJson(Map<String, dynamic> json) =>
    AddressComponent(
      longName: json['longName'] as String,
      shortName: json['shortName'] as String,
      types: (json['types'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$AddressComponentToJson(AddressComponent instance) =>
    <String, dynamic>{
      'longName': instance.longName,
      'shortName': instance.shortName,
      'types': instance.types,
    };

Geometry _$GeometryFromJson(Map<String, dynamic> json) => Geometry(
      location: Location.fromJson(json['location'] as Map<String, dynamic>),
      locationType: json['locationType'] as String,
      viewport: Viewport.fromJson(json['viewport'] as Map<String, dynamic>),
      bounds: json['bounds'] == null
          ? null
          : Viewport.fromJson(json['bounds'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$GeometryToJson(Geometry instance) => <String, dynamic>{
      'location': instance.location,
      'locationType': instance.locationType,
      'viewport': instance.viewport,
      'bounds': instance.bounds,
    };

Viewport _$ViewportFromJson(Map<String, dynamic> json) => Viewport(
      northeast: Location.fromJson(json['northeast'] as Map<String, dynamic>),
      southwest: Location.fromJson(json['southwest'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ViewportToJson(Viewport instance) => <String, dynamic>{
      'northeast': instance.northeast,
      'southwest': instance.southwest,
    };

Location _$LocationFromJson(Map<String, dynamic> json) => Location(
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
    );

Map<String, dynamic> _$LocationToJson(Location instance) => <String, dynamic>{
      'lat': instance.lat,
      'lng': instance.lng,
    };
