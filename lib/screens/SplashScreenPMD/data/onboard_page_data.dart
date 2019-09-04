import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:khiiaar/screens/SplashScreenPMD/models/onboard_page_model.dart';

List<OnboardPageModel> onboardData  = [
    OnboardPageModel(
      Colors.white,
      Colors.green,
      Color(0xFFFFE074),
      0,
      'images/flutter_onboarding_1.png',
      'أهلاً بك مع',
      'خيار',
      'مجتمع جديد هايخيرك لما تشتري. أختيار جهازك بقى سهل !',
    ),
    OnboardPageModel(
      Colors.green,
      Colors.white,
      Color(0xFF39393A),
      1,
      'images/flutter_onboarding_2.png',
      'من المميزات',
      'رشحلي',
      'رشح الجهاز لنفسك حسب رغباتك واختار اللي يلبي احتياجاتك',
    ),
    OnboardPageModel(
      Color(0xFFFFE074),
      Color(0xFF39393A),
      Color(0xFF39393A),
      2,
      'images/flutter_onboarding_4.png',
      'ولأول مرة',
      'قارن',
      'قارن بين أكتر من جهاز وشوف الأنسب ليك حسب احتياجك',
    ),
  ];