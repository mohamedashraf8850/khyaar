import 'package:flutter/material.dart';
import 'package:khiiaar/providers/color_provider.dart';
import 'package:provider/provider.dart';
import 'components/onboard_page.dart';
import 'components/page_view_indicator.dart';
import 'data/onboard_page_data.dart';

class Onboarding extends StatelessWidget{
  final PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    ColorProvider colorProvider = Provider.of<ColorProvider>(context);
    return Stack(
      children: <Widget>[
        PageView.builder(
          controller: pageController,
          physics: NeverScrollableScrollPhysics(),
          itemCount: onboardData.length,
          itemBuilder: (context, index) {
            return OnboardPage(
              pageController: pageController,
              pageModel: onboardData[index],
            );
          },
        ),
        Container(
          width: double.infinity,
          height: 80,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 32.0),
                  child: Row(
                    children: <Widget>[
                      Text(
                        'ـار',
                        style: Theme.of(context).textTheme.title.copyWith(
                          color: colorProvider.color,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left:1.5),
                        child: Image.asset(
                          "images/cucumber.png",
                          height: 20,
                          width: 20,
                          color:colorProvider.color
                        ),
                      ),
                        Text(
                          'خيـ',
                          style: Theme.of(context).textTheme.title.copyWith(
                            color: colorProvider.color,
                          ),
                        ),

                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 32.0),
                  child: Text(
                    'بدء الإستخدام',
                    style: TextStyle(
                      color: colorProvider.color,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomLeft,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 40.0, left: 40),
            child: PageViewIndicator(
              controller: pageController,
              itemCount: onboardData.length,
              color: colorProvider.color,
            ),
          ),
        )
      ],
    );
  }
}