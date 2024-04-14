import 'package:flutter/material.dart';
import 'package:wander/menu.dart';
import 'package:wander/theme.dart';

class Assistant extends StatelessWidget {
  const Assistant({super.key});

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
                color: Colors.indigo.shade200,
                boxShadow: const [
                  MyTheme.shadow,
                ],
              ),
              child: Stack(children: [
                Center(
                  child: IconButton(
                    onPressed: () {},
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.blueGrey.shade400),
                      fixedSize:
                          MaterialStateProperty.all(const Size(200, 200)),
                      iconSize: MaterialStateProperty.all(100),
                      shadowColor: MaterialStateProperty.all(Colors.black),
                    ),
                    icon: const Icon(Icons.mic),
                  ),
                ),
                Align(
                    alignment: Alignment.bottomRight,
                    child: Column(
                        verticalDirection: VerticalDirection.up,
                        children: [
                          Padding(
                              padding: MyTheme.padding,
                              child: IconButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => const Menu()));
                                },
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      Colors.green.shade200),
                                  fixedSize: MaterialStateProperty.all(
                                      const Size(MyTheme.buttonSize,
                                          MyTheme.buttonSize)),
                                  iconSize: MaterialStateProperty.all(
                                      MyTheme.buttonIconSize),
                                ),
                                icon: const Icon(Icons.menu),
                              )),
                        ])),
              ])),
        ),
      ),
    );
  }
}
