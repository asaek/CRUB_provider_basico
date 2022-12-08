import 'package:crub_sencillo_ejemplo/models/simple_string.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:flutter/material.dart';

class FirebaseProviderCRUB with ChangeNotifier {
  final String _baseURL = 'proyetopruebas-default-rtdb.firebaseio.com';

  List<SimpleString> _listadeStrings = [];
  List<SimpleString> get getListadeStrings => _listadeStrings;
  set setListadeStrings(SimpleString dato) {
    _listadeStrings.add(dato);
    notifyListeners();
  }

  String _valorEscrito = '';
  String getValorEscrito() => _valorEscrito;
  void setvalorEscrito(String dato) {
    _valorEscrito = dato;
  }

  SimpleString _updateStringSeletect = new SimpleString(simpleString: '');
  SimpleString getUpdateStringSeletect() => _updateStringSeletect;
  void setUpdateStringSeletect(SimpleString dato) {
    _updateStringSeletect = dato;
  }

  TextEditingController _txtController = new TextEditingController();
  TextEditingController get getTxtController => _txtController;
  void setTxtController(String dato) {
    _txtController.text = dato;
  }

  Future createCampo({required String saveString}) async {
    final SimpleString valoraSubir = SimpleString(simpleString: '');
    valoraSubir.simpleString = saveString;

    final url = Uri.https(_baseURL, '.json');
    final resp = await http.post(url, body: valoraSubir.toJson());
    final decoodeData = json.decode(resp.body);
    valoraSubir.idFirebase = decoodeData['name'];
    print(valoraSubir);
    setListadeStrings = valoraSubir;

    print(resp.statusCode);
    return;
  }

  Future loadStrings() async {
    final url = Uri.https(_baseURL, '.json');
    final resp = await http.get(url);

    final Map<String, dynamic>? stringsMap = json.decode(resp.body);
    if (stringsMap != null) {
      stringsMap.forEach((key, value) {
        final tempStringFirebase = SimpleString.fromMap(value);
        tempStringFirebase.idFirebase = key;
        setListadeStrings = tempStringFirebase;
      });
    }

    return;
  }

  Future deleteString({required SimpleString deleteString}) async {
    final url = Uri.https(_baseURL, '${deleteString.idFirebase}.json');
    final resp = await http.delete(url, body: deleteString.toJson());
    print(resp.statusCode);
    if (resp.statusCode == 200) {
      _listadeStrings.removeWhere(
          (element) => element.idFirebase == deleteString.idFirebase);
      print(_listadeStrings);
      notifyListeners();
    }
    return;
  }

  Future updateString(SimpleString updateString) async {
    final url = Uri.https(_baseURL, '${updateString.idFirebase}.json');
    final resp = await http.put(url, body: updateString.toJson());

    if (resp.statusCode == 200) {
      // _listadeStrings.removeWhere(
      //     (element) => element.idFirebase == updateString.idFirebase);
      // print(_listadeStrings);
      _listadeStrings[_listadeStrings.indexWhere(
        (element) => element.idFirebase == updateString.idFirebase,
      )] = updateString;

      print(_listadeStrings);
      notifyListeners();
    }
    return;
  }
}
