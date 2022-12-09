import 'package:crub_sencillo_ejemplo/models/quizz_modelo.dart';
import 'package:crub_sencillo_ejemplo/providers/quizz_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class QuizzPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Expanded(
              child: _PageVieBUilder(),
            ),
            SafeArea(
              top: false,
              bottom: true,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      child: Container(
                        height: 50,
                        width: 180,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.orangeAccent,
                          borderRadius: BorderRadius.circular(22),
                        ),
                        child: const Text(
                          'Atras',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                      onTap: () {
                        // traemos el pageController
                        final pageController =
                            Provider.of<QuizzProvider>(context, listen: false)
                                .getPageController;
                        // Y consultamos en que pagina se encuentra el pageView
                        final paginaactual = pageController.page!.toInt();
                        // Si no esta en la pagina 0 le pediremos que retroceda una pagina
                        if (paginaactual != 0) {
                          pageController.previousPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut);
                        }
                      },
                    ),
                    GestureDetector(
                      child: Container(
                        height: 50,
                        width: 180,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.orangeAccent,
                          borderRadius: BorderRadius.circular(22),
                        ),
                        child: const Text(
                          'Siguiente',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                      onTap: () {
                        // traemos el pageController
                        final pageController =
                            Provider.of<QuizzProvider>(context, listen: false)
                                .getPageController;

                        // Y consultamos en que pagina se encuentra el pageView
                        final paginaactual = pageController.page!.toInt();
                        //Traemos las respuestas desde nuestros provider
                        final respuestasList =
                            Provider.of<QuizzProvider>(context, listen: false)
                                .getRespuestas;
                        // si estamos en la pagina final osea 4 mandamos a llamar al metodo y modal _modalCalificaciones
                        if (paginaactual == 4) {
                          print(respuestasList);
                          // Le mandamos el xontext para poder trabjar con widgets seguir integrando mas
                          _modalCalificaciones(
                              context: context, respuestas: respuestasList);
                        } else {
                          // avanzaremos de pagina si no se encuentra en la pagina 4
                          pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PageVieBUilder extends StatefulWidget {
  @override
  State<_PageVieBUilder> createState() => _PageVieBUilderState();
}

// Honestamente creo que se podria hacer sin usar StatefulWidget pero lo correcto es usarlo a trabajar con un controlador
// aun que por ahorro de memoria y la manera correcta se tiene que destruir el controller para ahorrar memoria cuando ya no estas en la pagina
// donde se utiliza el controller o cuando ya no se nesecite
class _PageVieBUilderState extends State<_PageVieBUilder> {
  // declaramos un PageContorller y lo dejamos en late para luego inicializarlo
  late PageController _pageController;
  @override
  void initState() {
    // traemos y asignamos el pageController del provider
    _pageController =
        Provider.of<QuizzProvider>(context, listen: false).getPageController;

    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // escuchamos los cambios de la respuesta para que se pueda seleccionar y cambie de color la respuesta seleccionada
    final respuestaSeleccionada =
        Provider.of<QuizzProvider>(context, listen: true).getRespuestas;

    return PageView.builder(
      itemCount: preguntas.length,
      scrollDirection: Axis.horizontal,
      controller: _pageController,
      itemBuilder: (context, index) {
        return Column(
          children: [
            Text(
              'Pregunta ${index + 1}',
              style: const TextStyle(fontSize: 30),
            ),
            const Spacer(flex: 3),
            Text(
              preguntas[index].pregunta,
              style: const TextStyle(fontSize: 30),
            ),
            const Spacer(flex: 2),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Aqui estoy  reutilizando el boton de cada respuesta y ya solo se le mandan los parametros a usar
                  _RespuestaContainer(
                    index: index,
                    respuestaSeleccionada: respuestaSeleccionada,
                    slotRespuesta: 0,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  // opcion 2
                  _RespuestaContainer(
                    index: index,
                    respuestaSeleccionada: respuestaSeleccionada,
                    slotRespuesta: 1,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  // opcion 2
                  _RespuestaContainer(
                    index: index,
                    respuestaSeleccionada: respuestaSeleccionada,
                    slotRespuesta: 2,
                  ),

                  const SizedBox(width: 10),
                  // opcion 3
                  _RespuestaContainer(
                    index: index,
                    respuestaSeleccionada: respuestaSeleccionada,
                    slotRespuesta: 3,
                  ),
                ],
              ),
            ),
            const Spacer(flex: 3),
            GestureDetector(
              child: Container(
                height: 50,
                width: 200,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.orangeAccent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  'Borrar Respuesta',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
              onTap: () {
                // Creamos un objet Respuesta con los valores
                final Respuesta respuesta = Respuesta(
                  slot: index,
                  respuesta: null,
                );
                // Giardamos la respuesta seleccionada
                Provider.of<QuizzProvider>(context, listen: false)
                    .SetRespuestas = respuesta;
              },
            ),
            const Spacer(flex: 2),
          ],
        );
      },
    );
  }
}

class _RespuestaContainer extends StatelessWidget {
  final int slotRespuesta;
  final int index;
  final List<Respuesta> respuestaSeleccionada;
  const _RespuestaContainer({
    required this.slotRespuesta,
    required this.index,
    required this.respuestaSeleccionada,
  });
  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 5,
      child: GestureDetector(
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            // aqui hice algunas condiciones ternarias para pintar el boton seleccionado
            // Una para saber si era null y otra para saber  si lo habian seleccionado
            color: (respuestaSeleccionada[index].respuesta == null)
                ? Colors.orangeAccent
                : (respuestaSeleccionada[index].respuesta == slotRespuesta)
                    ? const Color.fromARGB(255, 255, 145, 0)
                    : Colors.orangeAccent,
            borderRadius: BorderRadius.circular(22),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
            child: Text(
              preguntas[index].opciones[slotRespuesta],
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
        ),
        onTap: () {
          final Respuesta respuesta = Respuesta(
            slot: index,
            respuesta: slotRespuesta,
          );
          Provider.of<QuizzProvider>(context, listen: false).SetRespuestas =
              respuesta;
        },
      ),
    );
  }
}

// tenemos el modal
_modalCalificaciones(
    {required BuildContext context, required List<Respuesta> respuestas}) {
  showDialog(
    context: context,
    // barrierDismissible: true,
    builder: (builder) {
      // le pedimos que nos retorne un dialog para el uso de las propiedades del scaffolt y del context
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
              child: Text(
                'Tus Resultados fueron:',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(
                respuestas.length,
                (index) => Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 30),
                  child: Container(
                    height: 50,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        // Una condicion ternaria es para pintar y cambiar de texto cuando no se selecciono respuesta
                        // para eso es el null que utilizo en el objeto Respuesta.respuesta
                        // La otra condicion es para comprar si esta bien o mal la respuesta
                        color: (respuestas[index].respuesta != null)
                            ? (respuestas[index].respuesta ==
                                    preguntas[index].opcionCorrecta)
                                ? Colors.green
                                : Colors.red
                            : Colors.blue),
                    child: (respuestas[index].respuesta != null)
                        ? (respuestas[index].respuesta ==
                                preguntas[index].opcionCorrecta)
                            ? const Text(
                                'Correcta ',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                ),
                              )
                            : const Text(
                                'Incorrecta ',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                ),
                              )
                        : const Text(
                            'Sin Contestar',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            GestureDetector(
              child: Container(
                height: 60,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: Colors.orange,
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(20)),
                ),
                child: const Text(
                  'Aceptar',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w300,
                    color: Colors.white,
                  ),
                ),
              ),
              onTap: () {
                // cierra el modal
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
    },
  );
}
