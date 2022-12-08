import 'package:crub_sencillo_ejemplo/providers/firebase_crub.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    AppState(),
  );
}

class AppState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
                    print('A por kyary');
                    final stringUpdate = Provider.of<FirebaseProviderCRUB>(
                            context,
                            listen: false)
                        .getUpdateStringSeletect();

                    stringUpdate.simpleString =
                        Provider.of<FirebaseProviderCRUB>(context,
                                listen: false)
                            .getValorEscrito();

                    Provider.of<FirebaseProviderCRUB>(context, listen: false)
                        .updateString(stringUpdate);
                    Provider.of<FirebaseProviderCRUB>(context, listen: false)
                        .setTxtController('');
                    print(stringUpdate);
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
                    print('A por kyary');
                    final valorEscrito = Provider.of<FirebaseProviderCRUB>(
                            context,
                            listen: false)
                        .getValorEscrito();

                    Provider.of<FirebaseProviderCRUB>(context, listen: false)
                        .createCampo(saveString: valorEscrito);
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
                          print('KPP');
                          Provider.of<FirebaseProviderCRUB>(context,
                                  listen: false)
                              .setTxtController(
                                  listaStrings[index].simpleString);
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
                          print('KPP');
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
        Provider.of<FirebaseProviderCRUB>(context, listen: false)
            .setvalorEscrito(texto);
      },
    );
  }
}
