import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:chat_api_app/components/app_theme.dart';
import 'package:chat_api_app/navigation_home_screen.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:chat_api_app/src/my_location_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  await dotenv.load(fileName: '.env');
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]).then((_) => runApp(MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => MyLocationProvider(),
          ),
        ],
        child: const MyApp(),
      )));
}

const seedColor = AppTheme.kDarkGreenColor;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness:
          !kIsWeb && Platform.isAndroid ? Brightness.dark : Brightness.light,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarDividerColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));

    return MaterialApp(
        title: 'Flutter ChatAPI',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.light,
          // textTheme: GoogleFonts.notoSansNKoTextTheme(
          //   Theme.of(context).textTheme,
          // ),
          textTheme: GoogleFonts.notoSansNKoTextTheme(
            Theme.of(context).textTheme,
          ),
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppTheme.kGinColor,
            secondary: Colors.lime,
          ),
          // colorSchemeSeed: seedColor,
          // colorScheme: ColorScheme.fromSeed(
          //     seedColor: seedColor, brightness: Brightness.dark),
        ),
        initialRoute: NavigationHomeScreen.routeName,
        routes: routes);
  }
}

final routes = {
  NavigationHomeScreen.routeName: (context) => const NavigationHomeScreen(),
  // OfficesGmapScreen.routeName: (context) => const OfficesGmapScreen(),
  // OfficesGmapScreen.routeName: (context) => OfficesGmapScreen(),
  // SecondScreen.routeName: (context) => SecondScreen(),
};

/*
// HexColor('#F8FAFB')
class HexColor extends Color {
  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));

  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF$hexColor';
    }
    return int.parse(hexColor, radix: 16);
  }
}
*/