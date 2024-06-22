import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

class AudioButton extends StatefulWidget {
  const AudioButton({super.key, required this.afterStopped, this.color});
  final void Function(String path) afterStopped;
  final MaterialColor? color;

  @override
  State<StatefulWidget> createState() => AudioButtonState();
}

class AudioButtonState extends State<AudioButton> {
  final AudioRecorder record;
  String? tmpPath;
  AudioButtonState() : record = AudioRecorder();
  bool recording = false;

  void startRecording() async {
    tmpPath = (await getTemporaryDirectory()).absolute.path;
    String path = '${tmpPath!}/tmp.wav';

// Check and request permission if needed
    if (await record.hasPermission()) {
      // Start recording to file
      await record.start(const RecordConfig(encoder: AudioEncoder.wav),
          path: path);
      recording = true;
    }
  }

  Future<bool> stopRecording() async {
    final path = await record.stop();
    debugPrint(path);
    recording = false;
    if (path != null) {
      widget.afterStopped(path);
      return true;
    } else {
      return false;
    }
  }

  @override
  void dispose() {
    super.dispose();
    record.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () async {
        if (!recording) {
          startRecording();
        } else {
          final success = await stopRecording();
          if (!success && context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Error during recording")));
          }
        }
      },
      icon: Icon(Icons.mic, color: widget.color,),
    );
  }
}
