import 'package:crub_sencillo_ejemplo/providers/firebase_crub.dart';
import 'package:crub_sencillo_ejemplo/providers/quizz_provider.dart';
import 'package:crub_sencillo_ejemplo/screens/menu_examen.dart';
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
        ChangeNotifierProvider(create: (_) => QuizzProvider()),
      ],
      child: MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      debugShowCheckedModeBanner: false,
      home: MenuPage(),
    );
  }
}
