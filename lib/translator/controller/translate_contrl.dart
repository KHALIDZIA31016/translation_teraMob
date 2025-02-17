import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:translator/translator.dart';
///
import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:country_flags/country_flags.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mnh/widgets/extensions/empty_space.dart';
import '../../utils/app_icons.dart';
import '../../widgets/back_button.dart';
import '../../widgets/text_widget.dart';
import '../controller/translate_contrl.dart';


class MyTranslationController extends GetxController {
  RxString firstContainerLanguage = "English".obs;
  RxString secondContainerLanguage = "Spanish".obs;
  RxString translatedText = "".obs;
  RxBool isListening = false.obs;
  RxBool isLoading = false.obs;
  final pitch = 0.5.obs;
  final speed = 0.5.obs;
  final isSpeechPlaying = false.obs;
  var selectedLanguage = 'English'.obs; // Holds selected language

  void updateLanguage(String language, String translatedHint) {
    selectedLanguage.value = language;
    translatedText.value = translatedHint;
  }
  @override
  void onInit() {
    super.onInit();
  }
  @override
  void onClose() {

    super.onClose();
  }
  TextEditingController controller = TextEditingController();
  final translator = GoogleTranslator();
  FlutterTts flutterTts = FlutterTts();

  final Map<String, String> languageCodes = {
    'English': 'en',       // English
    'Urdu': 'ur',          // Urdu
    'Hindi': 'hi',         // Hindi
    'Arabic': 'ar',        // Arabic
    'Punjabi': 'pa',       // Punjabi
    'Marathi': 'mr',       // Marathi
    'French': 'fr',        // French
    'Spanish': 'es',       // Spanish
    'Afrikaans': 'af',     // Afrikaans
    'Albanian': 'sq',      // Albanian
    'Amharic': 'am',       // Amharic
    'Armenian': 'hy',      // Armenian
    'Azerbaijani': 'az',   // Azerbaijani
    'Basque': 'eu',        // Basque
    'Belarusian': 'be',    // Belarusian
    'Bengali': 'bn',       // Bengali
    'Bosnian': 'bs',       // Bosnian
    'Bulgarian': 'bg',     // Bulgarian
    'Catalan': 'ca',       // Catalan
    'Cebuano': 'ceb',      // Cebuano
    'ChineseSimplified': 'zh-Hans',  // Chinese Simplified
    'ChineseTraditional': 'zh-Hant', // Chinese Traditional
    'Croatian': 'hr',      // Croatian
    'Czech': 'cs',         // Czech
    'Danish': 'da',        // Danish
    'Dutch': 'nl',         // Dutch
    'Esperanto': 'eo',     // Esperanto
    'Estonian': 'et',      // Estonian
    'Finnish': 'fi',       // Finnish
    'Frisian': 'fy',       // Frisian
    'Galician': 'gl',      // Galician
    'Georgian': 'ka',      // Georgian
    'German': 'de',        // German
    'Greek': 'el',         // Greek
    'Gujarati': 'gu',      // Gujarati
    'Haitian': 'ht',       // Haitian
    'Hausa': 'ha',         // Hausa
    'Hawaiian': 'haw',     // Hawaiian
    'Hebrew': 'he',        // Hebrew
    'Hmong': 'hmn',        // Hmong
    'Hungarian': 'hu',     // Hungarian
    'Icelandic': 'is',     // Icelandic
    'Indonesian': 'id',    // Indonesian
    'Irish': 'ga',         // Irish
    'Italian': 'it',       // Italian
    'Japanese': 'ja',      // Japanese
    'Javanese': 'jv',      // Javanese
    'Kannada': 'kn',       // Kannada
    'Kazakh': 'kk',        // Kazakh
    'Khmer': 'km',         // Khmer
    'KoreanNK': 'ko',      // Korean (North Korea)
    'KoreanSK': 'ko',      // Korean (South Korea)
    'Kurdish': 'ku',       // Kurdish
    'Kyrgyz': 'ky',        // Kyrgyz
    'Lao': 'lo',           // Lao
    'Latin': 'la',         // Latin
    'Latvian': 'lv',       // Latvian
    'Lithuanian': 'lt',    // Lithuanian
    'Luxembourgish': 'lb', // Luxembourgish
    'Macedonian': 'mk',    // Macedonian
    'Malagasy': 'mg',      // Malagasy
    'Malay': 'ms',         // Malay
    'Malayalam': 'ml',     // Malayalam
    'Maltese': 'mt',       // Maltese
    'Maori': 'mi',         // Maori
    'Marathi': 'mr',       // Marathi
    'Mongolian': 'mn',     // Mongolian
    'MyanmarBurmese': 'my',// Myanmar/Burmese
    'Nepali': 'ne',        // Nepali
    'Norwegian': 'no',     // Norwegian
    'NyanjaChichewa': 'ny',// Nyanja/Chichewa
    'Pashto': 'ps',        // Pashto
    'Persian': 'fa',       // Persian
    'Polish': 'pl',        // Polish
    'Portuguese': 'pt',    // Portuguese
    'Punjabi': 'pa',       // Punjabi
    'Romanian': 'ro',      // Romanian
    'Russian': 'ru',       // Russian
    'Samoan': 'sm',        // Samoan
    'ScotsGaelic': 'gd',   // Scots Gaelic
    'Serbian': 'sr',       // Serbian
    'Sesotho': 'st',       // Sesotho
    'Shona': 'sn',         // Shona
    'Sindhi': 'sd',        // Sindhi
    'Sinhala': 'si',       // Sinhala
    'Slovak': 'sk',        // Slovak
    'Slovenian': 'sl',     // Slovenian
    'Somali': 'so',        // Somali
    'Swahili': 'sw',       // Swahili
    'Swedish': 'sv',       // Swedish
    'Tagalog': 'tl',       // Tagalog
    'Tajik': 'tg',         // Tajik
    'Tamil': 'ta',         // Tamil
    'Telugu': 'te',        // Telugu
    'Thai': 'th',          // Thai
    'Turkish': 'tr',       // Turkish
    'Ukrainian': 'uk',     // Ukrainian
    'Urdu': 'ur',          // Urdu
    'Uzbek': 'uz',         // Uzbek
    'Vietnamese': 'vi',    // Vietnamese
    'Welsh': 'cy',         // Welsh
    'Xhosa': 'xh',         // Xhosa
    'Yiddish': 'yi',       // Yiddish
    'Yoruba': 'yo',        // Yoruba
    'Zulu': 'zu',          // Zulu
  };
  final Map<String, String> languageFlags = {
    'English': 'US',       // English (United States)
    'Urdu': 'PK',          // Urdu (Pakistan)
    'Hindi': 'IN',         // Hindi (India)
    'Arabic': 'AE',        // Arabic (UAE)
    'Punjabi': 'PK',       // Punjabi (Pakistan)
    'Marathi': 'IN',       // Marathi (India)
    'French': 'FR',        // French (France)
    'Spanish': 'ES',       // Spanish (Spain)
    'Afrikaans': 'ZA',     // Afrikaans (South Africa)
    'Albanian': 'AL',      // Albanian (Albania)
    'Amharic': 'ET',       // Amharic (Ethiopia)
    'Armenian': 'AM',      // Armenian (Armenia)
    'Azerbaijani': 'AZ',   // Azerbaijani (Azerbaijan)
    'Basque': 'ES',        // Basque (Spain)
    'Belarusian': 'BY',    // Belarusian (Belarus)
    'Bengali': 'BD',       // Bengali (Bangladesh)
    'Bosnian': 'BA',       // Bosnian (Bosnia and Herzegovina)
    'Bulgarian': 'BG',     // Bulgarian (Bulgaria)
    'Catalan': 'ES',       // Catalan (Spain)
    'Cebuano': 'PH',       // Cebuano (Philippines)
    'ChineseSimplified': 'CN',  // Chinese Simplified (China)
    'ChineseTraditional': 'TW', // Chinese Traditional (Taiwan)
    'Croatian': 'HR',      // Croatian (Croatia)
    'Czech': 'CZ',         // Czech (Czech Republic)
    'Danish': 'DK',        // Danish (Denmark)
    'Dutch': 'NL',         // Dutch (Netherlands)
    'Esperanto': 'ZZ',     // Esperanto (International)
    'Estonian': 'EE',      // Estonian (Estonia)
    'Finnish': 'FI',       // Finnish (Finland)
    'Frisian': 'NL',       // Frisian (Netherlands)
    'Galician': 'ES',      // Galician (Spain)
    'Georgian': 'GE',      // Georgian (Georgia)
    'German': 'DE',        // German (Germany)
    'Greek': 'GR',         // Greek (Greece)
    'Gujarati': 'IN',      // Gujarati (India)
    'Haitian': 'HT',       // Haitian (Haiti)
    'Hausa': 'NG',         // Hausa (Nigeria)
    'Hawaiian': 'US',      // Hawaiian (United States)
    'Hebrew': 'IL',        // Hebrew (Israel)
    'Hmong': 'US',         // Hmong (United States)
    'Hungarian': 'HU',     // Hungarian (Hungary)
    'Icelandic': 'IS',     // Icelandic (Iceland)
    'Indonesian': 'ID',    // Indonesian (Indonesia)
    'Irish': 'IE',         // Irish (Ireland)
    'Italian': 'IT',       // Italian (Italy)
    'Japanese': 'JP',      // Japanese (Japan)
    'Javanese': 'ID',      // Javanese (Indonesia)
    'Kannada': 'IN',       // Kannada (India)
    'Kazakh': 'KZ',        // Kazakh (Kazakhstan)
    'Khmer': 'KH',         // Khmer (Cambodia)
    'KoreanNK': 'KP',      // Korean (North Korea)
    'KoreanSK': 'KR',      // Korean (South Korea)
    'Kurdish': 'TR',       // Kurdish (Turkey)
    'Kyrgyz': 'KG',        // Kyrgyz (Kyrgyzstan)
    'Lao': 'LA',           // Lao (Laos)
    'Latin': 'ZZ',         // Latin (International)
    'Latvian': 'LV',       // Latvian (Latvia)
    'Lithuanian': 'LT',    // Lithuanian (Lithuania)
    'Luxembourgish': 'LU', // Luxembourgish (Luxembourg)
    'Macedonian': 'MK',    // Macedonian (North Macedonia)
    'Malagasy': 'MG',      // Malagasy (Madagascar)
    'Malay': 'MY',         // Malay (Malaysia)
    'Malayalam': 'IN',     // Malayalam (India)
    'Maltese': 'MT',       // Maltese (Malta)
    'Maori': 'NZ',         // Maori (New Zealand)
    'Marathi': 'IN',       // Marathi (India)
    'Mongolian': 'MN',     // Mongolian (Mongolia)
    'MyanmarBurmese': 'MM',// Myanmar/Burmese (Myanmar)
    'Nepali': 'NP',        // Nepali (Nepal)
    'Norwegian': 'NO',     // Norwegian (Norway)
    'NyanjaChichewa': 'MW',// Nyanja/Chichewa (Malawi)
    'Pashto': 'AF',        // Pashto (Afghanistan)
    'Persian': 'IR',       // Persian (Iran)
    'Polish': 'PL',        // Polish (Poland)
    'Portuguese': 'PT',    // Portuguese (Portugal)
    'Punjabi': 'PK',       // Punjabi (Pakistan)
    'Romanian': 'RO',      // Romanian (Romania)
    'Russian': 'RU',       // Russian (Russia)
    'Samoan': 'WS',        // Samoan (Samoa)
    'ScotsGaelic': 'GB',   // Scots Gaelic (United Kingdom)
    'Serbian': 'RS',       // Serbian (Serbia)
    'Sesotho': 'ZA',       // Sesotho (South Africa)
    'Shona': 'ZW',         // Shona (Zimbabwe)
    'Sindhi': 'PK',        // Sindhi (Pakistan)
    'Sinhala': 'LK',       // Sinhala (Sri Lanka)
    'Slovak': 'SK',        // Slovak (Slovakia)
    'Slovenian': 'SI',     // Slovenian (Slovenia)
    'Somali': 'SO',        // Somali (Somalia)
    'Swahili': 'KE',       // Swahili (Kenya)
    'Swedish': 'SE',       // Swedish (Sweden)
    'Tagalog': 'PH',       // Tagalog (Philippines)
    'Tajik': 'TJ',         // Tajik (Tajikistan)
    'Tamil': 'IN',         // Tamil (India)
    'Telugu': 'IN',        // Telugu (India)
    'Thai': 'TH',          // Thai (Thailand)
    'Turkish': 'TR',       // Turkish (Turkey)
    'Ukrainian': 'UA',     // Ukrainian (Ukraine)
    'Urdu': 'PK',          // Urdu (Pakistan)
    'Uzbek': 'UZ',         // Uzbek (Uzbekistan)
    'Vietnamese': 'VN',    // Vietnamese (Vietnam)
    'Welsh': 'GB',         // Welsh (United Kingdom)
    'Xhosa': 'ZA',         // Xhosa (South Africa)
    'Yiddish': 'IL',       // Yiddish (Israel)
    'Yoruba': 'NG',        // Yoruba (Nigeria)
    'Zulu': 'ZA',          // Zulu (South Africa)

  };


  final List<String> _rtlLanguages = ['ar', 'he', 'ur', 'fa'];
  bool isRTLLanguage(String language) {
    final languageCode = languageCodes[language] ?? 'en';
    return _rtlLanguages.contains(languageCode);
  }
  static const MethodChannel _methodChannel =
  MethodChannel('com.example.mnh/speech_Text');

  Future<void> WriteSpeechToText(String languageISO) async {
    try {
      isListening.value = true;
      final result = await _methodChannel.invokeMethod('getTextFromSpeech', {'languageISO': languageISO});

      if (result != null && result.isNotEmpty) {
        controller.text = result;
        await handleUserActionTranslate(result);
      }
    } on PlatformException catch (e) {
    }
  }

  Future<void> startSpeechToText(String languageISO) async {
    try {
      isListening.value = true;
      final result = await _methodChannel.invokeMethod('getTextFromSpeech', {'languageISO': languageISO});

      if (result != null && result.isNotEmpty) {
        controller.text = result;
        await handleUserActionTranslate(result);
      }
    } on PlatformException catch (e) {
      print("Speech-to-text error: ${e.toString()}");
    }
  }



  Future<void> speakText() async {
    try {
      await flutterTts.setEngine('com.google.android.tts');
      final Map<String, String> languageCodes = {
        'English': 'en-US',      // English (United States)
        'Urdu': 'ur-PK',         // Urdu (Pakistan)
        'Hindi': 'hi-IN',        // Hindi (India)
        'Arabic': 'ar',          // Arabic
        'Punjabi': 'pa-IN',      // Punjabi (India)
        'Marathi': 'mr-IN',      // Marathi (India)
        'French': 'fr-FR',       // French (France)
        'Spanish': 'es-ES',      // Spanish (Spain)
        'Afrikaans': 'af',       // Afrikaans
        'Albanian': 'sq',        // Albanian
        'Amharic': 'am',         // Amharic
        'Armenian': 'hy',        // Armenian
        'Azerbaijani': 'az',     // Azerbaijani
        'Basque': 'eu',          // Basque
        'Belarusian': 'be',      // Belarusian
        'Bengali': 'bn',         // Bengali
        'Bosnian': 'bs',         // Bosnian
        'Bulgarian': 'bg',       // Bulgarian
        'Catalan': 'ca',         // Catalan
        'Cebuano': 'ceb',        // Cebuano
        'ChineseSimplified': 'zh-Hans',  // Chinese Simplified
        'ChineseTraditional': 'zh-Hant', // Chinese Traditional
        'Croatian': 'hr',        // Croatian
        'Czech': 'cs',           // Czech
        'Danish': 'da',          // Danish
        'Dutch': 'nl',           // Dutch
        'Esperanto': 'eo',       // Esperanto
        'Estonian': 'et',        // Estonian
        'Finnish': 'fi',         // Finnish
        'Frisian': 'fy',         // Frisian
        'Galician': 'gl',        // Galician
        'Georgian': 'ka',        // Georgian
        'German': 'de',          // German
        'Greek': 'el',           // Greek
        'Gujarati': 'gu',        // Gujarati
        'Haitian': 'ht',         // Haitian
        'Hausa': 'ha',           // Hausa
        'Hawaiian': 'haw',       // Hawaiian
        'Hebrew': 'he',          // Hebrew
        'Hmong': 'hmn',          // Hmong
        'Hungarian': 'hu',       // Hungarian
        'Icelandic': 'is',       // Icelandic
        'Indonesian': 'id',      // Indonesian
        'Irish': 'ga',           // Irish
        'Italian': 'it',         // Italian
        'Japanese': 'ja',        // Japanese
        'Javanese': 'jv',        // Javanese
        'Kannada': 'kn',         // Kannada
        'Kazakh': 'kk',          // Kazakh
        'Khmer': 'km',           // Khmer
        'KoreanNK': 'ko',        // Korean (North Korea)
        'KoreanSK': 'ko',        // Korean (South Korea)
        'Kurdish': 'ku',         // Kurdish
        'Kyrgyz': 'ky',          // Kyrgyz
        'Lao': 'lo',             // Lao
        'Latin': 'la',           // Latin
        'Latvian': 'lv',         // Latvian
        'Lithuanian': 'lt',      // Lithuanian
        'Luxembourgish': 'lb',   // Luxembourgish
        'Macedonian': 'mk',      // Macedonian
        'Malagasy': 'mg',        // Malagasy
        'Malay': 'ms',           // Malay
        'Malayalam': 'ml',       // Malayalam
        'Maltese': 'mt',         // Maltese
        'Maori': 'mi',           // Maori
        'Marathi': 'mr',         // Marathi
        'Mongolian': 'mn',       // Mongolian
        'MyanmarBurmese': 'my',  // Myanmar/Burmese
        'Nepali': 'ne',          // Nepali
        'Norwegian': 'no',       // Norwegian
        'NyanjaChichewa': 'ny',  // Nyanja/Chichewa
        'Pashto': 'ps',          // Pashto
        'Persian': 'fa',         // Persian
        'Polish': 'pl',          // Polish
        'Portuguese': 'pt',      // Portuguese
        'Punjabi': 'pa',         // Punjabi
        'Romanian': 'ro',        // Romanian
        'Russian': 'ru',         // Russian
        'Samoan': 'sm',          // Samoan
        'ScotsGaelic': 'gd',     // Scots Gaelic
        'Serbian': 'sr',         // Serbian
        'Sesotho': 'st',         // Sesotho
        'Shona': 'sn',           // Shona
        'Sindhi': 'sd',          // Sindhi
        'Sinhala': 'si',         // Sinhala
        'Slovak': 'sk',          // Slovak
        'Slovenian': 'sl',       // Slovenian
        'Somali': 'so',          // Somali
        'Swahili': 'sw',         // Swahili
        'Swedish': 'sv',         // Swedish
        'Tagalog': 'tl',         // Tagalog
        'Tajik': 'tg',           // Tajik
        'Tamil': 'ta',           // Tamil
        'Telugu': 'te',          // Telugu
        'Thai': 'th',            // Thai
        'Turkish': 'tr',         // Turkish
        'Ukrainian': 'uk',       // Ukrainian
        'Urdu': 'ur',            // Urdu
        'Uzbek': 'uz',           // Uzbek
        'Vietnamese': 'vi',      // Vietnamese
        'Welsh': 'cy',           // Welsh
        'Xhosa': 'xh',           // Xhosa
        'Yiddish': 'yi',         // Yiddish
        'Yoruba': 'yo',          // Yoruba
        'Zulu': 'zu',            // Zulu
      };


      String selectedLanguageCode = languageCodes[secondContainerLanguage.value] ?? 'en-US';

      await flutterTts.setLanguage(selectedLanguageCode);
      await flutterTts.setPitch(pitch.value);
      await flutterTts.setSpeechRate(speed.value);
      if (translatedText.value.isNotEmpty) {
        await flutterTts.speak(translatedText.value);
        print("############# Speaking in $selectedLanguageCode: ${translatedText.value}");
      } else {
        Get.snackbar("Error", "No text available to speak.");
      }
    } catch (e) {
      print("########## Error in TTS: ${e.toString()}");
      Get.snackbar("############# Error", "TTS failed: ${e.toString()}");
    }
  }

  Future<void> handleUserActionTranslate(String text) async {
    await translate(text); // Proceed with translation once the ad is closed
    await speakText(); // Automatically speak after translation
  }

  void onTranslateButtonPressed() async {

    final textToTranslate = controller.text;
    if (textToTranslate.isEmpty) {
      Get.snackbar("Error", "Please enter text to translate.");
      return;
    }
  }

  // Future<void> translate(String text) async {
  //   if (text.isEmpty) {
  //     translatedText.value = "Please enter text to translate.";
  //     return;
  //   }
  //
  //   isLoading.value = true;
  //   try {
  //     final sourceLang = languageCodes[firstContainerLanguage.value] ?? 'en';
  //     final targetLang = languageCodes[secondContainerLanguage.value] ?? 'es';
  //
  //     final result = await translator.translate(text, from: sourceLang, to: targetLang);
  //
  //     print("#######er####### result: $result");
  //
  //     translatedText.value = result.text;
  //   } catch (e) {
  //     translatedText.value = "Translation failed: ${e.toString()}";
  //     print("################ No found the above content");
  //
  //   } finally {
  //     isLoading.value = false;
  //     print("############## something went wrong");
  //
  //   }
  //
  //
  //
  // }
  Future<void> translate(String text) async {
    if (text.isEmpty) {
      translatedText.value = firstContainerLanguage.value == 'Urdu' ? "یہاں متن لکھیں" : "Please enter text to translate.";
      return;
    }

    isLoading.value = true;
    try {
      final sourceLang = languageCodes[firstContainerLanguage.value] ?? 'en';
      final targetLang = languageCodes[secondContainerLanguage.value] ?? 'es';
      final result = await translator.translate(text, from: sourceLang, to: targetLang);
      translatedText.value = result.text;
    } catch (e) {
      translatedText.value = "Translation failed: ${e.toString()}";
    } finally {
      isLoading.value = false;
    }
  }

  }