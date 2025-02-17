import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:mnh/translator/controller/translate_contrl.dart';
import 'package:mnh/utils/app_icons.dart';
import 'package:mnh/views/spell_pronounce/pronunciation_screen.dart';
import 'package:mnh/views/spell_pronounce/translate_screen.dart';
import 'package:mnh/widgets/back_button.dart';
import 'package:mnh/widgets/custom_mic.dart';
import 'package:mnh/widgets/custom_textBtn.dart';
import 'package:mnh/widgets/extensions/empty_space.dart';
import 'package:mnh/widgets/text_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:translator/translator.dart';

class InputScreen extends StatefulWidget {
  @override
  _InputScreenState createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  final MyTranslationController translationController =
  Get.put(MyTranslationController());
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _controller = TextEditingController();
  final translator = GoogleTranslator();
  final FlutterTts flutterTts=FlutterTts();


  List<Map<String, String>> storedValues = [];

  bool showResults = true; // Controls visibility of results
  String originalLanguage = 'en';
  String translatedLanguage = 'ar';
  String lastEnteredText = ''; // Stores the last entered text
  bool _isTranslate = false;
  bool isTapped = false;
  //
  // final Map<String, String> languageFlags = {
  //   'English': 'US',       // English (United States)
  //   'Urdu': 'PK',          // Urdu (Pakistan)
  //   'Hindi': 'IN',         // Hindi (India)
  //   'Arabic': 'AE',        // Arabic (UAE)
  //   'Punjabi': 'PK',       // Punjabi (Pakistan)
  //   'Marathi': 'IN',       // Marathi (India)
  //   'French': 'FR',        // French (France)
  //   'Spanish': 'ES',       // Spanish (Spain)
  //   'Afrikaans': 'ZA',     // Afrikaans (South Africa)
  //   'Albanian': 'AL',      // Albanian (Albania)
  //   'Amharic': 'ET',       // Amharic (Ethiopia)
  //   'Armenian': 'AM',      // Armenian (Armenia)// Zulu (South Africa)
  //
  // };
  /// prev above new below
  // final Map<String, String> languageFlags = {
  //   'English': 'US',       // English (United States)
  //   'Afrikaans': 'ZA',     // Afrikaans (South Africa)
  //   'Albanian': 'AL',      // Albanian (Albania)
  //   'Amharic': 'ET',       // Amharic (Ethiopia)
  //   'Arabic': 'SA',        // Arabic (Saudi Arabia)
  //   'Armenian': 'AM',      // Armenian (Armenia)
  //   'Azerbaijani': 'AZ',   // Azerbaijani (Azerbaijan)
  //   'Basque': 'ES',        // Basque (Spain)
  //   'Belarusian': 'BY',    // Belarusian (Belarus)
  //   'Bengali': 'IN',       // Bengali (India)
  //   'Bosnian': 'BA',       // Bosnian (Bosnia and Herzegovina)
  //   'Bulgarian': 'BG',     // Bulgarian (Bulgaria)
  //   'Catalan': 'ES',       // Catalan (Spain)
  //   'Cebuano': 'PH',       // Cebuano (Philippines)
  //   'Chinese Simplified': 'CN',  // Chinese Simplified (China)
  //   'Chinese Traditional': 'TW', // Chinese Traditional (Taiwan)
  //   'Croatian': 'HR',      // Croatian (Croatia)
  //   'Czech': 'CZ',         // Czech (Czech Republic)
  //   'Danish': 'DK',        // Danish (Denmark)
  //   'Dutch': 'NL',         // Dutch (Netherlands)
  //   'Esperanto': 'EO',     // Esperanto (International)
  //   'Estonian': 'EE',      // Estonian (Estonia)
  //   'Finnish': 'FI',       // Finnish (Finland)
  //   'French': 'FR',        // French (France)
  //   'Frisian': 'NL',       // Frisian (Netherlands)
  //   'Galician': 'ES',      // Galician (Spain)
  //   'Georgian': 'GE',      // Georgian (Georgia)
  //   'German': 'DE',        // German (Germany)
  //   'Greek': 'GR',         // Greek (Greece)
  //   'Gujarati': 'IN',      // Gujarati (India)
  //   'Haitian': 'HT',       // Haitian Creole (Haiti)
  //   'Hausa': 'NG',         // Hausa (Nigeria)
  //   'Hawaiian': 'US',      // Hawaiian (United States)
  //   'Hebrew': 'IL',        // Hebrew (Israel)
  //   'Hindi': 'IN',         // Hindi (India)
  //   'Hmong': 'CN',         // Hmong (China)
  //   'Hungarian': 'HU',     // Hungarian (Hungary)
  //   'Icelandic': 'IS',     // Icelandic (Iceland)
  //   'Indonesian': 'ID',    // Indonesian (Indonesia)
  //   'Irish': 'IE',         // Irish (Ireland)
  //   'Italian': 'IT',       // Italian (Italy)
  //   'Japanese': 'JP',      // Japanese (Japan)
  //   'Javanese': 'ID',      // Javanese (Indonesia)
  //   'Kannada': 'IN',       // Kannada (India)
  //   'Kazakh': 'KZ',        // Kazakh (Kazakhstan)
  //   'Khmer': 'KH',         // Khmer (Cambodia)
  //   'Korean NK': 'KP',     // Korean (North Korea)
  //   'Korean SK': 'KR',     // Korean (South Korea)
  //   'Kurdish': 'TR',       // Kurdish (Turkey)
  //   'Kyrgyz': 'KG',        // Kyrgyz (Kyrgyzstan)
  //   'Lao': 'LA',           // Lao (Laos)
  //   'Latin': 'VA',         // Latin (Vatican City)
  //   'Latvian': 'LV',       // Latvian (Latvia)
  //   'Lithuanian': 'LT',    // Lithuanian (Lithuania)
  //   'Luxembourgish': 'LU', // Luxembourgish (Luxembourg)
  //   'Macedonian': 'MK',    // Macedonian (North Macedonia)
  //   'Malagasy': 'MG',      // Malagasy (Madagascar)
  //   'Malay': 'MY',         // Malay (Malaysia)
  //   'Malayalam': 'IN',     // Malayalam (India)
  //   'Maltese': 'MT',       // Maltese (Malta)
  //   'Maori': 'NZ',         // Maori (New Zealand)
  //   'Marathi': 'IN',       // Marathi (India)
  //   'Mongolian': 'MN',     // Mongolian (Mongolia)
  //   'Myanmar Burmese': 'MM', // Burmese (Myanmar)
  //   'Nepali': 'NP',        // Nepali (Nepal)
  //   'Norwegian': 'NO',     // Norwegian (Norway)
  //   'Nyanja Chichewa': 'MW', // Chichewa (Malawi)
  //   'Pashto': 'AF',        // Pashto (Afghanistan)
  //   'Persian': 'IR',       // Persian (Iran)
  //   'Polish': 'PL',        // Polish (Poland)
  //   'Portuguese': 'PT',    // Portuguese (Portugal)
  //   'Punjabi': 'PK',       // Punjabi (Pakistan)
  //   'Romanian': 'RO',      // Romanian (Romania)
  //   'Russian': 'RU',       // Russian (Russia)
  //   'Samoan': 'WS',        // Samoan (Samoa)
  //   'Scots Gaelic': 'GB',  // Scots Gaelic (United Kingdom)
  //   'Serbian': 'RS',       // Serbian (Serbia)
  //   'Sesotho': 'ZA',       // Sesotho (South Africa)
  //   'Shona': 'ZW',         // Shona (Zimbabwe)
  //   'Sindhi': 'PK',        // Sindhi (Pakistan)
  //   'Sinhala': 'LK',       // Sinhala (Sri Lanka)
  //   'Slovak': 'SK',        // Slovak (Slovakia)
  //   'Slovenian': 'SI',     // Slovenian (Slovenia)
  //   'Somali': 'SO',        // Somali (Somalia)
  //   'Spanish': 'ES',       // Spanish (Spain)
  //   'Sundanese': 'ID',     // Sundanese (Indonesia)
  //   'Swahili': 'KE',       // Swahili (Kenya)
  //   'Swedish': 'SE',       // Swedish (Sweden)
  //   'Tagalog': 'PH',       // Tagalog (Philippines)
  //   'Tajik': 'TJ',         // Tajik (Tajikistan)
  //   'Tamil': 'IN',         // Tamil (India)
  //   'Telugu': 'IN',        // Telugu (India)
  //   'Thai': 'TH',          // Thai (Thailand)
  //   'Turkish': 'TR',       // Turkish (Turkey)
  //   'Ukrainian': 'UA',     // Ukrainian (Ukraine)
  //   'Urdu': 'PK',          // Urdu (Pakistan)
  //   'Uzbek': 'UZ',         // Uzbek (Uzbekistan)
  //   'Vietnamese': 'VN',    // Vietnamese (Vietnam)
  //   'Welsh': 'GB',         // Welsh (United Kingdom)
  //   'Xhosa': 'ZA',         // Xhosa (South Africa)
  //   'Yiddish': 'IL',       // Yiddish (Israel)
  //   'Yoruba': 'NG',        // Yoruba (Nigeria)
  //   'Zulu': 'ZA',          // Zulu (South Africa)
  // };
  final FlutterTts _flutterTts = FlutterTts();
  String _selectedValue = 'English';
  final Map<String, String> _languageCodes = {
    'English': 'en-US',
    'Afrikaans': 'af-ZA',
    'Albanian': 'sq-AL',
    'Amharic': 'am-ET',
    'Arabic': 'ar-SA',
    'Armenian': 'hy-AM',
    'Azerbaijani': 'az-AZ',
    'Basque': 'eu-ES',
    'Belarusian': 'be-BY',
    'Bengali': 'bn-IN',
    'Bosnian': 'bs-BA',
    'Bulgarian': 'bg-BG',
    'Catalan': 'ca-ES',
    'Cebuano': 'ceb-PH',
    'Chinese Simplified': 'zh-CN',
    'Chinese Traditional': 'zh-TW',
    'Croatian': 'hr-HR',
    'Czech': 'cs-CZ',
    'Danish': 'da-DK',
    'Dutch': 'nl-NL',
    'Esperanto': 'eo',
    'Estonian': 'et-EE',
    'Finnish': 'fi-FI',
    'French': 'fr-FR',
    'Frisian': 'fy-NL',
    'Galician': 'gl-ES',
    'Georgian': 'ka-GE',
    'German': 'de-DE',
    'Greek': 'el-GR',
    'Gujarati': 'gu-IN',
    'Haitian': 'ht-HT',
    'Hausa': 'ha-NG',
    'Hawaiian': 'haw-US',
    'Hebrew': 'he-IL',
    'Hindi': 'hi-IN',
    'Hmong': 'hmn',
    'Hungarian': 'hu-HU',
    'Icelandic': 'is-IS',
    'Indonesian': 'id-ID',
    'Irish': 'ga-IE',
    'Italian': 'it-IT',
    'Japanese': 'ja-JP',
    'Javanese': 'jv-ID',
    'Kannada': 'kn-IN',
    'Kazakh': 'kk-KZ',
    'Khmer': 'km-KH',
    'Korean NK': 'ko-KP',
    'Korean SK': 'ko-KR',
    'Kurdish': 'ku-TR',
    'Kyrgyz': 'ky-KG',
    'Lao': 'lo-LA',
    'Latin': 'la',
    'Latvian': 'lv-LV',
    'Lithuanian': 'lt-LT',
    'Luxembourgish': 'lb-LU',
    'Macedonian': 'mk-MK',
    'Malagasy': 'mg-MG',
    'Malay': 'ms-MY',
    'Malayalam': 'ml-IN',
    'Maltese': 'mt-MT',
    'Maori': 'mi-NZ',
    'Marathi': 'mr-IN',
    'Mongolian': 'mn-MN',
    'Myanmar Burmese': 'my-MM',
    'Nepali': 'ne-NP',
    'Norwegian': 'no-NO',
    'Nyanja Chichewa': 'ny-MW',
    'Pashto': 'ps-AF',
    'Persian': 'fa-IR',
    'Polish': 'pl-PL',
    'Portuguese': 'pt-PT',
    'Punjabi': 'pa-IN',
    'Romanian': 'ro-RO',
    'Russian': 'ru-RU',
    'Samoan': 'sm-AS',
    'Scots Gaelic': 'gd-GB',
    'Serbian': 'sr-RS',
    'Sesotho': 'st-ZA',
    'Shona': 'sn-ZW',
    'Sindhi': 'sd-PK',
    'Sinhala': 'si-LK',
    'Slovak': 'sk-SK',
    'Slovenian': 'sl-SI',
    'Somali': 'so-KE',
    'Spanish': 'es-ES',
    'Sundanese': 'su-ID',
    'Swahili': 'sw-KE',
    'Swedish': 'sv-SE',
    'Tagalog': 'tl-PH',
    'Tajik': 'tg-TJ',
    'Tamil': 'ta-IN',
    'Telugu': 'te-IN',
    'Thai': 'th-TH',
    'Turkish': 'tr-TR',
    'Ukrainian': 'uk-UA',
    'Urdu': 'ur-PK',
    'Uzbek': 'uz-UZ',
    'Vietnamese': 'vi-VN',
    'Welsh': 'cy-GB',
    'Xhosa': 'xh-ZA',
    'Yiddish': 'yi',
    'Yoruba': 'yo-NG',
    'Zulu': 'zu-ZA',
  };

  Future<void> speak(String textVol) async {
    String? languageCode = _languageCodes[_selectedValue];

    if (languageCode != null) {
      try {
        // Check if the language is available on the device
        final List<dynamic> availableLanguages = await _flutterTts.getLanguages;
        if (availableLanguages.contains(languageCode)) {
          await _flutterTts.setLanguage(languageCode);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(
                    "Language not supported on this device. Using default language.")),
          );
          languageCode = 'en-US'; // Fallback to English
          await _flutterTts.setLanguage(languageCode);
        }

        // Adjust speech rate and pitch for single-word clarity
        await _flutterTts.setPitch(1.0); // Neutral pitch
        await _flutterTts.setSpeechRate(0.4); // Slower speech rate

        // Handle single word cases, adding a space after the word for Urdu
        if (_selectedValue == 'Urdu' && textVol.split(' ').length == 1) {
          textVol +=
          " "; // Add a space to the single word to improve recognition
        }
        setState(() {
          isTapped = true;
        });
        CircularProgressIndicator();
        // Speak the text
        await _flutterTts.speak(textVol);
        Future.delayed(Duration(seconds: 1), () {
          setState(() {
            isTapped = false;
          });
        });
      } catch (e) {
        print("Error: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error speaking in the selected language.")),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Selected language is not supported.")),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _clearStoredResults();
  }

  Future<void> _clearStoredResults() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('stored_values');
    setState(() {
      storedValues = [];
      showResults = true;
    });
  }

  Future<void> _saveValue() async {
    if (_controller.text.isNotEmpty) {
      lastEnteredText = _controller.text;
      String translatedText =
      await _translateText(lastEnteredText, translatedLanguage);

      setState(() {
        storedValues.insert(
            0, {'original': lastEnteredText, 'translated': translatedText});
        _controller.clear();
        showResults = true;
      });

      final prefs = await SharedPreferences.getInstance();
      List<String> storedList = storedValues
          .map((item) => "${item['original']}|${item['translated']}")
          .toList();
      await prefs.setStringList('stored_values', storedList);
    }
  }

  /// Translate text based on selected language
  Future<String> _translateText(String text, String targetLanguage) async {
    final translation =
    await translator.translate(text, from: 'auto', to: targetLanguage);
    return translation.text;
  }


  /// Retranslate **only the latest entered text** (not history)
  Future<void> _retranslateLastEntry() async {
    if (lastEnteredText.isNotEmpty) {
      String newTranslation =
      await _translateText(lastEnteredText, translatedLanguage);
      setState(() {
        storedValues[0]['translated'] = newTranslation;
      });
    }
  }

  bool isRtl(String text) {
    // Unicode range for Arabic, Urdu, Hebrew, Persian
    final rtlPattern = RegExp(r'[\u0600-\u06FF\u0750-\u077F\u08A0-\u08FF\u0590-\u05FF]');
    return rtlPattern.hasMatch(text);
  }

  void _hideResults() {
    setState(() {
      showResults = false; // Hide results, keep text field visible
    });
  }
  // List<Map<String, String>> languages = [
  //   {'code': 'en', 'name': 'English', 'flag': '🇺🇸'},
  //   {'code': 'ar', 'name': 'Arabic', 'flag': '🇦🇪'},
  //   {'code': 'hi', 'name': 'Hindi', 'flag': '🇮🇳'},
  //   {'code': 'ur', 'name': 'Urdu', 'flag': '🇵🇰'},
  //   {'code': 'de', 'name': 'German', 'flag': '🇩🇪'},
  //   {'code': 'it', 'name': 'Italian', 'flag': '🇮🇹'},
  //   {'code': 'es', 'name': 'Spanish', 'flag': '🇪🇸'},
  //   {'code': 'fr', 'name': 'French', 'flag': '🇫🇷'},
  // ];

  List<Map<String, String>> languages = [
    {'code': 'en', 'name': 'English', 'flag': '🇺🇸'}, // United States
    {'code': 'af', 'name': 'Afrikaans', 'flag': '🇿🇦'}, // South Africa
    {'code': 'sq', 'name': 'Albanian', 'flag': '🇦🇱'}, // Albania
    {'code': 'am', 'name': 'Amharic', 'flag': '🇪🇹'}, // Ethiopia
    {'code': 'ar', 'name': 'Arabic', 'flag': '🇸🇦'}, // Saudi Arabia
    {'code': 'hy', 'name': 'Armenian', 'flag': '🇦🇲'}, // Armenia
    {'code': 'az', 'name': 'Azerbaijani', 'flag': '🇦🇿'}, // Azerbaijan
    {'code': 'eu', 'name': 'Basque', 'flag': '🇪🇸'}, // Spain
    {'code': 'be', 'name': 'Belarusian', 'flag': '🇧🇾'}, // Belarus
    {'code': 'bn', 'name': 'Bengali', 'flag': '🇮🇳'}, // India
    {'code': 'bs', 'name': 'Bosnian', 'flag': '🇧🇦'}, // Bosnia and Herzegovina
    {'code': 'bg', 'name': 'Bulgarian', 'flag': '🇧🇬'}, // Bulgaria
    {'code': 'ca', 'name': 'Catalan', 'flag': '🇪🇸'}, // Spain
    {'code': 'ceb', 'name': 'Cebuano', 'flag': '🇵🇭'}, // Philippines
    {'code': 'zh', 'name': 'Chinese Simplified', 'flag': '🇨🇳'}, // China
    {'code': 'zh', 'name': 'Chinese Traditional', 'flag': '🇹🇼'}, // Taiwan
    {'code': 'hr', 'name': 'Croatian', 'flag': '🇭🇷'}, // Croatia
    {'code': 'cs', 'name': 'Czech', 'flag': '🇨🇿'}, // Czech Republic
    {'code': 'da', 'name': 'Danish', 'flag': '🇩🇰'}, // Denmark
    {'code': 'nl', 'name': 'Dutch', 'flag': '🇳🇱'}, // Netherlands
    {'code': 'eo', 'name': 'Esperanto', 'flag': '🏳️'}, // No country
    {'code': 'et', 'name': 'Estonian', 'flag': '🇪🇪'}, // Estonia
    {'code': 'fi', 'name': 'Finnish', 'flag': '🇫🇮'}, // Finland
    {'code': 'fr', 'name': 'French', 'flag': '🇫🇷'}, // France
    {'code': 'fy', 'name': 'Frisian', 'flag': '🇳🇱'}, // Netherlands
    {'code': 'gl', 'name': 'Galician', 'flag': '🇪🇸'}, // Spain
    {'code': 'ka', 'name': 'Georgian', 'flag': '🇬🇪'}, // Georgia
    {'code': 'de', 'name': 'German', 'flag': '🇩🇪'}, // Germany
    {'code': 'el', 'name': 'Greek', 'flag': '🇬🇷'}, // Greece
    {'code': 'gu', 'name': 'Gujarati', 'flag': '🇮🇳'}, // India
    {'code': 'ht', 'name': 'Haitian Creole', 'flag': '🇭🇹'}, // Haiti
    {'code': 'ha', 'name': 'Hausa', 'flag': '🇳🇬'}, // Nigeria
    {'code': 'he', 'name': 'Hebrew', 'flag': '🇮🇱'}, // Israel
    {'code': 'hi', 'name': 'Hindi', 'flag': '🇮🇳'}, // India
    {'code': 'hu', 'name': 'Hungarian', 'flag': '🇭🇺'}, // Hungary
    {'code': 'is', 'name': 'Icelandic', 'flag': '🇮🇸'}, // Iceland
    {'code': 'id', 'name': 'Indonesian', 'flag': '🇮🇩'}, // Indonesia
    {'code': 'ga', 'name': 'Irish', 'flag': '🇮🇪'}, // Ireland
    {'code': 'it', 'name': 'Italian', 'flag': '🇮🇹'}, // Italy
    {'code': 'ja', 'name': 'Japanese', 'flag': '🇯🇵'}, // Japan
    {'code': 'jv', 'name': 'Javanese', 'flag': '🇮🇩'}, // Indonesia
    {'code': 'kn', 'name': 'Kannada', 'flag': '🇮🇳'}, // India
    {'code': 'kk', 'name': 'Kazakh', 'flag': '🇰🇿'}, // Kazakhstan
    {'code': 'km', 'name': 'Khmer', 'flag': '🇰🇭'}, // Cambodia
    {'code': 'ko', 'name': 'Korean', 'flag': '🇰🇷'}, // South Korea
    {'code': 'ku', 'name': 'Kurdish', 'flag': '🇹🇷'}, // Turkey
    {'code': 'lo', 'name': 'Lao', 'flag': '🇱🇦'}, // Laos
    {'code': 'lv', 'name': 'Latvian', 'flag': '🇱🇻'}, // Latvia
    {'code': 'lt', 'name': 'Lithuanian', 'flag': '🇱🇹'}, // Lithuania
    {'code': 'lb', 'name': 'Luxembourgish', 'flag': '🇱🇺'}, // Luxembourg
    {'code': 'mk', 'name': 'Macedonian', 'flag': '🇲🇰'}, // North Macedonia
    {'code': 'ms', 'name': 'Malay', 'flag': '🇲🇾'}, // Malaysia
    {'code': 'ml', 'name': 'Malayalam', 'flag': '🇮🇳'}, // India
    {'code': 'mt', 'name': 'Maltese', 'flag': '🇲🇹'}, // Malta
    {'code': 'mi', 'name': 'Maori', 'flag': '🇳🇿'}, // New Zealand
    {'code': 'mr', 'name': 'Marathi', 'flag': '🇮🇳'}, // India
    {'code': 'mn', 'name': 'Mongolian', 'flag': '🇲🇳'}, // Mongolia
    {'code': 'ne', 'name': 'Nepali', 'flag': '🇳🇵'}, // Nepal
    {'code': 'no', 'name': 'Norwegian', 'flag': '🇳🇴'}, // Norway
    {'code': 'pl', 'name': 'Polish', 'flag': '🇵🇱'}, // Poland
    {'code': 'pt', 'name': 'Portuguese', 'flag': '🇵🇹'}, // Portugal
    {'code': 'pa', 'name': 'Punjabi', 'flag': '🇵🇰'}, // Pakistan
    {'code': 'ro', 'name': 'Romanian', 'flag': '🇷🇴'}, // Romania
    {'code': 'ru', 'name': 'Russian', 'flag': '🇷🇺'}, // Russia
    {'code': 'sr', 'name': 'Serbian', 'flag': '🇷🇸'}, // Serbia
    {'code': 'sk', 'name': 'Slovak', 'flag': '🇸🇰'}, // Slovakia
    {'code': 'sl', 'name': 'Slovenian', 'flag': '🇸🇮'}, // Slovenia
    {'code': 'es', 'name': 'Spanish', 'flag': '🇪🇸'}, // Spain
    {'code': 'sv', 'name': 'Swedish', 'flag': '🇸🇪'}, // Sweden
    {'code': 'ta', 'name': 'Tamil', 'flag': '🇮🇳'}, // India
    {'code': 'th', 'name': 'Thai', 'flag': '🇹🇭'}, // Thailand
    {'code': 'tr', 'name': 'Turkish', 'flag': '🇹🇷'}, // Turkey
    {'code': 'uk', 'name': 'Ukrainian', 'flag': '🇺🇦'}, // Ukraine
    {'code': 'ur', 'name': 'Urdu', 'flag': '🇵🇰'}, // Pakistan
    {'code': 'vi', 'name': 'Vietnamese', 'flag': '🇻🇳'}, // Vietnam
    {'code': 'cy', 'name': 'Welsh', 'flag': '🇬🇧'}, // United Kingdom
    {'code': 'zu', 'name': 'Zulu', 'flag': '🇿🇦'}, // South Africa
  ];

  Future<void> speakInLanguage(String text, String languageCode) async {
    final FlutterTts flutterTts = FlutterTts();

    try {
      // Set the language based on the language code
      await flutterTts.setLanguage(languageCode);

      // Speak the text
      await flutterTts.speak(text);
    } catch (e) {
      Get.snackbar('Error', 'Failed to speak the text. Try again.');
    }
  }


  void _showLanguagePicker(bool isOriginal) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: languages.map((lang) {
                return ListTile(
                  leading: Text(
                    lang['flag']!, // Dynamically showing the flag emoji
                    style: TextStyle(fontSize: 25),
                  ),
                  title: Text(lang['name']!),
                  onTap: () async {
                    if (isOriginal) {
                      setState(() {
                        originalLanguage = lang['code']!;
                        showResults = false; // Hide results, show input field
                      });
                    } else {
                      setState(() {
                        translatedLanguage = lang['code']!;
                      });
                      await _retranslateLastEntry(); // Retranslate only the latest entry
                    }
                    Navigator.pop(context);
                  },
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
  String getLanguageName(String code,) {
    return languages.firstWhere((lang) => lang['code'] == code)['name']!;
  }

  void swapLanguages() {
    setState(() {
      String temp = originalLanguage;
      originalLanguage = translatedLanguage;
      translatedLanguage = temp;
    });
  }


  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color(0XFFE8E8E8),
      appBar: AppBar(
        backgroundColor: Color(0XFF4169E1).withOpacity(0.76),
        leading: CustomBackButton(
          btnColor: Colors.white,
          icon: Icons.arrow_back_ios,
          iconSize: screenWidth * 0.05,
          onPressed: () {     flutterTts.stop();

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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      _showLanguagePicker(true);
                      _isTranslate = false;
                    },
                    child: Container(
                      width: 140,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Color(0XFF4169E1).withValues(alpha: .76),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            languages.firstWhere((lang) => lang['code'] == originalLanguage,
                                orElse: () => {"flag": "🏳"})['flag']!,
                            style: TextStyle(fontSize: 20), // Slightly smaller to fit inside the circle
                          ),
                          SizedBox(width: 8),

                          Expanded(
                            child: Text(
                              getLanguageName(originalLanguage),
                              style: TextStyle(fontSize: 14, color: Colors.white),
                              overflow: getLanguageName(translatedLanguage).length >= 10
                                  ? TextOverflow.ellipsis
                                  : TextOverflow.visible,
                              maxLines: 1, // Limits to one line
                            ),
                          ),
                          Icon(Icons.arrow_drop_down_outlined, color: Colors.white,)
                        ],
                      ),
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
                    onTap: () => _showLanguagePicker(false),
                    child: Container(
                      width: 140,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Color(0XFF4169E1).withValues(alpha: .76),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            languages.firstWhere((lang) => lang['code'] == translatedLanguage,
                                orElse: () => {"flag": "🏳"})['flag']!,
                            style: TextStyle(fontSize: 20), // Slightly smaller to fit inside the circle
                          ),
                          SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                getLanguageName(translatedLanguage),
                                style: TextStyle(fontSize: 14, color: Colors.white),
                                overflow: getLanguageName(translatedLanguage).length >= 10
                                  ? TextOverflow.ellipsis
                                  : TextOverflow.visible,
                                maxLines: 1, // Limits to one line
                              ),
                            ),
                          // Spacer(),
                          Icon(Icons.arrow_drop_down_outlined, color: Colors.white,)
                        ],
                      ),
                    ),
                  ),

                ],
              ),
              SizedBox(height: 10),

              if (!_isTranslate)
                Container(
                  height: screenHeight * 0.38,
                  decoration: BoxDecoration(
                    color: Color(0XFFFFFFFF).withOpacity(0.6),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // GestureDetector(
                      //   child: SelectedLangShow(
                      //     LangColor: Colors.black,
                      //     containerColor: Colors.transparent,
                      //     language: translationController
                      //         .firstContainerLanguage.value,
                      //     countryCode:
                      //     translationController.languageFlags[
                      //     translationController
                      //         .firstContainerLanguage.value]!,
                      //   ),
                      // ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10, top: 10, bottom: 0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              languages.firstWhere((lang) => lang['code'] == originalLanguage,
                                  orElse: () => {"flag": "🏳"})['flag']!,
                              style: TextStyle(fontSize: 20), // Slightly smaller to fit inside the circle
                            ),
                            SizedBox(width: 8),

                            Text(getLanguageName(originalLanguage),
                                style: TextStyle(fontSize: 13, color: Colors.black)),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Scrollbar(
                          controller: _scrollController,
                          thumbVisibility: true,
                          child: SingleChildScrollView(
                            controller: _scrollController,
                            child: Obx(() {
                              final isSourceRTL = translationController
                                  .isRTLLanguage(translationController
                                  .firstContainerLanguage.value);
                              return TextField(
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                ),
                                controller: _controller,
                                maxLines: null,
                                decoration: InputDecoration(
                                  hintText: 'type text here',
                                  hintStyle: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                  ),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide.none),
                                ),
                                textAlign: isSourceRTL
                                    ? TextAlign.right
                                    : TextAlign.left,
                                textDirection: translationController
                                    .controller.value ==
                                    'Urdu'
                                    ? TextDirection.rtl
                                    : TextDirection.ltr,
                              );
                            }),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CMic2(textController: _controller),
                            10.asWidthBox,
                            CustomTextBtn(
                              height: screenHeight * 0.06,
                              width: screenWidth * 0.52,
                              transController: _controller,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(12),
                                  bottomRight: Radius.circular(12),
                                ),
                                color:
                                Color(0XFF4169E1).withOpacity(0.76),
                              ),
                              textTitle: 'Translate',
                              onTap: () {
                                setState(() {
                                  _isTranslate =
                                  true; // Show translations only
                                });
                                _saveValue();
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

              // Show translated section only when _isTranslate is true
              if (_isTranslate && storedValues.isNotEmpty)
              // SizedBox(
              //   height: 600,
              //   child: ListView.builder(
              //     padding: EdgeInsets.zero,
              //     itemCount:
              //         storedValues.length >= 3
              //         ? 4
              //         : storedValues.length + 1, // Add 1 for "Your history"
              //     itemBuilder: (context, index) {
              //       if (index == 1) {
              //         // Show "Your history" only once after the first entry
              //         return Padding(
              //           padding:
              //               const EdgeInsets.symmetric(vertical: 8.0),
              //           child: Align(
              //             alignment: Alignment.centerLeft,
              //             child: Text(
              //               'Your recent history',
              //               style: TextStyle(
              //                   fontSize: 18, fontWeight: FontWeight.w400, color: Colors.blue),
              //               textAlign: TextAlign.center,
              //             ),
              //           ),
              //         );
              //       }
              //
              //       int dataIndex = index > 1 ? index - 1 : index;
              //
              //       return Column(
              //         children: [
              //           Container(
              //             height: 80,
              //             width: double.infinity,
              //             decoration: BoxDecoration(
              //               color: Colors.blueGrey[300],
              //               borderRadius: BorderRadius.only(
              //                 topRight: Radius.circular(12),
              //                 topLeft: Radius.circular(12),
              //               ),
              //             ),
              //             child: Row(
              //               mainAxisAlignment:
              //                   MainAxisAlignment.spaceBetween,
              //               children: [
              //                 Padding(
              //                   padding: const EdgeInsets.all(8.0),
              //                   child: Text(
              //                     storedValues[dataIndex]['original']!,
              //                     style: TextStyle(
              //                         fontSize: 16, color: Colors.white),
              //                   ),
              //                 ),
              //                 if(index == 0)
              //                   IconButton(
              //                     icon:
              //                     Icon(Icons.clear, color: Colors.red),
              //                     onPressed: () {
              //                       setState(() {
              //                         _isTranslate = false;
              //                       });
              //                     },
              //                   )
              //
              //
              //               ],
              //             ),
              //           ),
              //           Divider(height: 0, color: Colors.white),
              //           Container(
              //             height: 80,
              //             width: double.infinity,
              //             decoration: BoxDecoration(
              //               color: Colors.blueGrey[300],
              //               borderRadius: BorderRadius.only(
              //                 bottomRight: Radius.circular(12),
              //                 bottomLeft: Radius.circular(12),
              //               ),
              //             ),
              //             child: Center(
              //               child: Text(
              //                 storedValues[dataIndex]['translated']!,
              //                 style: TextStyle(fontSize: 16),
              //               ),
              //             ),
              //           ),
              //           SizedBox(height: 10),
              //         ],
              //       );
              //     },
              //   ),
              // ),

                SizedBox(
                  height: 600,
                  child: storedValues.isEmpty
                      ? SizedBox() // Don't show anything if there's no history
                      : ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: storedValues.length >= 3
                        ? 4
                        : storedValues.length + 1, // Add 1 for "Your recent history"
                    itemBuilder: (context, index) {
                      if (index == 1 && storedValues.isNotEmpty) {

                        // Show "Your recent history" only when there is history
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text( storedValues.isEmpty
                                ? ''
                                : 'Your recent history',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        );
                      }

                      int dataIndex = index > 1 ? index - 1 : index;
                      bool isHistory = index > 0;
                     ;

                      return Column(
                        children: [
                          // Container(
                          //   padding: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                          //   width: double.infinity,
                          //   decoration: BoxDecoration(
                          //     color: Colors.blueGrey[300],
                          //     borderRadius: BorderRadius.only(
                          //       topRight: Radius.circular(12),
                          //       topLeft: Radius.circular(12),
                          //     ),
                          //
                          //   ),
                          //   child: Row(
                          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //     children: [
                          //       Expanded(
                          //         child: Text(
                          //           storedValues[dataIndex]['original']!,
                          //           style: TextStyle(fontSize: 16, color: Colors.white),
                          //         ),
                          //       ),
                          //       if (index == 0)
                          //         Align(
                          //           alignment: Alignment.topRight,
                          //           child: IconButton(
                          //             icon: CircleAvatar(
                          //               backgroundColor: Colors.white60,
                          //                 radius: 12,
                          //                 child: Icon(Icons.clear, color: Colors.grey, size: 18,)),
                          //             onPressed: () {
                          //               setState(() {
                          //                 _isTranslate = false;
                          //               });
                          //             },
                          //           ),
                          //         )
                          //     ],
                          //   ),
                          // ),
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                            width: double.infinity,
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
                              crossAxisAlignment: isRtl(storedValues[dataIndex]['translated']!)
                                  ? CrossAxisAlignment.start // Align to the right for RTL
                                  : CrossAxisAlignment.end,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      languages.firstWhere((lang) => lang['code'] == originalLanguage,
                                          orElse: () => {"flag": "🏳"})['flag']!,
                                      style: TextStyle(fontSize: 20), // Slightly smaller to fit inside the circle
                                    ),
                                    Text(getLanguageName(originalLanguage),
                                        style: TextStyle(fontSize: 16, color: Colors.black)),
                                    Spacer(),
                                    if (index == 0)
                                    // cross mark
                                      Align(
                                        alignment: Alignment.topRight,
                                        child: IconButton(
                                          icon: CircleAvatar(
                                              backgroundColor: Colors.white60,
                                              radius: 12,
                                              child: Icon(Icons.clear, color: Colors.grey, size: 18,)),
                                          onPressed: () {
                                            setState(() {
                                              _isTranslate = false;
                                            });
                                          },
                                        ),
                                      )
                                  ],
                                ),
                                // original text
                                Text(
                                  storedValues[dataIndex]['original']!,
                                  style: TextStyle(fontSize: 16, color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                          Divider(height: 2, color: Colors.white),
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              // color: Colors.deepPurple[300],
                              color: isHistory
                                  ? Colors.deepPurple[300]
                                  : Color(0XFF4169E1).withOpacity(0.76),
                              borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(12),
                                bottomLeft: Radius.circular(12),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: isRtl(storedValues[dataIndex]['translated']!)
                                  ? CrossAxisAlignment.end // Align to the right for RTL
                                  : CrossAxisAlignment.start,
                              children: [
                                Row(
                                  spacing: 8,
                                  children: [
                                    Text(
                                      languages.firstWhere((lang) => lang['code'] == translatedLanguage,
                                          orElse: () => {"flag": "🏳"})['flag']!,
                                      style: TextStyle(fontSize: 20), // Slightly smaller to fit inside the circle
                                    ),
                                    Text(getLanguageName(translatedLanguage),
                                        style: TextStyle(fontSize: 16, color: Colors.white)),

                                  ],
                                ),
                                Text(
                                  storedValues[dataIndex]['translated']!,
                                  style: TextStyle(fontSize: 16, color: Colors.white),
                                ),
                                if (index == 0)
                                Align(
                                  alignment: isRtl(storedValues[dataIndex]['translated']!)
                                      ? Alignment.centerLeft
                                      : Alignment.centerRight,
                                  child: GestureDetector(
                                    onTap: () => speak('  ${storedValues[dataIndex]['translated']}'),
                                    child: Image.asset(
                                        AppIcons.volumeIcon,
                                        scale: screenHeight * 0.03,
                                        color:  isTapped ? Colors.black : Colors.white
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: 10),
                        ],
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

}



class TestLangCont extends StatelessWidget {
  final String language;
  final String countryCode;
  // final Color containerColor;

  const TestLangCont({
    required this.language,
    required this.countryCode,
    // required this.containerColor,
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
        color: Color(0XFF4169E1).withValues(alpha: .76),
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