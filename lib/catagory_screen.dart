import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:mnh/controller/category_contrl.dart';
import 'package:mnh/models/phrase_model.dart';
import 'package:mnh/translator/controller/translate_contrl.dart';
import 'package:mnh/utils/app_icons.dart';
import 'package:share_plus/share_plus.dart';

class PhrasesCategoryScreen extends StatefulWidget {
  final int id;
  final String name;
  final String titleLang;
  final String subtitleLang;
  final TextEditingController copyController;
  final TextEditingController shareController;
  final TextEditingController volumeController;

  const PhrasesCategoryScreen({
    super.key,
    required this.id,
    required this.name,
    required this.titleLang,
    required this.subtitleLang,
    required this.copyController,
    required this.shareController,
    required this.volumeController,
  });

  @override
  State<PhrasesCategoryScreen> createState() => _PhrasesCategoryScreenState();
}

class _PhrasesCategoryScreenState extends State<PhrasesCategoryScreen> {
  final MyTranslationController translationController =
      Get.put(MyTranslationController());
  final List<String> langList = ["Arabic", "Urdu", "Hebrew", "Persian"];
  final FlutterTts _flutterTts = FlutterTts();
  String _selectedValue = 'English'; // Default language


  String firstContainerLanguage = "English";
  String secondContainerLanguage = "Urdu";

  // Supported languages
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
        await _flutterTts.setPitch(0.7); // Neutral pitch
        await _flutterTts.setSpeechRate(1); // Slower speech rate

        // Handle single word cases, adding a space after the word for Urdu
        if (_selectedValue == 'Urdu' && textVol.split(' ').length <= 1) {
          textVol +=
              " "; // Add a space to the single word to improve recognition
        }

        // Speak the text
        await _flutterTts.speak(textVol);
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
  final Map<String, Map<String, String>> languageCountryCode = {
    "English": {"code": "US", "country": "United States"},
    "Afrikaans": {"code": "ZA", "country": "South Africa"},
    "Albanian": {"code": "AL", "country": "Albania"},
    "Amharic": {"code": "ET", "country": "Ethiopia"},
    "Arabic": {"code": "SA", "country": "Saudi Arabia"},
    "Armenian": {"code": "AM", "country": "Armenia"},
    "Azerbaijani": {"code": "AZ", "country": "Azerbaijan"},
    "Basque": {"code": "ES", "country": "Spain"},
    "Belarusian": {"code": "BY", "country": "Belarus"},
    "Bengali": {"code": "BD", "country": "Bangladesh"},
    "Bosnian": {"code": "BA", "country": "Bosnia and Herzegovina"},
    "Bulgarian": {"code": "BG", "country": "Bulgaria"},
    "Catalan": {"code": "ES", "country": "Spain"},
    "Cebuano": {"code": "PH", "country": "Philippines"},
    "ChineseSimplified": {"code": "CN", "country": "China"},
    "ChineseTraditional": {"code": "TW", "country": "Taiwan"},
    "Croatian": {"code": "HR", "country": "Croatia"},
    "Czech": {"code": "CZ", "country": "Czech Republic"},
    "Danish": {"code": "DK", "country": "Denmark"},
    "Dutch": {"code": "NL", "country": "Netherlands"},
    "Esperanto": {"code": "ZZ", "country": "Esperanto"},
    "Estonian": {"code": "EE", "country": "Estonia"},
    "Finnish": {"code": "FI", "country": "Finland"},
    "French": {"code": "FR", "country": "France"},
    "Frisian": {"code": "NL", "country": "Netherlands"},
    "Galician": {"code": "ES", "country": "Spain"},
    "Georgian": {"code": "GE", "country": "Georgia"},
    "German": {"code": "DE", "country": "Germany"},
    "Greek": {"code": "GR", "country": "Greece"},
    "Gujarati": {"code": "IN", "country": "India"},
    "Haitian": {"code": "HT", "country": "Haiti"},
    "Hausa": {"code": "NG", "country": "Nigeria"},
    "Hawaiian": {"code": "US", "country": "United States"},
    "Hebrew": {"code": "IL", "country": "Israel"},
    "Hindi": {"code": "IN", "country": "India"},
    "Hmong": {"code": "LA", "country": "Laos"},
    "Hungarian": {"code": "HU", "country": "Hungary"},
    "Icelandic": {"code": "IS", "country": "Iceland"},
    "Indonesian": {"code": "ID", "country": "Indonesia"},
    "Irish": {"code": "IE", "country": "Ireland"},
    "Italian": {"code": "IT", "country": "Italy"},
    "Japanese": {"code": "JP", "country": "Japan"},
    "Javanese": {"code": "ID", "country": "Indonesia"},
    "Kannada": {"code": "IN", "country": "India"},
    "Kazakh": {"code": "KZ", "country": "Kazakhstan"},
    "Khmer": {"code": "KH", "country": "Cambodia"},
    "KoreanNK": {"code": "KP", "country": "North Korea"},
    "KoreanSK": {"code": "KR", "country": "South Korea"},
    "Kurdish": {"code": "IQ", "country": "Iraq"},
    "Kyrgyz": {"code": "KG", "country": "Kyrgyzstan"},
    "Lao": {"code": "LA", "country": "Laos"},
    "Latin": {"code": "ZZ", "country": "Latin"},
    "Latvian": {"code": "LV", "country": "Latvia"},
    "Lithuanian": {"code": "LT", "country": "Lithuania"},
    "Luxembourgish": {"code": "LU", "country": "Luxembourg"},
    "Macedonian": {"code": "MK", "country": "North Macedonia"},
    "Malagasy": {"code": "MG", "country": "Madagascar"},
    "Malay": {"code": "MY", "country": "Malaysia"},
    "Malayalam": {"code": "IN", "country": "India"},
    "Maltese": {"code": "MT", "country": "Malta"},
    "Maori": {"code": "NZ", "country": "New Zealand"},
    "Marathi": {"code": "IN", "country": "India"},
    "Mongolian": {"code": "MN", "country": "Mongolia"},
    "MyanmarBurmese": {"code": "MM", "country": "Myanmar"},
    "Nepali": {"code": "NP", "country": "Nepal"},
    "Norwegian": {"code": "NO", "country": "Norway"},
    "NyanjaChichewa": {"code": "MW", "country": "Malawi"},
    "Pashto": {"code": "AF", "country": "Afghanistan"},
    "Persian": {"code": "IR", "country": "Iran"},
    "Polish": {"code": "PL", "country": "Poland"},
    "Portuguese": {"code": "PT", "country": "Portugal"},
    "Punjabi": {"code": "IN", "country": "India"},
    "Romanian": {"code": "RO", "country": "Romania"},
    "Russian": {"code": "RU", "country": "Russia"},
    "Samoan": {"code": "WS", "country": "Samoa"},
    "ScotsGaelic": {"code": "GB", "country": "United Kingdom"},
    "Serbian": {"code": "RS", "country": "Serbia"},
    "Sesotho": {"code": "LS", "country": "Lesotho"},
    "Shona": {"code": "ZW", "country": "Zimbabwe"},
    "Sindhi": {"code": "PK", "country": "Pakistan"},
    "Sinhala": {"code": "LK", "country": "Sri Lanka"},
    "Slovak": {"code": "SK", "country": "Slovakia"},
    "Slovenian": {"code": "SI", "country": "Slovenia"},
    "Somali": {"code": "SO", "country": "Somalia"},
    "Spanish": {"code": "ES", "country": "Spain"},
    "Sundanese": {"code": "ID", "country": "Indonesia"},
    "Swahili": {"code": "KE", "country": "Kenya"},
    "Swedish": {"code": "SE", "country": "Sweden"},
    "Tagalog": {"code": "PH", "country": "Philippines"},
    "Tajik": {"code": "TJ", "country": "Tajikistan"},
    "Tamil": {"code": "IN", "country": "India"},
    "Telugu": {"code": "IN", "country": "India"},
    "Thai": {"code": "TH", "country": "Thailand"},
    "Turkish": {"code": "TR", "country": "Turkey"},
    "Ukrainian": {"code": "UA", "country": "Ukraine"},
    "Urdu": {"code": "PK", "country": "Pakistan"},
    "Uzbek": {"code": "UZ", "country": "Uzbekistan"},
    "Vietnamese": {"code": "VN", "country": "Vietnam"},
    "Welsh": {"code": "GB", "country": "United Kingdom"},
    "Xhosa": {"code": "ZA", "country": "South Africa"},
    "Yiddish": {"code": "ZZ", "country": "Yiddish"},
    "Yoruba": {"code": "NG", "country": "Nigeria"},
    "Zulu": {"code": "ZA", "country": "South Africa"},
  };


  @override
  void dispose() {
    super.dispose();
    _flutterTts.stop();
  }

  final categoryController controller = Get.put(categoryController());

  String _getTranslation(PhrasesModel model, String titleLang) {
    switch (titleLang) {
      case "English":
        return model.english;
      case "Afrikaans":
        return model.afrikaans;
      case "Albanian":
        return model.albanian;
      case "Amharic":
        return model.amharic;
      case "Arabic":
        return model.arabic;
      case "Armenian":
        return model.armenian;
      case "Azerbaijani":
        return model.azeerbaijani;
      case "Basque":
        return model.basque;
      case "Belarusian":
        return model.belarusian;
      case "Bengali":
        return model.bengali;
      case "Bosnian":
        return model.bosnian;
      case "Bulgarian":
        return model.bulgarian;
      case "Catalan":
        return model.catalan;
      case "Cebuano":
        return model.cebuano;
      case "Chinese Simplified":
        return model.chineseSimplified;
      case "Chinese Traditional":
        return model.chineseTraditional;
      case "Croatian":
        return model.croatian;
      case "Czech":
        return model.czech;
      case "Danish":
        return model.danish;
      case "Dutch":
        return model.dutch;
      case "Esperanto":
        return model.esperanto;
      case "Estonian":
        return model.estonian;
      case "Finnish":
        return model.finnish;
      case "French":
        return model.french;
      case "Frisian":
        return model.frisian;
      case "Galician":
        return model.galician;
      case "Georgian":
        return model.georgian;
      case "German":
        return model.german;
      case "Greek":
        return model.greek;
      case "Gujarati":
        return model.gujarati;
      case "Haitian":
        return model.haitian;
      case "Hausa":
        return model.hausa;
      case "Hawaiian":
        return model.hawaiian;
      case "Hebrew":
        return model.hebrew;
      case "Hindi":
        return model.hindi;
      case "Hmong":
        return model.hmong;
      case "Hungarian":
        return model.hungarian;
      case "Icelandic":
        return model.icelandic;
      case "Indonesian":
        return model.indonesian;
      case "Irish":
        return model.irish;
      case "Italian":
        return model.italian;
      case "Japanese":
        return model.japanese;
      case "Javanese":
        return model.javanese;
      case "Kannada":
        return model.kannada;
      case "Kazakh":
        return model.kazakh;
      case "Khmer":
        return model.khmer;
      case "Korean NK":
        return model.koreanNK;
      case "Korean SK":
        return model.koreanSK;
      case "Kurdish":
        return model.kurdish;
      case "Kyrgyz":
        return model.kyrgyz;
      case "Lao":
        return model.lao;
      case "Latin":
        return model.latin;
      case "Latvian":
        return model.latvian;
      case "Lithuanian":
        return model.lithuanian;
      case "Luxembourgish":
        return model.luxembourgish;
      case "Macedonian":
        return model.macedonian;
      case "Malagasy":
        return model.malagasy;
      case "Malay":
        return model.malay;
      case "Malayalam":
        return model.malayalam;
      case "Maltese":
        return model.maltese;
      case "Maori":
        return model.maori;
      case "Marathi":
        return model.marathi;
      case "Mongolian":
        return model.mongolian;
      case "Myanmar Burmese":
        return model.myanmarBurmese;
      case "Nepali":
        return model.nepali;
      case "Norwegian":
        return model.norwegian;
      case "Nyanja Chichewa":
        return model.nyanjaChichewa;
      case "Pashto":
        return model.pashto;
      case "Persian":
        return model.persian;
      case "Polish":
        return model.polish;
      case "Portuguese":
        return model.portuguese;
      case "Punjabi":
        return model.punjabi;
      case "Romanian":
        return model.romanian;
      case "Russian":
        return model.russian;
      case "Samoan":
        return model.samoan;
      case "Scots Gaelic":
        return model.scotsGaelic;
      case "Serbian":
        return model.serbian;
      case "Sesotho":
        return model.sesotho;
      case "Shona":
        return model.shona;
      case "Sindhi":
        return model.sindhi;
      case "Sinhala":
        return model.sinhala;
      case "Slovak":
        return model.slovak;
      case "Slovenian":
        return model.slovenian;
      case "Somali":
        return model.somali;
      case "Spanish":
        return model.spanish;
      case "Sundanese":
        return model.sundanese;
      case "Swahili":
        return model.swahili;
      case "Swedish":
        return model.swedish;
      case "Tagalog":
        return model.tagalog;
      case "Tajik":
        return model.tajik;
      case "Tamil":
        return model.tamil;
      case "Telugu":
        return model.telugu;
      case "Thai":
        return model.thai;
      case "Turkish":
        return model.turkish;
      case "Ukrainian":
        return model.ukrainian;
      case "Urdu":
        return model.urdu;
      case "Uzbek":
        return model.uzbek;
      case "Vietnamese":
        return model.vietnamese;
      case "Welsh":
        return model.welsh;
      case "Xhosa":
        return model.xhosa;
      case "Yiddish":
        return model.yiddish;
      case "Yoruba":
        return model.yoruba;
      case "Zulu":
        return model.zulu;
      default:
        return model.english;
    }
  }

  // To track the active icons individually for each item (copy, share, volume)
  Map<int, String> activeIcons =
      {}; // Key is index, value is the icon type ("copy", "share", "volume")

  void _handleIconClick(int index, String text, String iconType) {
    setState(() {
      // Only update the tapped icon
      if (activeIcons[index] == iconType) {
        activeIcons.remove(index); // Remove if the same icon is tapped again
      } else {
        activeIcons[index] = iconType; // Set the clicked icon type
      }
    });

    // Handle specific actions for each icon
    if (iconType == "share" && text.isNotEmpty) {
      Share.share(text);
    } else if (iconType == "copy") {
      // Copy the text to clipboard
      final textToCopy = text;
      Clipboard.setData(ClipboardData(text: textToCopy)).then(
        (_) {
          Fluttertoast.showToast(msg: 'Text Copied to Clipboard');
        },
      );
    } else if (iconType == "volume") {
      // Speak the text
      speak(text);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No text to share!')),
      );
    }

    // Revert the color back to default after 3 seconds
    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        activeIcons.remove(index); // Remove the index after timeout
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Color(0XFFE0E0E0),
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.chevron_left, color: Colors.white, size: 28),
        ),
        title: Text(
          " ${widget.name}",
          style: TextStyle(
            fontSize: screenWidth * 0.046,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        backgroundColor: Color(0XFF4169E1).withValues(alpha: .76),
      ),
      body: Obx(() {
        // Filter phrases by category ID
        final filterPhraseID = controller.phrases
            .where((phrase) => phrase.category_id == widget.id)
            .toList();

        return ListView.builder(
            itemCount: filterPhraseID.length,
            itemBuilder: (context, index) {
          final item = filterPhraseID[index];
          final isActiveCopy = activeIcons[index] == "copy";
          final isActiveShare = activeIcons[index] == "share";
          final isActiveVolume = activeIcons[index] == "volume";
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                      height: 100,
                      width: 300,
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                      decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade400,
                              offset: Offset(0.2, 1.8),
                              blurRadius: 0.2,
                              // spreadRadius: .2,
                            )
                          ]
                      ),
                      // child: Column(
                      //   crossAxisAlignment: (["Arabic", "Urdu", "Hebrew", "Persian"].contains(widget.subtitleLang))
                      //       ? CrossAxisAlignment.start
                      //       :  CrossAxisAlignment.end,
                      //   children: [
                      //     Row(
                      //      children: [
                      //        GestureDetector(
                      //          onTap: () => {
                      //
                      //          },
                      //          child: LanguageContainer(
                      //            language:firstContainerLanguage,
                      //            countryCode: languageCountryCode[firstContainerLanguage]!['code']!,
                      //          ),
                      //        ),
                      //      ],
                      //     ),
                      //     Text(
                      //       _getTranslation(item,
                      //           widget.titleLang),
                      //       textDirection: (["Arabic", "Urdu", "Hebrew", "Persian"].contains(  widget.titleLang))
                      //           ? TextDirection.rtl
                      //           : TextDirection.ltr,
                      //       softWrap: true,
                      //       maxLines: 4,
                      //       locale: Locale(_selectedValue),
                      //       style: TextStyle(
                      //         color: Colors.black,
                      //         fontSize: screenWidth * 0.042,
                      //       ),
                      //     ),
                      //   ],
                      // )),
                    child: Column(
                      crossAxisAlignment: (["Arabic", "Urdu", "Hebrew", "Persian"].contains(widget.titleLang))
                          ? CrossAxisAlignment.end   : CrossAxisAlignment.start,
                      children: [
                        LanguageContainer(
                          language: widget.titleLang, // Use the selected language
                          countryCode: languageCountryCode[widget.titleLang]!['code']!, // Get the country code dynamically
                          textColor: Colors.black,
                        ),
                        SizedBox(height: 9),
                        Text(
                          _getTranslation(item, widget.titleLang), // Get translation based on the selected language
                          textDirection: (["Arabic", "Urdu", "Hebrew", "Persian"].contains(widget.titleLang))
                              ? TextDirection.rtl
                              : TextDirection.ltr,
                          softWrap: true,
                          maxLines: 4,
                          locale: Locale(_selectedValue),
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: screenWidth * 0.042,
                          ),
                        ),
                      ],
                    ),
                )),
                SizedBox(
                  height: 12,
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Container(
                      height: 100,
                      width: 300,
                      decoration: BoxDecoration(
                        color: Color(0XFF4169E1).withValues(alpha: .76),
                        borderRadius: BorderRadius.circular(12),
                         boxShadow:[
                           BoxShadow(
                             color: Colors.grey.shade400,
                             offset: Offset(0.2, 1.8),
                             blurRadius: 0.2,
                             // spreadRadius: .2,
                           )
                         ]
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        // child: Column(
                        //   crossAxisAlignment: CrossAxisAlignment.stretch,
                        //   children: [
                        //     Align(
                        //       alignment: (["Arabic", "Urdu", "Hebrew", "Persian"].contains(widget.subtitleLang))
                        //           ? Alignment.topRight // If text is right, buttons move left
                        //           : Alignment.topLeft,
                        //       child: Text(
                        //         _getTranslation(
                        //             item,
                        //             widget
                        //                 .subtitleLang),
                        //         style: TextStyle(
                        //           color: Colors.white,
                        //           fontSize: screenWidth * 0.042,
                        //         ),
                        //       ),
                        //     ),
                        //     Spacer(),
                        //     Align(
                        //       alignment: (["Arabic", "Urdu", "Hebrew", "Persian"].contains(widget.subtitleLang))
                        //           ? Alignment.centerLeft // If text is right, buttons move left
                        //           : Alignment.centerRight,
                        //       child: Row(
                        //         mainAxisSize: MainAxisSize.min,
                        //         mainAxisAlignment: (["Arabic", "Urdu", "Hebrew", "Persian"].contains(widget.subtitleLang))
                        //             ? MainAxisAlignment.end // RTL languages → Buttons align LEFT
                        //             : MainAxisAlignment.start,
                        //         children: [
                        //           // Copy Icon
                        //           GestureDetector(
                        //             onTap: () {
                        //               final textToCopy = _getTranslation(
                        //                   item, widget.subtitleLang);
                        //               _handleIconClick(index, textToCopy, "copy");
                        //             },
                        //             child: Image.asset(
                        //               AppIcons.copyIcon,
                        //               scale: screenHeight * 0.03,
                        //               color: isActiveCopy
                        //                   ? Colors.white
                        //                   : Colors.black,
                        //             ),
                        //           ),
                        //           SizedBox(width: 10),
                        //           // Share Icon
                        //           GestureDetector(
                        //             onTap: () {
                        //               final text = _getTranslation(
                        //                   item, widget.subtitleLang);
                        //               _handleIconClick(index, text, "share");
                        //             },
                        //             child: Image.asset(
                        //               AppIcons.sharIcon,
                        //               scale: screenHeight * 0.03,
                        //               color: isActiveShare
                        //                   ? Colors.white
                        //                   : Colors.black,
                        //             ),
                        //           ),
                        //           SizedBox(width: 10),
                        //           // Volume Icon
                        //           GestureDetector(
                        //             onTap: () async {
                        //               String textToSpeak = _getTranslation(
                        //                   item, widget.subtitleLang);
                        //               _handleIconClick(
                        //                   index, textToSpeak, "volume");
                        //             },
                        //             child: Image.asset(
                        //               AppIcons.volumeIcon,
                        //               scale: screenHeight * 0.03,
                        //               color: isActiveVolume
                        //                   ? Colors.white
                        //                   : Colors.black,
                        //             ),
                        //           ),
                        //         ],
                        //       ),
                        //     )
                        //   ],
                        // ),
                        child: Column(
                          crossAxisAlignment: (["Arabic", "Urdu", "Hebrew", "Persian"].contains(widget.subtitleLang))
                                              ? CrossAxisAlignment.end   : CrossAxisAlignment.start,
                          children: [
                            LanguageContainer(
                              language: widget.subtitleLang, // Use the selected language
                              countryCode: languageCountryCode[widget.subtitleLang]!['code']!, // Get the country code dynamically
                              textColor: Colors.white,
                            ),
                            SizedBox(height: 8),
                            Flexible(
                              child: Text(
                                _getTranslation(item, widget.subtitleLang), // Get translation based on the selected language
                                textDirection: (["Arabic", "Urdu", "Hebrew", "Persian"].contains(widget.titleLang))
                                    ? TextDirection.rtl
                                    : TextDirection.ltr,
                                softWrap: true,
                                maxLines: 4,
                                locale: Locale(_selectedValue),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: screenWidth * 0.042,
                                ),
                              ),
                            ),
                            SizedBox(height: 8),
                             Row(
                              // mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: (["Arabic", "Urdu", "Hebrew", "Persian"].contains(widget.subtitleLang))
                                  ? MainAxisAlignment.start // RTL languages → Buttons align LEFT
                                  : MainAxisAlignment.end,
                              children: [
                                // Copy Icon
                                GestureDetector(
                                  onTap: () {
                                    final textToCopy = _getTranslation(
                                        item, widget.subtitleLang);
                                    _handleIconClick(index, textToCopy, "copy");
                                  },
                                  child: Image.asset(
                                    AppIcons.copyIcon,
                                    scale: screenHeight * 0.035,
                                    color: isActiveCopy
                                        ? Colors.black
                                        : Colors.white,
                                  ),
                                ),
                                SizedBox(width: 7),
                                // Share Icon
                                GestureDetector(
                                  onTap: () {
                                    final text = _getTranslation(
                                        item, widget.subtitleLang);
                                    _handleIconClick(index, text, "share");
                                  },
                                  child: Image.asset(
                                    AppIcons.sharIcon,
                                    scale: screenHeight * 0.035,
                                    color: isActiveShare
                                        ? Colors.black
                                        : Colors.white,
                                  ),
                                ),
                                SizedBox(width: 7),
                                // Volume Icon
                                GestureDetector(
                                  onTap: () async {
                                    String textToSpeak = _getTranslation(
                                        item, widget.subtitleLang);
                                    _handleIconClick(
                                        index, textToSpeak, "volume");
                                  },
                                  child: Image.asset(
                                    AppIcons.volumeIcon,
                                    scale: screenHeight * 0.035,
                                    color: isActiveVolume
                                        ? Colors.black
                                        : Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )),
                ),
                // SizedBox(
                //   height: 12,
                // ),
                // translated text container
              ],
            ),
          );
        });

        // return ListView.builder(
        //   itemCount: filterPhraseID.length,
        //   itemBuilder: (context, index) {
        //     final item = filterPhraseID[index];
        //     final isActiveCopy   = activeIcons[index] == "copy";
        //     final isActiveShare  = activeIcons[index] == "share";
        //     final isActiveVolume = activeIcons[index] == "volume";
        //     return Container(
        //       padding: EdgeInsets.symmetric(
        //         horizontal: screenWidth * 0.04,
        //         vertical: screenHeight * 0.01,
        //       ),
        //       margin: EdgeInsets.symmetric(
        //         horizontal: screenWidth * 0.02,
        //         vertical: screenHeight * 0.01,
        //       ),
        //       width: screenWidth * 0.9,
        //       height: screenHeight * 0.17,
        //       decoration: BoxDecoration(
        //         color: Colors.grey[300],
        //         borderRadius: BorderRadius.circular(screenWidth * 0.066),
        //         // border: Border(
        //         //     // bottom: BorderSide(color: Color(0XFF22223B).withValues(alpha: .2), width: 2),
        //         //     top: BorderSide(color: Color(0XFF4169E1).withValues(alpha: .2), width: 2),
        //         //     left: BorderSide(color: Color(0XFF4169E1).withValues(alpha: .2), width: 2),
        //         //     right: BorderSide(color: Color(0XFF4169E1).withValues(alpha: .2), width: 2),
        //         // ),
        //         // color: Color(0XFF4169E1).withValues(alpha: .03),
        //         border: Border.all(color: Color(0XFF4169E1).withValues(alpha: .2), width: 2)
        //
        //       ),
        //       child: Column(
        //         crossAxisAlignment: CrossAxisAlignment.start,
        //         children: [
        //           Row(
        //             mainAxisAlignment: MainAxisAlignment.start,
        //             crossAxisAlignment: CrossAxisAlignment.start,
        //             children: [
        //               Flexible(
        //                 child: Column(
        //                   mainAxisAlignment: MainAxisAlignment.start,
        //                   crossAxisAlignment: CrossAxisAlignment.start,
        //                   children: [
        //                     Text(
        //                       _getTranslation(item, widget.titleLang), // Moved to the first argument
        //                       softWrap: true,
        //                       maxLines: 4,
        //                       locale: Locale(_selectedValue),
        //                       style: TextStyle(
        //                         color: Colors.black,
        //                         fontSize: screenWidth * 0.042,
        //                       ),
        //                       textDirection: (["Arabic", "Urdu", "Hebrew", "Persian"].contains(widget.titleLang))
        //                           ? TextDirection.rtl
        //                           : TextDirection.ltr,
        //                     ),
        //
        //                     Text(
        //                       _getTranslation(item, widget.subtitleLang),
        //                       textAlign: TextAlign.left,
        //                       style: TextStyle(
        //                         color: Color(0XFF4169E1).withValues(alpha: .76),
        //                         fontSize: screenWidth * 0.04,
        //                       ),
        //                     ),
        //                   ],
        //                 ),
        //               ),
        //             ],
        //           ),
        //           Spacer(),
        //           Row(
        //             mainAxisAlignment: MainAxisAlignment.end,
        //             children: [
        //               // Copy Icon
        //               GestureDetector(
        //                 onTap: () {
        //                   final textToCopy =
        //                   _getTranslation(item, widget.subtitleLang);
        //                   _handleIconClick(index, textToCopy, "copy");
        //                 },
        //                 child: CircleAvatar(
        //                   radius: 19,
        //                   backgroundColor: Color(0XFFaeaeae).withAlpha(26),
        //                   child: Image.asset(
        //                     AppIcons.copyIcon,
        //                     scale: screenHeight * 0.03,
        //                     color: isActiveCopy ? Colors.blue : Colors.black,
        //                   ),
        //                 ),
        //               ),
        //               SizedBox(width: 10),
        //               // Share Icon
        //               GestureDetector(
        //                 onTap: () {
        //                   final text = _getTranslation(item, widget.subtitleLang);
        //                   _handleIconClick(index, text, "share");
        //                 },
        //                 child: CircleAvatar(
        //                   radius: 19,
        //                   backgroundColor: Color(0XFFaeaeae).withAlpha(26),
        //                   child: Image.asset(
        //                     AppIcons.sharIcon,
        //                     scale: screenHeight * 0.03,
        //                     color: isActiveShare ? Colors.blue :  Colors.black,
        //                   ),
        //                 ),
        //               ),
        //               SizedBox(width: 10),
        //               // Volume Icon
        //               GestureDetector(
        //                 onTap: () async {
        //                   String textToSpeak =
        //                   _getTranslation(item, widget.subtitleLang);
        //                   _handleIconClick(index, textToSpeak, "volume");
        //                 },
        //                 child: CircleAvatar(
        //                   radius: 19,
        //                   backgroundColor: Color(0XFFaeaeae).withAlpha(26),
        //                   child: Image.asset(
        //                     AppIcons.volumeIcon,
        //                     scale: screenHeight * 0.03,
        //                     color: isActiveVolume ? Colors.blue :  Colors.black,
        //                   ),
        //                 ),
        //               ),
        //             ],
        //           )
        //         ],
        //       ),
        //     );
        //   },
        // );
      }),
    );
  }
}
class LanguageContainer extends StatelessWidget {
  final String language;
  final String countryCode;
  final Color textColor;

  const LanguageContainer({
    required this.language,
    required this.countryCode,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    // Truncate language if its length exceeds 10 characters
    String displayLanguage = language.length > 8 ? '${language.substring(0, 8)}...' : language;

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      spacing: 6,
      children: [

        CountryFlag.fromCountryCode(
          countryCode,
          height: 20,
          width: 20,
          shape: Circle(),
        ),
        Text(
          displayLanguage,
          style: TextStyle(
            color: textColor,
            fontSize: screenWidth * 0.038,
          ),
        ),

      ],
    );
  }
}