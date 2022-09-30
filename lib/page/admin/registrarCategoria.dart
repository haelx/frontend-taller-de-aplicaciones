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
class registrarCategoria extends StatefulWidget {
  const registrarCategoria({Key? key}) : super(key: key);

  @override
  registrarCategoriaState createState() {
    return registrarCategoriaState();
  }
}

class registrarCategoriaState extends State<registrarCategoria> {
  @override
  final _formKey = GlobalKey<FormState>();
  var textNombreRol = TextEditingController();
  var textPrimerApellido = TextEditingController();
  var textSegundoApellido = TextEditingController();
  var textEmail = TextEditingController();
  var textSexo = TextEditingController();
  var textCi = TextEditingController();

  formItemsDesign(icon, item) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1),
      child: Card(child: ListTile(leading: Icon(icon), title: item)),
    );
  }

  Widget build(BuildContext context) => Scaffold(
    //drawer: NavigationDrawerWidget(),
    appBar: AppBar(
      title: Text('Registro Categorias Noticias'),
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
                      controller: textNombreRol,
                      decoration: InputDecoration(
                          suffixIcon: IconButton(
                            onPressed: () => borrarNombre(),
                            icon: Icon(Icons.clear),
                          ),
                          border: UnderlineInputBorder(),
                          labelText: "Ingrese el nombre de la categoria"),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Porfavor introduzca algo";
                        }
                        return null;
                      })),
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Validate returns true if the form is valid, or false otherwise.
                      if (_formKey.currentState!.validate()) {
                        // If the form is valid, display a snackbar. In the real world,
                        // you'd often call a server or save the information in a database.
                        registrarregistrarCategoria(context);
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

  Future<void> registrarregistrarCategoria(BuildContext context) async {
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
    var nombreRol = textNombreRol.text;
    var datos = {
      "nombreCategoria": nombreRol
    };
    var urlLink = globals.apiUrl + "crearCategoria.php";
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
    textNombreRol.clear();
  }
  @override
  void initState() {
    super.initState();
  }
}
