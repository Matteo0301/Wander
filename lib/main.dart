import 'package:flutter/material.dart';
import 'package:wander/map.dart';
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
        home: Scaffold(
          backgroundColor: Colors.blueGrey,
          body: Center(
            child: SizedBox(
              width: MyTheme.windowSize,
              height: MyTheme.windowSize,
              child: DecoratedBox(
                decoration: const BoxDecoration(
                  borderRadius: MyTheme.windowBorderRadius,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      blurRadius: 10,
                      spreadRadius: 5,
                      offset: Offset(0, 0),
                    ),
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
                                child: FloatingActionButton(
                                  onPressed: () {
                                    // TODO: Open menu
                                  },
                                  backgroundColor: Colors.green.shade200,
                                  shape: const CircleBorder(),
                                  child: const Icon(Icons.menu),
                                )),
                            Padding(
                                padding: MyTheme.padding,
                                child: FloatingActionButton(
                                  onPressed: () {
                                    WanderMap.controller.zoomIn();
                                  },
                                  backgroundColor: Colors.orange.shade200,
                                  shape: const CircleBorder(),
                                  child: const Icon(Icons.add),
                                )),
                            Padding(
                                padding: MyTheme.padding,
                                child: FloatingActionButton(
                                  onPressed: () {
                                    WanderMap.controller.zoomOut();
                                  },
                                  backgroundColor: Colors.orange.shade200,
                                  shape: const CircleBorder(),
                                  child: const Icon(Icons.remove),
                                )),
                            Padding(
                                padding: MyTheme.padding,
                                child: FloatingActionButton(
                                  onPressed: () {
                                    WanderMap.controller.currentLocation();
                                  },
                                  backgroundColor: Colors.blueGrey.shade300,
                                  shape: const CircleBorder(),
                                  child: const Icon(Icons.gps_fixed),
                                )),
                            Padding(
                                padding: MyTheme.padding,
                                child: FloatingActionButton(
                                  onPressed: () {
                                    WanderMap.controller.currentLocation();
                                  },
                                  backgroundColor: Colors.blueGrey.shade300,
                                  shape: const CircleBorder(),
                                  child: const Icon(Icons.mic),
                                )),
                          ]))
                ]),
              ),
            ),
          ),
        ));
  }
}
