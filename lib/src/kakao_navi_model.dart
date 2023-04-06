// To parse this JSON data, do
//
//     final kakaoNaviModel = kakaoNaviModelFromJson(jsonString);

import 'dart:convert';

KakaoNaviModel kakaoNaviModelFromJson(String str) =>
    KakaoNaviModel.fromJson(json.decode(str));

String kakaoNaviModelToJson(KakaoNaviModel data) => json.encode(data.toJson());

class KakaoNaviModel {
  KakaoNaviModel({
    required this.transId,
    required this.routes,
  });

  String transId;
  List<Route> routes;

  factory KakaoNaviModel.fromJson(Map<String, dynamic> json) => KakaoNaviModel(
        transId: json["trans_id"],
        routes: List<Route>.from(json["routes"].map((x) => Route.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "trans_id": transId,
        "routes": List<dynamic>.from(routes.map((x) => x.toJson())),
      };
}

class Route {
  Route({
    required this.resultCode,
    required this.resultMsg,
    required this.summary,
    required this.sections,
  });

  int resultCode;
  String resultMsg;
  Summary summary;
  List<Section> sections;

  factory Route.fromJson(Map<String, dynamic> json) => Route(
        resultCode: json["result_code"],
        resultMsg: json["result_msg"],
        summary: Summary.fromJson(json["summary"]),
        sections: List<Section>.from(
            json["sections"].map((x) => Section.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "result_code": resultCode,
        "result_msg": resultMsg,
        "summary": summary.toJson(),
        "sections": List<dynamic>.from(sections.map((x) => x.toJson())),
      };
}

class Section {
  Section({
    required this.distance,
    required this.duration,
    required this.bound,
    required this.roads,
    required this.guides,
  });

  int distance;
  int duration;
  Bound bound;
  List<Road> roads;
  List<Guide> guides;

  factory Section.fromJson(Map<String, dynamic> json) => Section(
        distance: json["distance"],
        duration: json["duration"],
        bound: Bound.fromJson(json["bound"]),
        roads: List<Road>.from(json["roads"].map((x) => Road.fromJson(x))),
        guides: List<Guide>.from(json["guides"].map((x) => Guide.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "distance": distance,
        "duration": duration,
        "bound": bound.toJson(),
        "roads": List<dynamic>.from(roads.map((x) => x.toJson())),
        "guides": List<dynamic>.from(guides.map((x) => x.toJson())),
      };
}

class Bound {
  Bound({
    required this.minX,
    required this.minY,
    required this.maxX,
    required this.maxY,
  });

  double minX;
  double minY;
  double maxX;
  double maxY;

  factory Bound.fromJson(Map<String, dynamic> json) => Bound(
        minX: json["min_x"]?.toDouble(),
        minY: json["min_y"]?.toDouble(),
        maxX: json["max_x"]?.toDouble(),
        maxY: json["max_y"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "min_x": minX,
        "min_y": minY,
        "max_x": maxX,
        "max_y": maxY,
      };
}

class Guide {
  Guide({
    required this.name,
    required this.x,
    required this.y,
    required this.distance,
    required this.duration,
    required this.type,
    required this.guidance,
    required this.roadIndex,
  });

  String name;
  double x;
  double y;
  int distance;
  int duration;
  int type;
  String guidance;
  int roadIndex;

  factory Guide.fromJson(Map<String, dynamic> json) => Guide(
        name: json["name"],
        x: json["x"]?.toDouble(),
        y: json["y"]?.toDouble(),
        distance: json["distance"],
        duration: json["duration"],
        type: json["type"],
        guidance: json["guidance"],
        roadIndex: json["road_index"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "x": x,
        "y": y,
        "distance": distance,
        "duration": duration,
        "type": type,
        "guidance": guidance,
        "road_index": roadIndex,
      };
}

class Road {
  Road({
    required this.name,
    required this.distance,
    required this.duration,
    required this.trafficSpeed,
    required this.trafficState,
    required this.vertexes,
  });

  String name;
  int distance;
  int duration;
  int trafficSpeed;
  int trafficState;
  List<double> vertexes;

  factory Road.fromJson(Map<String, dynamic> json) => Road(
        name: json["name"],
        distance: json["distance"],
        duration: json["duration"],
        trafficSpeed: json["traffic_speed"],
        trafficState: json["traffic_state"],
        vertexes: List<double>.from(json["vertexes"].map((x) => x?.toDouble())),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "distance": distance,
        "duration": duration,
        "traffic_speed": trafficSpeed,
        "traffic_state": trafficState,
        "vertexes": List<dynamic>.from(vertexes.map((x) => x)),
      };
}

class Summary {
  Summary({
    required this.origin,
    required this.destination,
    required this.waypoints,
    required this.priority,
    required this.bound,
    required this.fare,
    required this.distance,
    required this.duration,
  });

  Destination origin;
  Destination destination;
  List<dynamic> waypoints;
  String priority;
  Bound bound;
  Fare fare;
  int distance;
  int duration;

  factory Summary.fromJson(Map<String, dynamic> json) => Summary(
        origin: Destination.fromJson(json["origin"]),
        destination: Destination.fromJson(json["destination"]),
        waypoints: List<dynamic>.from(json["waypoints"].map((x) => x)),
        priority: json["priority"],
        bound: Bound.fromJson(json["bound"]),
        fare: Fare.fromJson(json["fare"]),
        distance: json["distance"],
        duration: json["duration"],
      );

  Map<String, dynamic> toJson() => {
        "origin": origin.toJson(),
        "destination": destination.toJson(),
        "waypoints": List<dynamic>.from(waypoints.map((x) => x)),
        "priority": priority,
        "bound": bound.toJson(),
        "fare": fare.toJson(),
        "distance": distance,
        "duration": duration,
      };
}

class Destination {
  Destination({
    required this.name,
    required this.x,
    required this.y,
  });

  String name;
  double x;
  double y;

  factory Destination.fromJson(Map<String, dynamic> json) => Destination(
        name: json["name"],
        x: json["x"]?.toDouble(),
        y: json["y"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "x": x,
        "y": y,
      };
}

class Fare {
  Fare({
    required this.taxi,
    required this.toll,
  });

  int taxi;
  int toll;

  factory Fare.fromJson(Map<String, dynamic> json) => Fare(
        taxi: json["taxi"],
        toll: json["toll"],
      );

  Map<String, dynamic> toJson() => {
        "taxi": taxi,
        "toll": toll,
      };
}
