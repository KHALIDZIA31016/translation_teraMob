// import 'package:flutter/material.dart';
// import 'package:share_plus/share_plus.dart';
//
//
// class ShareBtn extends StatefulWidget {
//   final TextEditingController controller;
//   const ShareBtn({super.key, required this.controller});
//
//   @override
//   State<ShareBtn> createState() => _ShareBtnState();
// }
//
// class _ShareBtnState extends State<ShareBtn> {
//   @override
//   Widget build(BuildContext context) {
//     return IconButton(
//       onPressed: () {
//         final text = controller.text.trim();
//         if (text.isNotEmpty) {
//           Share.share(text);
//         } else {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text('No text to share!'),
//             ),
//           );
//         }
//       },
//       icon: Icon(
//         Icons.share,
//         color: Colors.blueGrey,
//       ),
//     );
//   }
// }

/// see the difference



import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mnh/utils/app_icons.dart';
import 'package:share_plus/share_plus.dart';

import '../utils/app_colors.dart';

class ShareBtn extends StatelessWidget {
  final Color iconColor;
  final TextEditingController controller;

  const ShareBtn({super.key,
    required this.controller,
    required this.iconColor});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return IconButton(
      onPressed: () {
        final text = controller.text.trim();
        if (controller.text.isEmpty) {
          Fluttertoast.showToast(
            msg: 'Please enter the text first to share',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            webShowClose: true,
            timeInSecForIosWeb: 1,
            // backgroundColor: Colors.grey,
            // textColor: Colors.white,

            fontSize: 16.0,
          );
      }
      else {
          Share.share(text).then((_) {
        });
      }
      },
      icon: Image.asset(AppIcons.sharIcon, color: iconColor, scale: screenWidth * 0.067,)
    );
  }
}
