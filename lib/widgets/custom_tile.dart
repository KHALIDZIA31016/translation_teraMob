import 'package:flutter/material.dart';

import '../views/spell_pronounce/spell_pronounce.dart';

class CustomTile extends StatelessWidget {
  final List<String> tileTitle;
  final List<String>? tileSubTitle;
  final Color tileColor;
  final List<Widget>? tileLeading;
  final Widget? tileTrailing;
  int? selectedValue;
  ValueChanged<int?>? onChanged;
  final Color? borderColor;
  VoidCallback? onTap;

  CustomTile({
    super.key,
    required this.tileTitle,
    this.tileSubTitle,
    required this.tileColor,
    this.tileLeading,
    this.selectedValue,
    this.onChanged,
    this.tileTrailing,
    this.borderColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: tileTitle.length,
      itemBuilder: (context, index) {
        Color currentBorderColor = selectedValue == index ? (borderColor ?? Colors.blue) : Colors.transparent;
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () async {
              // Update selected value when the container is tapped
              if (onChanged != null) {
                onChanged!(index);
              }

              // Wait for 1 second before navigating
              await Future.delayed(Duration(microseconds: 3000));

              // Navigate to the next screen after the delay
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SpellPronounce()),
              );
            },
            child: Container(
              height: 70,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: currentBorderColor,  // Apply the dynamic border color
                  width: 2,  // Border width
                ),
                color: tileColor,
              ),
              child: ListTile(
                dense: true,
                leading: tileLeading?[index],
                trailing: Radio<int>(
                  value: index,
                  groupValue: selectedValue,
                  onChanged: onChanged,
                  activeColor: Colors.indigo,
                ),
                // trailing: tileTrailing,
                title: Text(tileTitle[index], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),),
                subtitle: Text(tileSubTitle?[index] ?? ''),
              ),
            ),
          ),
        );
      },
    );
  }
}









/// prevoius is deleted after see the difference

// previous code
// import 'package:flutter/material.dart';
//
//
// class CustomTile extends StatelessWidget {
//   final List<String> tileTitle;
//   List<String>? tileSubTitle;
//   final Color tileColor;
//   Widget? tileLeading;
//   Widget? tileTrailing;
//
//   CustomTile({super.key,
//     required this.tileTitle,
//     this.tileSubTitle,
//     required this.tileColor,
//     this.tileLeading,
//     this.tileTrailing});
//
//   @override
//   Widget build(BuildContext context) {
//     return Flexible(
//       child: ListView.builder(
//         itemCount: tileTitle.length,
//         itemBuilder: (context, index) {
//         return Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Container(
//               height: 70, width: double.infinity,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(12),
//                 color: Colors.white,
//               ),
//               child: ListTile(
//                 leading: tileLeading,
//                 trailing: tileTrailing,
//                 title: Text(tileTitle[index]),
//                 subtitle: Text(tileSubTitle?[index] ?? ''),
//               )
//           ),
//         );
//       },),
//     );
//   }
// }
//
//
