import 'package:flutter/material.dart';
import 'package:chat_api_app/custom_drawer/drawer_user_controller.dart';
import 'package:chat_api_app/custom_drawer/home_drawer.dart';
import 'package:chat_api_app/screen/api_with_chatgpt_screen.dart';
import 'package:chat_api_app/screen/chatgpt_stream_screen.dart';
import 'package:chat_api_app/screen/dmap_full_screen.dart';
import 'package:chat_api_app/screen/help_screen.dart';
import 'package:chat_api_app/screen/offices_gmap_screen.dart';
import 'package:chat_api_app/screen/offices_list_screen.dart';

class NavigationHomeScreen extends StatefulWidget {
  static String routeName = "navigation_home_screen";

  const NavigationHomeScreen({super.key});
  @override
  State<NavigationHomeScreen> createState() => _NavigationHomeScreenState();
}

class _NavigationHomeScreenState extends State<NavigationHomeScreen> {
  Widget? screenView;
  DrawerIndex? drawerIndex;

  @override
  void initState() {
    // drawerIndex = DrawerIndex.GMAP;
    // screenView = const OfficesGmapScreen(); // 구글지도 보기
    drawerIndex = DrawerIndex.ApiWithChatGPT;
    screenView = const ApiWithChatGPTScreen(); // 구글지도 보기
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: AppTheme.white,
      // color: AppTheme.kDarkGreenColor,
      child: SafeArea(
        top: false,
        bottom: false,
        left: false,
        right: false,
        child: Scaffold(
          // backgroundColor: AppTheme.nearlyWhite,
          // backgroundColor: AppTheme.kGinColor,
          body: DrawerUserController(
            screenIndex: drawerIndex,
            drawerWidth: MediaQuery.of(context).size.width * 0.6,
            // drawerWidth: (MediaQuery.of(context).size.width >= 600)
            //     ? MediaQuery.of(context).size.width * 0.35
            //     : MediaQuery.of(context).size.width * 0.75,
            onDrawerCall: (DrawerIndex drawerIndexdata) {
              changeIndex(drawerIndexdata);
            },
            screenView: screenView,
          ),
        ),
      ),
    );
  }

  void changeIndex(DrawerIndex drawerIndexdata) {
    if (drawerIndex != drawerIndexdata) {
      drawerIndex = drawerIndexdata;
      switch (drawerIndex) {
        case DrawerIndex.ApiWithChatGPT:
          setState(() {
            screenView = const ApiWithChatGPTScreen();
          });
          break;
        case DrawerIndex.ChatGPTStram:
          setState(() {
            screenView = const ChatGPTStreamScreen();
          });
          break;
        case DrawerIndex.GMAP:
          setState(() {
            screenView = const OfficesGmapScreen();
          });
          break;
        case DrawerIndex.Office:
          setState(() {
            screenView = const OfficesListScreen();
          });
          break;
        case DrawerIndex.DMAP:
          setState(() {
            screenView = DmapFullScreen();
          });
          break;
        case DrawerIndex.Help:
          setState(() {
            screenView = HelpScreen();
          });
          break;
        // case DrawerIndex.Invite:
        //   setState(() {
        //     screenView = LoginScreen();
        //   });
        //   break;
        default:
          break;
      }
    }
  }
}
