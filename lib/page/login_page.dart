import 'dart:convert';
import 'dart:io';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'dart:io' as IO;
import '../api/globals.dart' as globals;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main2.dart';
class LoginPage extends StatefulWidget {
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _loading = false;
  var _texto = "";
  bool _isObscure = true;
  final _formLogin = GlobalKey<FormState>();
  var _textUsuario = TextEditingController();
  var _textPassword = TextEditingController();
  var ed=Offset(0, -30);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return WillPopScope(
      onWillPop: () async{return false;},
      child: Scaffold(
          resizeToAvoidBottomInset: true,
          body: Stack(
        children: [
          Container(
            height: 320.h,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [Color.fromRGBO(140, 4, 28, 1.0), Colors.red],
              ),
            ),
            child:

            Container(
              padding: const EdgeInsets.all(80),
              // child: Image.asset(
              //   "assets/img/logo.png",
              // ),
            ),
          ),
          Center(
            child: SizedBox(
              width: 400.w,
              child: Transform.translate(
                offset: ed,
                child: Center(
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formLogin,
                      child: Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        margin: const EdgeInsets.only(
                            left: 20, right: 20, top: 190, bottom: 20),
                        child: Padding(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 35, vertical: 20),
                          child: Column(
                            children: [
                              TextFormField(
                                onTap: ajustar,
                                controller: _textUsuario,
                                decoration: InputDecoration(
                                  labelText: "Usuario",
                                ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Porfavor introduzca algo";
                                    }
                                    return null;
                                  }
                              ),
                              SizedBox(
                                  height:0.04.sw
                              ),
                              TextFormField(
                                onTap: ajustar,
                                obscureText: _isObscure,
                                controller: _textPassword,
                                decoration: InputDecoration(
                                  labelText: "Contraseña",
                                  suffixIcon: IconButton(
                                    icon: Icon(_isObscure ? Icons.visibility : Icons.visibility_off),
                                   onPressed: ()=>setState(() {
                                     _isObscure = !_isObscure;
                                   }),
                                  )
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Porfavor introduzca algo";
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(
                                  height:0.04.sw
                              ),
                              Theme(
                                  data: Theme.of(context)
                                      .copyWith(colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.black)),
                                  child:ElevatedButton.icon(
                                    onPressed: () {
                                      if (_formLogin.currentState!.validate()) {
                                        _login(context);
                                      }
                                    },
                                    icon: Icon(Icons.how_to_reg),
                                    label: Text(_loading?'Processing':'Iniciar Sesion'),
                                  ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      )),
    );
    throw UnimplementedError();
  }

  Future<void> _login(BuildContext context) async {
    Dio dio = new Dio();

    if(!kIsWeb){
      (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
          (IO.HttpClient client) {
        client.badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
        return client;
      };
    }
    setState(() {
      _loading=true;
    });
    var usuario=_textUsuario.text;
    var pass=_textPassword.text;
    var urlLink=globals.apiUrl+"login.php";
    Response response;
    response = await dio.post(urlLink, data: {'usuario': usuario, 'clave': pass});
    if(response.statusCode==200){
      Map<String, dynamic> resp = jsonDecode(response.data);
      if(resp['Error']==1){
        _loading=false;
        setState(() {});
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          duration: Duration(seconds: 2),
          backgroundColor: Colors.red,
          content: Text(resp['Mensaje']),
          behavior: SnackBarBehavior.fixed,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ));
      }
      else{
         SharedPreferences prefs=await SharedPreferences.getInstance();
         await prefs.setString("user", jsonEncode(resp));
        globals.user=resp;
        globals.isLoggedIn=true;
        redireccionar();
      }

    }else{
       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          duration: Duration(seconds: 2),
        backgroundColor: Colors.red,
        content: const Text('Error al iniciar sesion'),
        behavior: SnackBarBehavior.fixed,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ));
       setState(() {
         _loading=false;
       });
    }
  }
  ajustar(){
    ed=Offset(0.h, -0.25.sh);
    setState(() {});
  }

  @override
  void initState() {
    globals.canvas=null;
    globals.modulo=null;
    verificar();
    _loading=false;
    super.initState();
  }
  Future<void> verificar() async{
    SharedPreferences prefs=await SharedPreferences.getInstance();
    var user =jsonDecode(prefs.getString('user').toString());
    // if(user!=null){
    //   Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
    //       MyApp()), (Route<dynamic> route) => false);
    // }
  }
  Future<void> redireccionar() async {
    setState(() {
      _loading=false;
    });
    SharedPreferences prefs=await SharedPreferences.getInstance();
    var suUser =jsonDecode(prefs.getString('user').toString());
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
        MyApp()), (Route<dynamic> route) => false);
  }
  @override
  void dispose() {
    super.dispose();
  }
}
