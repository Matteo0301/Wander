import 'package:flutter/material.dart';
import 'package:wander/assistant.dart';
import 'package:wander/main.dart';
import 'package:wander/theme.dart';

class Menu extends StatelessWidget {
  const Menu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: Center(
        child: SizedBox(
          width: MyTheme.windowSize,
          height: MyTheme.windowSize,
          child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: MyTheme.windowBorderRadius,
                color: Colors.blue.shade200,
                boxShadow: const [
                  MyTheme.shadow,
                ],
              ),
              child: Center(
                  child: Column(children: [
                Padding(
                    padding: const EdgeInsets.all(30),
                    child: IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Home()));
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.green.shade200),
                        fixedSize:
                            MaterialStateProperty.all(const Size(140, 140)),
                        iconSize: MaterialStateProperty.all(80),
                        shadowColor: MaterialStateProperty.all(Colors.black),
                      ),
                      icon: const Icon(Icons.location_on_sharp),
                    )),
                Padding(
                    padding: const EdgeInsets.all(30),
                    child: IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Assistant()));
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            Colors.deepPurple.shade300),
                        fixedSize:
                            MaterialStateProperty.all(const Size(140, 140)),
                        iconSize: MaterialStateProperty.all(80),
                        shadowColor: MaterialStateProperty.all(Colors.black),
                      ),
                      icon: const Icon(Icons.help_outline),
                    )),
              ]))),
        ),
      ),
    );
  }
}
