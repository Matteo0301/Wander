import 'dart:convert';
import 'dart:io';

import 'package:dart_openai/dart_openai.dart';
import 'package:flutter/material.dart';
import 'package:wander/theme.dart';

class AssistantResult extends StatelessWidget {
  const AssistantResult({super.key, required this.path});
  final String path;

  Future<String> audioTranscribe(String path) async {
    final audioFile = File(path);

    final OpenAIAudioModel transcription = await OpenAI.instance.audio
        .createTranscription(
            file: audioFile,
            model: "whisper-1",
            responseFormat: OpenAIAudioResponseFormat.json,
            prompt: "Answer to this question");
    debugPrint(transcription.text);
    return transcription.text;
  }

  Future<String> getResponse(String path) async {
    final String prompt = await audioTranscribe(path);
    // the system message that will be sent to the request.
    final systemMessage = OpenAIChatCompletionChoiceMessageModel(
      content: [
        OpenAIChatCompletionChoiceMessageContentItemModel.text(
          "Answer every prompt by the user as if you were a travel guide, return the answer as JSON",
        ),
      ],
      role: OpenAIChatMessageRole.assistant,
    );

    // the user message that will be sent to the request.
    final userMessage = OpenAIChatCompletionChoiceMessageModel(
      content: [
        OpenAIChatCompletionChoiceMessageContentItemModel.text(
          prompt,
        ),
      ],
      role: OpenAIChatMessageRole.user,
    );

// all messages to be sent.
    final requestMessages = [
      systemMessage,
      userMessage,
    ];

// the actual request.
    OpenAIChatCompletionModel chatCompletion =
        await OpenAI.instance.chat.create(
      model: "gpt-3.5-turbo-1106",
      responseFormat: {"type": "json_object"},
      seed: 6,
      messages: requestMessages,
      temperature: 0.2,
      maxTokens: 500,
    );

    debugPrint(chatCompletion.choices.first.message.content?.first.text);
    debugPrint(chatCompletion.systemFingerprint);
    debugPrint(chatCompletion.usage.promptTokens.toString());
    debugPrint(chatCompletion.id);
    final response =
        (chatCompletion.choices.first.message.content?.first.text != null)
            ? ResponseText.fromJson(jsonDecode(
                chatCompletion.choices.first.message.content!.first.text!))
            : ResponseText(response: "Error while connecting to the server");
    return response.response;
  }

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
              child: FutureBuilder<String>(
                future: getResponse(path),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Center(
                        child: Text(
                            snapshot.data ?? "Error while contacting server"));
                  } else if (snapshot.hasError) {
                    return const Center(
                        child: Text("Error while contacting server"));
                  } else {
                    return const Center(
                        child: SizedBox(
                            height: 40,
                            width: 40,
                            child: CircularProgressIndicator()));
                  }
                },
              )),
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
