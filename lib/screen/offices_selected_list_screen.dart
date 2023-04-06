import 'package:flutter/material.dart';
import 'package:chat_api_app/components/app_theme.dart';
import 'package:chat_api_app/components/custom_list_tile.dart';
import 'package:chat_api_app/src/my_location_provider.dart';
import 'package:chat_api_app/src/request_office_model.dart';
import 'package:provider/provider.dart';

class OfficesSelectedListScreen extends StatefulWidget {
  OfficesSelectedListScreen({
    required this.clusterOffices,
    Key? key,
  }) : super(key: key);

  List<RequestOffice> clusterOffices; // 지도에 보이는 전체 아이템 상세

  @override
  State<OfficesSelectedListScreen> createState() =>
      _OfficesSelectedListScreenState();
}

class _OfficesSelectedListScreenState extends State<OfficesSelectedListScreen> {
  @override
  Widget build(BuildContext context) {
    final provier = Provider.of<MyLocationProvider>(context, listen: false);
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isLightMode = brightness == Brightness.light;
    isLightMode = true;
    return Container(
      color: isLightMode ? AppTheme.nearlyWhite : AppTheme.nearlyBlack,
      child: Scaffold(
        backgroundColor:
            isLightMode ? AppTheme.nearlyWhite : AppTheme.nearlyBlack,
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            '등록된 거래 ${widget.clusterOffices.length}건',
            style: AppTheme.viewHead,
          ),
          // backgroundColor: AppTheme.kGinColor,
          elevation: 0.0,
        ),
        extendBodyBehindAppBar: true,
        body: SafeArea(
          top: true,
          child: ListView.builder(
            // scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemCount: widget.clusterOffices.length,
            itemBuilder: (context, index) {
              final office = widget.clusterOffices[index];
              return Column(
                children: [
                  CustomListTile(office: office),
                ],
                // child: CustomListView(offices: widget.clusterOffices),
              );
            },
          ),
        ),
      ),
    );
  }
}
