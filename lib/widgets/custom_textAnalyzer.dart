// import 'package:flutter/material.dart';
// import 'package:flutter_tts/flutter_tts.dart';
// import 'package:mnh/widgets/extensions/empty_space.dart';
// import 'package:mnh/widgets/share_btn.dart';
//
// import '../utils/app_images.dart';
// import 'copy_btn.dart';
// import 'custom_mic.dart';
// import 'custom_textBtn.dart';
// import 'delete_btn.dart';
// import 'dropDown_btn.dart';
//
//
//
// class CustomTextAnalyzer extends StatefulWidget {
//   final TextEditingController textController;
//   final void Function()? onCopy;
//   final void Function()? onShare;
//   final void Function()? onDelete;
//   final void Function()? onSpeak;
//
//   const CustomTextAnalyzer({
//     super.key,
//     required this.textController,
//     this.onCopy,
//     this.onShare,
//     this.onDelete,
//     this.onSpeak,
//   });
//
//   @override
//   State<CustomTextAnalyzer> createState() => _CustomTextAnalyzerState();
// }
//
// class _CustomTextAnalyzerState extends State<CustomTextAnalyzer> {
//   late final TextEditingController _textController;
//
//   @override
//   void initState() {
//     super.initState();
//     _textController = widget.textController; // Use the passed controller
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     double screenWidth = MediaQuery.of(context).size.width;
//     double screenHeight = MediaQuery.of(context).size.height;
//
//     return Container(
//       margin: EdgeInsets.symmetric(
//         horizontal: screenWidth * 0.02,
//         vertical: screenHeight * 0.02,
//       ),
//       height: 380,
//       width: screenWidth * 0.98,
//       color: Colors.white,
//       child: Column(
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               2.asWidthBox,
//               Image.asset(AppImages.UKFlag, scale: 20),
//               DropdownBtn(
//                 selectedValue: 'Eng',
//                 dropdownItems: ['Eng', 'Spanish', 'Turkish', 'Arabic', 'Hindi'],
//                 onChanged: (String? newValue) {
//                   // Handle language selection here
//                 },
//               ),
//               Spacer(),
//               CopyBtn(controller: _textController),
//               ShareBtn(controller: _textController),
//               DeleteBtn(controller: _textController),
//             ],
//           ),
//           Padding(
//             padding: const EdgeInsets.only(left: 10),
//             child: TextFormField(
//               controller: _textController,
//               decoration: InputDecoration(
//                 hintText: 'Type here',
//                 border: InputBorder.none,
//               ),
//             ),
//           ),
//           Spacer(),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               CustomMic(),
//               7.asWidthBox,
//               CustomTextBtn(onTap: widget.onSpeak),
//             ],
//           ),
//           10.asHeightBox,
//         ],
//       ),
//     );
//   }
// }
