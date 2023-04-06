import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_cluster_manager/google_maps_cluster_manager.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/foundation.dart';
import 'package:chat_api_app/components/app_theme.dart';
import 'package:chat_api_app/components/create_custom_marker_bitmap.dart';
import 'package:chat_api_app/screen/login_screen.dart';
import 'package:chat_api_app/screen/office_add_screen.dart';
import 'package:chat_api_app/screen/offices_selected_bottomsheet.dart';
import 'package:chat_api_app/screen/offices_selected_list_screen.dart';
import 'package:chat_api_app/src/my_location_provider.dart';
import 'package:chat_api_app/src/office_model.dart' as officeModel;
import 'package:chat_api_app/src/request_office_model.dart';
import 'package:chat_api_app/src/user.dart';
import 'package:provider/provider.dart';

class OfficesGmapScreen extends StatefulWidget {
  static String routeName = "offices_gmap_screen";

  const OfficesGmapScreen({super.key});
  @override
  State<OfficesGmapScreen> createState() => _OfficesGmapScreenState();
}

class _OfficesGmapScreenState extends State<OfficesGmapScreen> {
  late GoogleMapController mapController;
  late ClusterManager _clusterManager; // 지도에 표시되는 클러스터
  Set<Marker> markers = {}; // 지도에 표시되는 마커
  final Map<String, Circle> _circles = {}; // 내위치 서클

  // List<RequestOffice>? clusterOffices;
  List<RequestOffice> clusterOffices = [
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
  final bool _isGetLocation = true;
  bool _isGetMyLocation = true;
  bool _isGetOffices = false;
  final double _lat = 36.431280; // 지도중심 옥천
  final double _lng = 127.644891;

// filter 항목
  bool _rememberMe = false; // 나눔
  var _categories = <officeModel.CategoriesData>[];
  static const storage = FlutterSecureStorage();
  dynamic userInfo = ''; // storage에 있는 유저 정보를 저장
  // late User userData;
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkUserState();
    });
    clusterOffices.clear();
    _clusterManager = ClusterManager<RequestOffice>(
      clusterOffices,
      _updateMarkers,
      markerBuilder: _getMarkerBuilder(AppTheme.kDarkGreenColor),
      stopClusteringZoom: 11,
      // Optional : Configure this if you want to change zoom levels at which the clustering precision change
      levels: [1, 4.25, 6.75, 8.25, 11.5, 14.5, 16.0, 16.5, 20.0],
      // Optional : This number represents the percentage (0.2 for 20%) of latitude and longitude (in each direction) to be considered on top of the visible map bounds to render clusters. This way, clusters don't "pop out" when you cross the map.
      extraPercent: 0.2,
    );
    _getCategories();
    context.read<MyLocationProvider>().getMyLatLng(); // 내 위치 가져오기
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

  @override
  Widget build(BuildContext context) {
    if (!_isGetLocation) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return MaterialApp(
        home: Scaffold(
          body: Stack(
            children: <Widget>[
              _gMap(), // 구글지도
              _showProgesss(), // 스피너
              _filter(),
              _mapControl(),
            ],
          ),
        ),
      );
    }
  }

  Future<void> _onMapCreated(GoogleMapController controller) async {
    mapController = controller;
    final visibleRegion = await mapController.getVisibleRegion();
    print('카메라 범위: onCameraIdle visibleRegion: $visibleRegion');
    _clusterManager.setMapId(controller.mapId);
    _getOfficesList(); // 위치 리스트 가져오기
    // _getMyLocation(); // 내 위치 가져오기
  }

  Widget _gMap() {
    return Stack(children: [
      GoogleMap(
        gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
          Factory<OneSequenceGestureRecognizer>(
            () => EagerGestureRecognizer(),
          ),
        },
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: LatLng(_lat, _lng),
          zoom: 7.2,
        ),
        myLocationButtonEnabled: false,
        myLocationEnabled: true,
        markers: markers,
        circles: _circles.values.toSet(),
        // 클러스트맵 설정
        onCameraMove: (position) {
          _clusterManager.onCameraMove(position);
        },
        // 카메라 이동 종료 시
        onCameraIdle: () async {
          // final visibleRegion = await mapController.getVisibleRegion();
          // print('카메라 범위: onCameraIdle visibleRegion: $visibleRegion');
          clusterOffices.clear();
          _clusterManager.updateMap();
        },
      ),
    ]);
  }

  // 위치 리스트 가져오기
  void _getOfficesList() async {
    setState(() {
      _isGetOffices = false;
    });
    final offices = await officeModel.getOffices();
    setState(() {
      _setMarkers(offices);
      _isGetOffices = true;
    });
  }

  // 지도 내 위치 리스트 가져오기
  void _getOfficesListInMap() async {
    setState(() {
      _isGetOffices = false;
    });

    final visibleRegion = await mapController.getVisibleRegion();
    print('카메라 범위: onCameraIdle visibleRegion: $visibleRegion');
    final offices = await officeModel.getFilterOffices(visibleRegion);
    setState(() {
      _setMarkers(offices);
      _isGetOffices = true;
    });
  }

  void _setMarkers(List<officeModel.OfficeData> offices) async {
    clusterOffices.clear();
    _clusterManager.setItems(
      <RequestOffice>[
        for (final office in offices)
          for (var category in office.attributes.categories.data)
            RequestOffice(
              office.id,
              office.attributes.name,
              office.attributes.address.replaceAll(
                '대한민국 ',
                '',
              ),
              int.parse(office.attributes.price),
              office.attributes.lat,
              office.attributes.lng,
              LatLng(office.attributes.lat, office.attributes.lng),
              office.attributes.description,
              Users(
                  id: office.attributes.users.data.id,
                  name: office.attributes.users.data.attributes.username),
              Categories(
                id: category.id,
                name: category.attributes.name,
              ),
              office.attributes.updatedAt,
            ),
      ],
    );
  }

  void _updateMarkers(Set<Marker> markers) {
    print(
        '_updateMarkers: ${markers.length}개 클러스트 -> ${clusterOffices.length}개 아이템');
    // 화면에 보이는 마커의 수(클러스트 + 간뱔)
    setState(() {
      this.markers = markers;
    });
  }

  Future<Marker> Function(Cluster<RequestOffice>) _getMarkerBuilder(
          Color color) =>
      (cluster) async {
        for (var item in cluster.items) {
          if (clusterOffices.contains(item)) {
            // print('이미 있습니다:  ${item.id} ${item.address}');
          } else {
            clusterOffices.add(item);
            // print('item: ${item.id} ${item.address}');
          }
        }
        return Marker(
          markerId: MarkerId(cluster.getId()),
          position: cluster.location,
          onTap: () async {
            // cluster.items.forEach((p) => print(p.name));
            // 2개 이상: 지도 확대하기
            if (cluster.isMultiple) {
              // 한개: 상세 정보보기
              var currentZoomLevel = await mapController.getZoomLevel();
              mapController.animateCamera(
                CameraUpdate.newCameraPosition(
                  CameraPosition(
                    bearing: 0,
                    target: cluster.location,
                    tilt: 0,
                    zoom: currentZoomLevel + 2.00,
                  ),
                ),
              );
            } else {
              _sortClusterOffices(cluster.location);
              for (var office in cluster.items) {
                {
                  showModalBottomSheet(
                      context: context,
                      isScrollControlled: true, // 높이가 커짐
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(25.0),
                        ),
                      ),
                      builder: (context) => OfficesSelectedBottomSheet(
                            office: office,
                            clusterOffices: clusterOffices,
                          ));
                }
              }
            }
          },
          icon: await createCustomMarkerBitmap(
            cluster,
            userData.id, // 로그인 아이디 없을 시 0
          ),
        );
      };

  Widget _showProgesss() {
    // 내위치 또는 데이터 가져올때 로딩 스피너 표시
    if (!_isGetMyLocation || !_isGetOffices) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return const SizedBox(
        height: 0.1,
        width: 0.1,
      );
    }
  }

  _filterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        // snap: true,
        expand: false,
        initialChildSize: 0.7,
        maxChildSize: 0.89,
        minChildSize: 0.32,
        builder: (context, scrollController) => Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                controller: scrollController,
                child: StatefulBuilder(builder:
                    (BuildContext context, StateSetter setBottomState) {
                  return Column(
                    children: [
                      const Text('초기화'),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(
                            top: 24, bottom: 8, left: 8, right: 8),
                        child: Text(
                          '금액',
                          style: AppTheme.mapControlList,
                        ),
                      ),
                      Row(
                        children: [
                          Checkbox(
                            checkColor: Colors.white,
                            fillColor:
                                MaterialStateProperty.all(AppTheme.nearlyBlack),
                            value: _rememberMe,
                            onChanged: (value) {
                              setBottomState(() {
                                _rememberMe = value!;
                              });
                              // setState(() {
                              //   _rememberMe = value!;
                              // });
                            },
                          ),
                          Text('나눔', style: AppTheme.mapFilterList)
                        ],
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(
                            top: 24, bottom: 8, left: 8, right: 8),
                        child: Text(
                          '종류',
                          style: AppTheme.mapControlList,
                        ),
                      ),
                      for (int i = 0; i < _categories.length; i++)
                        Row(
                          children: [
                            Checkbox(
                              checkColor: Colors.white,
                              fillColor: MaterialStateProperty.all(
                                  AppTheme.kDarkGreenColor),
                              value: _categories[i].selectedFilter,
                              onChanged: (value) {
                                setBottomState(() {
                                  _categories[i].selectedFilter = value!;
                                });
                                // setState(() {
                                //   _rememberMe = value!;
                                // });
                              },
                            ),
                            // Text('매출원가', style: AppTheme.mapFilterList)
                            Text(_categories[i].attributes.name,
                                style: AppTheme.mapFilterList)
                          ],
                        ),
                      const Text('오규환사랑해요'),
                      const Text('오시환사랑해요'),
                      const Text('우리규환시환이 예쁜규환시환이이 엄마아빠가 사랑하는 우리규환시환이'),
                      const Text('오시환사랑해요'),
                      const Text('오시환사랑해요'),
                      const Text('오시환사랑해요'),
                      const Text('오시환사랑해요'),
                      const Text('오시환사랑해요'),
                      const Text('오시환사랑해요'),
                      const Text('오시환사랑해요'),
                      const Text('오시환사랑해요'),
                      const Text('오시환사랑해요'),
                      const Text('오시환사랑해요'),
                      const Text('오시환사랑해요'),
                      const Text('오시환사랑해요'),
                      const Text('오시환사랑해요'),
                      const Text('오시환사랑해요'),
                      const Text('오규환사랑해요'),
                      const Text('오규환사랑해요'),
                      const Text('오규환사랑해요'),
                      const Text('오규환사랑해요'),
                      const Text('오규환사랑해요'),
                      const Text('오규환사랑해요'),
                      const Text('오규환사랑해요'),
                      const Text('오규환사랑해요'),
                      const Text('오규환사랑해요'),
                      const Text('오규환사랑해요'),
                      const Text('data'),
                      const Text('data'),
                      const Text('data'),
                      const Text('data'),
                      const Text('data'),
                      const Text('data'),
                      const Text('data'),
                      const Text('data'),
                      const Text('data'),
                      const Text('data'),
                      const Text('data'),
                      const Text('data'),
                      const Text('data'),
                      const Text('data'),
                      const Text('data'),
                      const Text('data'),
                      const Text('data'),
                      const Text('data'),
                      const Text('data'),
                      const Text('data'),
                      const Text('data'),
                      const Text('data'),
                      const Text('data'),
                      const Text('data'),
                      const Text('data'),
                      const Text('data'),
                      const Text('data'),
                      const Text('data'),
                      const Text('data'),
                      const Text('data'),
                      const Text('data'),
                      const Text('data'),
                      const Text('data'),
                      const Text('data'),
                      const Text('data'),
                      const Text('data'),
                      const Text('data'),
                      const Text('data'),
                      const Text('data'),
                      const Text('data'),
                      const Text('data'),
                      ElevatedButton(
                        child: const Text('Done!'),
                        onPressed: () => Navigator.pop(context),
                      )
                    ],
                  );
                }),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(top: 8, bottom: 16, left: 8, right: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    height: AppBar().preferredSize.height * 0.8,
                    width: MediaQuery.of(context).size.width * 0.4,
                    decoration: BoxDecoration(
                        color: AppTheme.kGinColor,
                        borderRadius: BorderRadius.circular(10)),
                    child: TextButton(
                      onPressed: () {
                        // for (int i = 0; i < _categories.length; i++) {
                        //   setState(() {
                        //     _rememberMe = false;
                        //     _categories[i].selectedFilter = true;
                        //   });
                        // }
                      },
                      child: Text(
                        '초기화',
                        style: AppTheme.menu,
                      ),
                    ),
                  ),
                  Container(
                    height: AppBar().preferredSize.height * 0.8,
                    width: MediaQuery.of(context).size.width * 0.5,
                    decoration: BoxDecoration(
                        color: AppTheme.kDarkGreenColor,
                        borderRadius: BorderRadius.circular(10)),
                    child: TextButton(
                      onPressed: () {},
                      child: Text(
                        '저장',
                        style: AppTheme.inButton,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ).then((value) => {
          setState(() {
            print('_filterBottomSheet: 닫힘');
          })
        });
  }

  // 카테고리 리스트 가져오기
  _getCategories() async {
    // setState(() {
    // _isGetOffices = false;
    // });
    _categories.clear();
    _categories = await officeModel.getCategories();
    // setState(() {
    //   categories = categories;
    // });
  }

  _filter() {
    return Padding(
      padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + 6, left: 62),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: () async {
                // _getCategories();
                _filterBottomSheet(context);
              },
              child: Container(
                padding: const EdgeInsets.only(
                  left: 8,
                ),
                height: 44,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: AppTheme.white.withOpacity(0.9),
                ), //테두리
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        overflow: TextOverflow.ellipsis,
                        // '초기화, 나눔 매출원가, 매출액, 영업이익, 순이익, 순이익, 순이익, 순이익, 순이익',
                        '${context.watch<MyLocationProvider>().myLocation}',
                        style: AppTheme.mapFilterList,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.filter_alt_outlined,
                      color: AppTheme.nearlyBlack,
                    ),
                    const SizedBox(width: 13),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 8)
        ],
      ),
    );
  }

  Widget _mapControl() {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isLightMode = brightness == Brightness.light;
    isLightMode = true;

    return Stack(
      children: <Widget>[
        // 현재위치 및 새로고침 우측 상단
        Align(
          alignment: Alignment(
            Alignment.topRight.x,
            Alignment.topRight.y,
          ),
          child: Padding(
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 62, right: 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // const SizedBox(height: 15),
                SizedBox(
                  width: AppBar().preferredSize.height - 7,
                  height: AppBar().preferredSize.height - 7,
                  child: FloatingActionButton(
                    heroTag: "hero1",
                    // foregroundColor: Colors.blueGrey.shade600,
                    backgroundColor: isLightMode
                        ? AppTheme.white.withOpacity(0.9)
                        : AppTheme.darkGrey.withOpacity(0.9),
                    onPressed: _isGetMyLocation ? _moveToMyLocation : null,
                    child: const Icon(
                      Icons.my_location_sharp,
                      color: AppTheme.nearlyBlack,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                SizedBox(
                  width: AppBar().preferredSize.height - 7,
                  height: AppBar().preferredSize.height - 7,
                  child: FloatingActionButton(
                    heroTag: "refresh",
                    backgroundColor: isLightMode
                        ? AppTheme.white.withOpacity(0.9)
                        : AppTheme.darkGrey.withOpacity(0.9),
                    onPressed: _isGetOffices ? _moveToBaseLocation : null,
                    child: const Icon(
                      Icons.refresh,
                      color: AppTheme.nearlyBlack,
                    ),
                  ),
                ),
                // const SizedBox(height: 15),
                // SizedBox(
                //   width: AppBar().preferredSize.height - 7,
                //   height: AppBar().preferredSize.height - 7,
                //   child: FloatingActionButton(
                //     heroTag: "refresh2",
                //     backgroundColor: isLightMode
                //         ? AppTheme.white.withOpacity(0.9)
                //         : AppTheme.darkGrey.withOpacity(0.9),
                //     onPressed: _isGetOffices ? _getListVisibleRegion : null,
                //     child: const Icon(
                //       Icons.map_outlined,
                //       color: AppTheme.nearlyBlack,
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ),

        Align(
          alignment: Alignment(
            Alignment.topCenter.x,
            Alignment.topCenter.y,
          ),
          child: Padding(
            padding:
                EdgeInsets.only(top: MediaQuery.of(context).padding.top + 62),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 32,
                  child: FloatingActionButton.extended(
                    heroTag: "refresh3",
                    backgroundColor: isLightMode
                        // ? AppTheme.white.withOpacity(0.9)
                        ? AppTheme.white.withOpacity(0.9)
                        : AppTheme.darkGrey.withOpacity(0.9),
                    onPressed: _isGetOffices ? _getListVisibleRegion : null,
                    label: Text(
                      '지도 내 검색',
                      style: AppTheme.mapFilterList,
                    ),
                    icon: const Icon(Icons.refresh,
                        size: 18, color: AppTheme.nearlyBlack),
                  ),
                ),
              ],
            ),
          ),
        ),

        // 등록된 거래 하단
        Align(
          alignment: Alignment(
            Alignment.bottomCenter.x + 0.1,
            Alignment.bottomCenter.y - 0.1,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: AppBar().preferredSize.height - 7,
                height: AppBar().preferredSize.height - 7,
              ),
              FloatingActionButton.extended(
                heroTag: "hero3",
                backgroundColor: isLightMode
                    // ? AppTheme.white.withOpacity(0.9)
                    ? AppTheme.white.withOpacity(0.9)
                    : AppTheme.darkGrey.withOpacity(0.9),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OfficesSelectedListScreen(
                        clusterOffices: clusterOffices,
                      ),
                      fullscreenDialog: false,
                    ),
                  ).whenComplete(
                    () => {
                      print('whenComplete'),
                      // _getOfficesList(),
                    },
                  );
                },
                label: Text(
                  '등록된 거래 ${clusterOffices.length}건',
                  style: AppTheme.mapControlList,
                ),
                icon: const Icon(Icons.library_books_outlined,
                    size: 24, color: AppTheme.nearlyBlack),
              ),
              SizedBox(
                width: AppBar().preferredSize.height - 7,
                height: AppBar().preferredSize.height - 7,
                child: FloatingActionButton(
                  heroTag: "hero5",
                  // foregroundColor: Colors.blueGrey.shade600,
                  backgroundColor: isLightMode
                      ? AppTheme.kDarkGreenColor.withOpacity(0.9)
                      : AppTheme.darkGrey.withOpacity(0.9),
                  onPressed: () {
                    if (userData.id == 0) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Login(),
                          fullscreenDialog: true,
                        ),
                      ).then((value) => {
                            checkUserState(),
                          });
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OfficeAddScreen(
                            latLng: LatLng(_lat, _lng),
                          ),
                          fullscreenDialog: true,
                        ),
                      ).whenComplete(
                        () => {
                          _getOfficesList(),
                        },
                      );
                    }
                  },
                  child: const Icon(
                    // Icons.add,
                    Icons.edit,
                    size: 24,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _moveToMyLocation() async {
    setState(() {
      _isGetMyLocation = false;
    });
    await context.read<MyLocationProvider>().getMyLatLng();
    mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
            // bearing: 192.8334901395799,
            bearing: 0,
            target: context.read<MyLocationProvider>().myLocation,
            tilt: 0,
            zoom: 14.0),
      ),
    );

    setState(() {
      _isGetMyLocation = true;
      _circles.clear();
      final circle = Circle(
        circleId: const CircleId('내위치'),
        center: context.read<MyLocationProvider>().myLocation,
        fillColor: Colors.blue.withOpacity(0.5),
        radius: 100,
        strokeColor: Colors.blue,
        strokeWidth: 1,
      );
      _circles['내위치'] = circle;
    });
  }

// 전체 내역 가져오기
  Future<void> _moveToBaseLocation() async {
    _getOfficesList(); // 위치 리스트 가져오기
    mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          bearing: 0,
          target: LatLng(_lat, _lng),
          tilt: 0,
          zoom: 7.2,
        ),
      ),
    );
  }

//  지도 내 위치 리스트 가져오기
  Future<void> _getListVisibleRegion() async {
    _getOfficesListInMap(); // 지도 내 위치 리스트 가져오기
  }

  /*
  // 내 위치 가져오기
  void _getMyLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low);
    setState(() {
      _circles.clear();
      final circle = Circle(
        circleId: const CircleId('내위치'),
        center: LatLng(position.latitude, position.longitude),
        fillColor: Colors.blue.withOpacity(0.5),
        radius: 500,
        strokeColor: Colors.blue,
        strokeWidth: 1,
      );
      _circles['내위치'] = circle;
    });
  }
  */

  void _sortClusterOffices(LatLng location) {
    print('${location} 중심으로 clusterOffices ${clusterOffices.length}건 거리 순 정렬');

    clusterOffices.sort((a, b) {
      final distanceA = Geolocator.distanceBetween(
        a.location.latitude,
        a.location.longitude,
        location.latitude,
        location.longitude,
      );
      final distanceB = Geolocator.distanceBetween(
        b.location.latitude,
        b.location.longitude,
        location.latitude,
        location.longitude,
      );
      return distanceA.compareTo(distanceB);
    });
  }
}
