import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:chat_api_app/components/app_theme.dart';
import 'package:chat_api_app/navigation_home_screen.dart';
import 'package:chat_api_app/screen/login_screen.dart';
import 'package:chat_api_app/src/user.dart';

class HomeDrawer extends StatefulWidget {
  const HomeDrawer(
      {Key? key,
      this.screenIndex,
      this.iconAnimationController,
      this.callBackIndex})
      : super(key: key);

  final AnimationController? iconAnimationController;
  final DrawerIndex? screenIndex;
  final Function(DrawerIndex)? callBackIndex;

  @override
  _HomeDrawerState createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {
  List<DrawerList>? drawerList;
  final storage = const FlutterSecureStorage();
  dynamic userInfo = '';
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

  void setDrawerListArray() {
    drawerList = <DrawerList>[
      DrawerList(
        index: DrawerIndex.ApiWithChatGPT,
        labelName: 'Api&챗GPT',
        // isAssetsImage: true,
        // imageName: 'assets/images/supportIcon.png',
      ),

      DrawerList(
        index: DrawerIndex.ChatGPTStram,
        labelName: '챗GPT스트림',
        // isAssetsImage: true,
        // imageName: 'assets/images/supportIcon.png',
      ),
      DrawerList(
        index: DrawerIndex.GMAP,
        labelName: '구글지도',
        // icon: const Icon(Icons.map_outlined),
      ),
      DrawerList(
        index: DrawerIndex.Office,
        labelName: '리스트로 보기',
        // icon: const Icon(Icons.home),
      ),
      DrawerList(
        index: DrawerIndex.DMAP,
        labelName: 'Daum map',
        // icon: const Icon(Icons.map),
      ),
      DrawerList(
        index: DrawerIndex.Help,
        labelName: 'Help',
        // isAssetsImage: true,
        // imageName: 'assets/images/supportIcon.png',
      ),
      // DrawerList(
      //   index: DrawerIndex.FeedBack,
      //   labelName: 'FeedBack',
      //   icon: Icon(Icons.help),
      // ),
      // DrawerList(
      //   index: DrawerIndex.Invite,
      //   labelName: 'Invite Friend',
      //   icon: Icon(Icons.group),
      // ),
      // DrawerList(
      //   index: DrawerIndex.Share,
      //   labelName: 'Rate the app',
      //   icon: Icon(Icons.share),
      // ),
      // DrawerList(
      //   index: DrawerIndex.About,
      //   labelName: 'About Us',
      //   icon: Icon(Icons.info),
      // ),
    ];
  }

// user의 정보가 있다면 로그인 후 들어가는 첫 페이지로 넘어가게 합니다.
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
  void initState() {
    setDrawerListArray();
    super.initState();
    // 비동기로 flutter secure storage 정보를 불러오는 작업
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkUserState();
    });
  }

  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isLightMode = brightness == Brightness.light;
    isLightMode = true;
    const storage = FlutterSecureStorage();
    return Scaffold(
      // backgroundColor: AppTheme.notWhite.withOpacity(0.5),
      // backgroundColor: AppTheme.kGinColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          // 상단 로그인
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 40.0),
            child: Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  if (userData.id == 0)
                    Container(
                      margin: const EdgeInsets.only(
                        left: 50,
                        right: 50,
                        top: 30,
                        bottom: 10,
                      ),
                      // margin: EdgeInsets.all(20), // 모든 외부 면에 여백
                      // padding: EdgeInsets.all(10), // 모든 외부 면에 여백
                      height: 50,
                      width: 290,
                      decoration: BoxDecoration(
                          color: AppTheme.kDarkGreenColor,
                          borderRadius: BorderRadius.circular(30)),
                      child: TextButton(
                        child: Text(
                          '로그인',
                          style: AppTheme.inButton,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Login(),
                              fullscreenDialog: true,
                            ),
                          ).then((value) => {
                                checkUserState(),
                              });
                        },
                      ),
                    ),
                  if (userData.id != 0)
                    AnimatedBuilder(
                      animation: widget.iconAnimationController!,
                      builder: (BuildContext context, Widget? child) {
                        return ScaleTransition(
                          scale: AlwaysStoppedAnimation<double>(1.0 -
                              (widget.iconAnimationController!.value) * 0.2),
                          child: RotationTransition(
                            turns: AlwaysStoppedAnimation<double>(Tween<double>(
                                        begin: 0.0, end: 24.0)
                                    .animate(CurvedAnimation(
                                        parent: widget.iconAnimationController!,
                                        curve: Curves.fastOutSlowIn))
                                    .value /
                                360),
                            child: Container(
                              height: 120,
                              width: 120,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                      color: AppTheme.grey.withOpacity(0.6),
                                      offset: const Offset(2.0, 4.0),
                                      blurRadius: 8),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(60.0)),
                                child: Image.asset(
                                    'assets/images/userImage_04.png'),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  if (userData.id != 0)
                    Padding(
                      padding: const EdgeInsets.only(top: 8, left: 4),
                      child: Text(
                        userData.username,
                        // '오규환',
                        style: TextStyle(
                          fontFamily: AppTheme.fontName,
                          fontWeight: FontWeight.w600,
                          color:
                              isLightMode ? AppTheme.darkText : AppTheme.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          Divider(
            height: 1,
            color: AppTheme.grey.withOpacity(0.6),
          ),
          Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(
                left: 0,
                right: 0,
                top: 20,
                bottom: 0,
              ),
              itemCount: drawerList?.length,
              itemBuilder: (BuildContext context, int index) {
                return inkwell(drawerList![index]);
              },
            ),
          ),
          Divider(
            height: 1,
            color: AppTheme.grey.withOpacity(0.6),
          ),
          // 하단 로그 아웃
          if (userData.id != 0)
            Column(
              children: <Widget>[
                ListTile(
                  title: Text(
                    'Sign Out',
                    style: AppTheme.signForm,
                    // style: TextStyle(
                    //   fontFamily: AppTheme.fontName,
                    //   fontWeight: FontWeight.w600,
                    //   fontSize: 16,
                    //   color: AppTheme.darkText,
                    // ),
                    textAlign: TextAlign.left,
                  ),
                  trailing: const Icon(
                    Icons.power_settings_new,
                    color: Colors.red,
                  ),
                  onTap: () {
                    storage.delete(key: "userInfo");
                    // setState(() {
                    //   userData = User(
                    //       id: 0,
                    //       username: "",
                    //       email: "",
                    //       provider: "",
                    //       confirmed: false,
                    //       blocked: false,
                    //       createdAt: DateTime.now(),
                    //       updatedAt: DateTime.now());
                    // });
                    // Navigator.pushReplacement(
                    //   // Navigator.pushAndRemoveUntil(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => const NavigationHomeScreen(),
                    //   ),
                    // );

                    // 모든페이지 제거 후 특정페이지로 이동
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NavigationHomeScreen(),
                        ),
                        (route) => false);
                  },
                ),
                SizedBox(
                  height: MediaQuery.of(context).padding.bottom,
                )
              ],
            ),
        ],
      ),
    );
  }

  Widget inkwell(DrawerList listData) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        splashColor: Colors.grey.withOpacity(0.1),
        highlightColor: Colors.transparent,
        onTap: () {
          navigationtoScreen(listData.index!);
        },
        child: Stack(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
              child: Row(
                children: <Widget>[
                  Container(
                    width: 6.0,
                    height: 46.0,
                    decoration: BoxDecoration(
                      color: widget.screenIndex == listData.index
                          // ? Colors.blue
                          ? AppTheme.kDarkGreenColor
                          : Colors.transparent,
                      // borderRadius: new BorderRadius.only(
                      //   topLeft: Radius.circular(0),
                      //   topRight: Radius.circular(16),
                      //   bottomLeft: Radius.circular(0),
                      //   bottomRight: Radius.circular(16),
                      // ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                  ),
                  listData.isAssetsImage
                      ? Container(
                          width: 24,
                          height: 24,
                          child: Image.asset(listData.imageName,
                              color: widget.screenIndex == listData.index
                                  ? Colors.black
                                  : AppTheme.nearlyBlack),
                        )
                      : (listData.icon == null)
                          ? Text('')
                          : Icon(listData.icon?.icon,
                              color: widget.screenIndex == listData.index
                                  // ? Colors.blue
                                  ? Colors.black
                                  : AppTheme.nearlyBlack),
                  const Padding(
                    padding: EdgeInsets.all(4.0),
                  ),
                  // 메뉴 폰트
                  Text(
                    listData.labelName,
                    style: AppTheme.menu,
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            ),
            widget.screenIndex == listData.index
                ? AnimatedBuilder(
                    animation: widget.iconAnimationController!,
                    builder: (BuildContext context, Widget? child) {
                      return Transform(
                        transform: Matrix4.translationValues(
                            (MediaQuery.of(context).size.width * 0.6 - 64) *
                                (1.0 -
                                    widget.iconAnimationController!.value -
                                    1.0),
                            0.0,
                            0.0),
                        child: Padding(
                          padding: EdgeInsets.only(top: 4, bottom: 4),
                          child: Container(
                            width:
                                MediaQuery.of(context).size.width * 0.75 - 64,
                            height: 46,
                            decoration: BoxDecoration(
                              // color: Colors.blue.withOpacity(0.2),
                              color: AppTheme.kDarkGreenColor.withOpacity(0.1),
                              borderRadius: const BorderRadius.only(
                                //new
                                topLeft: Radius.circular(0),
                                topRight: Radius.circular(28),
                                bottomLeft: Radius.circular(0),
                                bottomRight: Radius.circular(28),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  )
                : const SizedBox()
          ],
        ),
      ),
    );
  }

  Future<void> navigationtoScreen(DrawerIndex indexScreen) async {
    widget.callBackIndex!(indexScreen);
  }
}

enum DrawerIndex {
  ApiWithChatGPT,
  ChatGPTStram,
  GMAP,
  Office,
  DMAP,
  Help,
}

class DrawerList {
  DrawerList({
    this.isAssetsImage = false,
    this.labelName = '',
    this.icon,
    this.index,
    this.imageName = '',
  });

  String labelName;
  Icon? icon;
  bool isAssetsImage;
  String imageName;
  DrawerIndex? index;
}
