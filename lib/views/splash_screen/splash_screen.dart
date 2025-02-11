import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:mnh/utils/app_images.dart';
import 'package:mnh/views/onBoarding_screens/onBoarding_view/onBoarding_view.dart';
import 'package:mnh/widgets/extensions/empty_space.dart';
import 'package:mnh/widgets/text_widget.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';



class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _progress = 0.0;

  @override
  void initState() {
    super.initState();
    _startProgress();
  }

  void _startProgress() {
    Timer.periodic(Duration(milliseconds: 50), (Timer timer) {
      setState(() {
        _progress = (_progress + 0.01).clamp(0.0, 1.0); // Ensure value stays between 0.0 and 1.0
      });

      if (_progress == 1.0) {
        timer.cancel();
        _navigateToNextScreen();
      }
    });
  }
  void _navigateToNextScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => OnboardingView()),
    );
  }
  final String _text =
      'Come learn with us in your language'; // Text to display dynamically
  Widget _buildDynamicText() {
    List<String> letters = _text.split(''); // Split text into individual letters
    int highlightedLetterCount = (_progress * letters.length).floor();

    List<TextSpan> spans = [];
    for (int i = 0; i < letters.length; i++) {
      spans.add(
        TextSpan(
          text: letters[i], // Add individual letter
          style: TextStyle(
            color: i < highlightedLetterCount ? Colors.deepPurple : Colors.blueGrey,
            fontWeight: FontWeight.w700,
            fontFamily: 'Poppins',
            fontSize: 16,
          ),
        ),
      );
    }

    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(children: spans),
    );
  }





  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            100.asHeightBox,
            _buildDynamicText(),
            40.asHeightBox,
            Center(child: Image.asset(AppImages.AppLogo2, scale: 12,)),
            30.asHeightBox,
            CircularPercentIndicator(
              radius: 40.0,
              lineWidth: 7.0,
              percent: _progress,
              center: Text('${(_progress * 100).toInt()}%', style: TextStyle(
                  fontSize: 18,
                  color: Colors.deepPurple,
                  fontWeight: FontWeight.w600),),
              progressColor: Colors.teal,
            ),

            Spacer(),
            _buildDynamicText(),
            140.asHeightBox,
          ],
        ),
      ),
    );
  }
}
