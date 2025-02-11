import 'package:flutter/material.dart';

Widget regularText ({

required String title,
  VoidCallback? ontap ,
double textSize = 12,
Color textColor = Colors.black,
final String textFamily = '',
FontWeight textWeight = FontWeight.normal,
TextAlign alignText = TextAlign.start,
})
{
  return GestureDetector(
    onTap: ontap,
    child: Text(title,
      textAlign: alignText,
      style: TextStyle(
      fontSize: textSize,
      color: textColor,
      fontWeight: textWeight,
        fontFamily: textFamily,
    ),),
  );
}