import 'package:dart_openai/dart_openai.dart';
import 'package:flutter/material.dart';
import 'package:wander/map.dart';
import 'package:wander/secrets.dart';

void main() {
  OpenAI.apiKey = chatGPTKey;
  OpenAI.organization = null;
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        debugShowCheckedModeBanner: false,
        color: Colors.blueGrey,
        home: Home());
  }
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.blueGrey,
      body: WanderMap(),
    );
  }
}
