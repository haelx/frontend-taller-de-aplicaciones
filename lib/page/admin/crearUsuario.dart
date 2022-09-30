import 'dart:convert';
import 'dart:io';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'dart:io' as IO;
import 'package:flutter/material.dart';
import '../../api/globals.dart' as globals;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'rolPojo.dart';
import 'personaPojo.dart';

class crearCuenta extends StatefulWidget {
  const crearCuenta({Key? key}) : super(key: key);

  @override
  crearCuentaState createState() {
    return crearCuentaState();
  }
}

class crearCuentaState extends State<crearCuenta> {
  @override
  final _formKey = GlobalKey<FormState>();
  var textUsuario = TextEditingController();
  var textPrimerApellido = TextEditingController();
  var textSegundoApellido = TextEditingController();
  var textEmail = TextEditingController();
  var textPassword1 = TextEditingController();
  var textPassword2 = TextEditingController();
  var textIdRol = null;
  var textIdPersona = null;

  formItemsDesign(icon, item) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1),
      child: Card(child: ListTile(leading: Icon(icon), title: item)),
    );
  }

  Widget build(BuildContext context) => Scaffold(
        //drawer: NavigationDrawerWidget(),
        appBar: AppBar(
          title: Text('Crear cuenta'),
          centerTitle: true,
          backgroundColor: Color.fromRGBO(146, 208, 80, 1.0),
        ),
        body: Container(
          padding: const EdgeInsets.all(5),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  formItemsDesign(
                      Icons.badge_outlined,
                      TextFormField(
                          minLines: 1,
                          maxLines: 5,
                          controller: textUsuario,
                          decoration: InputDecoration(
                              suffixIcon: IconButton(
                                onPressed: () => borrarUsuario(),
                                icon: Icon(Icons.clear),
                              ),
                              border: UnderlineInputBorder(),
                              labelText: "Nombre de usuario"),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Porfavor introduzca algo";
                            }
                            return null;
                          })),
                  formItemsDesign(
                      Icons.description_outlined,
                      TextFormField(
                          minLines: 1,
                          maxLines: 5,
                          controller: textPassword1,
                          decoration: InputDecoration(
                              suffixIcon: IconButton(
                                onPressed: () => borrarPassword1(),
                                icon: Icon(Icons.clear),
                              ),
                              border: UnderlineInputBorder(),
                              labelText: "Password"),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Porfavor introduzca algo";
                            }
                            return null;
                          })),
                  formItemsDesign(
                      Icons.description_outlined,
                      TextFormField(
                          minLines: 1,
                          maxLines: 5,
                          controller: textPassword2,
                          decoration: InputDecoration(
                              suffixIcon: IconButton(
                                onPressed: () => borrarPassword2(),
                                icon: Icon(Icons.clear),
                              ),
                              border: UnderlineInputBorder(),
                              labelText: "Repita el password"),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Porfavor introduzca algo";
                            }
                            return null;
                          })),
                  formItemsDesign(
                    Icons.description_outlined,
                    DropdownSearch<UserModel>(
                      asyncItems: (String filter) async {
                        var response = await Dio().get(
                          globals.apiUrl + "listarRol.php",
                          queryParameters: {"filter": filter},
                        );
                        var models =
                            UserModel.fromJsonList(jsonDecode(response.data));
                        return models;
                      },
                      popupProps: PopupProps.bottomSheet(),
                      dropdownDecoratorProps: DropDownDecoratorProps(
                        dropdownSearchDecoration: InputDecoration(
                          labelText: "Seleccione un rol",
                        ),
                      ),
                      onChanged: (UserModel? data) =>
                          {textIdRol = data?.buscarId()},
                    ),
                  ),
                  formItemsDesign(
                    Icons.description_outlined,
                    DropdownSearch<personaPojo>(
                      asyncItems: (String filter) async {
                        var response = await Dio().get(
                          globals.apiUrl + "listarPersonas.php",
                          queryParameters: {"filter": filter},
                        );
                        var models =
                            personaPojo.fromJsonList(jsonDecode(response.data));
                        return models;
                      },
                      popupProps: PopupProps.bottomSheet(),
                      dropdownDecoratorProps: DropDownDecoratorProps(
                        dropdownSearchDecoration: InputDecoration(
                          labelText: "Seleccione una persona",
                        ),
                      ),
                      onChanged: (personaPojo? data) =>
                          {textIdPersona = data?.buscarid()},
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: ElevatedButton.icon(
                        onPressed: () {
                          // Validate returns true if the form is valid, or false otherwise.
                          if (_formKey.currentState!.validate()) {
                            // If the form is valid, display a snackbar. In the real world,
                            // you'd often call a server or save the information in a database.
                            registrarcrearCuenta(context);
                          }
                        },
                        icon: Icon(Icons.save_outlined),
                        label: const Text('Guardar'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

  Future<void> registrarcrearCuenta(BuildContext context) async {
    Dio dio = new Dio();
    if (!kIsWeb) {
      (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
          (IO.HttpClient client) {
        client.badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
        return client;
      };
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var suUser = jsonDecode(prefs.getString('user').toString());
    var usuario = textUsuario.text;
    var password1 = textPassword1.text;
    var password2 = textPassword2.text;
    var idRol = textIdRol;
    var idPersona = textIdPersona;
    if (idRol!=null && idPersona!=null) {
      if (password1 == password2) {
        var datos = {
          'usuario': usuario,
          'clave': password1,
          'idPersona': idPersona,
          'idRol': idRol
        };
        print(datos);
        var urlLink = globals.apiUrl + "crearUsuario.php";
        var response = await dio.post(urlLink,
            options: Options(headers: {
              HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8",
            }),
            data: datos);

        if (response.statusCode == 200) {
          var datos = jsonDecode(response.data);
          print(response.data);
          if (datos["error"] == 1) {
            String mensaje = datos['mensaje'];
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: Colors.red,
              content: Text(mensaje),
              behavior: SnackBarBehavior.fixed,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ));
          } else {
            String mensaje = datos['mensaje'];
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: Colors.green,
              content: Text(mensaje),
              behavior: SnackBarBehavior.fixed,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ));
            setState(() {});
            Navigator.pop(context);
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.red,
            content: Text("Error en el servidor"),
            behavior: SnackBarBehavior.fixed,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ));
        }

      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          content: Text("Las constraseñas no coinciden"),
          behavior: SnackBarBehavior.fixed,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.red,
        content: Text("Seleccione el rol y la persona"),
        behavior: SnackBarBehavior.fixed,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ));
    }

  }

  void borrarUsuario() {
    textUsuario.clear();
  }

  void borrarPrimerApellido() {
    textPrimerApellido.clear();
  }

  void borrarSegundoApellido() {
    textSegundoApellido.clear();
  }

  void borrarEmail() {
    textEmail.clear();
  }

  void borrarPassword1() {
    textPassword1.clear();
  }

  void borrarPassword2() {
    textPassword2.clear();
  }

  @override
  void initState() {
    super.initState();
  }
}
