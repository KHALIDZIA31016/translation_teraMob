import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:mnh/testScreen.dart';
import 'package:mnh/utils/app_icons.dart';
import 'package:mnh/views/spell_pronounce/services_dict/dict_model.dart';
import 'package:mnh/views/spell_pronounce/services_dict/services.dart';
import 'package:mnh/widgets/copy_btn.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:share_plus/share_plus.dart';

import '../../translator/controller/translate_contrl.dart';
import '../../widgets/back_button.dart';

class DictionaryHomePage extends StatefulWidget {
  const DictionaryHomePage({super.key});

  @override
  State<DictionaryHomePage> createState() => _DictionaryHomePageState();
}

class _DictionaryHomePageState extends State<DictionaryHomePage> {
  final MyTranslationController translationController = Get.put(MyTranslationController());
  bool _isCooldown = false;
  bool _isTextAvailable = false;

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
      await translationController.startSpeechToText(languageCode);  // Start the speech-to-text conversion
      setState(() {
        _isTextAvailable = true;
      });
    } catch (e) {
      Get.snackbar('Error', 'Speech-to-text failed. Try again.');
    } finally {
      await Future.delayed(const Duration(seconds: 1));
      setState(() => _isCooldown = false);
    }
  }

  DictionaryModel? myDictionaryModel;
  bool isLoading = false;
  bool hasSearched = false;
  bool isLoad = false;
  bool isSearchPerformed = false; // Tracks if search was performed
  String noDataFound = "No word found!!\nCheck your word again";
  TextEditingController searchController = TextEditingController();

  // Fetch data for the searched word
  searchContain(String word) async {
    setState(() {
      isLoading = true;
      hasSearched = true;
      isLoad = true;
      isSearchPerformed = true; // Mark search as performed
    });
    try {
      myDictionaryModel = await APIservices.fetchData(word);
      setState(() {});
    } catch (e) {
      myDictionaryModel = null;
      noDataFound = "Meaning can't be found";
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Reset the search and clear input
  resetScreen() {
    setState(() {
      myDictionaryModel = null;
      isLoading = false;
      hasSearched = false;
      isSearchPerformed = false; // Reset search status
      searchController.clear();
      _isTextAvailable = false;  // Reset the text availability after reset
    });
  }

  // Display meanings or handle connectivity issues
  findMeanings() async {
    bool internetAvailable = await isInternetAvailable();

    if (internetAvailable == null) {
      Fluttertoast.showToast(
        msg: "Internet is weak or not available. Please check your connection.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
      return;
    }

    if (myDictionaryModel != null) {

    } else {
      Fluttertoast.showToast(
          msg: 'This word is not in your dictionary'
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0XFF4169E1).withValues(alpha: .76),
        leading: CustomBackButton(
            iconSize: 14,
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icons.arrow_back_ios_outlined,
            btnColor: Colors.white
        ),
        title: const Text(
          "Dictionary",
          style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: "Search the word here",
                prefixIcon: _isTextAvailable ? null : Icon(Icons.search, color: Color(0XFF4169E1)),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                suffixIcon: micSpeak(
                  textController: searchController,
                  onTextUpdated: () {
                    setState(() {
                      // Update the state when the text is updated via mic
                      _isTextAvailable = searchController.text.trim().isNotEmpty;
                    });
                  },
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _isTextAvailable = value.trim().isNotEmpty;
                });
              },
              onSubmitted: (value) {
                if (value.trim().isNotEmpty) {
                  searchContain(value);
                }
              },
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: isSearchPerformed ? resetScreen : null,
                  style: ButtonStyle(
                    backgroundColor:
                    MaterialStateProperty.resolveWith<Color?>((states) {
                      if (!isSearchPerformed) {
                        return Colors.blueGrey.shade100; // Gray when disabled
                      }
                      return Color(0XFF4169E1).withValues(alpha: .76);; // Blue when enabled
                    }),
                  ),
                  child: const Text(
                    "Reset",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                ElevatedButton(
                  onPressed: _isTextAvailable || searchController.text.trim().isNotEmpty
                      ? () async {
                    await searchContain(searchController.text.trim());
                    findMeanings(); // Check meanings after fetching data
                  }
                      : null,  // Enable button if text is available from mic or input field
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color?>((states) {
                      if (states.contains(MaterialState.disabled)) {
                        return Colors.blueGrey.shade100; // Disabled state color
                      }
                      return Color(0XFF4169E1).withValues(alpha: .76);; // Enabled state color
                    }),
                  ),
                  child: const Text(
                    "Find Meaning",
                    style: TextStyle(color: Colors.white),
                  ),
                ),

              ],
            ),
            const SizedBox(height: 10),

            // Conditionally display dictionary image or meaning content
            if (!isSearchPerformed || myDictionaryModel == null)
              Image.asset(
                AppIcons.dictIcon1,
                color: Color(0XFF4169E1).withOpacity(0.26),
                scale: 4,
              ),
            if (isLoading)
              const Expanded(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            else if (myDictionaryModel != null)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 15),
                    Text(
                      myDictionaryModel!.word,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.blue,
                      ),
                    ),
                    Text(
                      myDictionaryModel!.phonetics.isNotEmpty
                          ? myDictionaryModel!.phonetics[0].text ?? ""
                          : "",
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: ListView.builder(
                        itemCount: myDictionaryModel!.meanings.length,
                        itemBuilder: (context, index) {
                          return showMeaning(myDictionaryModel!.meanings[index]);
                        },
                      ),
                    ),
                  ],
                ),
              )
            else if (hasSearched)
                Center(
                  child: Text(
                    noDataFound,
                    style: const TextStyle(fontSize: 16, color: Colors.red),
                  ),
                ),
          ],
        ),
      ),
    );
  }

  showMeaning(Meaning meaning) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Container wrapping Part of Speech, Definitions, and Explanation
          Container(
            clipBehavior: Clip.none,
            padding: const EdgeInsets.all(10),
            width: double.infinity,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border(bottom: BorderSide(color: Colors.grey, width: 2))
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Part of Speech (e.g., Noun, Verb, Adjective)
                Text(
                  meaning.partOfSpeech,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(height: 10),

                // Definitions
                if (meaning.definitions.isNotEmpty) ...[
                  const Text(
                    "Definitions:",
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 15),
                  // Use a Column to handle each definition individually
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: meaning.definitions.map((error) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: Text(
                          "• ${error.definition} ",
                          style: const TextStyle(fontSize: 14),
                          textAlign: TextAlign.justify,  // Justify text
                        ),
                      );
                    }).toList(),
                  ),
                ],
                  SizedBox(height: 40,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  spacing: 18,
                  children: [
                    CopyBtnDic(
                        iconColor: Colors.black,
                        contentToCopy: meaning.definitions.map((definition)
                                        => definition.definition).join("\n\n")),
                    VolumeBtnDic(iconColor: Colors.red, textToSpeak: meaning.definitions.map((definition)
                    => definition.definition).join("\n\n")),
                    ShareBtnDic(iconColor: Colors.green, textToShare:meaning.definitions.map((definition)
                    => definition.definition).join("\n\n")),
                  ],
                )
              ],
            ),
          ),
          const SizedBox(height: 10),

          // Container wrapping Synonyms and Antonyms
          if (meaning.synonyms.isNotEmpty || meaning.antonyms.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(10),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border(bottom: BorderSide(color: Colors.grey, width: 2))
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 22,
                children: [
                  wordRelation("Synonyms", meaning.synonyms),

                  wordRelation("Antonyms", meaning.antonyms),
                ],
              ),
            ),
        ],
      ),
    );
  }

  // Display Synonyms or Antonyms
  wordRelation(String title, List<String>? setList) {
    if (setList?.isNotEmpty ?? false) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          spacing: 18,
          children: [
           Text(
             maxLines: null,
             // softWrap: true,
             "$title:    ",
             style: const TextStyle(
                 fontWeight: FontWeight.w700,
                 fontSize: 16,
                 color: Colors.blue
             ),
           ),
           Text(
             setList!.toSet().join(", "),
             maxLines: null,
             softWrap: true,
             style: const TextStyle(fontSize: 16),
           ),

           Row(
             mainAxisAlignment: MainAxisAlignment.spaceBetween,
             spacing: 18,
              children: [
                CopyBtnDic(iconColor: Colors.black, contentToCopy: setList.toSet().join(", "),),
                VolumeBtnDic(iconColor: Colors.red, textToSpeak: setList.toSet().join(", ")),
                ShareBtnDic(iconColor: Colors.green, textToShare: setList.toSet().join(", ")),
              ],
            ),


          ],
        ),
      );
    } else {
      return const SizedBox();
    }
  }
}

class micSpeak extends StatefulWidget {
  final TextEditingController textController;
  final Function onTextUpdated;
  const micSpeak({super.key, required this.textController, required this.onTextUpdated});

  @override
  State<micSpeak> createState() => _micSpeakState();
}

class _micSpeakState extends State<micSpeak> {
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
            widget.onTextUpdated(); // Notify that text has been updated
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
        _startListening();
      },
      child: Image.asset(
          AppIcons.micIcon,
          color: Color(0XFF4169E1).withValues(alpha: .76),
          scale: 28),
    );
  }
}




class CopyBtnDic extends StatelessWidget {
  final Color iconColor;
  final String contentToCopy; // New parameter

  CopyBtnDic({required this.iconColor, required this.contentToCopy});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.copy, color: iconColor, size: 20,),
      onPressed: () {
        Clipboard.setData(ClipboardData(text: contentToCopy));
        Fluttertoast.showToast(msg: 'Text copied to clipboard');
      },
    );
  }
}


/// Volume Button - Speaks out text


class VolumeBtnDic extends StatefulWidget {
  final Color iconColor;
  final String textToSpeak;

  const VolumeBtnDic({required this.iconColor, required this.textToSpeak, Key? key}) : super(key: key);

  @override
  _VolumeBtnDicState createState() => _VolumeBtnDicState();
}

class _VolumeBtnDicState extends State<VolumeBtnDic> {
  final FlutterTts flutterTts = FlutterTts();

  void _speak() async {
    await flutterTts.stop(); // Stop ongoing speech before starting new one
    if (widget.textToSpeak.isNotEmpty) {
      await flutterTts.speak(widget.textToSpeak);
    }
  }

  @override
  void dispose() {
    flutterTts.stop(); // Stop speech when navigating away
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.volume_up, color: widget.iconColor, size: 20),
      onPressed: () {
        _speak();
        Fluttertoast.showToast(msg: 'Listen carefully');
      },
    );
  }
}


/// Share Button - Shares text using share_plus
class ShareBtnDic extends StatelessWidget {
  final Color iconColor;
  final String textToShare;

  ShareBtnDic({required this.iconColor, required this.textToShare});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.share, color: iconColor, size: 20),
      onPressed: () {
        if (textToShare.trim().isNotEmpty) {
          Share.share(textToShare);
          Fluttertoast.showToast(msg: 'share the text');
        } else {
          Fluttertoast.showToast(msg: 'No text to share');
        }
      },
    );
  }
}
