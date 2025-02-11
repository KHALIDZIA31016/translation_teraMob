import 'package:flutter/cupertino.dart';
import 'package:mnh/models/languageModel.dart';
import 'package:mnh/models/phrase_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:io';
import 'package:flutter/services.dart';

class DbHelper {
  late Database _db;

  Future<void> initDatabase() async {

    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'LearnItalian.db');

    final isExist = await databaseExists(path);

    if (!isExist) {
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (e) {
        print("error creating directoy");
      }

      ByteData data = await rootBundle.load('assets/data_base/LearnItalian.db');
      List<int> bytes = data.buffer.asUint8List(
          data.offsetInBytes, data.lengthInBytes
      );
      await File(path).writeAsBytes(bytes);
    }
    else {
      print("existence database check noe");
    }
    _db = await openDatabase(path);
  }

  /// Example function to fetch data


  Future<List<LanguageModel>> fetchCategory() async {
    if (_db == null) {
      throw Exception("Database not initialized. Call initDatabase first.");
    }

    final List<Map<String, dynamic>> map = await _db.query('category');
    print("Fetched ${map.length} records from 'category'");

    return map.isNotEmpty
        ? List.generate(map.length, (i) => LanguageModel.fromMap(map[i]))
        : [];
  }


  Future<List<PhrasesModel>> fetchPhrases() async {
    final List<Map<String, dynamic>> phrasesMap = await _db.query('phrase');
    print("fetch or load... ${phrasesMap.length} records from 'phrase'");

    return phrasesMap.isNotEmpty
        ? List.generate(
        phrasesMap.length, (i) => PhrasesModel.fromMap(phrasesMap[i]))
        : [];
  }

}



























//
//
// class PhrasesScreen extends StatefulWidget {
//   const PhrasesScreen({super.key});
//
//   @override
//   State<PhrasesScreen> createState() => _PhrasesScreenState();
// }
//
// class _PhrasesScreenState extends State<PhrasesScreen> {
//   String selectedCountry = 'Eng';
//
//   final categoryController controller = Get.put(categoryController());
//   final List<String> languages = [
//     "English",
//     "Urdu",
//     "Arabic",
//     "Hindi",
//     "Sindhi",
//     "German",
//     "Italian",
//     "French"
//   ];
//
//   final BTMController btmController = Get.put(BTMController());
//
//   String? firstContainerLanguage = "English";
//   String? secondContainerLanguage = "Urdu";
//
//   String _getTranslation(BtmModel model, String language) {
//     switch (language) {
//       case "Urdu":
//         return model.urdu.isNotEmpty ? model.urdu : "No Translation";
//       case "Arabic":
//         return model.arabic.isNotEmpty ? model.arabic : "No Translation";
//       case "Hindi":
//         return model.hindi.isNotEmpty ? model.hindi : "No Translation";
//       case "Sindhi":
//         return model.sindhi.isNotEmpty ? model.sindhi : "No Translation";
//       case "German":
//         return model.german.isNotEmpty ? model.german : "No Translation";
//       case "Italian":
//         return model.italian.isNotEmpty ? model.italian : "No Translation";
//       case "French":
//         return model.french.isNotEmpty ? model.french : "No Translation";
//       default:
//         return model.english.isNotEmpty ? model.english : "No Translation";
//     }
//   }
//
//   void _showLanguageSelector({
//     required String currentLanguage,
//     required void Function(String) onLanguageSelected,
//   }) {
//     showModalBottomSheet(
//       context: context,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (BuildContext context) {
//         return Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             children: [
//               const SizedBox(height: 10),
//               Text(
//                 'Select the language you want',
//                 style: TextStyle(
//                     color: Colors.indigo,
//                     fontSize: 15,
//                     fontWeight: FontWeight.w400),
//               ),
//               Expanded(
//                 child: ListView.builder(
//                   shrinkWrap: true,
//                   itemCount: languages.length,
//                   itemBuilder: (context, index) {
//                     return ListTile(
//                       title: Text(languages[index]),
//                       trailing: currentLanguage == languages[index]
//                           ? Icon(Icons.check_circle, color: Colors.blue, size: 15)
//                           : null,
//                       onTap: () {
//                         onLanguageSelected(languages[index]);
//                         Navigator.pop(context); // Close the modal
//                       },
//                     );
//                   },
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//   final List<String> leadingIcons = [
//     AppImages.genIcon,
//     AppImages.travellingIcon,
//     AppImages.shopIcon,
//     AppImages.mealIcon,
//     AppImages.dateIcon,
//     AppImages.hospitalIcon,
//     AppImages.techIcon,
//     AppImages.planeIcon,
//   ];
//
//   final List<Map<String, dynamic>> phrasesCategories = [
//     {"name": "General", "catID": 01},
//     {"name": "Travel", "catID": 02},
//     {"name": "Market", "catID": 03},
//     {"name": "Meal Time", "catID": 04},
//     {"name": "Time & Date", "catID": 05},
//     {"name": "Hospital", "catID": 06},
//     {"name": "Technology", "catID": 07},
//     {"name": "Airport", "catID": 08},
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey.shade300,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         leading: CustomBackButton(
//           onPressed: () {
//             Navigator.pop(context);
//           },
//           icon: Icons.arrow_back_ios,
//           btnColor: Colors.indigo,
//         ),
//         title: regularText(
//           title: 'Phrases',
//           textColor: Colors.indigo,
//           textWeight: FontWeight.bold,
//           textSize: 18,
//         ),
//       ),
//       body: Column(
//         children: [
//           10.asHeightBox,
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: GestureDetector(
//                   onTap: () => _showLanguageSelector(
//                     currentLanguage: firstContainerLanguage!,
//                     onLanguageSelected: (selected) {
//                       setState(() {
//                         firstContainerLanguage = selected;
//                       });
//                     },
//                   ),
//                   child: Container(
//                     height: 40,
//                     width: 140,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(12),
//                       border: Border.all(color: Colors.grey),
//                       color: Colors.blueGrey,
//                     ),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Text(
//                           firstContainerLanguage!,
//                           style: TextStyle(color: Colors.white, fontSize: 16),
//                         ),
//                         Icon(Icons.arrow_drop_down_outlined, color: Colors.white),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           Expanded(
//             child: ListView.builder(
//                 itemCount: phrasesCategories.length,
//                 itemBuilder: (context, index) {
//                   return Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Container(
//                       height: 70,
//                       width: double.infinity,
//                       decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(16),
//                           border: Border.all(color: Colors.green)),
//                       child: InkWell(
//                         onTap: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => PhrasesCategoryScreen(
//                                 id: phrasesCategories[index]["catID"],
//                                 language: firstContainerLanguage!,
//                               ),
//                             ),
//                           );
//                         },
//                         child: ListTile(
//                           title: Text(phrasesCategories[index]["name"]),
//                           leading: Image.asset(
//                             leadingIcons[index],
//                             scale: 16,
//                           ),
//                         ),
//                       ),
//                     ),
//                   );
//                 }),
//           ),
//         ],
//       ),
//     );
//   }
// }
