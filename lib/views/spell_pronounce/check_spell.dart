import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For Clipboard
import 'package:fluttertoast/fluttertoast.dart'; // For Toast messages
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:languagetool_textfield/languagetool_textfield.dart';
import 'package:mnh/utils/app_images.dart';
import 'package:mnh/views/spell_pronounce/pronunciation_screen.dart';
import 'package:mnh/widgets/extensions/empty_space.dart';
import 'package:share_plus/share_plus.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

import '../../translator/controller/translate_contrl.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_icons.dart';
import '../../widgets/back_button.dart';
import '../../widgets/copy_btn.dart';
import '../../widgets/custom_mic.dart';
import '../../widgets/custom_textBtn.dart';
import '../../widgets/delete_btn.dart';
import '../../widgets/dropDown_btn.dart';
import '../../widgets/lang_selection.dart';
import '../../widgets/share_btn.dart';
import '../../widgets/text_widget.dart';

class CheckSpellScreen extends StatefulWidget {
  const CheckSpellScreen({super.key});

  @override
  State<CheckSpellScreen> createState() => _CheckSpellScreenState();
}

class _CheckSpellScreenState extends State<CheckSpellScreen> {
  final TextEditingController _textController = TextEditingController();
  final LanguageToolController _controller = LanguageToolController();


  final FlutterTts _flutterTts = FlutterTts();
  bool _isLoading = false;

  Color copyColor = Colors.grey;
  Color deleteColor = Colors.grey;
  Color shareColor = Colors.grey;

  // Function to change color temporarily for 2 seconds
  void changeColor(String action) {
    setState(() {
      if (action == 'copy') {
        copyColor = Colors.blue;
      } else if (action == 'delete') {
        deleteColor = Colors.blue;
      } else if (action == 'share') {
        shareColor = Colors.blue;
      }
    });

    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        if (action == 'copy') {
          copyColor = Colors.grey;
        } else if (action == 'delete') {
          deleteColor = Colors.grey;
        } else if (action == 'share') {
          shareColor = Colors.grey;
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _flutterTts.setLanguage('en-US');
      _showWelcomeDialog();
    });
  }

  final Map<String, Map<String, String>> languageCountryCode = {
  "English": {"code": "US", "country": "United States"},
  "Afrikaans": {"code": "ZA", "country": "South Africa"},
  "Albanian": {"code": "AL", "country": "Albania"},
  };

  // Define _performSpellCheck method
  Future<void> _performSpellCheck() async {
    String inputText = _controller.text.trim();
    String correctedText = inputText;

    if(inputText.isEmpty){
      Fluttertoast.showToast(msg: 'Please enter the text');
    }else if(inputText.isNotEmpty){
      Fluttertoast.showToast(msg: 'spelling check completed, wrong spellings are highlighted');
    }
    setState(() {
      _isLoading = true;
      _controller.text = correctedText;
      _isLoading = false;
    });

  }

  // Show the toast message when text is empty
  void _showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void _showDeleteConfirmationDialog() {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissal by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmation'),
          content: const Text('Are you sure you want to delete the text?'),
          actions: [
            TextButton(
              onPressed: () {
                _controller.clear(); // Clear the text
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('OK'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog without doing anything
              },
              child: const Text('No'),
            ),
          ],
        );
      },
    );
  }

  void _showWelcomeDialog() {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissal by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          icon: CircleAvatar(
              backgroundColor: Colors.transparent,
              child: Image.asset(AppIcons.alertIcon)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12)
          ),
          content: regularText(
            title: 'Do you want to proceed to the Spell Check Screen?',
            textColor: Colors.black,
            textSize: 14
          ),
          actions: [

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              spacing: 16,
              children: [
                GestureDetector(
                  onTap: (){
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    height: 40, width: 100,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.grey
                    ),
                    child: Center(child: regularText(title: 'No', textSize: 16, textColor: Colors.white)),
                  ),
                ),
                GestureDetector(
                  onTap: (){
                    Navigator.of(context).pop();

                  },
                  child: Container(
                    height: 40, width: 100,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.blue
                    ),
                    child: Center(child: regularText(title: 'Yes', textSize: 16, textColor: Colors.white)),
                  ),
                ),
              ],
            )

          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    _controller.dispose();
    _flutterTts.stop();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        backgroundColor: Color(0XFF4169E1).withValues(alpha: .76),
        leading: CustomBackButton(
            iconSize: 16,
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icons.arrow_back_ios_outlined,
            btnColor: Colors.white
        ),
        centerTitle: true,
        title: regularText(
          title: 'Spell Check',
          textColor: Colors.white,
          textWeight: FontWeight.w500,
          textSize: screenWidth * 0.042,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.01, vertical: screenHeight * 0.01),
              height: screenHeight * 0.5,
              width: screenWidth * 0.98,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(12), bottomRight: Radius.circular(12))
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 10,
                    children: [
                      LanguageContainer(
                        language: 'English',
                        countryCode:  languageCountryCode['English']!['code']!,
                      ),
                      Spacer(),
                      CopyBtn(iconColor: Colors.black, controller: _controller),
                      ShareBtn(iconColor: Colors.black, controller: _controller),
                      DeleteBtn(iconColor: Colors.black, controller: _controller),

                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10,),
                    child: LanguageToolTextField(
                      controller: _controller,
                      language: 'en-US',
                      maxLines: 6,
                      // obscureText: false,  // Ensure this is false
                      // readOnly: true,
                      decoration: const InputDecoration(
                          hintText: 'Type your text here...',
                          hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                          border: InputBorder.none
                      ),
                    ),
                  ),
                  Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: screenWidth * 0.003,
                    children: [
                      // CustomMic2(textController: _textController,),
                      // CuMic2(textController: _textController,),
                      CMic2(textController: _controller,),
                      7.asWidthBox,
                      _isLoading
                          ? const CircularProgressIndicator()
                          : CustomTextBtn(
                        height: screenHeight * 0.06,
                        width: screenWidth * 0.52,
                        textTitle: 'Spell Check',
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(topRight: Radius.circular(12), bottomRight: Radius.circular(12)),
                            color: Color(0XFF4169E1).withValues(alpha: .76),
                        ),
                        onTap: _performSpellCheck,
                      ),
                    ],
                  ),
                  10.asHeightBox,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


/// lang cont


class LanguageContainer extends StatelessWidget {
  final String language ;
  final String countryCode;

  const LanguageContainer({
    required this.language,
    required this.countryCode,
  });

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    // Truncate language if its length exceeds 10 characters
    String displayLanguage = language.length > 8 ? '${language.substring(0, 8)}...' : language;

    return SizedBox(
      height: screenHeight * 0.07,
      width: screenWidth * 0.4,
      // decoration: BoxDecoration(
      //   borderRadius: BorderRadius.circular(12),
      //   color: Color(0XFF4169E1).withOpacity(0.76),
      // ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        spacing: 6,
        children: [
          SizedBox(width: 6),
          CountryFlag.fromCountryCode(
            countryCode,
            height: 24,
            width: 24,
            shape: Circle(),
          ),
          Text(
            displayLanguage,
            style: TextStyle(
              color: Colors.black,
              fontSize: screenWidth * 0.037,
            ),
          ),
          // Icon(
          //   Icons.arrow_drop_down_outlined,
          //   color: Colors.grey,
          // ),
        ],
      ),
    );
  }
}



/// replace buttons


// replaced button
// GestureDetector(
// onTap: () {
// if (_controller.text.trim().isEmpty) {
// _showToast("Please enter some text first!");
// } else {
// changeColor('share');
// final textToShare = _controller.text.trim();
// Share.share(textToShare);
// }
// },
// child: CircleAvatar(
// radius: 16,
// backgroundColor: Color(0XFFaeaeae).withAlpha(26),
// child: Image.asset(
// AppIcons.shareIcon,
// scale:  screenHeight * 0.047,
// color: shareColor,
// ),
// ),
// ),
//
// GestureDetector(
// onTap: () {
// if (_controller.text.trim().isEmpty) {
// _showToast("Please enter some text first!");
// } else {
// changeColor('delete');
// _showDeleteConfirmationDialog();
// }
// },
// child: CircleAvatar(
// radius: 16,
// backgroundColor: Color(0XFFaeaea0).withAlpha(70),
// child: Icon(
// Icons.delete,
// size: screenHeight * 0.03,
// color: deleteColor,
// ),
// ),
// ),

// GestureDetector(
//   onTap: () {
//     if (_controller.text.trim().isEmpty) {
//       _showToast("Please enter some text first!");
//     } else {
//       // changeColor('copyd');
//       final textToCopy = _controller.text.trim();
//       Clipboard.setData(ClipboardData(text: textToCopy)).then((_) {
//
//           // Fluttertoast.showToast(msg: 'copy text success');
//           // Fluttertoast.showToast(msg: textToCopy);
//
//       });
//     }
//   },
//   child: Image.asset(
//     AppIcons.copyIcon,
//     scale: screenHeight * 0.037,
//     color: copyColor,
//   ),
// ),






class CuMic2 extends StatefulWidget {
  final TextEditingController textController;
  const CuMic2({super.key, required this.textController});

  @override
  State<CuMic2> createState() => _CuMic2State();
}

class _CuMic2State extends State<CuMic2> {
  // final MyTranslationController translationController = Get.put(MyTranslationController());
  late stt.SpeechToText _speech;
  bool _isListening = false;
  bool _isCooldown = false;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _initializeSpeech();
  }

  Future<void> _initializeSpeech() async {
    bool available = await _speech.initialize(
      onStatus: (status) {
        print("Speech Status: $status");
      },
      onError: (error) {
        print("Speech Error: $error");
      },
    );
    if (!available) {
      Get.snackbar("Error", "Speech recognition is not available.");
    }
  }

  Future<bool> isInternetAvailable() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  Future<void> _startListening(String languageCode) async {
    if (_isCooldown || _isListening) return;

    final internetAvailable = await isInternetAvailable();
    if (!internetAvailable) {
      Fluttertoast.showToast(
        msg: "Internet is weak or not available. Please check your connection.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
      return;
    }

    setState(() {
      _isListening = true;
      _isCooldown = true;
    });

    try {
      // await translationController.startSpeechToText(languageCode);

      await _speech.listen(
        onResult: (result) {
          setState(() {
            widget.textController.text = result.recognizedWords;
          });
        },
        listenFor: const Duration(seconds: 10),
        cancelOnError: true,
      );
    } catch (e) {
      Get.snackbar('Error', 'Speech-to-text failed. Try again.');
    } finally {
      await Future.delayed(const Duration(seconds: 1));
      setState(() {
        _isListening = false;
        _isCooldown = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () {
        _startListening('en-US');
      },
      child: Container(
        height: screenHeight * 0.06,
        width: screenWidth * 0.14,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(12),
            bottomLeft: Radius.circular(12),
          ),
          color: const Color(0XFF4169E1).withOpacity(0.76),
        ),
        child: Image.asset(AppIcons.micIcon, color: Colors.white, scale: 23),
      ),
    );
  }
}
