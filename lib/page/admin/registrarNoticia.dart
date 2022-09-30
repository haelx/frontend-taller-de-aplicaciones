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
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
class registrarNoticia extends StatefulWidget {
  const registrarNoticia({Key? key}) : super(key: key);

  @override
  registrarNoticiaState createState() {
    return registrarNoticiaState();
  }
}

class registrarNoticiaState extends State<registrarNoticia> {
  @override
  final _formKey = GlobalKey<FormState>();
  var textTitulo = TextEditingController();
  var textDescripcionCorta = TextEditingController();
  var textDescripcionLarga = TextEditingController();
  var textFoto = TextEditingController();
  var textCategoria = TextEditingController();
  var textFechaPublicacion = TextEditingController();

  formItemsDesign(icon, item) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1),
      child: Card(child: ListTile(leading: Icon(icon), title: item)),
    );
  }

  Widget build(BuildContext context) => Scaffold(
    //drawer: NavigationDrawerWidget(),
    appBar: AppBar(
      title: Text('Registro Noticias'),
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
                      controller: textTitulo,
                      decoration: InputDecoration(
                          suffixIcon: IconButton(
                            onPressed: () => borrarNombre(),
                            icon: Icon(Icons.clear),
                          ),
                          border: UnderlineInputBorder(),
                          labelText: "Ingrese el titulo"),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Porfavor introduzca algo";
                        }
                        return null;
                      })),
              formItemsDesign(
                  Icons.badge_outlined,
                  TextFormField(
                      minLines: 1,
                      maxLines: 5,
                      controller: textDescripcionCorta,
                      decoration: InputDecoration(
                          suffixIcon: IconButton(
                            onPressed: () => borrarDescripcionCorta(),
                            icon: Icon(Icons.clear),
                          ),
                          border: UnderlineInputBorder(),
                          labelText: "Ingrese la descripcion corta"),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Porfavor introduzca algo";
                        }
                        return null;
                      })),
              formItemsDesign(
                  Icons.badge_outlined,
                  TextFormField(
                      minLines: 1,
                      maxLines: 5,
                      controller: textDescripcionLarga,
                      decoration: InputDecoration(
                          suffixIcon: IconButton(
                            onPressed: () => borrarDescripcionLarga(),
                            icon: Icon(Icons.clear),
                          ),
                          border: UnderlineInputBorder(),
                          labelText: "Ingrese la descripcion larga"),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Porfavor introduzca algo";
                        }
                        return null;
                      })),
              formItemsDesign(
                  Icons.badge_outlined,
                  TextFormField(
                      minLines: 1,
                      maxLines: 5,
                      controller: textFoto,
                      decoration: InputDecoration(
                          suffixIcon: IconButton(
                            onPressed: () => borrarFoto(),
                            icon: Icon(Icons.clear),
                          ),
                          border: UnderlineInputBorder(),
                          labelText: "Ingrese la foto"),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Porfavor introduzca algo";
                        }
                        return null;
                      })),
              formItemsDesign(
                  Icons.badge_outlined,
                  TextFormField(
                      minLines: 1,
                      maxLines: 5,
                      controller: textCategoria,
                      decoration: InputDecoration(
                          suffixIcon: IconButton(
                            onPressed: () => borrarCategoria(),
                            icon: Icon(Icons.clear),
                          ),
                          border: UnderlineInputBorder(),
                          labelText: "Ingrese la categoria"),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Porfavor introduzca algo";
                        }
                        return null;
                      })),
              formItemsDesign(
                  Icons.badge_outlined,
                  TextFormField(
                      minLines: 1,
                      maxLines: 5,
                      controller: textFechaPublicacion,
                      decoration: InputDecoration(
                          suffixIcon: IconButton(
                            onPressed: () => borrarFecha(),
                            icon: Icon(Icons.clear),
                          ),
                          border: UnderlineInputBorder(),
                          labelText: "Ingrese la fecha"),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Porfavor introduzca algo";
                        }
                        return null;
                      })),
          // formItemsDesign(
          //   Icons.badge_outlined,
          //   TextButton(
          //       onPressed: () {
          //         DatePicker.showDatePicker(context,
          //             showTitleActions: true,
          //             minTime: DateTime(2018, 3, 5),
          //             maxTime: DateTime(2019, 6, 7), onChanged: (date) {
          //               print('change $date');
          //             }, onConfirm: (date) {
          //               print('confirm $date');
          //             }, currentTime: DateTime.now(), locale: LocaleType.es);
          //       },
          //       child: Text(
          //         'show date time picker (Chinese)',
          //         style: TextStyle(color: Colors.blue),
          //       )
          //   )
          // ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Validate returns true if the form is valid, or false otherwise.
                      if (_formKey.currentState!.validate()) {
                        // If the form is valid, display a snackbar. In the real world,
                        // you'd often call a server or save the information in a database.
                        registrarregistrarNoticia(context);
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

  Future<void> registrarregistrarNoticia(BuildContext context) async {
    Dio dio = new Dio();
    if (!kIsWeb) {
      (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
          (IO.HttpClient client) {
        client.badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
        return client;
      };
    }
    SharedPreferences prefs=await SharedPreferences.getInstance();
    var suUser =jsonDecode(prefs.getString('user').toString());
    var titulo = textTitulo.text;
    var descripcionCorta = textDescripcionCorta.text;
    var descripcionLarga=textDescripcionLarga.text;
    var foto=textFoto.text;
    var idCategoria=textCategoria.text;
    var fecha=textFechaPublicacion.text;
    var datos = {
      "titulo": titulo,
      "descripcionCorta":descripcionCorta,
      "descripcionLarga":descripcionLarga,
      "foto":foto,
      "idCategoria":idCategoria,
      "fechaPublicacion":fecha
    };
    print(datos);
    var urlLink = globals.apiUrl + "crearNoticia.php";
    var response = await dio.post(urlLink,
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8",
        }),
        data: datos);

    if (response.statusCode == 200) {
      var datos = jsonDecode(response.data);
      print(response.data);
      if (datos["error"] == 1) {
        print(response.data);
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
  }

  void borrarNombre() {
    textTitulo.clear();
  }
  void borrarDescripcionCorta() {
    textDescripcionCorta.clear();
  }
  void borrarDescripcionLarga() {
    textDescripcionLarga.clear();
  }
  void borrarFoto() {
    textFoto.clear();
  }
  void borrarCategoria() {
    textCategoria.clear();
  }
  void borrarFecha() {
    textFechaPublicacion.clear();
  }
  @override
  void initState() {
    super.initState();
  }
}
