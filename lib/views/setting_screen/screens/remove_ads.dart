import 'package:flutter/material.dart';
import 'package:mnh/widgets/text_widget.dart';

import '../../../widgets/back_button.dart';


class RemoveAdsScreen extends StatefulWidget {
  const RemoveAdsScreen({super.key});

  @override
  State<RemoveAdsScreen> createState() => _RemoveAdsScreenState();
}

class _RemoveAdsScreenState extends State<RemoveAdsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: CustomBackButton(
          onPressed: () => Navigator.pop(context),
          icon: Icons.arrow_back_ios,
          iconSize: 18,
          btnColor: Color(0XFF006699),
        ),
        title: regularText(
          title: 'Remove ADS',
          textSize: 18,
          textColor: Color(0XFF006699),
          textWeight: FontWeight.w500,
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [

        ],
      ),
    );
  }
}
