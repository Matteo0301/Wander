import 'package:flutter/material.dart';
import 'package:wander/map.dart';
import 'package:wander/menu.dart';
import 'package:wander/theme.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        color: Colors.blueGrey,
        home: Home());
  }
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: Center(
        child: SizedBox(
          width: MyTheme.windowSize,
          height: MyTheme.windowSize,
          child: DecoratedBox(
            decoration: const BoxDecoration(
              borderRadius: MyTheme.windowBorderRadius,
              boxShadow: [
                MyTheme.shadow,
              ],
            ),
            child: Stack(children: [
              const WanderMap(),
              Align(
                  alignment: Alignment.bottomRight,
                  child: Column(
                      verticalDirection: VerticalDirection.up,
                      children: [
                        Padding(
                            padding: MyTheme.padding,
                            child: IconButton(
                              onPressed: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return const Menu();
                                }));
                              },
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    Colors.green.shade200),
                                fixedSize: MaterialStateProperty.all(const Size(
                                    MyTheme.buttonSize, MyTheme.buttonSize)),
                                iconSize: MaterialStateProperty.all(
                                    MyTheme.buttonIconSize),
                              ),
                              icon: const Icon(Icons.menu),
                            )),
                        Padding(
                            padding: MyTheme.padding,
                            child: IconButton(
                              onPressed: () {
                                WanderMap.controller.zoomIn();
                              },
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    Colors.orange.shade200),
                                fixedSize: MaterialStateProperty.all(const Size(
                                    MyTheme.buttonSize, MyTheme.buttonSize)),
                                iconSize: MaterialStateProperty.all(
                                    MyTheme.buttonIconSize),
                              ),
                              icon: const Icon(Icons.add),
                            )),
                        Padding(
                            padding: MyTheme.padding,
                            child: IconButton(
                              onPressed: () {
                                WanderMap.controller.zoomOut();
                              },
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    Colors.orange.shade200),
                                fixedSize: MaterialStateProperty.all(const Size(
                                    MyTheme.buttonSize, MyTheme.buttonSize)),
                                iconSize: MaterialStateProperty.all(
                                    MyTheme.buttonIconSize),
                              ),
                              icon: const Icon(Icons.remove),
                            )),
                        Padding(
                            padding: MyTheme.padding,
                            child: IconButton(
                              onPressed: () {
                                WanderMap.controller.currentLocation();
                                WanderMap.controller.enableTracking();
                              },
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    Colors.blueGrey.shade300),
                                fixedSize: MaterialStateProperty.all(const Size(
                                    MyTheme.buttonSize, MyTheme.buttonSize)),
                                iconSize: MaterialStateProperty.all(
                                    MyTheme.buttonIconSize),
                              ),
                              icon: const Icon(Icons.gps_fixed),
                            )),
                        Padding(
                            padding: MyTheme.padding,
                            child: IconButton(
                              onPressed: () {
                                // TODO: Open voice command
                              },
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    Colors.blueGrey.shade300),
                                fixedSize: MaterialStateProperty.all(const Size(
                                    MyTheme.buttonSize, MyTheme.buttonSize)),
                                iconSize: MaterialStateProperty.all(
                                    MyTheme.buttonIconSize),
                              ),
                              icon: const Icon(Icons.mic),
                            )),
                      ]))
            ]),
          ),
        ),
      ),
    );
  }
}
