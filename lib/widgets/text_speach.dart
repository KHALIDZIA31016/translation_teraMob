// import 'package:flutter/material.dart';
// import 'package:flutter_tts/flutter_tts.dart';
//
//
// class TTSWidget extends StatefulWidget {
//   final String initialText; // Initial text to display and speak
//   final String language; // Language for TTS (default is English)
//   final double pitch; // Pitch value (default is 1.0)
//   final double speechRate; // Speech rate value (default is 0.5)
//
//   const TTSWidget({
//     Key? key,
//     this.initialText = "",
//     this.language = "en-US",
//     this.pitch = 1.0,
//     this.speechRate = 0.5,
//   }) : super(key: key);
//
//   @override
//   _TTSWidgetState createState() => _TTSWidgetState();
// }
//
// class _TTSWidgetState extends State<TTSWidget> {
//   late final FlutterTts flutterTts;
//   late final TextEditingController textController;
//
//   @override
//   void initState() {
//     super.initState();
//     flutterTts = FlutterTts();
//     textController = TextEditingController(text: widget.initialText);
//   }
//
//   @override
//   void dispose() {
//     flutterTts.stop();
//     textController.dispose();
//     super.dispose();
//   }
//
//   Future<void> speak() async {
//     String text = textController.text.trim();
//     if (text.isNotEmpty) {
//       await flutterTts.setLanguage(widget.language);
//       await flutterTts.setPitch(widget.pitch);
//       await flutterTts.setSpeechRate(widget.speechRate);
//       await flutterTts.speak(text);
//     }
//   }
//
//   Future<void> stop() async {
//     await flutterTts.stop();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         TextField(
//           controller: textController,
//           decoration: InputDecoration(
//             labelText: "Enter text to speak",
//             border: OutlineInputBorder(),
//           ),
//           maxLines: null,
//         ),
//         const SizedBox(height: 16),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: [
//             ElevatedButton(
//               onPressed: speak,
//               child: const Text("Speak"),
//             ),
//             ElevatedButton(
//               onPressed: stop,
//               child: const Text("Stop"),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
// }
