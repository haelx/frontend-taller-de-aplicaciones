import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'navigation_drawer_widget.dart' ;
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'dart:io' as IO;
import 'package:shared_preferences/shared_preferences.dart';
import '../../api/globals.dart' as globals;
var noticias=null;
Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(MyApp());
}
Future<void> mostrarShared() async{
  // Obtain shared preferences.
  final prefs = await SharedPreferences.getInstance();
  var user =jsonDecode(prefs.getString('user').toString());
}
class MyApp extends StatelessWidget {
  static const String title = 'Noticias';

  @override
  Widget build(BuildContext context) => ScreenUtilInit(
      designSize: Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          // Use this line to prevent extra rebuilds
          useInheritedMediaQuery: true,
          title: title,
          // You can use the library anywhere in the app even in theme
          theme: ThemeData(
            primarySwatch: Palette.kToDark,
            textTheme: TextTheme(bodyText2: TextStyle(fontSize: 16.sp)),
          ),
          home: MainPage(),
        );
      });
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  static const _textInstrucciones = "";

  @override
  Widget build(BuildContext context) => WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Scaffold(
            drawer: NavigationDrawerWidget(),
            // endDrawer: NavigationDrawerWidget(),
            appBar: AppBar(
              title: Text(MyApp.title),

              actions: [
                Container(
                  width: 0.15.sw,
                  height: 0.15.sw,
                  padding:  EdgeInsets.all(3),
                  child: MaterialButton(
                    onPressed: () => {
                      MostrarNoticias(context)
                    },
                    child: Icon(Icons.refresh),
                  ),
                ),
              ],
            ),
            body: Container(
              width: 300.sw,
              padding: EdgeInsets.all(18.0),
              child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: [
                      for (var i = 0; i < noticias.length; i++)
                        buildCard(i)
                    ],
                  )),
            ))
      );

  Future<void> MostrarNoticias(BuildContext context) async {
    Dio dio = new Dio();
    if (!kIsWeb) {
      (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
          (IO.HttpClient client) {
        client.badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
        return client;
      };
    }
    var urlLink = globals.apiUrl + "listarNoticias.php";
    var response = await dio.get(urlLink);

    if (response.statusCode == 200) {
       noticias= jsonDecode(response.data);
       setState(() {
       });
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();


  }

  @override
  void initState() {
    MostrarNoticias(context);
    super.initState();
  }
}

class Palette {
  static const MaterialColor kToDark = const MaterialColor(
    0xff92d050,
    // 0% comes in here, this will be color picked if no shade is selected when defining a Color property which doesn’t require a swatch.
    const <int, Color>{
      50: const Color(0x1a92d050), //10%
      100: const Color(0x3392d050), //20%
      200: const Color(0x4d92d050), //30%
      300: const Color(0x6692d050), //40%
      400: const Color(0x8092d050), //50%
      500: const Color(0x9992d050), //60%
      600: const Color(0xb392d050), //70%
      700: const Color(0xcc92d050), //80%
      800: const Color(0xe692d050), //90%
      900: const Color(0xff92d050), //100%
    },
  );
} //
 buildCard(i) {
  print(i);
  var noticia=noticias[i];
    var heading = noticia['titulo'];
    var subheading = noticia['descripcionCorta'];
    var cardImage = NetworkImage(
        'https://source.unsplash.com/random/800x600?house');
    return Card(
        elevation: 4.0,
        child: Column(
          children: [
            ListTile(
              title: Text(heading),
              subtitle: Text(subheading),
              trailing: Icon(Icons.favorite_outline),
            ),
            Container(
              height: 200.0,
              child: Ink.image(
                image: cardImage,
                fit: BoxFit.cover,
              ),
            ),
            ButtonBar(
              children: [
                TextButton(
                  child: const Text('VER NOTICIA'),
                  onPressed: () {
                    /* ... */
                  },
                )
              ],
            )
          ],
        ));
}
