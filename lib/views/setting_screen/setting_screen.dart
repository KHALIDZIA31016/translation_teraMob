import 'package:flutter/material.dart';
import 'package:mnh/utils/app_icons.dart';
import 'package:mnh/views/setting_screen/screens/chat_support.dart';
import 'package:mnh/views/setting_screen/screens/privacy_policy.dart';
import 'package:mnh/views/setting_screen/screens/rate_us.dart';
import 'package:mnh/views/setting_screen/screens/remove_ads.dart';
import 'package:mnh/views/setting_screen/screens/share.dart';
import 'package:mnh/views/setting_screen/screens/spell_pro.dart';
import 'package:mnh/views/setting_screen/screens/term_services.dart';
import '../../widgets/back_button.dart';
import '../../widgets/text_widget.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool _showSubtitles = false; // Track whether subtitles are visible

  final List<String> tileTitle = [
    'Remove Ads',
    'Customer Support',
    'Rate Us',
    'Share',
    'Privacy Policy',
    'Terms of Services',
    'Spell and Pronounce',
  ];

  final List<String> tileSubTitle = [
    'Remove all ads within the app',
    'Tell us what changes you\'d like to see, or bug you\'ve discovered.',
    'Do you like this app? Please support it with 5 stars',
    'Do you want to share this app with your friends?',
    'Read the privacy policy',
    'Read the terms and services',
    "Version 5.1.0"
  ];

  final List<String> leadingIcons = [
    AppIcons.adsIcon,
    AppIcons.csuppIcon,
    AppIcons.sirIcon,
    AppIcons.sarIcon,
    AppIcons.policIcon,
    AppIcons.termIon,
    AppIcons.spelIcon,
  ];

  final List<Widget> screens = [
    RemoveAdsScreen(),
    ChatSupportScreen(),
    RateUsScreen(),
    ShareScreen(),
    PrivacyPolicyscreen(),
    TermOfServiceScreen(),
    SpellAndProScreen(),
  ];

  void _onTileTap(int index) {
    setState(() {
      _showSubtitles = true; // Show subtitles for all tiles
    });

    // Navigate to the selected screen after 2 seconds
    Future.delayed(Duration(seconds: 2), () {
      Navigator.push(context, MaterialPageRoute(builder: (context) => screens[index]),
      ).then((_) {
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Color(0XFFE8E8E8),
      appBar: AppBar(
        leading: CustomBackButton(
          onPressed: () => Navigator.pop(context),
          icon: Icons.arrow_back_ios,
          iconSize: 18,
          btnColor: Color(0XFF006699),
        ),
        title: regularText(
          title: 'Setting Screen',
          textSize: screenWidth * 0.053,
          textColor: Color(0XFF006699),
          textWeight: FontWeight.w500,
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: tileTitle.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => _onTileTap(index),
            child: AnimatedContainer(
              duration: Duration(milliseconds: 300),
              height: _showSubtitles ? screenHeight * 0.11 : screenHeight * 0.08,
              width: screenWidth * 0.9, // Fixed width
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              decoration: BoxDecoration(
                color: Colors.white38,
                borderRadius: BorderRadius.circular(12),
                border: Border(
                  bottom: BorderSide(color: Colors.grey.shade300, width: 2),
                  top: BorderSide(color: Colors.grey.shade300, width: 2),
                ),
              ),
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Padding(
                  padding: const EdgeInsets.only(left: 4, right: 4),
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.blueGrey[100],
                    child: Image.asset(leadingIcons[index], scale: 24),
                  ),
                ),
                title: Text(
                  tileTitle[index],
                  style: TextStyle(
                    color: Color(0XFF006699),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: _showSubtitles
                    ? Text(
                  tileSubTitle[index],
                  style: TextStyle(
                    color: Color(0XFF22223B),
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
                  ),
                )
                    : null,
              ),
            ),
          );
        },
      ),
    );
  }
}
