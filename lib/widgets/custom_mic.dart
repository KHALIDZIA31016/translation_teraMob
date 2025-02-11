import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../translator/controller/translate_contrl.dart';
import '../utils/app_icons.dart';

import 'package:speech_to_text/speech_to_text.dart' as stt;

class CustomMic extends StatefulWidget {
  final VoidCallback? onTap;
  const CustomMic({
    super.key,
    this.onTap,
  });

  @override
  State<CustomMic> createState() => _CustomMicState();
}

class _CustomMicState extends State<CustomMic> {
  final MyTranslationController translationController = Get.put(MyTranslationController());
  bool _isCooldown = false;

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
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: widget.onTap ?? () {
        // final selectedLanguageCode =
        //     '${translationController.languageCodes[
        // translationController.firstContainerLanguage.value
        // ]}-US';
        handleSpeechToText('');
      },
      child: Container(
        height: screenHeight * 0.06,
        width: screenWidth * 0.14,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(12), bottomLeft: Radius.circular(12)),
            color: Color(0XFF4169E1).withValues(alpha: .76),
        ),
        child: Image.asset(AppIcons.micIcon, color: Colors.white,scale: 23,),
      ),
    );
  }
}



//
// class CustomMic2 extends StatefulWidget {
//   final TextEditingController textController;
//   const CustomMic2({super.key, required this.textController});
//
//   @override
//   State<CustomMic2> createState() => _CustomMic2State();
// }
//
// class _CustomMic2State extends State<CustomMic2> {
//   late stt.SpeechToText _speech;
//   bool _isListening = false;
//   bool _isCooldown = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _speech = stt.SpeechToText();
//     _initializeSpeech();
//   }
//
//   Future<void> _initializeSpeech() async {
//     bool available = await _speech.initialize(
//       onStatus: (status) {
//         print("Speech Status: $status");
//       },
//       onError: (error) {
//         print("Speech Error: $error");
//       },
//     );
//     if (!available) {
//       Get.snackbar("Error", "Speech recognition is not available.");
//     }
//   }
//
//   Future<bool> isInternetAvailable() async {
//     var connectivityResult = await Connectivity().checkConnectivity();
//     return connectivityResult != ConnectivityResult.none;
//   }
//
//   Future<void> _startListening() async {
//     if (_isCooldown || _isListening) return;
//
//     final internetAvailable = await isInternetAvailable();
//     if (!internetAvailable) {
//       Fluttertoast.showToast(
//         msg: "Internet is weak or not available. Please check your connection.",
//         toastLength: Toast.LENGTH_SHORT,
//         gravity: ToastGravity.BOTTOM,
//       );
//       return;
//     }
//
//     try {
//       setState(() {
//         _isListening = true;
//         _isCooldown = true;
//       });
//
//       await _speech.listen(
//         onResult: (result) {
//           setState(() {
//             widget.textController.text = result.recognizedWords;
//           });
//         },
//         listenFor: const Duration(seconds: 10),
//         cancelOnError: true,
//       );
//     } catch (e) {
//       Get.snackbar('Error', 'Speech-to-text failed. Try again.');
//     } finally {
//       await Future.delayed(const Duration(seconds: 1));
//       setState(() {
//         _isListening = false;
//         _isCooldown = false;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     double screenHeight = MediaQuery.of(context).size.height;
//     double screenWidth = MediaQuery.of(context).size.width;
//     return GestureDetector(
//       onTap: _startListening,
//       child: Container(
//         height: screenHeight * 0.06,
//         width: screenWidth * 0.14,
//         decoration: BoxDecoration(
//           borderRadius: const BorderRadius.only(
//             topLeft: Radius.circular(12),
//             bottomLeft: Radius.circular(12),
//           ),
//           color: const Color(0XFF4169E1).withOpacity(0.76),
//         ),
//         child: Image.asset(AppIcons.micIcon, color: Colors.white, scale: 23),
//       ),
//     );
//   }
// }



class CustomMic2 extends StatefulWidget {
  final TextEditingController textController;
  const CustomMic2({super.key, required this.textController});

  @override
  State<CustomMic2> createState() => _CustomMic2State();
}

class _CustomMic2State extends State<CustomMic2> {

  final MyTranslationController translationController = Get.put(MyTranslationController());
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

    try {
      setState(() async{
        await translationController.startSpeechToText(languageCode);
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
      onTap: (){
        _startListening;
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




























/// dictionary
///
///

// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:mnh/utils/app_icons.dart';
// import 'package:mnh/views/spell_pronounce/services_dict/dict_model.dart';
// import 'package:mnh/views/spell_pronounce/services_dict/services.dart';
//
// import '../../translator/controller/translate_contrl.dart';
// import '../../widgets/back_button.dart';
//
// class DictionaryHomePage extends StatefulWidget {
//   const DictionaryHomePage({super.key});
//
//   @override
//   State<DictionaryHomePage> createState() => _DictionaryHomePageState();
// }
// class _DictionaryHomePageState extends State<DictionaryHomePage> {
//   final MyTranslationController translationController = Get.put(MyTranslationController());
//    bool _isCooldown = false;
//
//   Future<bool> isInternetAvailable() async {
//     var connectivityResult = await Connectivity().checkConnectivity();
//     return connectivityResult != ConnectivityResult.none;
//   }
//
//   Future<void> handleSpeechToText(String languageCode) async {
//     if (_isCooldown) {
//       Fluttertoast.showToast(
//         msg: "You tapped more than once. Please wait a moment.",
//         toastLength: Toast.LENGTH_SHORT,
//         gravity: ToastGravity.BOTTOM,
//       );
//       return;
//     }
//
//     final internetAvailable = await isInternetAvailable();
//
//     if (!internetAvailable) {
//       Fluttertoast.showToast(
//         msg: "Internet is weak or not available. Please check your connection.",
//         toastLength: Toast.LENGTH_SHORT,
//         gravity: ToastGravity.BOTTOM,
//       );
//       return;
//     }
//
//     try {
//       setState(() => _isCooldown = true);
//       await translationController.startSpeechToText(languageCode);  // Start the speech-to-text conversion
//       // Assuming `startSpeechToText` directly updates the TextField or handles it within itself.
//     } catch (e) {
//       Get.snackbar('Error', 'Speech-to-text failed. Try again.');
//     } finally {
//       await Future.delayed(const Duration(seconds: 1));
//       setState(() => _isCooldown = false);
//     }
//   }
//
//   DictionaryModel? myDictionaryModel;
//   bool isLoading = false;
//   bool hasSearched = false;
//   bool isLoad = false;
//   bool isSearchPerformed = false; // Tracks if search was performed
//   String noDataFound = "No word found!!\nCheck your word again";
//   TextEditingController searchController = TextEditingController();
//
//   // Fetch data for the searched word
//   searchContain(String word) async {
//     setState(() {
//       isLoading = true;
//       hasSearched = true;
//       isLoad = true;
//       isSearchPerformed = true; // Mark search as performed
//     });
//     try {
//       myDictionaryModel = await APIservices.fetchData(word);
//       setState(() {});
//     } catch (e) {
//       myDictionaryModel = null;
//       noDataFound = "Meaning can't be found";
//     } finally {
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }
//
//   // Reset the search and clear input
//   resetScreen() {
//     setState(() {
//       myDictionaryModel = null;
//       isLoading = false;
//       hasSearched = false;
//       isSearchPerformed = false; // Reset search status
//       searchController.clear();
//     });
//   }
//
//   // Display meanings or handle connectivity issues
//   findMeanings() async {
//     bool internetAvailable = await isInternetAvailable();
//
//     if (internetAvailable == null) {
//       Fluttertoast.showToast(
//         msg: "Internet is weak or not available. Please check your connection.",
//         toastLength: Toast.LENGTH_SHORT,
//         gravity: ToastGravity.BOTTOM,
//       );
//       return;
//     }
//
//     if (myDictionaryModel != null) {
//
//     } else {
//       Fluttertoast.showToast(
//           msg: 'This word is not in your dictionary'
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Color(0XFF4169E1).withValues(alpha: .76),
//         leading: CustomBackButton(
//             iconSize: 14,
//             onPressed: () {
//               Navigator.pop(context);
//             },
//             icon: Icons.arrow_back_ios_outlined,
//             btnColor: Colors.white
//         ),
//         title: const Text(
//           "Dictionary",
//           style: TextStyle(
//               color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700),
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(15),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             TextField(
//               controller: searchController,
//               decoration: InputDecoration(
//                 hintText: "Search the word here",
//                 prefixIcon: const Icon(Icons.search, color: Colors.blue),
//                 border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//                 suffixIcon: IconButton(
//
//                   icon: const Icon(Icons.mic, color: Colors.blue),
//                   onPressed: () {
//                     handleSpeechToText('isSearchPerformed');
//                   },
//                 ),
//               ),
//               onChanged: (value) {
//                 setState(() {});
//               },
//               onSubmitted: (value) {
//                 if (value.trim().isNotEmpty) {
//                   searchContain(value);
//                 }
//               },
//             ),
//             const SizedBox(height: 10),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 ElevatedButton(
//                   onPressed: isSearchPerformed ? resetScreen : null,
//                   style: ButtonStyle(
//                     backgroundColor:
//                     MaterialStateProperty.resolveWith<Color?>((states) {
//                       if (!isSearchPerformed) {
//                         return Colors.blueGrey.shade100; // Gray when disabled
//                       }
//                       return Colors.blueGrey; // Blue when enabled
//                     }),
//                   ),
//                   child: const Text(
//                     "Reset",
//                     style: TextStyle(color: Colors.white),
//                   ),
//                 ),
//                 ElevatedButton(
//                   onPressed: searchController.text.trim().isEmpty
//                       ? null
//                       : () async {
//                     await searchContain(searchController.text.trim());
//                     findMeanings(); // Check meanings after fetching data
//                   },
//                   style: ButtonStyle(
//                     backgroundColor:
//                     MaterialStateProperty.resolveWith<Color?>((states) {
//                       if (states.contains(MaterialState.disabled)) {
//                         return Colors.blueGrey.shade100;
//                       }
//                       return Colors.blueGrey;
//                     }),
//                   ),
//                   child: const Text(
//                     "Find Meaning",
//                     style: TextStyle(color: Colors.white),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 10),
//
//             // Conditionally display dictionary image or meaning content
//             if (!isSearchPerformed || myDictionaryModel == null)
//               Image.asset(
//                 AppIcons.dictIcon1,
//                 color: Color(0XFF4169E1).withOpacity(0.26),
//                 scale: 4,
//               ),
//             if (isLoading)
//               const Expanded(
//                 child: Center(
//                   child: CircularProgressIndicator(),
//                 ),
//               )
//             else if (myDictionaryModel != null)
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const SizedBox(height: 15),
//                     Text(
//                       myDictionaryModel!.word,
//                       style: const TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 25,
//                         color: Colors.blue,
//                       ),
//                     ),
//                     Text(
//                       myDictionaryModel!.phonetics.isNotEmpty
//                           ? myDictionaryModel!.phonetics[0].text ?? ""
//                           : "",
//                     ),
//                     const SizedBox(height: 10),
//                     Expanded(
//                       child: ListView.builder(
//                         itemCount: myDictionaryModel!.meanings.length,
//                         itemBuilder: (context, index) {
//                           return showMeaning(myDictionaryModel!.meanings[index]);
//                         },
//                       ),
//                     ),
//                   ],
//                 ),
//               )
//             else if (hasSearched)
//                 Center(
//                   child: Text(
//                     noDataFound,
//                     style: const TextStyle(fontSize: 16, color: Colors.red),
//                   ),
//                 ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   // Display meaning details
//   showMeaning(Meaning meaning) {
//     String wordDefinition = "";
//     for (var element in meaning.definitions) {
//       int index = meaning.definitions.indexOf(element);
//       wordDefinition += "\n${index + 1}.${element.definition}\n";
//     }
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 10),
//       child: Material(
//         borderRadius: BorderRadius.circular(20),
//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 meaning.partOfSpeech,
//                 style: const TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 22,
//                   color: Colors.blue,
//                 ),
//               ),
//               const SizedBox(height: 10),
//               const Text(
//                 "Definitions:",
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 18,
//                   color: Colors.black,
//                 ),
//               ),
//               Text(
//                 wordDefinition,
//                 style: const TextStyle(
//                   fontSize: 16,
//                   height: 1,
//                 ),
//               ),
//               wordRelation("Synonyms", meaning.synonyms),
//               wordRelation("Antonyms", meaning.antonyms),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   // Display synonyms or antonyms
//   wordRelation(String title, List<String>? setList) {
//     if (setList?.isNotEmpty ?? false) {
//       return Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             "$title:",
//             style: const TextStyle(
//               fontWeight: FontWeight.bold,
//               fontSize: 18,
//             ),
//           ),
//           Text(
//             setList!.toSet().toString().replaceAll("{", "").replaceAll("}", ""),
//             style: const TextStyle(fontSize: 18),
//           ),
//           const SizedBox(height: 10),
//         ],
//       );
//     } else {
//       return const SizedBox();
//     }
//   }
// }
//
//
//



// updated dict noe
// after making containers to elevation or a white color



// Display meaning details
// showMeaning(Meaning meaning) {
//   String wordDefinition = "";
//   for (var element in meaning.definitions) {
//     int index = meaning.definitions.indexOf(element);
//     wordDefinition += "\n${index + 1}.${element.definition}\n";
//   }
//   return Padding(
//     padding: const EdgeInsets.symmetric(vertical: 10),
//     child: Material(
//       borderRadius: BorderRadius.circular(20),
//       child: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Container(
//
//               color: Colors.greenAccent,
//               child: Text(
//                 meaning.partOfSpeech,
//                 style: const TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 22,
//                   color: Colors.blue,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 10),
//             Card(
//               color: Colors.orangeAccent,
//               child: const Text(
//                 "Definitions:",
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 18,
//                   color: Colors.black,
//                 ),
//               ),
//             ),
//             Card(
//               color: Colors.deepPurple,
//               child: Text(
//                 wordDefinition,
//                 style: const TextStyle(
//                   fontSize: 16,
//                   height: 1,
//                 ),
//               ),
//             ),
//             Card(
//               color: Colors.deepOrange,
//               child: Column(
//                 spacing: 14,
//                 children: [
//                   wordRelation("Synonyms", meaning.synonyms),
//                   wordRelation("Antonyms", meaning.antonyms),
//                 ],
//               ),
//             )
//
//           ],
//         ),
//       ),
//     ),
//   );
// }
//
// // Display synonyms or antonyms
// wordRelation(String title, List<String>? setList) {
//   if (setList?.isNotEmpty ?? false) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           "$title:",
//           style: const TextStyle(
//             fontWeight: FontWeight.bold,
//             fontSize: 18,
//           ),
//         ),
//         Text(
//           setList!.toSet().toString().replaceAll("{", "").replaceAll("}", ""),
//           style: const TextStyle(fontSize: 18),
//         ),
//         const SizedBox(height: 10),
//       ],
//     );
//   } else {
//     return const SizedBox();
//   }
// }




