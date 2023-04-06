import 'package:flutter/material.dart';
import 'package:chat_api_app/components/app_theme.dart';
import 'package:chat_api_app/src/office_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OfficesListScreen extends StatefulWidget {
  const OfficesListScreen({super.key});

  @override
  State<OfficesListScreen> createState() => _OfficesListScreenState();
}

class _OfficesListScreenState extends State<OfficesListScreen> {
  Future<List<OfficeData>> officesFuture = _getOfficesList();

  static Future<List<OfficeData>> _getOfficesList() async {
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

  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isLightMode = brightness == Brightness.light;
    return Container(
      color: isLightMode ? AppTheme.nearlyWhite : AppTheme.nearlyBlack,
      child: Scaffold(
        backgroundColor:
            isLightMode ? AppTheme.nearlyWhite : AppTheme.nearlyBlack,
        appBar: AppBar(
          centerTitle: true,
          title: Text('Fetch Data Example'),
          // backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
        extendBodyBehindAppBar: true,
        body: SafeArea(
          top: true,
          child: Center(
              child: FutureBuilder<List<OfficeData>>(
            future: officesFuture,
            builder: (context, snapshot) {
              final offices = snapshot.data;
              // print(offices);
              if (snapshot.hasData) {
                return builsPosts(offices!);
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              // 기본적으로 로딩 Spinner를 보여줍니다.
              return const CircularProgressIndicator();
            },
          )),
        ),
      ),
    );
  }

  Widget builsPosts(List<OfficeData> offices) => ListView.builder(
        itemCount: offices.length,
        itemBuilder: (context, index) {
          final office = offices[index];
          return Card(
            child: ListTile(
              title: Text(office.attributes.name),
              subtitle: Text(office.attributes.address),
              leading: Text(office.attributes.users.data.attributes.email),
              trailing: Text(office.attributes.users.data.attributes.username),
            ),
          );
        },
      );
}
