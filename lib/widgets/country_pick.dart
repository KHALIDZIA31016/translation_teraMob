// import 'package:country_picker/country_picker.dart';
// import 'package:flutter/material.dart';
//
// // void main() => runApp(MyApp());
// //
// // class MyApp extends StatelessWidget {
// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       title: 'Demo for country picker package',
// //       theme: ThemeData(
// //         primarySwatch: Colors.blue,
// //         visualDensity: VisualDensity.adaptivePlatformDensity,
// //       ),
// //       // supportedLocales: [
// //       //   const Locale('en'),
// //       //   const Locale('ar'),
// //       //   const Locale('es'),
// //       //   const Locale('de'),
// //       //   const Locale('fr'),
// //       //   const Locale('el'),
// //       //   const Locale('et'),
// //       //   const Locale('nb'),
// //       //   const Locale('nn'),
// //       //   const Locale('pl'),
// //       //   const Locale('pt'),
// //       //   const Locale('ru'),
// //       //   const Locale('hi'),
// //       //   const Locale('ne'),
// //       //   const Locale('uk'),
// //       //   const Locale('hr'),
// //       //   const Locale('tr'),
// //       //   const Locale('lv'),
// //       //   const Locale('lt'),
// //       //   const Locale('ku'),
// //       //   const Locale('nl'),
// //       //   const Locale('it'),
// //       //   const Locale('ko'),
// //       //   const Locale('ja'),
// //       //   const Locale('id'),
// //       //   const Locale('cs'),
// //       //   const Locale('ht'),
// //       //   const Locale('sk'),
// //       //   const Locale('ro'),
// //       //   const Locale('bg'),
// //       //   const Locale('ca'),
// //       //   const Locale('he'),
// //       //   const Locale('fa'),
// //       //   const Locale('da'),
// //       //   const Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hans'), // Generic Simplified Chinese 'zh_Hans'
// //       //   const Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant'), // Generic traditional Chinese 'zh_Hant'
// //       // ],
// //       // localizationsDelegates: [
// //       //   CountryLocalizations.delegate,
// //       //   // GlobalMaterialLocalizations.delegate,
// //       //   // GlobalCupertinoLocalizations.delegate,
// //       //   // GlobalWidgetsLocalizations.delegate,
// //       // ],
// //       home: HomePage(),
// //     );
// //   }
// // }
//
// class CountryPick extends StatefulWidget {
//   @override
//   _CountryPickState createState() => _CountryPickState();
// }
//
// class _CountryPickState extends State<CountryPick> {
//   // Initial country: United Kingdom
//   Country _selectedCountry = Country(
//     countryCode: 'GB',
//     phoneCode: '44',
//     e164Sc: 0,
//     geographic: true,
//     level: 1,
//     name: 'United Kingdom',
//     displayName: 'United Kingdom (ENG)',
//     displayNameNoCountryCode: 'United Kingdom',
//     e164Key: '', example: '',
//   );
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Demo for country picker')),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () {
//             showCountryPicker(
//               context: context,
//               favorite: <String>['GB'],
//               showPhoneCode: false,
//               onSelect: (Country country) {
//                 setState(() {
//                   _selectedCountry = country;
//                 });
//               },
//               countryListTheme: CountryListThemeData(
//                 borderRadius: BorderRadius.only(
//                   topLeft: Radius.circular(40.0),
//                   topRight: Radius.circular(40.0),
//                 ),
//                 inputDecoration: InputDecoration(
//                   labelText: 'Search',
//                   hintText: 'Start typing to search',
//                   prefixIcon: const Icon(Icons.search),
//                   border: OutlineInputBorder(
//                     borderSide: BorderSide(
//                       color: const Color(0xFF8C98A8).withOpacity(0.2),
//                     ),
//                   ),
//                 ),
//                 searchTextStyle: TextStyle(
//                   color: Colors.blue,
//                   fontSize: 18,
//                 ),
//               ),
//             );
//           },
//           child: Row(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Image.asset(
//                 'assets/flags/${_selectedCountry.countryCode.toLowerCase()}.png', // Assumes flag assets are present
//                 width: 24,
//                 height: 24,
//               ),
//               SizedBox(width: 8),
//               Text(_selectedCountry.displayNameNoCountryCode),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
