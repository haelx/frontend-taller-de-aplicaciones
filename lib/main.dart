import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'page/login_page.dart';
Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([

  ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      WillPopScope(
        onWillPop: () async{return false;},
        child: ScreenUtilInit(
          designSize: Size(360, 690),
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (context , child) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              // Use this line to prevent extra rebuilds
              useInheritedMediaQuery: true,
              // You can use the library anywhere in the app even in theme
              theme: ThemeData(
                primarySwatch: Palette.kToDark,
                textTheme: TextTheme(bodyText2: TextStyle(fontSize: 16.sp)),
              ),
              home: LoginPage(),
            );
          }
        ),
      );
}
class Palette {
  static const MaterialColor kToDark = const MaterialColor(
    0xff92d050, // 0% comes in here, this will be color picked if no shade is selected when defining a Color property which doesn’t require a swatch.
    const <int, Color>{
      50: const Color(0x1a1166bf),//10%
      100: const Color(0x331166bf),//20%
      200: const Color(0x4d1166bf),//30%
      300: const Color(0x661166bf),//40%
      400: const Color(0x801166bf),//50%
      500: const Color(0x991166bf),//60%
      600: const Color(0xb31166bf),//70%
      700: const Color(0xcc1166bf),//80%
      800: const Color(0xe61166bf),//90%
      900: const Color(0xff1166bf),//100%
    },
  );
} // you