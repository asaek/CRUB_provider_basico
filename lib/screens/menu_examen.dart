import 'package:crub_sencillo_ejemplo/screens/crub_examen1.dart';
import 'package:crub_sencillo_ejemplo/screens/quizzz_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MenuPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SafeArea(
              bottom: false,
              child: Text(
                'Menu De Examen',
                style: TextStyle(fontSize: 30),
              ),
            ),
            const Spacer(flex: 3),
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
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: const Text(
                      'CRUD',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                  onTap: () => Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (BuildContext context) => CrubPage(),
                    ),
                  ),
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
                      'Quizz',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                  onTap: () => Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (BuildContext context) => QuizzPage(),
                    ),
                  ),
                ),
              ],
            ),
            const Spacer(flex: 7),
          ],
        ),
      ),
    );
  }
}
