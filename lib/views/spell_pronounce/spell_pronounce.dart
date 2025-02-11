import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:mnh/utils/app_colors.dart';
import 'package:mnh/utils/app_icons.dart';
import 'package:mnh/views/languages/languages.dart';
import 'package:mnh/views/spell_pronounce/check_spell.dart';
import 'package:mnh/views/spell_pronounce/dictionary.dart';
import 'package:mnh/views/spell_pronounce/phases.dart';
import 'package:mnh/views/spell_pronounce/pronunciation_screen.dart';
import 'package:mnh/views/spell_pronounce/translate_screen.dart';
import 'package:mnh/widgets/custom_mic.dart';
import 'package:mnh/widgets/extensions/empty_space.dart';
import 'package:panara_dialogs/panara_dialogs.dart';
import '../../testScreen.dart';
import '../../translator/view/my_translate_view.dart';
import '../../widgets/back_button.dart';
import '../../widgets/custom_drawer.dart';
import '../../widgets/text_widget.dart';
import '../setting_screen/setting_screen.dart';

class SpellPronounce extends StatefulWidget {
  const SpellPronounce({super.key});

  @override
  State<SpellPronounce> createState() => _SpellPronounceState();
}

class _SpellPronounceState extends State<SpellPronounce> {

  bool isTap = true;

  final List<String> title = [
    'Spell Checker',
    'Translator',
    'Dictionary',
    'Phrases',
    'Test Trans'
  ];

  final List<Widget> screens = [
    CheckSpellScreen(),
    TranslationScreen(),
    // TranslateScreen(),
    DictionaryHomePage(),
    PhrasesScreen(),
    InputScreen(),
  ];

  final List<double> iconSize = [14.3, 14.2, 14.2, 14.7, 14.7];

  final List<String> icons = [
    AppIcons.spelIcon1,
    AppIcons.transIcon1,
    AppIcons.dictnIcon1,
    AppIcons.phrsIcon1,
    AppIcons.occasionIcon,
  ];

  final List<Color> tileColor = [
    Color(0XFF6082B6),
    Color(0XFF6082B6),
    Color(0XFF6082B6),
    Color(0XFF6082B6),
    Color(0XFF6082B6),
  ];
  @override
  void initState() {
    super.initState();
    // Trigger the animation with a delay when the screen loads
    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        isTap = false; // Trigger the animation to expand the container
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: AppColors.kWhiteEF,
      drawer: CustomDrawer(),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Color(0XFF4169E1).withValues(alpha: .76),
        title: regularText(
          title: 'Spell and Pronounce',
          textSize: screenWidth * 0.042,
          textColor: Color(0XFFFFFFFF),
          textWeight: FontWeight.w500,
        ),
        actions: [
          CustomDialogBox(),
          10.asWidthBox,
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border(bottom: BorderSide(color: AppColors.kWhite, width: 2)),
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Pronunciation AnimatedContainer
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PronunciationScreen()));
                },
                child: AnimatedContainer(
                  alignment:
                      Alignment.centerLeft, // Fix the container to the left
                  duration: Duration(seconds: 2),
                  curve: Curves.easeInOut,
                  height: screenHeight * 0.1,
                  width: isTap ? screenWidth * 0.62 : screenWidth * 0.92,
                  decoration: BoxDecoration(
                    color: Color(0XFF4169E1).withValues(alpha: .76),
                    borderRadius: BorderRadius.circular(screenWidth * 0.04),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        AppIcons.pronIcon1,
                        scale: screenWidth * 0.06,
                        color: Colors.white,
                      ),
                      14.asWidthBox,
                      regularText(
                        title: 'Pronunciation',
                        textSize: screenWidth * 0.04,
                        textColor: Colors.white,
                        textWeight: FontWeight.w500,
                      ),
                    ],
                  ),
                ),
              ),

              Flexible(
                child: GridView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.01, vertical: 20),
                  itemCount: 5,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 4 / 3,
                    mainAxisSpacing: screenWidth * 0.05,
                    crossAxisSpacing: screenWidth * 0.05,
                  ),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => screens[index]));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0XFF4169E1).withValues(alpha: .76),
                          borderRadius:
                              BorderRadius.circular(screenWidth * 0.034),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              icons[index],
                              color: Colors.white,
                              scale: iconSize[index],
                              errorBuilder: (context, error, stackTrace) {
                                print("Error loading asset: ${icons[index]}");
                                return Icon(Icons.error, color: Colors.red);
                              },
                            ),
                            10.asHeightBox,
                          // CountryFlag.fromLanguageCode('en'),
                            regularText(
                              title: title[index].toString(),
                              textSize: screenWidth * 0.036,
                              textColor: Colors.white,
                              textWeight: FontWeight.w600,
                            ),



                          ],
                        ),
                      ),
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

class CustomDialogBox extends StatelessWidget {
  const CustomDialogBox({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => PanaraInfoDialog.show(
          noImage: true,
              context,
              title: "Rate our app",
              message: "Do you like the app",
              buttonText: "Rate Me",
              onTapDismiss: () {
                Navigator.pop(context);
              },
              color: Color(0XFF4169E1).withValues(alpha: .76),
              panaraDialogType: PanaraDialogType.custom,
              barrierDismissible: true, // optional parameter (default is true)
            ),
        child: Icon(Icons.thumb_up_off_alt, color: Colors.white));

  }
}





// now check spell row
// Column(
// children: [
// Row(
// mainAxisAlignment: MainAxisAlignment.center,
// spacing: 16,
// children: [
// // flag and language
// GestureDetector(
// onTap: () => _showLanguageSelect(
// currentLang: translationController.firstContainerLanguage.value,
// onLangSelect: (selected) {
// setState(() {
// translationController.firstContainerLanguage.value = selected!;
// });
// },
// ),
// child: LanguageContainer(
// LangColor: Colors.black,
// containerColor: Colors.white,
// language: translationController.firstContainerLanguage.value,
// countryCode: translationController.languageFlags[
// translationController.firstContainerLanguage.value]!,
// ),
// ),
//
// Spacer(),
// // buttons
// GestureDetector(
// onTap: () {
// if (_controller.text.trim().isEmpty) {
// _showToast("Please enter some text first!");
// } else {
// changeColor('copy');
// final textToCopy = _controller.text.trim();
// Clipboard.setData(ClipboardData(text: textToCopy)).then((_) {
// ScaffoldMessenger.of(context).showSnackBar(
// SnackBar(content: Text('Text copied to clipboard')),
// );
// });
// }
// },
// child: Image.asset(
// AppIcons.copyIcon,
// scale: screenHeight * 0.027,
// color: Colors.black,
// ),
// ),
// GestureDetector(
// onTap: () {
// if (_controller.text.trim().isEmpty) {
// _showToast("Please enter some text first!");
// } else {
// changeColor('share');
// final textToShare = _controller.text.trim();
// Share.share(textToShare);
// }
// },
// child: Image.asset(
// AppIcons.shareIcon,
// scale:  screenHeight * 0.032,
// color: Colors.black,
// ),
// ),
// GestureDetector(
// onTap: () {
// if (_controller.text.trim().isEmpty) {
// _showToast("Please enter some text first!");
// } else {
// changeColor('delete');
// _showDeleteConfirmationDialog();
// }
// },
// child: Icon(
// Icons.delete,
// size: screenHeight * 0.03,
// color: Colors.black,
// ),
// ),
// ],
// ),
// LanguageToolTextField(
// controller: _controller,
// language: 'en-US',
// maxLines: 6,
// decoration: const InputDecoration(
// hintText: 'Type your text here...',
// border: InputBorder.none
// ),
// ),
// Spacer(),
// // Mic and button
// Row(
// mainAxisAlignment: MainAxisAlignment.center,
// spacing: screenWidth * 0.003,
// children: [
// CustomMic(),
// 7.asWidthBox,
// _isLoading
// ? const CircularProgressIndicator()
//     : CustomTextBtn(
// height: screenHeight * 0.06,
// width: screenWidth * 0.52,
// textTitle: 'Spell Check',
// decoration: BoxDecoration(
// borderRadius: BorderRadius.only(topRight: Radius.circular(12), bottomRight: Radius.circular(12)),
// color: Color(0XFF4169E1).withValues(alpha: .76),
// ),
// onTap: _performSpellCheck,
// ),
// ],
// ),
// 10.asHeightBox,
// ],
// ),



