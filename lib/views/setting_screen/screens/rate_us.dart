import 'package:flutter/material.dart';

import '../../../widgets/text_widget.dart';


class RateUsScreen extends StatefulWidget {
  const RateUsScreen({super.key});

  @override
  State<RateUsScreen> createState() => _RateUsScreenState();
}

class _RateUsScreenState extends State<RateUsScreen> {
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
