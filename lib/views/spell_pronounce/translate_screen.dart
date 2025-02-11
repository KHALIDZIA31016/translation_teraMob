import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:country_flags/country_flags.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mnh/widgets/custom_mic.dart';
import 'package:mnh/widgets/extensions/empty_space.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:translator/translator.dart';
import '../../db_helper.dart';
import '../../translator/controller/translate_contrl.dart';
import '../../utils/app_icons.dart';
import '../../widgets/back_button.dart';
import '../../widgets/custom_textBtn.dart';
import '../../widgets/text_widget.dart';


class TranslationScreen extends StatefulWidget {
  const TranslationScreen({Key? key}) : super(key: key);

  @override
  State<TranslationScreen> createState() => _TranslationScreenState();
}

class _TranslationScreenState extends State<TranslationScreen> {
  final MyTranslationController translationController = Get.put(MyTranslationController());
  final ScrollController _scrollController = ScrollController();

  DateTime? lastTapTime;
  bool _isCooldown = false;
  bool _isTtsInProgress = false;
  bool _isTranslate = false;
  bool showTranslationContainer = false;
  @override

  Future<bool> isInternetAvailable() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }
  Future<void> handleSpeechToText(String languageCode) async {
    if (_isCooldown) {
      Fluttertoast.showToast(
        msg: "You tapped more than once. Please wait a moment.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
      return;
    }

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
      setState(() => _isCooldown = true);
      await translationController.startSpeechToText(languageCode);
    } catch (e) {
      Get.snackbar('Error', 'Speech-to-text failed. Try again.');
    } finally {
      await Future.delayed(const Duration(seconds: 1));
      setState(() => _isCooldown = false);
    }
  }
  Future<void> speakText() async {
    if (_isTtsInProgress) {
      Fluttertoast.showToast(
        msg: "TTS is already in progress. Please wait.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
      return;
    }

    try {
      setState(() => _isTtsInProgress = true);
      await translationController.speakText();
    } catch (e) {
      Get.snackbar('Error', 'TTS failed. Try again.');
    } finally {
      setState(() => _isTtsInProgress = false);
    }
  }

  void onLanguageSelected(String language) {
    if (language == 'English') {
      translationController.updateLanguage(language, "Enter your text here...");
    } else if (language == 'Urdu') {
      translationController.updateLanguage(language, "اپنا متن یہاں درج کریں...");
    } else if (language == 'French') {
      translationController.updateLanguage(language, "Entrez votre texte ici...");
    }
  }


  void  swapLanguages() {
    String temp = translationController.firstContainerLanguage.value;
    translationController.firstContainerLanguage.value = translationController.secondContainerLanguage.value;
    translationController.secondContainerLanguage.value = temp;
    print('tapped on swap icon');
  }




  void _showLanguageSelect({
    required String currentLang,
    required void Function(String?) onLangSelect,
  }){
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context){
          return Column(
            children: [
              const SizedBox(height: 10),
              Text(
                'Select the lang you want',
                style: TextStyle(
                  color: Color(0XFF4682B4),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),

              Expanded(
                child: ListView.builder(
                  itemCount: translationController.languageCodes.length,
                  itemBuilder: (context, index) {
                    String language = translationController.languageFlags.keys.elementAt(index);
                    String code = translationController.languageFlags[language]!;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.black),
                        ),
                        child: ListTile(
                          tileColor: Colors.grey.shade200,
                          title: Text(language, style: TextStyle(fontSize: 16)),
                          dense: true,
                          leading: CountryFlag.fromCountryCode(
                            code,
                            height: 25,
                            shape: Circle(),
                          ),
                          trailing: currentLang == language
                              ? Icon(Icons.check_circle, color: Colors.green, size: 20)
                              : null,
                          onTap: () {
                            onLangSelect(language);
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),

            ],
          );
        });
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _isTranslate = true;
  }

  void dispose() {
    _scrollController.dispose();
    Get.delete<MyTranslationController>(); // Dispose controller when leaving the screen
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          backgroundColor: Color(0XFFE8E8E8),
          appBar: AppBar(
            backgroundColor: Color(0XFF4169E1).withOpacity(0.76),
            leading: CustomBackButton(
              btnColor: Colors.white,
              icon: Icons.arrow_back_ios,
              iconSize: screenWidth * 0.05,
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            centerTitle: true,
            title: regularText(
              title: 'Translate language',
              textColor: Colors.white,
              textSize: screenWidth * 0.046,
              textWeight: FontWeight.w500,
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                // Country Flag and Language Selection Row
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () => _showLanguageSelect(
                          currentLang: translationController.firstContainerLanguage.value,
                          onLangSelect: (selected) {
                            setState(() {
                              translationController.firstContainerLanguage.value = selected!;
                            });
                          },
                        ),
                        child: LanguageContainer(
                          containerColor: Color(0XFF4169E1).withOpacity(0.76),
                          language: translationController.firstContainerLanguage.value,
                          countryCode: translationController.languageFlags[
                          translationController.firstContainerLanguage.value]!,
                        ),
                      ),
                      Container(
                        height: 35,
                        width: 35,
                        decoration: BoxDecoration(
                          border: Border.all(color: Color(0XFF4169E1).withOpacity(0.76), width: 2),
                          shape: BoxShape.circle,
                        ),
                        child: ColorFiltered(
                          colorFilter: ColorFilter.mode(
                              Color(0XFF4169E1).withOpacity(0.76), BlendMode.srcIn),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                swapLanguages();
                              });
                            },
                            child: Image.asset(AppIcons.convertIcon, scale: 26),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => _showLanguageSelect(
                          currentLang: translationController.secondContainerLanguage.value,
                          onLangSelect: (selected) {
                            setState(() {
                              translationController.secondContainerLanguage.value = selected!;
                            });
                          },
                        ),
                        child: LanguageContainer(
                          containerColor: Color(0XFF4169E1).withOpacity(0.76),
                          language: translationController.secondContainerLanguage.value,
                          countryCode: translationController.languageFlags[
                          translationController.secondContainerLanguage.value]!,
                        ),
                      ),
                    ],
                  ),
                ),

                _isTranslate
                    ? Padding(
                  padding: EdgeInsets.all(screenWidth * 0.02),
                  child: Container(
                    height: screenHeight * 0.38,
                    decoration: BoxDecoration(
                      color: Color(0XFFFFFFFF).withOpacity(0.6),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          child: SelectedLangShow(
                            LangColor: Colors.black,
                            containerColor: Colors.transparent,
                            language: translationController.firstContainerLanguage.value,
                            countryCode: translationController.languageFlags[
                            translationController.firstContainerLanguage.value]!,
                          ),
                        ),

                        // Text Field for Input Text
                        Expanded(
                          child: Scrollbar(
                            controller: _scrollController,
                            thumbVisibility: true,
                            child: SingleChildScrollView(
                              controller: _scrollController,
                              child: Obx(() {
                                final isSourceRTL =
                                    translationController.isRTLLanguage(
                                    translationController.firstContainerLanguage.value
                                );
                                return TextField(
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                  ),
                                  controller: translationController.controller,
                                  maxLines: null,
                                  decoration: InputDecoration(
                                    hintText: 'type text here',
                                    hintStyle: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 14,
                                    ),
                                    border: OutlineInputBorder(borderSide: BorderSide.none),
                                  ),
                                  textAlign: isSourceRTL ? TextAlign.right : TextAlign.left,
                                  textDirection: translationController.controller.value == 'Urdu' ? TextDirection.rtl : TextDirection.ltr,
                                );
                              }),
                            ),
                          ),
                        ),

                        // Mic and Button Row
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CustomMic(
                                onTap: () async {
                                  final selectedLanguageCode =
                                      '${translationController.languageCodes[
                                  translationController.firstContainerLanguage.value]}-US';
                                  await handleSpeechToText(selectedLanguageCode);
                                  String text=translationController.controller.toString();
                                  final prefs = await SharedPreferences.getInstance();
                                  prefs.setString("text",text);
                                  print("value is save${text}");

                                  // Ensure text is translated before replacing the container
                                  if (translationController.translatedText.value.isNotEmpty) {
                                    setState(() {
                                      _isTranslate = false; // Replace container only when translation is available
                                    });
                                  }
                                },
                              ),
                                10.asWidthBox,
                              CustomTextBtn(
                                height: screenHeight * 0.06,
                                width: screenWidth * 0.52,
                                transController: translationController.controller,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(12),
                                    bottomRight: Radius.circular(12),
                                  ),
                                  color: Color(0XFF4169E1).withOpacity(0.76),
                                ),
                                textTitle: 'Translate',
                                onTap: () async{
                                  try {
                                    final th = translationController.translate(
                                        translationController.controller.text);
                                    // await translationController.translatedText('$th');
                                    if (translationController.translatedText.value.isNotEmpty) {
                                      setState(() {
                                        _isTranslate = false; // Replace container only when translation is available
                                      });
                                    }
                                    print("######################## ${th}");
                                    print("######################## ${translationController.controller.text}");
                                  } catch (e) {
                                    print("######### $e");
                                  }

                                  // Open mic for speech-to-text but keep the input container visible

                                },
                              ),
                            ],
                          ),
                        ),

                      ],
                    ),
                  ),
                )
                // Translated Text Section (Results Container)
                    : Obx(() {
                  if (translationController.translatedText.value.isNotEmpty) {
                    final isRTL = translationController.isRTLLanguage(
                        translationController.firstContainerLanguage.value);
                    return Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Column(
                          spacing: 5,
                          children: [
                            // First Container (Original Text)
                            Container(
                              // margin: EdgeInsets.symmetric(horizontal: 8),
                              height: screenHeight * 0.16,
                              width: screenWidth * 0.78,
                              decoration: BoxDecoration(
                                color: Color(0XFFFFFFF9),
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(0),
                                  bottomRight: Radius.circular(0),
                                  topRight: Radius.circular(16),
                                  topLeft: Radius.circular(16),
                                ),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      GestureDetector(
                                        child: SelectedLangShow(
                                          LangColor: Colors.black,
                                          containerColor: Colors.transparent,
                                          language: translationController.firstContainerLanguage.value,
                                          countryCode: translationController.languageFlags[
                                          translationController.firstContainerLanguage.value]!,
                                        ),
                                      ),
                                      Spacer(),
                                      IconButton(
                                        icon: Icon(Icons.close, color: Colors.red, size: 22,),
                                        onPressed: () {
                                          setState(() {
                                            _isTranslate = true; // Switch back to input container
                                            translationController.controller.clear(); // Optional: Clear text
                                            translationController.translatedText.value = ''; // Reset translated text
                                          });
                                        },
                                      ),

                                    ],
                                  ),
                                  Align(
                                    alignment: isRTL ? Alignment.topRight : Alignment.topLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 16),
                                      child: Text(
                                        translationController.controller.text,
                                        textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ),


                                ],
                              ),
                            ),

                            // Second Container (Translated Text)
                            Container(
                              // margin: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              height: screenHeight * 0.18,
                              width: screenWidth * 0.78,
                              decoration: BoxDecoration(
                                color: Color(0XFFAFAFAF),
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(16),
                                  bottomRight: Radius.circular(16),
                                  topRight: Radius.circular(0),
                                  topLeft: Radius.circular(0),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  GestureDetector(
                                    child: SelectedLangShow(
                                      LangColor: Colors.black,
                                      containerColor: Colors.transparent,
                                      language: translationController.secondContainerLanguage.value,
                                      countryCode: translationController.languageFlags[
                                      translationController.secondContainerLanguage.value]!,
                                    ),
                                  ),
                                  Align(
                                    alignment: isRTL ? Alignment.topRight : Alignment.topLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 16),
                                      child: Text(
                                        translationController.translatedText.value,
                                        textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ),
                                  16.asHeightBox,
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 16),
                                        child: CircleAvatar(
                                          radius: 16,
                                          backgroundColor: Colors.white,
                                          child: IconButton(
                                            icon: const Icon(
                                              Icons.volume_up,
                                              color: Color(0XFF6082B6),
                                              size: 18,
                                            ),
                                            onPressed: speakText,
                                            tooltip: "Speak text",
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),


                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  } else {
                    return const SizedBox();
                  }
                }),

              ],
            ),
          ),
        )
    );
  }
  Widget pickCountry(String currentValue, Function(String?) onChanged) {
    return Flexible(
      child: Row(
        children: [
          GestureDetector(
            onTap: () => _showLanguageSelect(
              currentLang: translationController.firstContainerLanguage.value,
              onLangSelect: (selected) {
                setState(() {
                  translationController.firstContainerLanguage.value = selected!;
                });
              },
            ),
            child: LanguageContainer(
              containerColor: Color(0XFF4169E1).withValues(alpha: .76),
              language: translationController.firstContainerLanguage.value,
              countryCode: translationController.languageCodes[
              translationController.firstContainerLanguage.value]!,
            ),
          ),
          Container(
            height: 35, width: 35,
            decoration: BoxDecoration(
                border: Border.all(color: Color(0XFF000000).withValues(alpha: .4),width: 2),
                // color: Colors.blueGrey.shade100,
                shape: BoxShape.circle
            ),
            child: ColorFiltered(
              colorFilter: ColorFilter.mode( Color(0XFF000000).withValues(alpha: .4),
                  BlendMode.srcIn),
              child: GestureDetector(
                  onTap: () {
                    print('tapped');
                    setState(() {
                      swapLanguages();
                    });
                  },
                  child: Image.asset(AppIcons.convertIcon, scale: 26,)),
            ),
          ),
          GestureDetector(
            onTap: () => _showLanguageSelect(
              currentLang: translationController.secondContainerLanguage.value,
              onLangSelect: (selected) {
                setState(() {
                  translationController.secondContainerLanguage.value = selected!;
                });
              },
            ),
            child: LanguageContainer(
              containerColor: Color(0XFF4169E1).withValues(alpha: .76),
              language: translationController.secondContainerLanguage.value,
              countryCode: translationController.languageCodes[
              translationController.secondContainerLanguage.value]!,
            ),
          ),
        ],
      ),
    );
  }
}

class LanguageContainer extends StatelessWidget {
  final String language;
  final String countryCode;
  final Color containerColor;

  const LanguageContainer({
    required this.language,
    required this.countryCode,
    required this.containerColor,
  });

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth  = MediaQuery.of(context).size.width;
    return Container(
      height: screenHeight * 0.07,
      width: screenWidth * 0.4,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: containerColor
      ),
      child: Row(
        spacing: 10,
        children: [
          10.asWidthBox,
          CountryFlag.fromCountryCode(
            countryCode,
            height: 26,
            width: 26,
            shape: Circle(),
          ),
          Text(
            language,
            style: TextStyle(color: Colors.white, fontSize: screenWidth * 0.04),
          ),
          Icon(Icons.arrow_drop_down_outlined, color: Colors.white),
        ],
      ),
    );
  }
}



class SelectedLangShow extends StatelessWidget {
  final String language;
  final String countryCode;
  final Color containerColor;
  final Color? LangColor;

  const SelectedLangShow({
    required this.language,
    required this.countryCode,
    required this.containerColor,
    this.LangColor,
  });

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth  = MediaQuery.of(context).size.width;
    return Container(
      height: screenHeight * 0.07,
      width: screenWidth * 0.4,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: containerColor
      ),
      child: Row(
        spacing: 10,
        children: [
          2.asWidthBox,
          CountryFlag.fromCountryCode(
            countryCode,
            height: 26,
            width: 26,
            shape: Circle(),
          ),
          Text(
            language,
            style: TextStyle(color: LangColor ?? Colors.white, fontSize: screenWidth * 0.04),
          ),
        ],
      ),
    );
  }
}







/// nos


