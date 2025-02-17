// import 'dart:async';
// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:country_flags/country_flags.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:mnh/widgets/custom_mic.dart';
// import 'package:mnh/widgets/extensions/empty_space.dart';
// import '../../utils/app_icons.dart';
// import '../../widgets/back_button.dart';
// import '../../widgets/custom_textBtn.dart';
// import '../../widgets/text_widget.dart';
// import '../controller/translate_contrl.dart';
//
// class TranslateScreen extends StatefulWidget {
//   const TranslateScreen({Key? key}) : super(key: key);
//
//   @override
//   State<TranslateScreen> createState() => _TranslateScreenState();
// }
//
// class _TranslateScreenState extends State<TranslateScreen> {
//   final MyTranslationController translationController = Get.put(MyTranslationController());
//   final ScrollController _scrollController = ScrollController();
//   DateTime? lastTapTime;
//   bool _isCooldown = false;
//   bool _isTtsInProgress = false;
//   @override
//
//   void dispose() {
//     _scrollController.dispose();
//     Get.delete<MyTranslationController>(); // Dispose controller when leaving the screen
//     super.dispose();
//   }
//   Future<bool> isInternetAvailable() async {
//     var connectivityResult = await Connectivity().checkConnectivity();
//     return connectivityResult != ConnectivityResult.none;
//   }
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
//       await translationController.startSpeechToText(languageCode);
//     } catch (e) {
//       Get.snackbar('Error', 'Speech-to-text failed. Try again.');
//     } finally {
//       await Future.delayed(const Duration(seconds: 1));
//       setState(() => _isCooldown = false);
//     }
//   }
//   Future<void> speakText() async {
//     if (_isTtsInProgress) {
//       Fluttertoast.showToast(
//         msg: "TTS is already in progress. Please wait.",
//         toastLength: Toast.LENGTH_SHORT,
//         gravity: ToastGravity.BOTTOM,
//       );
//       return;
//     }
//
//     try {
//       setState(() => _isTtsInProgress = true);
//       await translationController.speakText();
//     } catch (e) {
//       Get.snackbar('Error', 'TTS failed. Try again.');
//     } finally {
//       setState(() => _isTtsInProgress = false);
//     }
//   }
//
//
//   void  swapLanguages() {
//     String temp = translationController.firstContainerLanguage.value;
//     translationController.firstContainerLanguage.value = translationController.secondContainerLanguage.value;
//     translationController.secondContainerLanguage.value = temp;
//     print('tapped on swap icon');
//   }
//   void _showLanguageSelect({
//     required String currentLang,
//     required void Function(String?) onLangSelect,
//   }){
//     showModalBottomSheet(
//         context: context,
//         builder: (BuildContext context){
//           return Column(
//             children: [
//               const SizedBox(height: 10),
//               Text(
//                 'Select the lang you want',
//                 style: TextStyle(
//                   color: Color(0XFF4682B4),
//                   fontSize: 16,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//
//               Expanded(
//                 child: ListView.builder(
//                   itemCount: translationController.languageCodes.length,
//                   itemBuilder: (context, index) {
//                     String language = translationController.languageFlags.keys.elementAt(index);
//                     String code = translationController.languageFlags[language]!;
//                     return Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
//                       child: Container(
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(10),
//                           border: Border.all(color: Colors.black),
//                         ),
//                         child: ListTile(
//                           tileColor: Colors.grey.shade200,
//                           title: Text(language, style: TextStyle(fontSize: 16)),
//                           dense: true,
//                           leading: CountryFlag.fromCountryCode(
//                             code,
//                             height: 25,
//                             shape: Circle(),
//                           ),
//                           trailing: currentLang == language
//                               ? Icon(Icons.check_circle, color: Colors.green, size: 20)
//                               : null,
//                           onTap: () {
//                             onLangSelect(language);
//                             Navigator.pop(context);
//                           },
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//
//             ],
//           );
//         });
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     final screenHeight = MediaQuery.of(context).size.height;
//     final screenWidth = MediaQuery.of(context).size.width;
//     return GestureDetector(
//       onTap: () => FocusScope.of(context).unfocus(),
//       child: Scaffold(
//         backgroundColor: Color(0XFFE8E8E8),
//         appBar: AppBar(
//           backgroundColor: Color(0XFF4169E1).withValues(alpha: .76),
//           leading:  CustomBackButton(
//             btnColor: Colors.white,
//             icon: Icons.arrow_back_ios,
//             iconSize: screenWidth * 0.05,
//             onPressed: (){
//               Navigator.pop(context);
//             },
//           ),
//           centerTitle: true,
//           title: regularText(
//               title: 'Translate language',
//               textColor: Colors.white,
//               textSize: screenWidth * 0.06,
//               textWeight: FontWeight.w500
//
//           ),
//         ),
//         body: SingleChildScrollView(
//           child: Column(
//             children: [
//               Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 10),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     GestureDetector(
//                       onTap: () => _showLanguageSelect(
//                         currentLang:  translationController.firstContainerLanguage.value,
//                         onLangSelect: (selected) {
//                           setState(() {
//                             translationController.firstContainerLanguage.value = selected!;
//                           });
//                         },
//                       ),
//                       child: LanguageContainer(
//                         LangColor: Colors.black,
//                         containerColor: Colors.pink,
//                         language: translationController.firstContainerLanguage.value,
//                         countryCode: translationController.languageFlags[
//                         translationController.firstContainerLanguage.value]!,
//                       ),
//                     ),
//                     Container(
//                       height: 35, width: 35,
//                       decoration: BoxDecoration(
//                           border: Border.all(color: Color(0XFF4169E1).withValues(alpha: .76), width: 2),
//                           // color: Colors.blueGrey.shade100,
//                           shape: BoxShape.circle
//                       ),
//                       child: ColorFiltered(
//                         colorFilter: ColorFilter.mode( Color(0XFF4169E1).withValues(alpha: .76),
//                             BlendMode.srcIn),
//                         child: GestureDetector(
//                             onTap: () {
//                               print('tapped');
//                               setState(() {
//                                 swapLanguages();
//                               });
//                             },
//                             child: Image.asset(AppIcons.convertIcon, scale: 26,)),
//                       ),
//                     ),
//                     GestureDetector(
//                       onTap: () => _showLanguageSelect(
//                         currentLang: translationController.secondContainerLanguage.value,
//                         onLangSelect: (selected) {
//                           setState(() {
//                             translationController.secondContainerLanguage.value = selected!;
//                           });
//                         },
//                       ),
//                       child: LanguageContainer(
//                         LangColor: Colors.black,
//                         containerColor: Colors.pink,
//                         language: translationController.secondContainerLanguage.value,
//                         countryCode: translationController.languageFlags[
//                         translationController.secondContainerLanguage.value]!,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//
//
//                       // me open
//                       // me
//                       // Container(
//                       //   margin: EdgeInsets.symmetric(horizontal: 10),
//                       //   height: screenHeight * 0.23,
//                       //   decoration: BoxDecoration(
//                       //     color: Color(0XFF4169E1).withValues(alpha: .6),
//                       //     borderRadius: BorderRadius.circular(16),
//                       //   ),
//                       //     child: Column(
//                       //     children: [
//                       //       TextField(
//                       //         style: TextStyle(
//                       //         color: Colors.white,
//                       //           fontSize: 16,
//                       //                 ),
//                       //           controller: translationController.controller,
//                       //           maxLines: null,
//                       //           decoration: const InputDecoration(
//                       //             hintText: 'Type your text here...',
//                       //             hintStyle:  TextStyle(
//                       //               color: Colors.white,
//                       //               fontSize: 16,
//                       //             ),
//                       //             border: OutlineInputBorder(borderSide: BorderSide.none),
//                       //           ),
//                       //           // textAlign: isSourceRTL ? TextAlign.right : TextAlign.left,
//                       //           // textDirection: isSourceRTL ? TextDirection.rtl : TextDirection.ltr,
//                       //         ),
//                       //       Spacer(),
//                       //       Row(
//                       //         mainAxisAlignment: MainAxisAlignment.center,
//                       //         crossAxisAlignment: CrossAxisAlignment.center,
//                       //         spacing: 10,
//                       //         children: [
//                       //           CustomMic(),
//                       //           CustomTextBtn(
//                       //             transController: translationController.controller,
//                       //             height: screenHeight * 0.06,
//                       //             width: screenWidth * 0.52,
//                       //             textTitle: 'Translate',
//                       //             decoration: BoxDecoration(
//                       //               borderRadius: BorderRadius.only(topRight: Radius.circular(12), bottomRight: Radius.circular(12)),
//                       //               color:    Color(0XFF4169E1).withValues(alpha: .76),
//                       //             ),
//                       //             // onTap: _speak, // mention a translated functionality here on click
//                       //           ),
//                       //         ],
//                       //       )
//                       //
//                       //                   ],
//                       //                 ),
//                       //         ),
//
//                        // me
//               // Input Text Section
//
//
//               // Container(
//               //   margin: EdgeInsets.symmetric(horizontal: 10),
//               //   height: screenHeight * 0.23,
//               //   decoration: BoxDecoration(
//               //     color: Color(0XFF4169E1).withOpacity(0.6),
//               //     borderRadius: BorderRadius.circular(16),
//               //   ),
//               //   child: Column(
//               //     children: [
//               //       Expanded(
//               //         child: Padding(
//               //           padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
//               //           child: Obx(() {
//               //             final isSourceRTL = translationController.isRTLLanguage(
//               //                 translationController.firstContainerLanguage.value);
//               //             return TextField(
//               //               style: TextStyle(
//               //                 color: Colors.white,
//               //                 fontSize: 16,
//               //               ),
//               //               controller: translationController.controller,
//               //               maxLines: null,
//               //               decoration: const InputDecoration(
//               //                 hintText: 'Type your text here...',
//               //                 hintStyle: TextStyle(
//               //                   color: Colors.white,
//               //                   fontSize: 16,
//               //                 ),
//               //                 border: OutlineInputBorder(borderSide: BorderSide.none),
//               //               ),
//               //               textAlign: isSourceRTL ? TextAlign.right : TextAlign.left,
//               //               textDirection: isSourceRTL ? TextDirection.rtl : TextDirection.ltr,
//               //             );
//               //           }),
//               //         ),
//               //       ),
//               //       Padding(
//               //         padding: EdgeInsets.all(8.0),
//               //         child: Row(
//               //           mainAxisAlignment: MainAxisAlignment.center,
//               //           children: [
//               //             GestureDetector(
//               //               onTap: () {
//               //                 final selectedLanguageCode =
//               //                     '${translationController.languageCodes[translationController.firstContainerLanguage.value]}-US';
//               //                 handleSpeechToText(selectedLanguageCode);
//               //               },
//               //               child: CircleAvatar(
//               //                 backgroundColor: Colors.white,
//               //                 child: Icon(Icons.mic, color: Color(0XFF6082B6)),
//               //               ),
//               //             ),
//               //             SizedBox(width: 10),
//               //             CustomTextBtn(
//               //               transController: translationController.controller,
//               //               height: screenHeight * 0.06,
//               //               width: screenWidth * 0.52,
//               //               textTitle: 'Translate',
//               //               decoration: BoxDecoration(
//               //                 borderRadius: BorderRadius.only(
//               //                     topRight: Radius.circular(12),
//               //                     bottomRight: Radius.circular(12)),
//               //                 color: Color(0XFF4169E1).withOpacity(0.76),
//               //               ),
//               //               onTap: () {
//               //                 translationController.translatedText();
//               //               },
//               //             ),
//               //           ],
//               //         ),
//               //       ),
//               //     ],
//               //   ),
//               // ),
//                       // me close
//                           20.asHeightBox,
//                           Container(
//                             margin: EdgeInsets.symmetric(horizontal: 16),
//                             height: 200, width: double.infinity,
//                             decoration: BoxDecoration(
//                               color: Colors.grey,
//                               borderRadius: BorderRadius.circular(12),
//                               border: Border.all(color: Colors.grey)
//                             ),
//                             child: Column(
//                               children: [
//                                 // original text
//                                 Expanded(
//                                   child: Padding(
//                                     padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
//                                     child: Obx(() {
//                                       final isSourceRTL = translationController.isRTLLanguage(
//                                           translationController.firstContainerLanguage.value);
//                                       return TextField(
//                                         style: TextStyle(
//                                           color: Colors.white,
//                                           fontSize: 16,
//                                         ),
//                                         controller: translationController.controller,
//                                         maxLines: null,
//                                         decoration: const InputDecoration(
//                                           hintText: 'Type your text here...',
//                                           hintStyle: TextStyle(
//                                             color: Colors.white,
//                                             fontSize: 16,
//                                           ),
//                                           border: OutlineInputBorder(borderSide: BorderSide.none),
//                                         ),
//                                         textAlign: isSourceRTL ? TextAlign.right : TextAlign.left,
//                                         textDirection: isSourceRTL ? TextDirection.rtl : TextDirection.ltr,
//                                       );
//                                     }),
//                                   ),
//                                 ),
//                                 Padding(
//                                   padding: EdgeInsets.all(8.0),
//                                   child: Row(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: [
//                                       GestureDetector(
//                                         onTap: () {
//                                           final selectedLanguageCode =
//                                               '${translationController.languageCodes[
//                                                 translationController.firstContainerLanguage.value]}-US';
//                                           handleSpeechToText(selectedLanguageCode);
//                                         },
//                                         child: CircleAvatar(
//                                           backgroundColor: Colors.white,
//                                           child: Icon(Icons.mic, color: Color(0XFF6082B6)),
//                                         ),
//                                       ),
//                                       SizedBox(width: 10),
//                                       CustomTextBtn(
//                                         transController: translationController.controller,
//                                         height: screenHeight * 0.06,
//                                         width: screenWidth * 0.52,
//                                         textTitle: 'Translate',
//                                         decoration: BoxDecoration(
//                                           borderRadius: BorderRadius.only(
//                                               topRight: Radius.circular(12),
//                                               bottomRight: Radius.circular(12)),
//                                           color: Color(0XFF4169E1).withOpacity(0.76),
//                                         ),
//                                         onTap: () {
//                                           translationController.translatedText();
//                                         },
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 //translated text
//                                 Divider(color: Colors.black,),
//                                           Obx((){
//                                             if(translationController.translatedText.value.isNotEmpty){
//                                               final isRTL = translationController.isRTLLanguage(
//                                                   translationController.secondContainerLanguage.value);
//                                               return Container(
//                                                 height: 100,
//                                                 color: Colors.blue,
//                                                 child: Column(
//                                                   children: [
//                                                     Row(
//                                                       children: [
//                                                       ],
//                                                     ),
//                                                     Align(
//                                                       alignment: isRTL ? Alignment.topRight : Alignment.topLeft,
//                                                       child: Padding(
//                                                           padding: const EdgeInsets.all(8.0),
//                                                           child:Text(
//                                                             translationController.translatedText.value ,
//                                                             textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
//                                                             style: TextStyle(
//                                                               color: Colors.white,
//                                                               fontSize: 18,
//
//                                                             ),
//                                                           )
//
//                                                       ),
//                                                     ),
//                                                   ],
//                                                 ),
//                                               );
//
//                                             }
//                                             return const SizedBox();
//                                           }),
//                               ],
//                             ),
//                           ),
//
//               // Padding(
//               //   padding: EdgeInsets.all(screenWidth * 0.02),
//               //   child: Container(
//               //     height: screenHeight * 0.23,
//               //     decoration: BoxDecoration(
//               //       color: Color(0XFF4169E1).withValues(alpha: .6),
//               //       borderRadius: BorderRadius.circular(16),
//               //     ),
//               //     child: Column(
//               //       children: [
//               //         Expanded(
//               //           child: Scrollbar(
//               //             controller: _scrollController,
//               //             thumbVisibility: true,
//               //             child: SingleChildScrollView(
//               //               controller: _scrollController,
//               //               child: Padding(
//               //                 padding: EdgeInsets.symmetric(
//               //                   horizontal: screenWidth * 0.02,
//               //                 ),
//               //                 child: Obx(() {
//               //                   final isSourceRTL = translationController.isRTLLanguage(
//               //                       translationController.firstContainerLanguage.value);
//               //                   return TextField(
//               //                     style: TextStyle(
//               //                       color: Colors.white,
//               //                       fontSize: 16,
//               //                     ),
//               //                     controller: translationController.controller,
//               //                     maxLines: null,
//               //                     decoration: const InputDecoration(
//               //                       hintText: 'Type your text here...',
//               //                       hintStyle:  TextStyle(
//               //                         color: Colors.white,
//               //                         fontSize: 16,
//               //                       ),
//               //                       border: OutlineInputBorder(borderSide: BorderSide.none),
//               //                     ),
//               //                     textAlign: isSourceRTL ? TextAlign.right : TextAlign.left,
//               //                     textDirection: isSourceRTL ? TextDirection.rtl : TextDirection.ltr,
//               //                   );
//               //                 }),
//               //               ),
//               //             ),
//               //           ),
//               //         ),
//               //         SizedBox(height: screenHeight * 0.01),
//               //         Padding(
//               //           padding: const EdgeInsets.all(8.0),
//               //           child: Row(
//               //             mainAxisAlignment: MainAxisAlignment.end,
//               //             children: [
//               //               GestureDetector(
//               //                 onTap: () {
//               //                   final selectedLanguageCode =
//               //                       '${translationController.languageCodes[
//               //                   translationController.firstContainerLanguage.value
//               //                   ]}-US';
//               //                   handleSpeechToText(selectedLanguageCode);
//               //                 },
//               //                 child: CircleAvatar(
//               //                   backgroundColor: Colors.white,
//               //                   child: Icon(Icons.mic, color: Color(0XFF6082B6),),
//               //                 ),
//               //               ),
//               //             ],
//               //           ),
//               //         )
//               //       ],
//               //     ),
//               //   ),
//               // ),
//               /// me open
//               //           Obx((){
//               //             if(translationController.translatedText.value.isNotEmpty){
//               //               final isRTL = translationController.isRTLLanguage(
//               //                   translationController.secondContainerLanguage.value);
//               //               return Container(
//               //                 color: Colors.blue,
//               //                 child: Align(
//               //                   alignment: isRTL ? Alignment.topRight : Alignment.topLeft,
//               //                   child: Padding(
//               //                       padding: const EdgeInsets.all(8.0),
//               //                       child:Text(
//               //                         translationController.translatedText.value ,
//               //                         textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
//               //                         style: TextStyle(
//               //                           color: Colors.white,
//               //                           fontSize: 18,
//               //
//               //                         ),
//               //                       )
//               //
//               //                   ),
//               //                 ),
//               //               );
//               //
//               //             }
//               //             return const SizedBox();
//               //           }),
// //// me close
//
//
//
//
//               // Translated Text Section
//               // Obx(() {
//               //   if (translationController.translatedText.value.isNotEmpty) {
//               //     final isRTL = translationController.isRTLLanguage(
//               //         translationController.secondContainerLanguage.value);
//               //     return Padding(
//               //       padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
//               //       child: Container(
//               //         height: screenHeight * 0.23,
//               //         width: double.infinity,
//               //         padding: EdgeInsets.all(screenWidth * 0.02),
//               //         decoration: BoxDecoration(
//               //           color: Color(0XFF698296).withValues(alpha: .6),
//               //           borderRadius: BorderRadius.circular(15),
//               //         ),
//               //         child: Column(
//               //           children: [
//               //
//               //             Expanded(
//               //               child: SingleChildScrollView(
//               //                 child: Align(
//               //                   alignment: isRTL ? Alignment.topRight : Alignment.topLeft,
//               //                   child: Padding(
//               //                     padding: const EdgeInsets.all(8.0),
//               //                     child:Text(
//               //                       translationController.translatedText.value ,
//               //                       textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
//               //                       style: TextStyle(
//               //                         color: Colors.white,
//               //                         fontSize: 18,
//               //
//               //                       ),
//               //                     )
//               //
//               //                   ),
//               //                 ),
//               //               ),
//               //             ),
//               //             Row(
//               //               mainAxisAlignment: MainAxisAlignment.end,
//               //               children: [
//               //                 CircleAvatar(
//               //                   backgroundColor: Colors.white,
//               //                   child: IconButton(
//               //                     icon: const Icon(Icons.volume_up, color: Color(0XFF6082B6),),
//               //                     onPressed: speakText,
//               //                     tooltip: "Speak text",
//               //                   ),
//               //                 ),
//               //               ],
//               //             ),
//               //           ],
//               //         ),
//               //       ),
//               //     );
//               //   } else {
//               //     return const SizedBox();
//               //   }
//               // }),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//   Widget pickCountry(String currentValue, Function(String?) onChanged) {
//   return Flexible(
//       child: Row(
//         children: [
//           GestureDetector(
//             onTap: () => _showLanguageSelect(
//               currentLang: translationController.firstContainerLanguage.value,
//               onLangSelect: (selected) {
//                 setState(() {
//                   translationController.firstContainerLanguage.value = selected!;
//                 });
//               },
//             ),
//             child: LanguageContainer(
//               LangColor: Colors.black,
//               containerColor: Colors.pink,
//               language: translationController.firstContainerLanguage.value,
//               countryCode: translationController.languageCodes[
//               translationController.firstContainerLanguage.value]!,
//             ),
//           ),
//           Container(
//             height: 35, width: 35,
//             decoration: BoxDecoration(
//                 border: Border.all(color: Color(0XFF000000).withValues(alpha: .4),width: 2),
//                 // color: Colors.blueGrey.shade100,
//                 shape: BoxShape.circle
//             ),
//             child: ColorFiltered(
//               colorFilter: ColorFilter.mode( Color(0XFF000000).withValues(alpha: .4),
//                   BlendMode.srcIn),
//               child: GestureDetector(
//                   onTap: () {
//                     print('tapped');
//                     setState(() {
//                       swapLanguages();
//                     });
//                   },
//                   child: Image.asset(AppIcons.convertIcon, scale: 26,)),
//             ),
//           ),
//           GestureDetector(
//             onTap: () => _showLanguageSelect(
//               currentLang: translationController.secondContainerLanguage.value,
//               onLangSelect: (selected) {
//                 setState(() {
//                   translationController.secondContainerLanguage.value = selected!;
//                 });
//               },
//             ),
//             child: LanguageContainer(
//               LangColor: Colors.black,
//               containerColor: Colors.pink,
//               language: translationController.secondContainerLanguage.value,
//               countryCode: translationController.languageCodes[
//               translationController.secondContainerLanguage.value]!,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
//
// // class LangContainer extends StatelessWidget {
// //   final String language;
// //   final String countryCode;
// //   final Color containerColor;
// //
// //   const LanguageContainer({
// //     required this.language,
// //     required this.countryCode,
// //     required this.containerColor,
// //   });
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     double screenHeight = MediaQuery.of(context).size.height;
// //     double screenWidth  = MediaQuery.of(context).size.width;
// //     return Container(
// //       height: screenHeight * 0.07,
// //       width: screenWidth * 0.4,
// //       decoration: BoxDecoration(
// //           borderRadius: BorderRadius.circular(12),
// //           color: containerColor
// //       ),
// //       child: Row(
// //         spacing: 10,
// //         children: [
// //           10.asWidthBox,
// //           CountryFlag.fromCountryCode(
// //             countryCode,
// //             height: 26,
// //             width: 26,
// //             shape: Circle(),
// //           ),
// //           Text(
// //             language,
// //             style: TextStyle(color: Colors.white, fontSize: screenWidth * 0.04),
// //           ),
// //           Icon(Icons.arrow_drop_down_outlined, color: Colors.white),
// //         ],
// //       ),
// //     );
// //   }
// // }
//
//
// class LanguageContainer extends StatelessWidget {
//   final String language;
//   final String countryCode;
//   final Color containerColor;
//   final Color LangColor;
//   const LanguageContainer({
//     required this.language,
//     required this.countryCode,
//     required this.containerColor,
//     required this.LangColor,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     double screenHeight = MediaQuery.of(context).size.height;
//     double screenWidth  = MediaQuery.of(context).size.width;
//     return Container(
//       height: screenHeight * 0.07,
//       width: screenWidth * 0.4,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(12),
//         color: containerColor
//       ),
//       child: Row(
//         spacing: 10,
//         children: [
//           10.asWidthBox,
//           CountryFlag.fromCountryCode(
//             countryCode,
//             height: 26,
//             width: 26,
//             shape: Circle(),
//           ),
//           Text(
//             language,
//             style: TextStyle(color: LangColor, fontSize: screenWidth * 0.04),
//           ),
//           Icon(Icons.arrow_drop_down_outlined, color: Colors.white),
//         ],
//       ),
//     );
//   }
// }
//
//
//
//
//
//
//
//
//
//
