// import 'package:country_picker/country_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:mnh/widgets/text_widget.dart';
// //
// // class langSec extends StatefulWidget {
// //   const langSec({super.key});
// //
// //   @override
// //   State<langSec> createState() => _langSecState();
// // }
// //
// // class _langSecState extends State<langSec> {
// //   String selectedCountry = "eng";
// //   @override
// //   Widget build(BuildContext context) {
// //     double screenWidth = MediaQuery.of(context).size.width;
// //     return Scaffold(
// //       body: Center(
// //         child: Container(
// //           height: 100,
// //           width: 280,
// //           decoration: BoxDecoration(
// //             borderRadius: BorderRadius.circular(26),
// //             border: Border.all(color: Colors.blueGrey, width: 3)
// //           ),
// //           child: Row(
// //             children: [
// //               regularText(title: selectedCountry, textSize: 18, textColor: Colors.indigo),
// //               InkWell(
// //                 onTap: () {
// //                   showCountryPicker(
// //                     context: context,
// //                     showSearch: false,
// //                     onSelect: (Country country) {
// //                       setState(() {
// //                         selectedCountry = country.name; // Update selected country
// //                       });
// //                     },
// //                     countryListTheme: CountryListThemeData(
// //                       margin: EdgeInsets.only(right: 160),
// //                       flagSize: 25,
// //                       backgroundColor: Colors.white,
// //                       textStyle: TextStyle(fontSize: 16, color: Colors.blueGrey),
// //                       bottomSheetHeight: 600,
// //                       bottomSheetWidth: screenWidth * 0.6,
// //                       borderRadius: BorderRadius.only(
// //                         topLeft: Radius.circular(20.0),
// //                         topRight: Radius.circular(20.0),
// //                       ),
// //                       inputDecoration: InputDecoration(
// //                         prefixIcon: Icon(Icons.search),
// //                         border: OutlineInputBorder(
// //                           borderSide: BorderSide(
// //                             color: Color(0xFF8C98A8).withOpacity(0.2),
// //                           ),
// //                         ),
// //                       ),
// //                     ),
// //                   );
// //                 },
// //                 child: Icon(Icons.arrow_drop_down),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }
//
//
// class CountryPickerExample extends StatelessWidget {
//   void _showBottomSheet(BuildContext context, String country) {
//     showModalBottomSheet(
//       context: context,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (BuildContext context) {
//         return Container(
//           padding: EdgeInsets.all(16),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text(
//                 'Selected Country',
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//               ),
//               SizedBox(height: 10),
//               Text(
//                 country,
//                 style: TextStyle(fontSize: 16),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Country Picker"),
//         actions: [
//           PopupMenuButton<String>(
//             onSelected: (value) {
//               _showBottomSheet(context, value);
//             },
//             itemBuilder: (BuildContext context) {
//               return [
//                 PopupMenuItem(
//                   value: 'USA',
//                   child: Text('USA'),
//                 ),
//                 PopupMenuItem(
//                   value: 'Canada',
//                   child: Text('Canada'),
//                 ),
//                 PopupMenuItem(
//                   value: 'India',
//                   child: Text('India'),
//                 ),
//               ];
//             },
//             offset: Offset(0, 50), // Adjusts alignment of the menu
//           ),
//         ],
//       ),
//       body: Center(
//         child: Text("Tap the menu in the top-right corner"),
//       ),
//     );
//   }
// }
