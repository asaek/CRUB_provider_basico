import 'package:crub_sencillo_ejemplo/providers/firebase_crub.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Esperamos  a que  se inicialice firebase
  await Firebase.initializeApp();

  runApp(
    AppState(),
  );
}

class AppState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // incluimos el multiprovider al nivel mas alto posible para agregarlo al builtcontext
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FirebaseProviderCRUB()),
      ],
      child: MyApp(),
    );
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // cargamos los Strings a la lista desde el provider
    Provider.of<FirebaseProviderCRUB>(context, listen: false).loadStrings();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            SafeArea(
              bottom: false,
              child: _TextField(),
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  child: Container(
                    height: 50,
                    width: 180,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.orangeAccent,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Text(
                      'Update',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 35,
                      ),
                    ),
                  ),
                  onTap: () {
                    // Traigo el objeto<SimpleString> que voy a actualizar
                    final stringUpdate = Provider.of<FirebaseProviderCRUB>(
                            context,
                            listen: false)
                        .getUpdateStringSeletect();

                    // Tambien traigo el texto escrito en el TextField
                    stringUpdate.simpleString =
                        Provider.of<FirebaseProviderCRUB>(context,
                                listen: false)
                            .getValorEscrito();

                    // y aqui lo mando al metodo que lo subira y lo actualizara en la lista
                    Provider.of<FirebaseProviderCRUB>(context, listen: false)
                        .updateString(stringUpdate);

                    // Limpio el textfield
                    Provider.of<FirebaseProviderCRUB>(context, listen: false)
                        .setTxtController('');
                  },
                ),
                GestureDetector(
                  child: Container(
                    height: 50,
                    width: 180,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.orangeAccent,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Text(
                      'Guardarlo',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 35,
                      ),
                    ),
                  ),
                  onTap: () {
                    // leo traigo el valor escrito en el textField
                    final valorEscrito = Provider.of<FirebaseProviderCRUB>(
                            context,
                            listen: false)
                        .getValorEscrito();

                    // envio el texto escrito para su procesamiento al metodo createCampo
                    Provider.of<FirebaseProviderCRUB>(context, listen: false)
                        .createCampo(saveString: valorEscrito);
                    // Limpio el textFlied
                    Provider.of<FirebaseProviderCRUB>(context, listen: false)
                        .setTxtController('');
                  },
                ),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            ListBuilder(),
          ],
        ),
      )),
    );
  }
}

class ListBuilder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final listaStrings =
        Provider.of<FirebaseProviderCRUB>(context, listen: true)
            .getListadeStrings;

    return Expanded(
      child: (listaStrings.isEmpty)
          ? const Center(
              child: Text(
                'No hay datos!',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
            )
          : ListView.builder(
              itemCount: listaStrings.length,
              scrollDirection: Axis.vertical,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          listaStrings[index].simpleString,
                          style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                      GestureDetector(
                        child: Container(
                          height: 30,
                          width: 100,
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                            color: Colors.green,
                          ),
                          child: const Text(
                            'Editar',
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        ),
                        onTap: () {
                          // tomo el valor String simpleString del objeto de la lista listaStrings y
                          // lo envio al textfield
                          Provider.of<FirebaseProviderCRUB>(context,
                                  listen: false)
                              .setTxtController(
                                  listaStrings[index].simpleString);
                          // guardo el objeto que se va a editar
                          Provider.of<FirebaseProviderCRUB>(context,
                                  listen: false)
                              .setUpdateStringSeletect(listaStrings[index]);
                        },
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      GestureDetector(
                        child: Container(
                          height: 30,
                          width: 100,
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                            color: Colors.red,
                          ),
                          child: const Text(
                            'Borrar',
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        ),
                        onTap: () {
                          // Envia el objeto para su elimnacion de la bd y de la lista
                          Provider.of<FirebaseProviderCRUB>(context,
                                  listen: false)
                              .deleteString(deleteString: listaStrings[index]);
                        },
                      )
                    ],
                  ),
                );
              },
            ),
    );
  }
}

class _TextField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextField(
      autofocus: true,
      keyboardType: TextInputType.number,
      style: const TextStyle(color: Colors.black, fontSize: 30),
      // Asigamos un TextEditingController para poder tomar control del TextFlied
      // y asi poder borrar y alterar lo escrito
      controller: Provider.of<FirebaseProviderCRUB>(context, listen: false)
          .getTxtController,
      decoration: const InputDecoration(
        helperText: 'Agrega Texto',
        focusColor: Colors.black,
        hoverColor: Colors.black,
        fillColor: Colors.black,
        suffixIconColor: Colors.black,
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
      ),
      onChanged: (String texto) {
        // Cada ves que se escribe o se edita lo escrtio lo mandara a guardar
        Provider.of<FirebaseProviderCRUB>(context, listen: false)
            .setvalorEscrito(texto);
      },
    );
  }
}
