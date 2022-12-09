import 'package:crub_sencillo_ejemplo/models/quizz_modelo.dart';
import 'package:flutter/material.dart';

class QuizzProvider with ChangeNotifier {
  // declaramos e inicializamos  un PageController
  // para manejar  el PageView
  final PageController _pageController = PageController();
  PageController get getPageController => _pageController;

  // Creamos un objeto y los inicializamos para tener los slot listos
  // de las preguntas
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

  //declaramos un getter an setter para estar consultando la lista de respuestas
  // y el setter se usara para asignar la respuesta
  // y notificamos a los que esten escuchando la lista
  List<Respuesta> get getRespuestas => _respuestas;
  set SetRespuestas(Respuesta dato) {
    _respuestas[dato.slot].respuesta = dato.respuesta;
    notifyListeners();
  }
}
