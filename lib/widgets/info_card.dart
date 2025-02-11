import 'package:flutter/material.dart';
import 'package:mnh/widgets/extensions/empty_space.dart';
import 'package:mnh/widgets/text_widget.dart';

import '../utils/app_icons.dart';

class InfoCard extends StatelessWidget {
  const InfoCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 190, width: 230,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey)),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: Column(
          children: [
            Row(
              children: [
                Icon(Icons.flag, color: Colors.red,),
                regularText(title: 'English')
              ],
            ),
            regularText(
                title: '"I am not afraid of storms. for I am learning how to sail my ship."'
            ),
            10.asHeightBox,
            Row(
              children: [
                Flexible(child: Divider(color: Colors.grey, thickness: 1,indent: 10,)),
                6.asWidthBox,
                Image.asset(AppIcons.convertIcon, scale: 40,),
                6.asWidthBox,
                Flexible(child: Divider(color: Colors.grey, thickness: 1,endIndent: 10,)),
              ],
            ),
            10.asHeightBox,
            Row(
              children: [
                Icon(Icons.flag, color: Colors.yellow,),
                regularText(title: 'Spanish')
              ],
            ),
            regularText(
                title: '"I am not afraid of storms. for I am learning how to sail my ship."'
            ),
          ],
        ),
      ),
    );
  }
}

