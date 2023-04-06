import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:chat_api_app/components/app_theme.dart';
import 'package:chat_api_app/components/custom_add_field.dart';
import 'package:chat_api_app/src/coor_to_addr.dart';
import 'package:chat_api_app/src/my_location_provider.dart';
import 'package:chat_api_app/src/office_model.dart' as officeModel;
import 'package:chat_api_app/src/request_office_model.dart';
import 'package:chat_api_app/src/user.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:provider/provider.dart';

class OfficeAddScreen extends StatefulWidget {
  const OfficeAddScreen({required this.latLng, Key? key}) : super(key: key);
  final LatLng latLng;

  @override
  State<OfficeAddScreen> createState() => _OfficeAddScreen();
}

class _OfficeAddScreen extends State<OfficeAddScreen> {
  late GoogleMapController mapController;
  final Map<String, Circle> _circles = {};
  var premise = '5-5';
  var sublocality_level_2 = '을지로';
  var sublocality_level_1 = '중구';
  var locality = '';
  var administrative_area_level_1 = '서울특별시';
  var country = '대한민국';
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  static const storage = FlutterSecureStorage();
  dynamic userInfo = ''; // storage에 있는 유저 정보를 저장
  User userData = User(
    id: 0,
    username: "",
    email: "",
    provider: "",
    confirmed: false,
    blocked: false,
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );

  @override
  void initState() {
    super.initState();
    // 비동기로 flutter secure storage 정보를 불러오는 작업
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkUserState();
    });
    _setCategoryList();
  }

  checkUserState() async {
    final userInfo = await storage.read(key: 'userInfo');
    if (userInfo != null) {
      setState(() {
        userData = User.deserialize(userInfo);
      });
    } else {
      // print('로그인이 필요합니다');
    }
  }

  final Map<int, Categories> categories = {
    // 1: Categories(id: 1, name: '부엽토'),
  };

  // 카테고리 리스트 가져오기
  _setCategoryList() async {
    categories.clear();
    final response =
        await http.get(Uri.parse("${dotenv.get('API_URL')}/Categories/"));
    var datas = json.decode(response.body)['data'];
    for (var data in datas) {
      var category =
          Categories(id: data['id'], name: data['attributes']['name']);
      categories[data['id']] = category;
    }
  }

  Future<void> _onMapCreated(GoogleMapController controller) async {
    mapController = controller;
    final provier = Provider.of<MyLocationProvider>(context, listen: false);
    mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
            bearing: 0, target: provier.myLocation, tilt: 0, zoom: 13.0),
      ),
    );

    _circles.clear();
    final circle = Circle(
      circleId: const CircleId('내위치'),
      center: provier.myLocation,
      fillColor: Colors.red.withOpacity(0.3),
      radius: 700,
      strokeColor: Colors.red,
      strokeWidth: 1,
    );
    setState(() {
      _circles['내위치2'] = circle;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // 화면 터치 시 키보드 내리기
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      // child: addDataScaffold(),
      child: Scaffold(
        body: addDataSlivers(),
        // bottomSheet: BottomSheet(
        //   backgroundColor: AppTheme.kGinColor,
        //   shape: const RoundedRectangleBorder(
        //     borderRadius: BorderRadius.zero,
        //   ),
        //   onClosing: () {},
        //   builder: (context) => SizedBox(
        //     height: (MediaQuery.of(context).viewInsets.bottom == 0) ? 0 : 40,
        //     width: MediaQuery.of(context).size.width,
        //     child: Row(
        //       children: [
        //         Expanded(
        //           child: SizedBox(),
        //         ),
        //         IconButton(
        //           onPressed: () {
        //             FocusScope.of(context).unfocus();
        //           },
        //           icon: const Icon(Icons.keyboard_hide_outlined),
        //           color: AppTheme.kDarkGreenColor,
        //           iconSize: 24,
        //         ),
        //         SizedBox(
        //           width: 16,
        //         )
        //       ],
        //     ),
        //   ),
        // ),
      ),
    );
  }

  Widget addDataSlivers() {
    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          expandedHeight: MediaQuery.of(context).size.height * 0.5, // appBar 높이
          pinned: true, // 스크롤 시에도 보이도록
          floating: false,
          snap: false,
          // Sliver appBar를 설정
          flexibleSpace: FlexibleSpaceBar(
            titlePadding: const EdgeInsets.all(0),
            title: Container(
              alignment: Alignment.center,
              color: AppTheme.kGinColor,
              height: AppBar().preferredSize.height,
              width: MediaQuery.of(context).size.width,
              child: Text(
                office.address.replaceAll(
                  '대한민국 ',
                  '',
                ),
                style: AppTheme.signForm,
              ),
            ),
            expandedTitleScale: 1.1,
            centerTitle: true,
            background: gMap(),
          ),
          leading: Padding(
            padding: const EdgeInsets.only(top: 0, left: 8),
            child: CircleAvatar(
              // backgroundColor: Colors.grey.shade300,
              backgroundColor: AppTheme.white.withOpacity(0.9),
              radius: 24.0,
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context, 'close');
                },
                icon: const Icon(
                  Icons.close,
                  color: AppTheme.kDarkGreenColor,
                  size: 28.0,
                ),
              ),
            ),
          ),
          actions: [
            Padding(
              padding:
                  const EdgeInsets.only(top: 0, bottom: 0, left: 0, right: 8.0),
              child: Container(
                height: AppBar().preferredSize.height * 0.7,
                width: 65,
                decoration: BoxDecoration(
                    color: AppTheme.kDarkGreenColor,
                    borderRadius: BorderRadius.circular(10)),
                child: TextButton(
                  onPressed: onSavePressed,
                  child: Text(
                    '저장',
                    style: AppTheme.inButton,
                  ),
                ),
              ),
            ),
          ],
        ),

        SliverToBoxAdapter(
          child: Form(
            key: _formkey,
            child: Column(
              children: [
                CustomAddField(
                  hintText: '글 제목',
                  maxLines: 1,
                  keyboardType: TextInputType.text,
                  onChanged: (value) {},
                  onSaved: (String? val) {
                    office.name = val!;
                  },
                  validator: titleValidator,
                ),
                InkWell(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 16.0,
                      right: 16.0,
                      top: 8,
                      bottom: 4,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            '종류',
                            style: AppTheme.signForm,
                          ),
                        ),
                        Text(
                          (office.categories.id == 0)
                              ? '선택'
                              : (office.categories.id == 999)
                                  ? '종류를 선택하세요.'
                                  : office.categories.name,
                          style: (office.categories.id == 0)
                              ? AppTheme.addForm
                              : (office.categories.id == 999)
                                  ? AppTheme.signError
                                  : AppTheme.signForm,
                        ),
                        const SizedBox(width: 8),
                        const Icon(
                          Icons.arrow_forward_ios,
                          color: AppTheme.kDarkGreenColor,
                          size: 20.0,
                        ),
                      ],
                    ),
                  ),
                  onTap: () {
                    showModalBottomSheet(
                      isScrollControlled: false,
                      context: context,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(25.0),
                        ),
                      ),
                      builder: (context) => StatefulBuilder(
                        builder: (BuildContext context, StateSetter state) {
                          return Container(
                              height:
                                  48 * categories.entries.length.toDouble() +
                                      173,
                              padding: const EdgeInsets.symmetric(
                                vertical: 24.0,
                                horizontal: 16.0,
                              ),
                              child: StatefulBuilder(builder:
                                  (BuildContext context,
                                      StateSetter setBottomState) {
                                return Column(
                                  children: <Widget>[
                                    Text(
                                      '종류',
                                      style: AppTheme.appbarAction,
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    // 부엽토
                                    for (int i = 1;
                                        i <= categories.entries.length;
                                        i++)
                                      RadioListTile(
                                          value: categories[i]!.id,
                                          title: Text(
                                            categories[i]!.name,
                                            style: AppTheme.signForm,
                                          ),
                                          activeColor: AppTheme.kDarkGreenColor,
                                          groupValue: office.categories.id,
                                          onChanged: (value) {
                                            setBottomState(() {
                                              // categories[i]!.id;
                                              office.categories.id = value!;
                                              office.categories.name =
                                                  categories[value]!.name;
                                            });
                                          }),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            height: 16,
                                          ),
                                          Container(
                                            height: 50,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.9,
                                            decoration: BoxDecoration(
                                                color: AppTheme.kDarkGreenColor,
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child: TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                                setState(() {});
                                              },
                                              child: Text(
                                                '완료',
                                                style: AppTheme.inButton,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            height: 24,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              }));
                        },
                      ),
                    );
                  },
                ),
                const Divider(
                  height: 1,
                  thickness: 1,
                  indent: 8,
                  endIndent: 8,
                  color: AppTheme.kGinColor,
                ),
                CustomAddField(
                  hintText: '₩ 가격',
                  maxLines: 1,
                  keyboardType: TextInputType.number,
                  onChanged: (value) {},
                  onSaved: (String? val) {
                    final CurrencyTextInputFormatter formatter =
                        CurrencyTextInputFormatter();
                    formatter.format(val!);
                    var curr = formatter.getUnformattedValue() * 100;
                    office.price = curr.toInt();
                  },
                  validator: priceValidator,
                ),
                CustomAddField(
                  hintText: '내용',
                  maxLines: 0,
                  keyboardType: TextInputType.multiline,
                  onChanged: (value) {},
                  onSaved: (String? val) {
                    office.description = val!;
                  },
                  validator: descriptValidator,
                ),
                Text(office.lat.toString()),
                Text(office.lng.toString()),
                Text('country: ${country}'),
                Text(
                    'administrative_area_level_1: ${administrative_area_level_1}'),
                Text('locality: ${locality}'),
                Text('sublocality_level_1: ${sublocality_level_1}'),
                Text('sublocality_level_2: ${sublocality_level_2}'),
                Text('premise: ${premise}'),
                Text(userData.id.toString()),
                Text(userData.username),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.4,
                ),
              ],
            ),
          ),
        ),

        /*********************** body 부분 *************************/

        // 코딩세프
        /*
        SliverToBoxAdapter(
          child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2),
              itemCount: 20,
              primary: false,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return SizedBox(
                  height: 150,
                  width: double.infinity,
                  child: Card(
                    child: Image.network(
                      'https://source.unsplash.com/random?sig=$index',
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              }),
        ),
        */
        // Sliver 1
        // 스크롤 영역에 표시될 화면을 정의한 것이라고 이해하면 쉬울 것 같다.
        /*
        const SliverFillRemaining(
          child: Center(
              child: Text(
            "SliberAppBody",
            style: TextStyle(color: Colors.red),
          )),
        ),
        */

        // Sliver 2
        // Grid view
        /*
        SliverGrid(
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200.0, // Grid view 너비
            mainAxisSpacing: 10.0, // 행 간 거리
            crossAxisSpacing: 10.0, // 열 간 거리
          ),
          // 화면에 표시될 위젯을 설정
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return Container(
                alignment: Alignment.center,
                color: Colors.green,
                child: Text(
                  'Grid Item $index',
                  style: TextStyle(fontSize: 20),
                ),
              );
            },
            childCount: 10,
          ),
        ),
        */
        // Sliver 3
        // List view
        /*
        SliverFixedExtentList(
          itemExtent: 50.0,
          // 화면에 표시될 위젯을 설정
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return ListTile(
                title: Text(
                  'List Item $index',
                  style: TextStyle(fontSize: 20),
                ),
              );
            },
          ),
        ),
        */
      ],
    );
  }

  Widget gMap() {
    return Stack(children: [
      GoogleMap(
        gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
          Factory<OneSequenceGestureRecognizer>(
            () => EagerGestureRecognizer(),
          ),
        },
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: widget.latLng,
          zoom: 13,
        ),
        myLocationButtonEnabled: true,
        myLocationEnabled: true,
        // circles: _circles.values.toSet(),
        // 카메라 이동 종료 시
        onCameraIdle: () {
          _getAddressFromCooper();
        },
        // 카메라 이동시
        onCameraMove: (position) {
          office.lat = position.target.latitude;
          office.lng = position.target.longitude;
          _circles.clear();
          final circle = Circle(
            circleId: const CircleId('내위치'),
            center: position.target,
            fillColor: Colors.red.withOpacity(0.3),
            radius: 1000,
            strokeColor: Colors.red,
            strokeWidth: 1,
          );
          _circles['내위치2'] = circle;
          // setState(() {

          // });
        },
      ),
      Align(
        alignment: Alignment.center,

        // child: Image.asset(
        //   'assets/images/marker.png',
        //   width: 70,
        //   height: 70,
        //   color: AppTheme.kDarkGreenColor,
        //   alignment: Alignment.topCenter,
        //   fit: BoxFit.fitHeight,
        //   // fit: BoxFit.fitWidth,
        // ),

        child: Container(
          // color: Colors.red,
          width: 120,
          height: 100,
          child: Column(
            children: [
              Container(
                alignment: Alignment.center,
                height: 32,
                width: 120,
                decoration: BoxDecoration(
                    // color: AppTheme.kDarkGreenColor,
                    color: AppTheme.kGinColor,
                    borderRadius: BorderRadius.circular(10)),
                child: Text(
                  '거래 희망 장소',
                  // style: AppTheme.inButton,
                  style: AppTheme.signForm,
                ),
              ),
              const SizedBox(
                height: 2,
              ),
              Image.asset(
                'assets/images/marker.png',
                width: 62,
                // height: 62,
                color: AppTheme.kDarkGreenColor,
                alignment: Alignment.topCenter,
                fit: BoxFit.fitHeight,
                // fit: BoxFit.fitWidth,
              ),
            ],
          ),
        ),
      ),
    ]);
  }

  // 경로로 주소 가져오기
  void _getAddressFromCooper() async {
    String url =
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=${office.lat},${office.lng}&key=${dotenv.get('GmapApiKey')}&language=ko';
    final response = await http.get(Uri.parse(url));

    print(url);
    premise = '';
    sublocality_level_2 = '';
    sublocality_level_1 = '';
    locality = '';
    administrative_area_level_1 = '';
    country = '';

    try {
      final data = CoorToAddr.fromJson(json.decode(response.body));
      for (final result in data.results) {
        office.address = result.formattedAddress;
        print(office.address);
        for (final component in result.addressComponents) {
          if (component.types.contains('premise')) {
            premise = component.longName;
            print('premise: ${premise}');
          } else if (component.types.contains('sublocality_level_4')) {
            sublocality_level_2 = component.longName;
            print('sublocality_level_2: ${sublocality_level_2}');
          } else if (component.types.contains('sublocality_level_3')) {
            sublocality_level_2 = component.longName;
          } else if (component.types.contains('sublocality_level_2')) {
            sublocality_level_2 = component.longName;
          } else if (component.types.contains('sublocality_level_1')) {
            sublocality_level_1 = component.longName;
            print('sublocality_level_1: ${sublocality_level_1}');
          } else if (component.types.contains('locality')) {
            locality = component.longName;
            print('locality: ${locality}');
          } else if (component.types.contains('administrative_area_level_1')) {
            administrative_area_level_1 = component.longName;
            print(
                'administrative_area_level_1: ${administrative_area_level_1}');
          } else if (component.types.contains('country')) {
            country = component.longName;
            print('country: ${country}');
          }
        }
        break;
      }

      setState(() {});
    } catch (e) {
      print(e);
    }
  }

  String? titleValidator(String? val) {
    if (val!.isEmpty) {
      return '제목을 입력하세요.';
    }
    return null;
  }

  String? priceValidator(String? val) {
    if (val!.isEmpty) {
      return '갸격을 입력하세요.';
    }
    final CurrencyTextInputFormatter formatter = CurrencyTextInputFormatter();
    formatter.format(val);
    var curr = formatter.getUnformattedValue() * 100;
    print(curr.toInt());
    return null;
  }

  String? descriptValidator(String? val) {
    if (val!.isEmpty) {
      return '내용을 입력하세요.';
    }
    return null;
  }

  // 저장하기
  Future onSavePressed() async {
    final formKeyState = _formkey.currentState!;

    if (office.categories.id == 0) {
      setState(() {
        office.categories.id = 999;
      });
      return;
    } else if (office.categories.id == 0) {
      return;
    }

    if (formKeyState.validate()) {
      formKeyState.save();
      // todo: 아이디가 없을 경우
      office.users.id = userData.id;
      print(office.toJson());
      try {
        Map<String, String> headers = {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Charset': 'UTF-8'
        };
        var response = await http.post(
          Uri.parse(
            "${dotenv.get('API_URL')}/offices/",
          ),
          headers: headers,
          body: office.toJson(),
        );
        print(response.statusCode);
        print(response.body);
      } catch (e) {
        throw Exception(e);
      }
      Navigator.pop(context);
    }
  }

  Widget addDataScaffold() {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "등록하기",
          style: AppTheme.appbarHead,
        ),
        leading: Padding(
          padding: const EdgeInsets.only(top: 0, left: 8),
          child: CircleAvatar(
            // backgroundColor: Colors.grey.shade300,
            backgroundColor: AppTheme.white.withOpacity(0.9),
            radius: 24.0,
            child: IconButton(
              onPressed: () {
                Navigator.pop(context, 'close');
              },
              icon: const Icon(
                Icons.close,
                color: AppTheme.kDarkGreenColor,
                size: 28.0,
              ),
            ),
          ),
        ),
        actions: [
          Padding(
            padding:
                const EdgeInsets.only(top: 0, bottom: 0, left: 0, right: 8.0),
            child: Container(
              height: AppBar().preferredSize.height * 0.7,
              width: 65,
              decoration: BoxDecoration(
                  color: AppTheme.kDarkGreenColor,
                  borderRadius: BorderRadius.circular(10)),
              child: TextButton(
                onPressed: onSavePressed,
                child: Text(
                  '저장',
                  style: AppTheme.inButton,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: gMap(),
          ),
          Container(
            alignment: Alignment.center,
            color: AppTheme.kGinColor,
            height: 45,
            width: MediaQuery.of(context).size.width,
            child: Text(
              office.address,
              style: AppTheme.signForm,
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: EdgeInsets.only(
                top: 16,
                // bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: SingleChildScrollView(
                child: Form(
                  key: _formkey,
                  child: Column(
                    children: [
                      CustomAddField(
                        hintText: '글 제목',
                        maxLines: 1,
                        keyboardType: TextInputType.text,
                        onChanged: (value) {},
                        onSaved: (String? val) {
                          office.name = val!;
                        },
                        validator: titleValidator,
                      ),
                      InkWell(
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 16.0,
                            right: 16.0,
                            top: 8,
                            bottom: 4,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  '종류',
                                  style: AppTheme.signForm,
                                ),
                              ),
                              Text(
                                (office.categories.id == 0)
                                    ? '선택'
                                    : (office.categories.id == 999)
                                        ? '종류를 선택하세요.'
                                        : office.categories.name,
                                style: (office.categories.id == 0)
                                    ? AppTheme.addForm
                                    : (office.categories.id == 999)
                                        ? AppTheme.signError
                                        : AppTheme.signForm,
                              ),
                              const SizedBox(width: 8),
                              const Icon(
                                Icons.arrow_forward_ios,
                                color: AppTheme.kDarkGreenColor,
                                size: 20.0,
                              ),
                            ],
                          ),
                        ),
                        onTap: () {
                          showModalBottomSheet(
                            isScrollControlled: false,
                            context: context,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(25.0),
                              ),
                            ),
                            builder: (context) => StatefulBuilder(
                              builder:
                                  (BuildContext context, StateSetter state) {
                                return Container(
                                    height: 48 *
                                            categories.entries.length
                                                .toDouble() +
                                        173,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 24.0,
                                      horizontal: 16.0,
                                    ),
                                    child: StatefulBuilder(builder:
                                        (BuildContext context,
                                            StateSetter setBottomState) {
                                      return Column(
                                        children: <Widget>[
                                          Text(
                                            '종류',
                                            style: AppTheme.appbarAction,
                                          ),
                                          const SizedBox(
                                            height: 8,
                                          ),
                                          // 부엽토
                                          for (int i = 1;
                                              i <= categories.entries.length;
                                              i++)
                                            RadioListTile(
                                                value: categories[i]!.id,
                                                title: Text(
                                                  categories[i]!.name,
                                                  style: AppTheme.signForm,
                                                ),
                                                activeColor:
                                                    AppTheme.kDarkGreenColor,
                                                groupValue:
                                                    office.categories.id,
                                                onChanged: (value) {
                                                  setBottomState(() {
                                                    office.categories.id =
                                                        value!;
                                                    office.categories.name =
                                                        categories[value]!.name;
                                                  });
                                                }),
                                          Expanded(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Container(
                                                  height: 16,
                                                ),
                                                Container(
                                                  height: 50,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.9,
                                                  decoration: BoxDecoration(
                                                      color: AppTheme
                                                          .kDarkGreenColor,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10)),
                                                  child: TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                      setState(() {});
                                                    },
                                                    child: Text(
                                                      '완료',
                                                      style: AppTheme.inButton,
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  height: 24,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      );
                                    }));
                              },
                            ),
                          );
                        },
                      ),
                      const Divider(
                        height: 1,
                        thickness: 1,
                        indent: 8,
                        endIndent: 8,
                        color: AppTheme.kGinColor,
                      ),
                      CustomAddField(
                        hintText: '₩ 가격',
                        maxLines: 1,
                        keyboardType: TextInputType.number,
                        onChanged: (value) {},
                        onSaved: (String? val) {
                          final CurrencyTextInputFormatter formatter =
                              CurrencyTextInputFormatter();
                          formatter.format(val!);
                          var curr = formatter.getUnformattedValue() * 100;
                          office.price = curr.toInt();
                        },
                        validator: priceValidator,
                      ),
                      CustomAddField(
                        hintText: '내용',
                        maxLines: 0,
                        keyboardType: TextInputType.multiline,
                        onChanged: (value) {},
                        onSaved: (String? val) {
                          office.description = val!;
                        },
                        validator: descriptValidator,
                      ),
                      // TextField(
                      //   onChanged: (val) {
                      //     office.name = val;
                      //   },
                      //   decoration: const InputDecoration(
                      //     hintText: '글 제목',
                      //   ),
                      // ),
                      // SizedBox(height: 6.0),
                      // TextField(
                      //   onChanged: (val) {
                      //     office.description = val;
                      //   },
                      //   maxLines: null,
                      //   decoration: const InputDecoration(
                      //     hintText: '내용을 작성해주세요.',
                      //     contentPadding: const EdgeInsets.symmetric(
                      //         vertical: 25.0, horizontal: 10.0),
                      //   ),
                      // ),
                      Text(office.lat.toString()),
                      Text(office.lng.toString()),

                      Text(userData.id.toString()),
                      Text(userData.username),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  RequestOffice office = RequestOffice(
    0,
    '제목',
    '주소',
    0,
    35.450701,
    127.570667,
    LatLng(35.00, 127.00),
    '내용',
    Users(id: 1, name: ''),
    Categories(id: 0, name: ''),
    DateTime.now(),
  );
}
