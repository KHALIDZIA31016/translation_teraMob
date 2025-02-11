import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:mnh/testScreen.dart';
import 'package:mnh/utils/app_colors.dart';
import 'package:mnh/widgets/copy_btn.dart';
import 'package:mnh/widgets/delete_btn.dart';
import 'package:mnh/widgets/extensions/empty_space.dart';
import 'package:mnh/widgets/share_btn.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../../utils/app_icons.dart';
import '../../utils/app_images.dart';
import '../../widgets/back_button.dart';
// import '../../widgets/custom_mic.dart';
import '../../widgets/custom_textBtn.dart';
import '../../widgets/dropDown_btn.dart';
import '../../widgets/lang_selection.dart';
import '../../widgets/text_widget.dart';

class PronunciationScreen extends StatefulWidget {
  const PronunciationScreen({super.key});

  @override
  State<PronunciationScreen> createState() => _PronunciationScreenState();
}

class _PronunciationScreenState extends State<PronunciationScreen> {
  final TextEditingController _textController = TextEditingController();
///
  final FlutterTts _flutterTts = FlutterTts();
  String _selectedValue = 'Eng';

  final Map<String, String> _languageCodes = {
    'Eng': 'en-US',
    'Spanish': 'es-ES',
    'Turkish': 'tr-TR',
    'Arabic': 'ar-SA',
    'Hindi': 'hi-IN',
  };

  @override
  void initState() {
    super.initState();
    // Ensure the plugin is initialized after the widget build.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _flutterTts.setLanguage('en-US'); // Default language
    });
  }

  Future<void> _speak() async {
    String textToSpeak = _textController.text.trim();
    if (textToSpeak.isEmpty ) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter text to read aloud.")),
      );
      return;
    }

    String? languageCode = _languageCodes[_selectedValue];
    if (languageCode != null) {
      await _flutterTts.setLanguage(languageCode);
      await _flutterTts.speak(textToSpeak);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Selected language is not supported.")),
      );
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    _flutterTts.stop();
    super.dispose();
  }
  ///




  // String _selectedValue = 'Eng';
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade100,
      appBar: AppBar(
        backgroundColor: Color(0XFF4169E1).withValues(alpha: .76),
        leading:  CustomBackButton(
          btnColor: Colors.white,
          icon: Icons.arrow_back_ios,
          iconSize: 16,
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        title: regularText(
          title: 'Pronunciation',
          textSize: screenWidth * 0.042,
          textColor: Colors.white,
          textWeight: FontWeight.w500,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          spacing: screenWidth * 0.001,
          children: [
            Container(
              height: screenHeight *  0.45, width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
                // border: Border(bottom: BorderSide(color: Color(0XFF4169E1).withValues(alpha: .16), width: 2.7)),
                color: Colors.white,
              ),
              child: Column(
              children: [

                Row(
                  // mainAxisAlignment: MainAxisAlignment.start,
                  // spacing: 7,
                  children: [
                    6.asWidthBox,
                    Image.asset(AppImages.UKFlag, scale: 22,),
                    6.asWidthBox,
                    regularText(title: 'Eng', textSize: 16, textWeight: FontWeight.w400),
                    Spacer(),
                    CopyBtn(iconColor: Colors.black, controller: _textController),
                    ShareBtn(iconColor: Colors.black, controller: _textController),
                    DeleteBtn(iconColor: Colors.black, controller: _textController),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: TextFormField(
                    controller: _textController,
                    decoration: InputDecoration(
                      hintText: 'Type here',
                      border: InputBorder.none
                    ),
                  ),
                ),

               Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: screenWidth * 0.003,
                  children: [
                    CustomMic2(textController: _textController,),
                    7.asWidthBox,
                    CustomTextBtn(
                      height: screenHeight * 0.06,
                      width: screenWidth * 0.52,
                      textTitle: 'Pronounce',
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(topRight: Radius.circular(12), bottomRight: Radius.circular(12)),
                          color:    Color(0XFF4169E1).withValues(alpha: .76),
                      ),
                      onTap: _speak,
                    ),
                  ],
                ),
                10.asHeightBox,
              ],
            ),
            )
          ],
        ),
      ),
    );
  }
}











class CustomMic2 extends StatefulWidget {
  final TextEditingController textController;
  const CustomMic2({super.key, required this.textController});

  @override
  State<CustomMic2> createState() => _CustomMic2State();
}

class _CustomMic2State extends State<CustomMic2> {
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

  Future<void> _startListening() async {
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

    try {
      setState(() {
        _isListening = true;
        _isCooldown = true;
      });

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
      onTap: _startListening,
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
