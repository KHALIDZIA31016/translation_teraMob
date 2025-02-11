import 'package:flutter/material.dart';

import '../../../widgets/text_widget.dart';


class PrivacyPolicyscreen extends StatefulWidget {
  const PrivacyPolicyscreen({super.key});

  @override
  State<PrivacyPolicyscreen> createState() => _PrivacyPolicyscreenState();
}

class _PrivacyPolicyscreenState extends State<PrivacyPolicyscreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: regularText(title: 'Remove Ads'),),
      body: Column(
        children: [

        ],
      ),
    );
  }
}
