import 'dart:convert';
import 'dart:io';

import 'package:dart_openai/dart_openai.dart';
import 'package:flutter/material.dart';
import 'package:wander/assistant_result.dart';
import 'package:wander/audio_button.dart';
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
                  child: AudioButton(
                    afterStopped: (path) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AssistantResult(
                                    path: path,
                                  )));
                    },
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

class ResponseText {
  final String response;
  ResponseText({required this.response});

  factory ResponseText.fromJson(Map<String, dynamic> json) {
    final String response = (json.containsKey("response"))
        ? json["response"]
        : "Error while connecting to the server";
    return ResponseText(response: response);
  }
}
