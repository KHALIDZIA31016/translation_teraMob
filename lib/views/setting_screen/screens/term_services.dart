import 'package:flutter/material.dart';

import '../../../widgets/text_widget.dart';


class TermOfServiceScreen extends StatefulWidget {
  const TermOfServiceScreen({super.key});

  @override
  State<TermOfServiceScreen> createState() => _TermOfServiceScreenState();
}

class _TermOfServiceScreenState extends State<TermOfServiceScreen> {
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
