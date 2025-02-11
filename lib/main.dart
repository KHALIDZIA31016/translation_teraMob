import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:mnh/translator/view/my_translate_view.dart';
import 'package:mnh/views/spell_pronounce/dictionary.dart';
import 'package:mnh/views/spell_pronounce/services_dict/phras_db/lang_seg.dart';
import 'package:mnh/views/spell_pronounce/spell_pronounce.dart';
import 'package:mnh/widgets/custom_textBtn.dart';
import 'internet_connectivity/view/internet_connectivity.dart';


void main(){
  runApp(VoiceAssistance());
}


class VoiceAssistance extends StatefulWidget {
  const VoiceAssistance({super.key});

  @override
  State<VoiceAssistance> createState() => _VoiceAssistanceState();
}

class _VoiceAssistanceState extends State<VoiceAssistance> {
  final ConnectivityService connectivityService = ConnectivityService();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      maintainBottomViewPadding: true,
      child: GetMaterialApp(
        locale: Locale('en'),
        supportedLocales: [
          Locale('en'), // English
          Locale('es'), // Spanish
        ],

        debugShowCheckedModeBanner: false,
        title: 'SharedPreferencesWithCache Demo',
        home: SpellPronounce(),
      ),
    );
  }
}
