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
  final MyTranslationController translationController = Get.put(MyTranslationController());
  final List<String> langList = ["Arabic", "Urdu", "Hebrew", "Persian"];
  final FlutterTts _flutterTts = FlutterTts();
  String _selectedValue = 'English'; // Default language

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
            SnackBar(content: Text("Language not supported on this device. Using default language.")),
          );
          languageCode = 'en-US'; // Fallback to English
          await _flutterTts.setLanguage(languageCode);
        }

        // Adjust speech rate and pitch for single-word clarity
        await _flutterTts.setPitch(1.0); // Neutral pitch
        await _flutterTts.setSpeechRate(0.4); // Slower speech rate

        // Handle single word cases, adding a space after the word for Urdu
        if (_selectedValue == 'Urdu' && textVol.split(' ').length == 1) {
          textVol += " "; // Add a space to the single word to improve recognition
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


  @override
  void dispose() {
    super.dispose();
    _flutterTts.stop();
  }

  final categoryController controller = Get.put(categoryController());


  String _getTranslation(PhrasesModel model, String titleLang) {
    switch (titleLang) {
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
  Map<int, String> activeIcons = {}; // Key is index, value is the icon type ("copy", "share", "volume")

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
      backgroundColor: Color(0XFFF0F0F0),
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
            final isActiveCopy   = activeIcons[index] == "copy";
            final isActiveShare  = activeIcons[index] == "share";
            final isActiveVolume = activeIcons[index] == "volume";
            return Container(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.04,
                vertical: screenHeight * 0.01,
              ),
              margin: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.02,
                vertical: screenHeight * 0.01,
              ),
              width: screenWidth * 0.9,
              height: screenHeight * 0.17,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(screenWidth * 0.066),
                // border: Border(
                //     // bottom: BorderSide(color: Color(0XFF22223B).withValues(alpha: .2), width: 2),
                //     top: BorderSide(color: Color(0XFF4169E1).withValues(alpha: .2), width: 2),
                //     left: BorderSide(color: Color(0XFF4169E1).withValues(alpha: .2), width: 2),
                //     right: BorderSide(color: Color(0XFF4169E1).withValues(alpha: .2), width: 2),
                // ),
                // color: Color(0XFF4169E1).withValues(alpha: .03),
                border: Border.all(color: Color(0XFF4169E1).withValues(alpha: .2), width: 2)

              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _getTranslation(item, widget.titleLang), // Moved to the first argument
                              softWrap: true,
                              maxLines: 4,
                              locale: Locale(_selectedValue),
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: screenWidth * 0.042,
                              ),
                              textDirection: (["Arabic", "Urdu", "Hebrew", "Persian"].contains(widget.titleLang))
                                  ? TextDirection.rtl
                                  : TextDirection.ltr,
                            ),

                            Text(
                              _getTranslation(item, widget.subtitleLang),
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                color: Color(0XFF4169E1).withValues(alpha: .76),
                                fontSize: screenWidth * 0.04,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // Copy Icon
                      GestureDetector(
                        onTap: () {
                          final textToCopy =
                          _getTranslation(item, widget.subtitleLang);
                          _handleIconClick(index, textToCopy, "copy");
                        },
                        child: CircleAvatar(
                          radius: 19,
                          backgroundColor: Color(0XFFaeaeae).withAlpha(26),
                          child: Image.asset(
                            AppIcons.copyIcon,
                            scale: screenHeight * 0.03,
                            color: isActiveCopy ? Colors.blue : Colors.black,
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      // Share Icon
                      GestureDetector(
                        onTap: () {
                          final text = _getTranslation(item, widget.subtitleLang);
                          _handleIconClick(index, text, "share");
                        },
                        child: CircleAvatar(
                          radius: 19,
                          backgroundColor: Color(0XFFaeaeae).withAlpha(26),
                          child: Image.asset(
                            AppIcons.sharIcon,
                            scale: screenHeight * 0.03,
                            color: isActiveShare ? Colors.blue :  Colors.black,
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      // Volume Icon
                      GestureDetector(
                        onTap: () async {
                          String textToSpeak =
                          _getTranslation(item, widget.subtitleLang);
                          _handleIconClick(index, textToSpeak, "volume");
                        },
                        child: CircleAvatar(
                          radius: 19,
                          backgroundColor: Color(0XFFaeaeae).withAlpha(26),
                          child: Image.asset(
                            AppIcons.volumeIcon,
                            scale: screenHeight * 0.03,
                            color: isActiveVolume ? Colors.blue :  Colors.black,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            );
          },
        );
      }),
    );
  }
}
