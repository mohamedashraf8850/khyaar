import 'package:flutter/material.dart';
import 'package:khiiaar/screens/SplashScreenPMD/data/onboard_page_data.dart';

class ColorProvider with ChangeNotifier {
  Color _color = onboardData[0].accentColor;

  Color get color => _color;

  set color(Color color) {
    _color = color;
    notifyListeners();
  }
}