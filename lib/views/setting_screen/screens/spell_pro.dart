import 'package:flutter/material.dart';

import '../../../widgets/text_widget.dart';


class SpellAndProScreen extends StatefulWidget {
  const SpellAndProScreen({super.key});

  @override
  State<SpellAndProScreen> createState() => _SpellAndProScreenState();
}

class _SpellAndProScreenState extends State<SpellAndProScreen> {
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
