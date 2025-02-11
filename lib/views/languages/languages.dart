  import 'package:flutter/material.dart';
import 'package:mnh/utils/app_images.dart';
  import 'package:mnh/views/spell_pronounce/spell_pronounce.dart';
  import 'package:mnh/widgets/extensions/empty_space.dart';
  import 'package:mnh/widgets/text_widget.dart';

  import '../../widgets/custom_tile.dart';

  class LanguagesScreen extends StatefulWidget {
    const LanguagesScreen({super.key});

    @override
    State<LanguagesScreen> createState() => _LanguagesScreenState();
  }

  class _LanguagesScreenState extends State<LanguagesScreen> {
    int _selectedValue = 0;
    final List<String> languageNames = [
      'English',
      'Spanish',
      'Hindi',
      'Korean',
      'French',
      'Portuguese',
    ];

    final List<String> countriesFlag = [
      AppImages.UKFlag,
      AppImages.spainFlag,
      AppImages.hindiFlag,
      AppImages.koreanFlag,
      AppImages.frenchFlag,
      AppImages.portugueseFlag,
    ];


    void _onChanged(int? value) {
      if (value != null) {
        setState(() {
          _selectedValue = value;
        });
      }
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: Colors.grey.shade200,
        appBar: AppBar(
          shadowColor: Colors.grey,
          toolbarHeight: 65,
          title: regularText(
            title: 'Languages',
            textColor: Colors.white,
            textSize: 20,
          ),
          backgroundColor: Colors.indigo,
          actions: [
            Container(
              height: 40,
              width: 90,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Center(
                child: regularText(
                  title: 'Next',
                  textColor: Colors.white,
                  textSize: 16,
                  ontap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SpellPronounce()),
                    );
                  },
                ),
              ),
            ),
            20.asWidthBox,
          ],
        ),
        body: CustomTile(
          tileTitle: languageNames, // Pass language names
          tileColor: Colors.white,
          tileLeading: List.generate(
            countriesFlag.length,
                (index) => CircleAvatar(
              backgroundImage: AssetImage(countriesFlag[index]),
            ),
          ),
          selectedValue: _selectedValue, // Pass selected value
          onChanged: _onChanged, // Pass the change handler
        ),
      );
    }
  }


/// previous code



// import 'package:flutter/material.dart';
// import 'package:mnh/views/auth_screens/login_screen/login_screen.dart';
// import 'package:mnh/views/spell_pronounce/spell_pronounce.dart';
// import 'package:mnh/widgets/extensions/empty_space.dart';
// import 'package:mnh/widgets/text_widget.dart';
//
// import '../../widgets/custom_tile.dart';
// import '../../widgets/radio_btn.dart';
//
// class LanguagesScreen extends StatefulWidget {
//   const LanguagesScreen({super.key});
//
//   @override
//   State<LanguagesScreen> createState() => _LanguagesScreenState();
// }
//
// class _LanguagesScreenState extends State<LanguagesScreen> {
//   int _selectedValue = 0;
//
//   void _onChanged(int? value) {
//     if (value != null) {
//       setState(() {
//         _selectedValue = value;
//       });
//     }
//   }
//
//   final List<String> languageNames= [
//     'English',
//     'Spanish',
//     'Hindi',
//     'Korean',
//     'Italian',
//     'Chinese',
//     'Arabic',
//     'Urdu'
//   ];
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.blue.shade50,
//       appBar: AppBar(
//         title: regularText(
//           title: 'Languages',
//           textColor: Colors.white,
//           textSize: 16,
//         ),
//         backgroundColor: Colors.indigo,
//         actions: [
//           Container(
//             height: 40,
//             width: 90,
//             decoration: BoxDecoration(
//               color: Colors.blue,
//               borderRadius: BorderRadius.circular(14),
//             ),
//             child: Center(
//               child: regularText(
//                 title: 'Next',
//                 textColor: Colors.white,
//                 textSize: 16,
//                 ontap: (){
//                   Navigator.push(context, MaterialPageRoute(builder: (context) => SpellPronounce()));
//                 },
//               ),
//             ),
//           ),
//           20.asWidthBox
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//         child: Column(
//           children: [
//
//             CustomTile(
//               tileTitle: languageNames,
//               tileLeading: CircleAvatar(
//                 backgroundColor: Colors.grey,
//                 child: regularText(title: 'Flag', textColor: Colors.white),
//               ),
//               tileColor: Colors.grey,
//               tileTrailing: Radio<int>(
//                 value: index,
//                 groupValue: _selectedValue,
//                 onChanged: _onChanged,
//                 activeColor: Colors.indigo,
//                 fillColor: MaterialStateProperty.resolveWith(
//                       (states) {
//                     if (states.contains(MaterialState.selected)) {
//                       return Colors.indigo; // Indigo for selected
//                     }
//                     return Colors.grey; // Grey for unselected
//                   },
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
