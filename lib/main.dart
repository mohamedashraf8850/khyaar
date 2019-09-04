import 'package:flutter/material.dart';
import 'package:khiiaar/providers/color_provider.dart';
import 'package:khiiaar/themes/styles.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

import 'screens/SplashScreenPMD/onboarding.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Khiiaar',
      theme: appTheme(),
      home: Home(),
    );
  }
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Colors.transparent,
   ));
    return Scaffold(
      body: ChangeNotifierProvider(
        builder: (context) => ColorProvider(),
        child: Onboarding(),
      ),
    );
  }
}