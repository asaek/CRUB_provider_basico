import 'package:crub_sencillo_ejemplo/models/simple_string.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:flutter/material.dart';

// Creamos la clase provider mixeada o integrada con ChangeNotifier
class FirebaseProviderCRUB with ChangeNotifier {
  // asignamos la URL del servidor rest de firebase de nuestro backend
  final String _baseURL = 'proyetopruebas-default-rtdb.firebaseio.com';

  // creamos nuestra lista de objetos SimpleString
  List<SimpleString> _listadeStrings = [];

  // creamos un getter para leer la propiedad encapsulada que en este caso es la lista
  List<SimpleString> get getListadeStrings => _listadeStrings;
  // Creamos un setter para asignar el objeto a a;adir a la lista y
  // Notificamos a los que la esten esscuchando, en este caso
  // el ListView.builder se actualizara al escuchar los cambios
  set setListadeStrings(SimpleString dato) {
    _listadeStrings.add(dato);
    notifyListeners();
  }

  // igual creamos una  variable String y la inicializamos
  String _valorEscrito = '';
  // En este caso tenemos un metodo que retorna la variable encapsulado en este caso un String
  String getValorEscrito() => _valorEscrito;
  // tenemos un metodo que recibe una String y se le asigna a la variable encapusalada
  void setvalorEscrito(String dato) {
    _valorEscrito = dato;
  }

  // igual creamos un objeto y se inicializa
  SimpleString _updateStringSeletect = SimpleString(simpleString: '');
  SimpleString getUpdateStringSeletect() => _updateStringSeletect;
  void setUpdateStringSeletect(SimpleString dato) {
    _updateStringSeletect = dato;
  }

  // Inicializamos un TextEditingController este es inicializado y
  // lo declaramos final ya que no sera editado
  final TextEditingController _txtController = TextEditingController();
  TextEditingController get getTxtController => _txtController;
  // Creamos un metodo para asignar valores al textField y al TextEditingController
  void setTxtController(String dato) {
    _txtController.text = dato;
  }

  // Creamos un metodo que sea asyncrono por el await que esperara de firebase
  // honestamente yo les agrego que retornen un Future pero en este caso no es necesario
  createCampo({required String saveString}) async {
    // inicializamos un onjeto tipo SimpleString es  final por que no se modificara el objeto
    // pero si sus propiedades  ;)
    final SimpleString valoraSubir = SimpleString(simpleString: '');
    valoraSubir.simpleString = saveString;
    // creamos y agregamos la base de la URL y PATH lo dejamos en raiz de la BD
    final url = Uri.https(_baseURL, '.json');
    // lo comvertimos a formato JSON y hacemos el Post y esperamos la respuesta
    final resp = await http.post(url, body: valoraSubir.toJson());
    final decoodeData = json.decode(resp.body);
    // tomamos el id de firebase del objeto que es parte de la respuesta
    valoraSubir.idFirebase = decoodeData['name'];

    // y se lo setteamos a;adimos a la lista
    setListadeStrings = valoraSubir;

    // dejo el return para terminar y controlar el flujo aun que es casi innecesasrio
    return;
  }

  loadStrings() async {
    // creamos y agregamos la base de la URL y PATH lo dejamos en raiz de la BD
    // que es donde apuntaremos para traer los objetos
    final url = Uri.https(_baseURL, '.json');
    // hacemos la peticion y esperamos la respuesta
    final resp = await http.get(url);
    // Aqui tomamos la respuesta JSON y la pasamos a un Map
    // Para  si poder manipularla
    final Map<String, dynamic>? stringsMap = json.decode(resp.body);
    // Manejamos la ecepcion por  si no tenemos ningun objeto en firebase
    if (stringsMap != null) {
      // recorremos el map y le asignamos su id de firebase a cada objeto
      //a si y creamos un objeto temporal en donde asignamos el valor del map
      // ya vuelto objeto con fromMap
      stringsMap.forEach((key, value) {
        final tempStringFirebase = SimpleString.fromMap(value);
        tempStringFirebase.idFirebase = key;
        setListadeStrings = tempStringFirebase;
      });
    }

    return;
  }

  deleteString({required SimpleString deleteString}) async {
    // aqui tenemos  que traer el objeto que deseamos borrar
    // el cual trae el id de firebase del objeto a borrar
    final url = Uri.https(_baseURL, '${deleteString.idFirebase}.json');
    // se pasa el objeto a formato JSON e
    // igual hacemos la peticion delete y esperamos la respuesta
    final resp = await http.delete(url, body: deleteString.toJson());
    print(resp.statusCode);
    // atrapamos el codigo que nos lance para ver si se hizo bien el delete y
    // ahora si borrarlo de la lista y notificamos para actualizar el ListView.Builder
    if (resp.statusCode == 200) {
      _listadeStrings.removeWhere(
          (element) => element.idFirebase == deleteString.idFirebase);
      print(_listadeStrings);
      notifyListeners();
    }
    return;
  }

  updateString(SimpleString updateString) async {
    // aqui igual tomamos el objeto updateString para tomar su id de firebase
    final url = Uri.https(_baseURL, '${updateString.idFirebase}.json');
    // mandamos la peticion put de update y esperamos respuesta
    final resp = await http.put(url, body: updateString.toJson());

    // igual comprobamos que haya sido correctamente hecha
    if (resp.statusCode == 200) {
      // utilizamos la funcion indexWhere para buscar y asignarle el nuevo valor al
      // objeto y  atualizamos al lista
      _listadeStrings[_listadeStrings.indexWhere(
        (element) => element.idFirebase == updateString.idFirebase,
      )] = updateString;

      print(_listadeStrings);
      notifyListeners();
    }
    return;
  }
}
