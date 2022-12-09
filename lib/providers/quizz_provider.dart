import 'package:crub_sencillo_ejemplo/models/quizz_modelo.dart';
import 'package:flutter/material.dart';

class QuizzProvider with ChangeNotifier {
  final PageController _pageController = PageController();

  PageController get getPageController => _pageController;

  List<Respuesta> _respuestas = [
    Respuesta(
      slot: 0,
      respuesta: null,
    ),
    Respuesta(
      slot: 1,
      respuesta: null,
    ),
    Respuesta(
      slot: 2,
      respuesta: null,
    ),
    Respuesta(
      slot: 3,
      respuesta: null,
    ),
    Respuesta(
      slot: 4,
      respuesta: null,
    ),
  ];

  List<Respuesta> get getRespuestas => _respuestas;

  set SetRespuestas(Respuesta dato) {
    _respuestas[dato.slot].respuesta = dato.respuesta;
    notifyListeners();
  }
}
