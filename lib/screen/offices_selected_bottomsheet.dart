import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:chat_api_app/components/app_theme.dart';
import 'package:chat_api_app/components/custom_list_tile.dart';
import 'package:chat_api_app/src/request_office_model.dart';
import 'package:intl/intl.dart';

class OfficesSelectedBottomSheet extends StatefulWidget {
  OfficesSelectedBottomSheet({
    required this.office,
    required this.clusterOffices,
    Key? key,
  }) : super(key: key);

  RequestOffice office; // 선택된 아이템
  List<RequestOffice> clusterOffices; // 지도에 보이는 전체 아이템 상세

  @override
  State<OfficesSelectedBottomSheet> createState() =>
      _OfficesSelectedBottomSheetState();
}

class _OfficesSelectedBottomSheetState
    extends State<OfficesSelectedBottomSheet> {
  List<RequestOffice> relationOffices = [
    RequestOffice(
      0,
      '제목',
      '주소',
      0,
      35.450701,
      127.570667,
      const LatLng(35.00, 127.00),
      '내용',
      Users(id: 1, name: ''),
      Categories(id: 0, name: ''),
      DateTime.now(),
    ),
  ];

  @override
  void initState() {
    // 마커에는 동일 주소 항목만 하단에 표시한다.
    relationOffices.clear();
    for (var clusterOffice in widget.clusterOffices) {
      final splitA = widget.office.address.split(' ');
      final splitB = clusterOffice.address.split(' ');
      // print('splitA: ${widget.office.id} ${widget.office}');
      // print('splitB: ${clusterOffice.id} ${clusterOffice}');
      if (splitA.length >= 2 && splitB.length >= 2) {
        if (splitA[0] == splitB[0] && splitA[1] == splitB[1]) {
          relationOffices.add(clusterOffice);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.4,
      maxChildSize: 0.89,
      minChildSize: 0.32,
      builder: (context, scrollController) => ListView.builder(
        controller: scrollController,
        // scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemCount: relationOffices.length,
        itemBuilder: (context, index) {
          final office = relationOffices[index];
          return Column(
            children: [
              (index != 0)
                  ? CustomListTile(office: office)
                  : Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 24.0,
                        horizontal: 16.0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.only(
                              top: 0,
                              bottom: 16,
                            ),
                            width: MediaQuery.of(context).size.width,
                            child: Row(
                              children: [
                                Expanded(child: Container()),
                                Container(
                                  alignment: Alignment.center,
                                  width: 60,
                                  height: 7,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Colors.grey.shade300,
                                  ),
                                ),
                                Expanded(child: Container()),
                              ],
                            ),
                          ),
                          Text(
                            '[${widget.office.id}] ${widget.office.name}',
                            style: AppTheme.viewHead,
                          ),
                          const SizedBox(height: 4.0),
                          Row(
                            children: [
                              Text(
                                widget.office.categories.name,
                                style: AppTheme.viewCaption,
                              ),
                              Text(' | '),
                              Text(
                                _dateDiff(widget.office.updatedAt),
                                style: AppTheme.viewCaption,
                              ),
                            ],
                          ),
                          const SizedBox(height: 4.0),
                          Text(
                            converPriceToString(widget.office.price.toString()),
                            style: AppTheme.viewPrice,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                // Text(
                                //   office.attributes.address,
                                //   style: AppTheme.signForm,
                                // ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10.0, bottom: 20.0),
                                  child: Text(
                                    widget.office.description,
                                    style: AppTheme.viewCaption,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: CircleAvatar(
                                  backgroundColor: AppTheme.kGinColor,
                                  radius: 26.0,
                                  child: IconButton(
                                    color: Colors.white,
                                    splashRadius: 28.0,
                                    icon: const Icon(
                                      // Icons.shopping_cart_outlined,
                                      Icons.favorite_border,
                                      color: AppTheme.kDarkGreenColor,
                                      size: 28.0,
                                    ),
                                    onPressed: () {},
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.office.users.name,
                                      // '청년사업가',
                                      style: AppTheme.viewCaption,
                                    ),
                                    Text(
                                      // office.attributes.address,
                                      widget.office.address.replaceAll(
                                        '대한민국 ',
                                        '',
                                      ),
                                      style: AppTheme.viewCaption,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              Container(
                                height: 50,
                                width: 120,
                                decoration: BoxDecoration(
                                    color: AppTheme.kDarkGreenColor,
                                    borderRadius: BorderRadius.circular(30)),
                                child: TextButton(
                                  onPressed: () {},
                                  child: Text(
                                    '연락하기',
                                    style: AppTheme.inButton,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24.0),
                          Container(height: 0.5, color: Colors.grey.shade500),
                          const SizedBox(height: 24.0),
                          Text(
                            '이 거래와 함께 봤어요',
                            style: AppTheme.viewCaption,
                          ),
                        ],
                      ),
                    ),
            ],
          );
        },
      ),
    );
  }
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
  // int diffHours = _toDay.difference(updatedAt).inHours;

  // print('diffHours:${diffHours} / diffDays: ${diffDays}');
  if (diffDays == 0) {
    return '오늘';
  } else if (diffDays == 1) {
    return '어제';
  } else if (diffDays <= 365) {
    return '$diffDays일 전';
  }
  return '';
}
