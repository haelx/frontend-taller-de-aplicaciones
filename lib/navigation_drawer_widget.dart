import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:io' as IO;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pro/page/admin/crearUsuario.dart';
import 'package:pro/page/admin/registrarCategoria.dart';
import 'package:pro/page/admin/registrarNoticia.dart';
import 'package:pro/page/admin/registrarPersona.dart';
import 'package:pro/page/admin/registrarRol.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'page/login_page.dart';

class NavigationDrawerWidget extends StatefulWidget {
  @override
  State<NavigationDrawerWidget> createState() => _NavigationDrawerWidgetState();
}

class _NavigationDrawerWidgetState extends State<NavigationDrawerWidget> {
  @override
  var _menu = null;
  var _nombre = "";
  var _primerApellido = "";
  var _segundoApellido = "";
  var supUser = null;

  Future<void> mostrarShared() async {
    // Obtain shared preferences.
    final prefs = await SharedPreferences.getInstance();
    var user = jsonDecode(prefs.getString('user').toString());
    _nombre = user['nombre'];
    _primerApellido = user['primerApellido'];
    _segundoApellido = user['segundoApellido'];
    supUser = user;
    if(user['nombreRol']=="administrador"){
      _menu = Column(
        children: [
          const SizedBox(height: 20),
          buildMenuItem(
              text: 'Registrar persona',
              icon: Icons.dashboard_customize_outlined,
              onClicked: () => {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => registrarPersona(),
                ))
              }
          ),
          buildMenuItem(
              text: 'Crear Cuenta',
              icon: Icons.dashboard_customize_outlined,
              onClicked: () => {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => crearCuenta(),
                ))
              }
          ),
          buildMenuItem(
              text: 'Registrar rol',
              icon: Icons.dashboard_customize_outlined,
              onClicked: () => {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => registrarRol(),
                ))
              }
          ),
          buildMenuItem(
              text: 'Registrar categoria',
              icon: Icons.dashboard_customize_outlined,
              onClicked: () => {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => registrarCategoria(),
                ))
              }
          ),
          buildMenuItem(
              text: 'Registrar Noticia',
              icon: Icons.dashboard_customize_outlined,
              onClicked: () => {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => registrarNoticia(),
                ))
              }
          ),
          buildMenuItem(
              text: 'Cerrar sesion',
              icon: Icons.dashboard_customize_outlined,
              onClicked: () => {
                cerrarSesion(),
                Navigator.of(context).pop(),
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => LoginPage(),
                ))
              }
          ),
        ],
      );
    }

    setState(() {});
  }

  void initState() {
    // TODO: implement initState
    mostrarShared();
    super.initState();
  }

  final padding = EdgeInsets.symmetric(horizontal: 20);

  @override
  Widget build(BuildContext context) {
    final photo = Container(
      margin: const EdgeInsets.only(top: 20.0, left: 20.0),
      width: 50.0.w,
      height: 50.0.h,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
              fit: BoxFit.contain,
              image: AssetImage('assets/img/avatar0.jpg'))),
    );
    return Drawer(
      child: Material(
        color: Color.fromRGBO(0, 51, 204, 1.0),
        child: ListView(
          children: <Widget>[
            photo,
            const SizedBox(height: 20),
            Center(
                child: Text(
              _nombre,
              style: const TextStyle(color: Colors.white),
            )),
            Center(
                child: Text(
              _primerApellido + " " + _segundoApellido,
              style: const TextStyle(color: Colors.white),
            )),
            Container(padding: padding, child: _menu),
          ],
        ),
      ),
    );
  }

  Widget buildHeader({
    required String urlImage,
    required String name,
    required String email,
    required VoidCallback onClicked,
  }) =>
      InkWell(
        onTap: onClicked,
        child: Container(
          padding: padding.add(EdgeInsets.symmetric(vertical: 40)),
          child: Row(
            children: [
              CircleAvatar(radius: 30, backgroundImage: NetworkImage(urlImage)),
              SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    email,
                    style: TextStyle(fontSize: 14, color: Colors.white),
                  ),
                ],
              ),
              Spacer(),
              CircleAvatar(
                radius: 24,
                backgroundColor: Color.fromRGBO(0, 51, 204, 1.0),
                child: Icon(Icons.add_comment_outlined, color: Colors.white),
              )
            ],
          ),
        ),
      );

  Widget buildSearchField() {
    const color = Colors.white;

    return TextField(
      style: TextStyle(color: color),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        hintText: 'Search',
        hintStyle: TextStyle(color: color),
        prefixIcon: Icon(Icons.search, color: color),
        filled: true,
        fillColor: Colors.white12,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(color: color.withOpacity(0.7)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(color: color.withOpacity(0.7)),
        ),
      ),
    );
  }

  Widget buildMenuItem({
    required String text,
    required IconData icon,
    VoidCallback? onClicked,
  }) {
    const color = Colors.white;
    const hoverColor = Colors.white70;

    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(text, style: TextStyle(color: color)),
      hoverColor: hoverColor,
      onTap: onClicked,
    );
  }

  Future<void> cerrarSesion() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('user');
    await prefs.remove('modulo');
    await prefs.remove('canvas');
    setState(() {});
  }
}
