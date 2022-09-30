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
class registrarPersona extends StatefulWidget {
  const registrarPersona({Key? key}) : super(key: key);

  @override
  registrarPersonaState createState() {
    return registrarPersonaState();
  }
}

class registrarPersonaState extends State<registrarPersona> {
  @override
  final _formKey = GlobalKey<FormState>();
  var textNombres = TextEditingController();
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
      title: Text('Registro persona'),
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
                      controller: textNombres,
                      decoration: InputDecoration(
                          suffixIcon: IconButton(
                            onPressed: () => borrarNombre(),
                            icon: Icon(Icons.clear),
                          ),
                          border: UnderlineInputBorder(),
                          labelText: "Nombres"),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Porfavor introduzca algo";
                        }
                        return null;
                      })),
              formItemsDesign(
                  Icons.location_on_outlined,
                  TextFormField(
                      minLines: 1,
                      maxLines: 5,
                      controller: textPrimerApellido,
                      decoration: InputDecoration(
                          suffixIcon: IconButton(
                            onPressed: () => borrarPrimerApellido(),
                            icon: Icon(Icons.clear),
                          ),
                          border: UnderlineInputBorder(),
                          labelText: "Primer apellido"),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Porfavor introduzca algo";
                        }
                        return null;
                      })),
              formItemsDesign(
                  Icons.engineering_outlined,
                  TextFormField(
                      minLines: 1,
                      maxLines: 5,
                      controller: textSegundoApellido,
                      decoration: InputDecoration(
                          suffixIcon: IconButton(
                            onPressed: () => borrarSegundoApellido(),
                            icon: Icon(Icons.clear),
                          ),
                          border: UnderlineInputBorder(),
                          labelText: "Segundo apellido"),
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
                      controller: textEmail,
                      decoration: InputDecoration(
                          suffixIcon: IconButton(
                            onPressed: () => borrarEmail(),
                            icon: Icon(Icons.clear),
                          ),
                          border: UnderlineInputBorder(),
                          labelText: "Correo electronico"),
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
                      controller: textSexo,
                      decoration: InputDecoration(
                          suffixIcon: IconButton(
                            onPressed: () => borrarSexo(),
                            icon: Icon(Icons.clear),
                          ),
                          border: UnderlineInputBorder(),
                          labelText: "Sexo"),
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
                      controller: textCi,
                      decoration: InputDecoration(
                          suffixIcon: IconButton(
                            onPressed: () => borrarCi(),
                            icon: Icon(Icons.clear),
                          ),
                          border: UnderlineInputBorder(),
                          labelText: "Numero de carnet"),
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
                        registrarregistrarPersona(context);
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

  Future<void> registrarregistrarPersona(BuildContext context) async {
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
    var nombres = textNombres.text;
    var primerApellido = textPrimerApellido.text;
    var segundoApellido = textSegundoApellido.text;
    var email = textEmail.text;
    var sexo = textSexo.text;
    var ci = textCi.text;
    var datos = {
      "nombre": nombres,
      "primerApellido": primerApellido,
      "segundoApellido": segundoApellido,
      "email": email,
      "sexo": sexo,
      "ci": ci,
    };
    var urlLink = globals.apiUrl + "crearPersona.php";
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
    textNombres.clear();
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
  void borrarSexo() {
    textSexo.clear();
  }
  void borrarCi() {
    textCi.clear();
  }
  @override
  void initState() {
    super.initState();
  }
}
