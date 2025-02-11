import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mnh/views/languages/languages.dart';
import 'package:mnh/views/spell_pronounce/spell_pronounce.dart';
import 'package:mnh/widgets/custom_textBtn.dart';
import 'package:mnh/widgets/extensions/empty_space.dart';

import '../../../widgets/back_button.dart';
import '../../../widgets/text_widget.dart';


class ChatSupportScreen extends StatefulWidget {
  const ChatSupportScreen({super.key});

  @override
  State<ChatSupportScreen> createState() => _ChatSupportScreenState();
}

class _ChatSupportScreenState extends State<ChatSupportScreen> {
  final TextEditingController _controller = TextEditingController();
  bool _isButtonEnabled = false;
  bool isSelected = true;
 @override
  void initState() {
    super.initState();
    _controller.addListener((){
      setState(() {
        _isButtonEnabled = _controller.text.length >=20;
        isSelected = false;
      });
    });
  }


@override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
   double screenWidth = MediaQuery.of(context).size.width;
   double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Color(0XFFE8E8E8),
      appBar: AppBar(
        leading: CustomBackButton(
          onPressed: () => Navigator.pop(context),
          icon: Icons.arrow_back_ios,
          iconSize: 18,
          btnColor: Color(0XFF006699),
        ),
        title: regularText(
          title: 'Chat Support',
          textSize: 18,
          textColor: Color(0XFF006699),
          textWeight: FontWeight.w500,
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),

      body: Column(
        children: [
          4.asHeightBox,
         Center(
           child: AnimatedContainer(
             duration: Duration(seconds: 2),
             color: isSelected ? Colors.grey.shade100 : Colors.white,
             height: isSelected ? 40 : 200,
             width: isSelected ? 160 : 400,
             child: TextFormField(
               controller: _controller,
               maxLines: null,
               decoration: InputDecoration(
                 border: OutlineInputBorder(
                   borderRadius: isSelected 
                       ? BorderRadius.circular(16)
                       : BorderRadius.only(bottomRight: Radius.circular(16), bottomLeft: Radius.circular(16)),
                   borderSide: BorderSide.none
                 ),
                 hintText: 'Describe Issue (atleast 20 characters)',
                 hintStyle: TextStyle(
                   fontSize: screenWidth * 0.035,
                   color: Colors.grey,
                   fontWeight: FontWeight.w300,
                 )
               ),
             ),
           ),

         ),
          Spacer(),

         InkWell(
           onTap: _isButtonEnabled ? (){
             Navigator.pop(context);
            Fluttertoast.showToast(msg: 'Successfully submitted');
           } :null ,
           child: CustomTextBtn(
                height: 50,
                width: 300,
                textTitle: 'send query',
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: _isButtonEnabled ? Colors.indigo :Colors.grey,
              ),
            ),
         ),
        ],
      ),
    );
  }
}
