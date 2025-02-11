import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:mnh/widgets/text_widget.dart';

import '../utils/app_icons.dart';
import '../views/languages/languages.dart';
import '../views/setting_screen/setting_screen.dart';


class CustomDrawer extends StatelessWidget {
  const CustomDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 240,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          SizedBox(
            height: 120,
            child: DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.indigo[400],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 15,
                children: [
                  Image.asset(AppIcons.transIcon1, scale: 16,color: Colors.white,),
                  Text(
                    'Speak and Translate',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                ],
              ),
            ),
          ),
          ListTile(
            leading: Image.asset(AppIcons.transIcon1, scale: 20,),
            title: regularText(title: 'Languages', textWeight: FontWeight.w500, textSize: 14),
            onTap: () {
              // Navigate to Profile Screen
              Navigator.push(context, MaterialPageRoute(builder: (context) => LanguagesScreen()));
            },
          ),
          ListTile(
            leading: Image.asset(AppIcons.sarIcon, scale: 27,color: Colors.black,),
            title: regularText(title: 'Rate US', textWeight: FontWeight.w500, textSize: 14),
            onTap: () {
              // Navigate to Profile Screen
              // Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen()));
            },
          ),
          ListTile(
            leading: Image.asset(AppIcons.settingIcon, scale: 25,),
            title: regularText(title: ' More Apps', textWeight: FontWeight.w500, textSize: 14),
            onTap: () {
              // Navigate to Profile Screen
              // Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen()));
            },
          ),
          ListTile(
            leading: Image.asset(AppIcons.privPolIcon, scale: 22, ),
            title: regularText(title: 'Privacy Policy', textWeight: FontWeight.w500, textSize: 14),
            onTap: () {
              // Navigate to Profile Screen
              // Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen()));
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: regularText(title: 'Settings', textWeight: FontWeight.w500, textSize: 14),
            onTap: () {
              // Navigate to Profile Screen
              Navigator.push(context, MaterialPageRoute(builder: (context) => SettingScreen()));
            },
          ),
          ListTile(
            leading: Image.asset(AppIcons.pronIcon1, scale: 24,color: Colors.black,),
            title: regularText(title: 'Spell and Pronounce', textWeight: FontWeight.w500, textSize: 14),
            onTap: () {
              // Navigate to Profile Screen
              // Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen()));
            },
          ),
          ListTile(
            leading: Image.asset(AppIcons.remAdsIcon, scale: 24,),
            title: regularText(title: 'Remove Ads', textWeight: FontWeight.w500, textSize: 14),
            onTap: () {
              // Navigate to Profile Screen
              // Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen()));
            },
          ),

        // Logout Button
      ElevatedButton(
        onPressed: () {
          showLogoutConfirmation(context);
        },
        child: Text("Logout"),
      ),
        ],
      ),
    );
  }
}


void showLogoutConfirmation(BuildContext context) {
  Get.defaultDialog(
    title: "Confirm Logout",
    middleText: "Are you sure you want to logout?",
    textCancel: "No",
    textConfirm: "Yes",
    confirmTextColor: Colors.white,
    onConfirm: () {
      Navigator.push(context, MaterialPageRoute(builder: (context) => LanguagesScreen()));
    },
  );
}
