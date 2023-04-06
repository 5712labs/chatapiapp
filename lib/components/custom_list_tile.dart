import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:chat_api_app/components/app_theme.dart';
import 'package:chat_api_app/src/my_location_provider.dart';
import 'package:chat_api_app/src/request_office_model.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class CustomListTile extends StatefulWidget {
  const CustomListTile({
    required this.office,
    Key? key,
  }) : super(key: key);

  final RequestOffice office;

  @override
  State<CustomListTile> createState() => _CustomListTileState();
}

class _CustomListTileState extends State<CustomListTile> {
  // LatLng myLocation = const LatLng(0, 0);
  String distance = ''; // 전체 검색 결과 거리(미터)
  String duration = ''; // 목적지까지 소요 시간(초)
  String result_msg = '';
  @override
  void initState() {
    super.initState();
    _getKakaoNavi();
  }

// https://apis-navi.kakaomobility.com/v1/directions?origin=127.11015314141542,37.39472714688412&destination=127.10824367964793,37.401937080111644&waypoints=&priority=RECOMMEND&car_fuel=GASOLINE&car_hipass=false&alternatives=false&road_details=false

  _getKakaoNavi() async {
    LatLng myLocation = context.read<MyLocationProvider>().myLocation;

    if (myLocation.latitude == 0) {
      distance = '';
      return;
    }

    Map<String, String> headers = {
      'Authorization': dotenv.get('kakaoMapKey'),
    };

    final response = await http.get(
        Uri.parse(
            "https://apis-navi.kakaomobility.com/v1/directions?origin=${myLocation.longitude},${myLocation.latitude}&destination=${widget.office.lng},${widget.office.lat}"),
        headers: headers);

    var datas = json.decode(response.body)['routes'];

    print(result_msg);

    print('START=====================');
    for (var data in datas) {
      setState(() {
        if (data['result_code'] == 0) {
          if (data['summary']['distance'] < 1000) {
            distance = '${data['summary']['distance'].toInt()}M';
          } else {
            int kilro = data['summary']['distance'] ~/ 1000;
            distance = '${kilro}Km';
          }

          double durationSec = data['summary']['duration'] / 60;
          int durationMin = durationSec.toInt();
          duration = '${durationMin}분';
        } else {
          // result_code = 104; // 에러
          result_msg = data['result_msg'];
        }
      });
    }
  }

  late MyLocationProvider provier;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          isThreeLine: true,
          onTap: () {
            print('${widget.office.name}clicked!!');
          },
          title: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '[${widget.office.id}] [${widget.office.categories.name}] ${widget.office.name}',
                // style: AppTheme.signForm,
                style: AppTheme.listTitle,
              ),
              const SizedBox(
                height: 8,
              ),
            ],
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    _dateDiff(widget.office.updatedAt),
                    style: AppTheme.listSubtitle,
                  ),
                  const Text(' | '),
                  Text(
                    widget.office.address,
                    style: AppTheme.listSubtitle,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                converPriceToString(widget.office.price.toString()),
                style: AppTheme.listPrice,
              ),
            ],
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                distance,
                style: AppTheme.listSubtitle,
              ),

              Text(
                duration,
                style: AppTheme.listSubtitle,
              ),
              // const SizedBox(height: 8),
              // const Icon(Icons.arrow_forward_ios),
            ],
          ),
          minVerticalPadding:
              18, // title , subtitle 의 top 과 bottom 의 최소 padding 값
          // minLeadingWidth: 80, // leading 의 최소 Width 값
          // contentPadding: EdgeInsets.fromLTRB(
          //     15, 15, 15, 15), // ListTile 의 외곽 padding 값
          // visualDensity: VisualDensity(
          //     vertical: 0, horizontal: 0), // ListTile 안에 있는 위젯사이의 padding 값
        ),
        Divider(
          height: 1,
          thickness: 1,
          indent: 8,
          endIndent: 8,
          color: Colors.grey.shade200,
        ),
      ],
    );
  }

  String converPriceToString(String price) {
    if (price == '0') {
      return '나눔';
    }
    var cPrice = NumberFormat.simpleCurrency(
      locale: "ko_kr",
      name: '',
      decimalDigits: 0,
    ).format(int.parse(price));

    return '$cPrice원';
  }

  String _dateDiff(updatedAt) {
    int diffDays = DateTime.now().difference(updatedAt).inDays;
    if (diffDays == 0) {
      return '오늘';
    } else if (diffDays == 1) {
      return '어제';
    } else if (diffDays <= 365) {
      return '$diffDays일 전';
    }
    return '';
  }
}
