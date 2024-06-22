import 'dart:convert';
import 'dart:io';

//import 'package:file_picker/file_picker.dart';
import 'package:dart_openai/dart_openai.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:uuid/uuid.dart';
import 'package:wander/assistant.dart';
import 'package:wander/audio_button.dart';
import 'package:wander/map.dart';


class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  static List<types.Message> _messages = [];
  static List<String> messageTexts = [];
  final _user = const types.User(
    id: '82091008-a484-4a89-ae75-a22bf8d6f3ac',
  );

  final chat = const types.User(
    id: '82091008-a484-4a89-ae75-a22bf8d6f3ad',
    //imageUrl: null,
    firstName: "Wander",
  );

  Future<String> getResponse(String prompt, List<String> previousMessages) async {
    // the system message that will be sent to the request.
    final systemMessage = OpenAIChatCompletionChoiceMessageModel(
      content: [
        OpenAIChatCompletionChoiceMessageContentItemModel.text(
          "Answer every prompt by the user as if you were a travel guide, return the answer as JSON and remember you must put the result into the 'response' field in a human readable way. You will find a JSON containing the current itinerary of the user in the next message, if the user asks to modify it by adding or removing some places return the new one in the 'itinerary' field, otherwise return the old one. The 'itinerary' field should be a list of strings (places) that can be understood from Google Maps, and that are sorted in the way that you think is the best. All the messages that will follow are the previous conversation between you and the user. Remember that you must ALWAYS put an answer into the 'response' field.",
        ),
        OpenAIChatCompletionChoiceMessageContentItemModel.text(jsonEncode(MapState.places)),
      ] + previousMessages.map((e) => OpenAIChatCompletionChoiceMessageContentItemModel.text(e)).toList(),
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
            : ResponseText(response: "Error while connecting to the server", itinerary: null);
    if(response.itinerary != null){
      MapState.places = response.itinerary!;
    }
    return response.response;
  }

  Future<String> audioTranscribe(String path) async {
    final audioFile = File(path);

    final OpenAIAudioModel transcription = await OpenAI.instance.audio
        .createTranscription(
            file: audioFile,
            language: "en",
            model: "whisper-1",
            responseFormat: OpenAIAudioResponseFormat.json,
            prompt: "Answer to this question");
    debugPrint(transcription.text);
    return transcription.text;
  }

  @override
  void initState() {
    super.initState();
    //TODO: add loading from server
    //_loadMessages();
  }

  void _addMessage(types.Message message, String text) {
    setState(() {
      _messages.insert(0, message);
      messageTexts.add(text);
    });
  }

  void _handleAttachmentPressed() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) => SafeArea(
        child: SizedBox(
          height: 144,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text('Cancel'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

/*   void _handleMessageTap(BuildContext _, types.Message message) async {
    if (message is types.FileMessage) {
      var localPath = message.uri;

      if (message.uri.startsWith('http')) {
        try {
          final index =
              _messages.indexWhere((element) => element.id == message.id);
          final updatedMessage =
              (_messages[index] as types.FileMessage).copyWith(
            isLoading: true,
          );

          setState(() {
            _messages[index] = updatedMessage;
          });

          final client = http.Client();
          final request = await client.get(Uri.parse(message.uri));
          final bytes = request.bodyBytes;
          final documentsDir = (await getApplicationDocumentsDirectory()).path;
          localPath = '$documentsDir/${message.name}';

          if (!File(localPath).existsSync()) {
            final file = File(localPath);
            await file.writeAsBytes(bytes);
          }
        } finally {
          final index =
              _messages.indexWhere((element) => element.id == message.id);
          final updatedMessage =
              (_messages[index] as types.FileMessage).copyWith(
            isLoading: null,
          );

          setState(() {
            _messages[index] = updatedMessage;
          });
        }
      }

      await OpenFilex.open(localPath);
    }
  } */

  void _handlePreviewDataFetched(
    types.TextMessage message,
    types.PreviewData previewData,
  ) {
    final index = _messages.indexWhere((element) => element.id == message.id);
    final updatedMessage = (_messages[index] as types.TextMessage).copyWith(
      previewData: previewData,
    );

    setState(() {
      _messages[index] = updatedMessage;
    });
  }

  void handleConversation(String msg) async {
    final textMessage = types.TextMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v4(),
      text: msg,
    );

    _addMessage(textMessage,msg);
    //debugPrint("Messages" + _messages.toString());

    String response = await getResponse(msg,messageTexts);
    final responseMessage = types.TextMessage(
      author: chat,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v4(),
      text: response,
    );
    _addMessage(responseMessage,response);
  }

  void _handleSendPressed(types.PartialText message) async  {
    handleConversation(message.text);
  }

  void _loadMessages() async {
    /* final response = await rootBundle.loadString('assets/messages.json');
    final messages = (jsonDecode(response) as List)
        .map((e) => types.Message.fromJson(e as Map<String, dynamic>))
        .toList(); */

    setState(() {
      _messages = [];
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          actions: [
             AudioButton(afterStopped: (path) async {
          String msg = await audioTranscribe(path);
          handleConversation(msg);
        })
          ],
        ),
        body: Chat(
          messages: _messages,
          //onAttachmentPressed: _handleAttachmentPressed,
          //onMessageTap: _handleMessageTap,
          onPreviewDataFetched: _handlePreviewDataFetched,
          onSendPressed: _handleSendPressed,
          showUserAvatars: true,
          showUserNames: true,
          user: _user,
        ),
        //floatingActionButton: Padding(padding: const EdgeInsets.only(bottom: 70),child: FloatingActionButton(onPressed: (){},child:,)),
      );
}
