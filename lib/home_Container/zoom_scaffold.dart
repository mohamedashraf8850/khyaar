import 'package:flutter/material.dart';
import 'package:khiiaar/sidebar/circlepainting.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:provider/provider.dart';
import 'package:flip_card/flip_card.dart';
import 'package:khiiaar/providers/color_provider.dart';
import 'package:khiiaar/themes/styles.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:flutter/scheduler.dart';

class ZoomScaffold extends StatefulWidget {
  final Widget menuScreen;
  final Layout contentScreen;

  ZoomScaffold({
    this.menuScreen,
    this.contentScreen,
  });

  @override
  _ZoomScaffoldState createState() => new _ZoomScaffoldState();
}

class _ZoomScaffoldState extends State<ZoomScaffold>
    with TickerProviderStateMixin {
  TextEditingController search = TextEditingController();

  final pageController = PageController(
    initialPage: 1,
  );
  Curve scaleDownCurve = new Interval(0.0, 0.3, curve: Curves.easeOut);
  Curve scaleUpCurve = new Interval(0.0, 1.0, curve: Curves.easeOut);
  Curve slideOutCurve = new Interval(0.0, 1.0, curve: Curves.easeOut);
  Curve slideInCurve = new Interval(0.0, 1.0, curve: Curves.easeOut);

  int _currentIndex = 1;
  createContentDisplay() {
    List<Widget> Pages = [
      buildBodyforModwana(context),
      buildBodyforMokaranat(context),
      buildBodyforRashahly(context),
      buildBodyforTrend(context),
    ];
    onTabTapped(int index) {
      setState(() {
        _currentIndex = index;
        print(index);
      });
      return _currentIndex;
    }

    return zoomAndSlideContent(new Container(
      child: new Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.grey[200],
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(100.0),
          child: new AppBar(
            brightness: Brightness.light,
            centerTitle: true,
            backgroundColor: Colors.white,
            elevation: 0.0,
            leading: new IconButton(
                icon: Icon(
                  Icons.menu,
                  color: Colors.black,
                ),
                onPressed: () {
                  Provider.of<MenuController>(context, listen: true).toggle();
                }),
            actions: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 10.0, bottom: 5.0),
                child: GestureDetector(
                  child: Image.asset(
                    "images/home.png",
                    height: 25,
                    width: 25,
                  ),
                ),
              ),
            ],
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'ـار',
                  style: TextStyle(color: Colors.black),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 1.5),
                  child: Image.asset(
                    "images/cucumber.png",
                    height: 20,
                    width: 20,
                  ),
                ),
                Text(
                  'خيـ',
                  style: TextStyle(color: Colors.black),
                ),
              ],
            ),
            bottom: PreferredSize(
                child: buildSeacrhField(controller: search, context: context),
                preferredSize: null),
          ),
        ),
        body: SingleChildScrollView(child: Pages[_currentIndex]),
        bottomNavigationBar: BottomNavigationBar(
          onTap: onTabTapped, // new
          currentIndex: _currentIndex, // new
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.black,
          unselectedItemColor: Color(0xFFC5C5C5),
          elevation: 10,
          items: [
            BottomNavigationBarItem(
              title: Text('مدونة',
                  style:
                      TextStyle(color: Colors.black, fontFamily: 'ArbFONTS')),
              icon: Image.asset(
                "images/blog.png",
                height: 25,
                width: 25,
              ),
            ),
            BottomNavigationBarItem(
              title: Text('قارن',
                  style:
                      TextStyle(color: Colors.black, fontFamily: 'ArbFONTS')),
              icon: Image.asset(
                "images/mokaranat.png",
                height: 25,
                width: 25,
              ),
            ),
            BottomNavigationBarItem(
              title: Text('رشحلي',
                  style:
                      TextStyle(color: Colors.black, fontFamily: 'ArbFONTS')),
              icon: Image.asset(
                "images/rshahly.png",
                height: 25,
                width: 25,
              ),
            ),
            BottomNavigationBarItem(
              title: Text('ترند',
                  style:
                      TextStyle(color: Colors.black, fontFamily: 'ArbFONTS')),
              icon: Image.asset(
                "images/trend.png",
                height: 25,
                width: 25,
              ),
            ),
          ],
        ),
      ),
    ));
  }

  zoomAndSlideContent(Widget content) {
    var slidePercent, scalePercent;

    switch (Provider.of<MenuController>(context, listen: true).state) {
      case MenuState.closed:
        slidePercent = 0.0;
        scalePercent = 0.0;
        break;
      case MenuState.open:
        slidePercent = 1.0;
        scalePercent = 1.0;
        break;
      case MenuState.opening:
        slidePercent = slideOutCurve.transform(
            Provider.of<MenuController>(context, listen: true).percentOpen);
        scalePercent = scaleDownCurve.transform(
            Provider.of<MenuController>(context, listen: true).percentOpen);
        break;
      case MenuState.closing:
        slidePercent = slideInCurve.transform(
            Provider.of<MenuController>(context, listen: true).percentOpen);
        scalePercent = scaleUpCurve.transform(
            Provider.of<MenuController>(context, listen: true).percentOpen);
        break;
    }

    final slideAmount = 275.0 * slidePercent;
    final contentScale = 1.0 - (0.2 * scalePercent);
    final cornerRadius =
        16.0 * Provider.of<MenuController>(context, listen: true).percentOpen;

    return new Transform(
      transform: new Matrix4.translationValues(slideAmount, 0.0, 0.0)
        ..scale(contentScale, contentScale),
      alignment: Alignment.centerLeft,
      child: new Container(
        decoration: new BoxDecoration(
          boxShadow: [
            new BoxShadow(
              color: Colors.black12,
              offset: const Offset(0.0, 5.0),
              blurRadius: 15.0,
              spreadRadius: 10.0,
            ),
          ],
        ),
        child: new ClipRRect(
            borderRadius: new BorderRadius.circular(cornerRadius),
            child: content),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.dark,
    ));

    return Stack(
      children: [
        Container(
          child: Scaffold(
            body: widget.menuScreen,
          ),
        ),
        createContentDisplay()
      ],
    );
  }
}

class ZoomScaffoldMenuController extends StatefulWidget {
  final ZoomScaffoldBuilder builder;

  ZoomScaffoldMenuController({
    this.builder,
  });

  @override
  ZoomScaffoldMenuControllerState createState() {
    return new ZoomScaffoldMenuControllerState();
  }
}

class ZoomScaffoldMenuControllerState
    extends State<ZoomScaffoldMenuController> {
  @override
  Widget build(BuildContext context) {
    return widget.builder(
        context, Provider.of<MenuController>(context, listen: true));
  }
}

typedef Widget ZoomScaffoldBuilder(
    BuildContext context, MenuController menuController);

class Layout {
  final WidgetBuilder contentBuilder;

  Layout({
    this.contentBuilder,
  });
}

class MenuController extends ChangeNotifier {
  final TickerProvider vsync;
  final AnimationController _animationController;
  MenuState state = MenuState.closed;

  MenuController({
    this.vsync,
  }) : _animationController = new AnimationController(vsync: vsync) {
    _animationController
      ..duration = const Duration(milliseconds: 250)
      ..addListener(() {
        notifyListeners();
      })
      ..addStatusListener((AnimationStatus status) {
        switch (status) {
          case AnimationStatus.forward:
            state = MenuState.opening;
            break;
          case AnimationStatus.reverse:
            state = MenuState.closing;
            break;
          case AnimationStatus.completed:
            state = MenuState.open;
            break;
          case AnimationStatus.dismissed:
            state = MenuState.closed;
            break;
        }
        notifyListeners();
      });
  }

  @override
  dispose() {
    _animationController.dispose();
    super.dispose();
  }

  get percentOpen {
    return _animationController.value;
  }

  open() {
    _animationController.forward();
  }

  close() {
    _animationController.reverse();
  }

  toggle() {
    if (state == MenuState.open) {
      close();
    } else if (state == MenuState.closed) {
      open();
    }
  }
}

enum MenuState {
  closed,
  opening,
  open,
  closing,
}

//Bodys------------------------------------------------------------------------------------
Widget buildBodyforTrend(BuildContext context) {
  //SingleChildScrollView
  return Container(
      height: MediaQuery.of(context).size.height,
      color: Colors.white,
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: <Widget>[
          Expanded(child: AdvList()),
          Expanded(
            flex: 2,
            child: DefaultTabController(
                length: 5,
                initialIndex: 1,
                child: Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      color: Colors.white,
                      child: Center(
                        child: TabBar(
                          tabs: [
                            Tab(text: 'VR'),
                            Tab(text: 'كاميرا'),
                            Tab(text: 'ديسك توب'),
                            Tab(text: 'لاب توب'),
                            Tab(text: 'موبايل'),
                          ],
                          indicatorWeight: 3.5,
                          indicatorColor: Colors.yellow,
                          indicatorSize: TabBarIndicatorSize.label,
                          labelColor: Colors.black,
                          isScrollable: true,
                        ),
                      ),
                    ),
                    Divider(
                      color: Color(0xFFF1F1F1),
                    ),
                    Container(
                        color: Colors.white,
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                          //  - (274 + (142 + 17 + 16)),
                        child: TabBarView(
                          //body in lists
                          children: [
                            Center(child: Text("VR")),
                            Center(child: Text("كاميرا")),
                            Center(child: Text("ديسك توب")),
                            Center(child: Text("لاب توب")),
                            Listofitems(context),
                          ],
                        ))
                  ],
                )),
          ),
        ],
      ));
}

Widget buildBodyforRashahly(BuildContext context) {
  return Container(
      height: MediaQuery.of(context).size.height,
      color: Colors.white,
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: <Widget>[
          UberRowforRashahly(context),
          Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(30),
                      bottomLeft: Radius.circular(30),
                      topRight: Radius.circular(30)),
                  child: RaisedButton(
                    elevation: 1,
                    color: Color(0xFF69C86C),
                    child: Text(
                      "فلترة",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {},
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 130),
                child: InkWell(
                  child: Row(
                    children: <Widget>[
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "جميع الترشيحات",
                        style:
                            TextStyle(fontSize: 15, color: Color(0xFFC5C5C5)),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Icon(
                        Icons.arrow_back_ios,
                        color: Color(0xFFC5C5C5),
                        size: 20,
                      ),
                    ],
                  ),
                  onTap: () {},
                ),
              ),
            ],
          ),
          ListofRashahlyitems(context),
        ],
      ));
}

Widget buildBodyforMokaranat(BuildContext context) {
  TextEditingController searchmob1 = TextEditingController();
  TextEditingController searchmob2 = TextEditingController();
  return Container(
      height: MediaQuery.of(context).size.height,
      color: Colors.white,
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: <Widget>[
          UberRowforMokaranat(context, searchmob1, searchmob2),
          Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(30),
                      bottomLeft: Radius.circular(30),
                      topRight: Radius.circular(30)),
                  child: RaisedButton(
                    elevation: 1,
                    color: Color(0xFF69C86C),
                    child: Text(
                      "أضف جهاز",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {},
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 180),
                child: InkWell(
                  child: Row(
                    children: <Widget>[
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "رشحلي",
                        style:
                            TextStyle(fontSize: 15, color: Color(0xFFC5C5C5)),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Icon(
                        Icons.arrow_back_ios,
                        color: Color(0xFFC5C5C5),
                        size: 20,
                      ),
                    ],
                  ),
                  onTap: () {},
                ),
              ),
            ],
          ),
          ListofMokaranatitems(context),
        ],
      ));
}

Widget buildBodyforModwana(BuildContext context) {
  return Container(
      height: MediaQuery.of(context).size.height,
      color: Colors.white,
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Row(
            children: <Widget>[
              Padding(
                padding:
                    const EdgeInsets.only(left: 10.0, top: 10.0, bottom: 10.0),
                child: Container(
                  width: 80,
                  height: 30,
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(30),
                        bottomLeft: Radius.circular(30),
                        topRight: Radius.circular(30)),
                    child: RaisedButton(
                      elevation: 1,
                      color: Color(0xFF69C86C),
                      child: Text(
                        "مترجم",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {},
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(left: 10.0, top: 10.0, bottom: 10.0),
                child: Container(
                  width: 80,
                  height: 30,
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(30),
                        bottomLeft: Radius.circular(30),
                        topRight: Radius.circular(30)),
                    child: RaisedButton(
                      elevation: 1,
                      color: Color(0xFFFE5735),
                      child: Text(
                        "مميز",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {},
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(left: 70, top: 10.0, bottom: 10.0),
                child: InkWell(
                  child: Row(
                    children: <Widget>[
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "عرض الجميع",
                        style:
                            TextStyle(fontSize: 15, color: Color(0xFFC5C5C5)),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Icon(
                        Icons.arrow_back_ios,
                        color: Color(0xFFC5C5C5),
                        size: 20,
                      ),
                    ],
                  ),
                  onTap: () {},
                ),
              ),
            ],
          ),
          ListofModawanaitems(context),
        ],
      ));
}

//UberRows----------------------------------------------------------------------------------

Widget UberRowforRashahly(context) {
  String MobileValue = '  Lenovo';
  String PriceValue = '  1.000 L.E';
  String SortingValue = '  Processor';
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Card(
                elevation: 0,
                color: Color(0xFFF7F7F7),
                child: Wrap(
                  children: <Widget>[
                    //Mobile
                    DropdownButton<String>(
                      underline: Text(""),
                      value: SortingValue,
                      onChanged: (String newValue) {
//          setState(){
//            dropdownValue = newValue;
//          };
                      },
                      items: <String>[
                        '  Processor',
                        'Price',
                        'Ram',
                        'Screen',
                        'Memory'
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                            value: value,
                            child: Center(
                              child: Text(
                                value,
                                style: TextStyle(
                                    color: Color(0xFFC5C5C5),
                                    fontSize: 15,
                                    fontFamily: 'ArbFONTS'),
                                textAlign: TextAlign.center,
                              ),
                            ));
                      }).toList(),
                    ),
                  ],
                ),
              ),
              Card(
                elevation: 0,
                color: Color(0xFFF7F7F7),
                child: Wrap(
                  children: <Widget>[
                    //Price
                    DropdownButton<String>(
                      underline: Text(""),
                      value: PriceValue,
                      onChanged: (String newValue) {
//          setState(){
//            dropdownValue = newValue;
//          };
                      },
                      items: <String>[
                        '  1.000 L.E',
                        '2.000 L.E',
                        '3.000 L.E',
                        '4.000 L.E'
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                            value: value,
                            child: Center(
                              child: Text(
                                value,
                                style: TextStyle(
                                    color: Color(0xFFC5C5C5),
                                    fontSize: 15,
                                    fontFamily: 'ArbFONTS'),
                                textAlign: TextAlign.center,
                              ),
                            ));
                      }).toList(),
                    ),
                  ],
                ),
              ),
              Card(
                elevation: 0,
                color: Color(0xFFF7F7F7),
                child: DropdownButton<String>(
                  underline: Text(""),
                  value: MobileValue,
                  onChanged: (String newValue) {
//          setState(){
//            dropdownValue = newValue;
//          };
                  },
                  items: <String>['  Lenovo', 'Apple', 'LG', 'Nokia']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                        value: value,
                        child: Center(
                          child: Text(
                            value,
                            style: TextStyle(
                                color: Color(0xFFC5C5C5),
                                fontSize: 15,
                                fontFamily: 'ArbFONTS'),
                            textAlign: TextAlign.center,
                          ),
                        ));
                  }).toList(),
                ),
              ),
            ],
          ),
          ClipRRect(
              borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                  topLeft: Radius.circular(10)),
              child: Container(
                child: RaisedButton(
                  elevation: 1,
                  onPressed: () {},
                  color: Color(0xFF3BB73D),
                  child: Text(
                    "رشحلي",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontFamily: 'ArbFONTS'),
                  ),
                ),
                width: MediaQuery.of(context).size.width - 30,
              )),
          Divider(
            color: Color(0xFFF1F1F1),
          ),
        ],
      ),
    ),
  );
}

Widget UberRowforMokaranat(context, controller1, controller2) {
  String MobileValue = '  موبايل';
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: TextFormField(
                  style: new TextStyle(
                      fontSize: 10.0, height: 0.8, color: Colors.black),
                  decoration: new InputDecoration(
                    fillColor: Color(0xFFF7F7F7),
                    contentPadding:
                        EdgeInsets.only(top: 3, bottom: 3, right: 20),
                    hintText: 'اسم الهاتف',
                    hintStyle: TextStyle(color: Color(0xFFC5C5C5)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(5.0),
                        ),
                        borderSide: BorderSide(color: Color(0xFFF7F7F7))),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(5.0),
                        ),
                        borderSide: BorderSide(color: Color(0xFFF7F7F7))),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(5.0),
                        ),
                        borderSide: BorderSide(color: Color(0xFFF7F7F7))),
                    prefixIcon: Icon(
                      Icons.search,
                      size: 10.0,
                      color: Color(0xFFC5C5C5),
                    ),
                    filled: true,
                  ),
                  keyboardType: TextInputType.text,
                  textAlign: TextAlign.end,
                  controller: controller1,
                ),
              ),
              SizedBox(width: 3),
              Expanded(
                flex: 1,
                child: TextFormField(
                  style: new TextStyle(
                      fontSize: 10.0, height: 0.8, color: Colors.black),
                  decoration: new InputDecoration(
                    fillColor: Color(0xFFF7F7F7),
                    contentPadding:
                        EdgeInsets.only(top: 3, bottom: 3, right: 20),
                    hintText: 'اسم الهاتف',
                    hintStyle: TextStyle(color: Color(0xFFC5C5C5)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(5.0),
                        ),
                        borderSide: BorderSide(color: Color(0xFFF7F7F7))),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(5.0),
                        ),
                        borderSide: BorderSide(color: Color(0xFFF7F7F7))),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(5.0),
                        ),
                        borderSide: BorderSide(color: Color(0xFFF7F7F7))),
                    prefixIcon: Icon(
                      Icons.search,
                      size: 10.0,
                      color: Color(0xFFC5C5C5),
                    ),
                    filled: true,
                  ),
                  keyboardType: TextInputType.text,
                  textAlign: TextAlign.end,
                  controller: controller2,
                ),
              ),
              Expanded(
                flex: 1,
                child: Card(
                  elevation: 0,
                  color: Color(0xFFF7F7F7),
                  child: Center(
                    child: DropdownButton<String>(
                      underline: Text(""),
                      icon: Icon(
                        Icons.arrow_drop_down,
                        color: Color(0xFFC5C5C5),
                        textDirection: TextDirection.rtl,
                      ),
                      isExpanded: true,
                      value: MobileValue,
                      onChanged: (String newValue) {
//          setState(){
//            dropdownValue = newValue;
//          };
                      },
                      items: <String>[
                        '  موبايل',
                        '  لابتوب',
                        '  ديسكتوب',
                        '  كاميرا',
                        '  VR'
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                            value: value,
                            child: Center(
                              child: Text(
                                value,
                                style: TextStyle(
                                  color: Color(0xFFC5C5C5),
                                  fontSize: 10,
                                ),
                                textAlign: TextAlign.end,
                              ),
                            ));
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ],
          ),
          ClipRRect(
              borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                  topLeft: Radius.circular(10)),
              child: Container(
                child: RaisedButton(
                  elevation: 1,
                  onPressed: () {},
                  color: Color(0xFF3BB73D),
                  child: Text(
                    "قارن",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontFamily: 'ArbFONTS'),
                  ),
                ),
                width: MediaQuery.of(context).size.width - 30,
              )),
          Divider(
            color: Color(0xFFF1F1F1),
          ),
        ],
      ),
    ),
  );
}

//Wigets-------------------------------------------------------------------------------------

Widget buildSeacrhField({var controller, context}) {
  return Padding(
    padding: const EdgeInsets.only(left: 10.0, right: 10.0),
    child: TextFormField(
      autofocus: false,
      textAlign: TextAlign.end,
      style: new TextStyle(fontSize: 15.0, height: 0.8, color: Colors.black),
      controller: controller,
      decoration: new InputDecoration(
        fillColor: Color(0xFFF7F7F7),
        contentPadding: EdgeInsets.only(top: 3, bottom: 3, right: 20),
        hintText: 'بحث',
        hintStyle: TextStyle(color: Color(0xFFC5C5C5)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(50.0),
            ),
            borderSide: BorderSide(color: Color(0xFFF7F7F7))),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(50.0),
            ),
            borderSide: BorderSide(color: Color(0xFFF7F7F7))),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(50.0),
            ),
            borderSide: BorderSide(color: Color(0xFFF7F7F7))),
        prefixIcon: Icon(
          Icons.search,
          size: 20.0,
          color: Color(0xFFC5C5C5),
        ),
        filled: true,
      ),
      keyboardType: TextInputType.text,
    ),
  );
}

Widget item(
    {imageUrl,
    name,
    Ranking,
    RankingText,
    battery,
    Ram,
    Processor,
    Camera,
    Screen_Size,
    setSate,
    Price}) {
  bool loading = true;

  double ratingtxt = 3.5;
  int starCount = 6;
  return Material(
    child: IgnorePointer(
      ignoring: !loading,
      child: AnimatedOpacity(
        opacity: loading ? 1 : 0,
        duration: Duration(milliseconds: 500),
        child: Card(
          elevation: 1.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25),
                bottomLeft: Radius.circular(25),
                bottomRight: Radius.circular(25),
                topRight: Radius.circular(150)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 110.0, top: 10),
                    child: Text(
                      name,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'ArbFONTS',
                      ),
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      new Padding(
                        padding: new EdgeInsets.only(
                          bottom: 10.0,
                          right: 140,
                        ),
                        child: Row(
                          children: <Widget>[
                            new StarRating(
                              size: 15.0,
                              rating: ratingtxt,
                              color: Colors.orange,
                              borderColor: Colors.grey,
                              starCount: starCount,
                            ),
                            Text(
                              "$ratingtxt",
                              style: new TextStyle(fontSize: 10.0),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      buildFeature(
                          image: "images/screensize.png", title: Screen_Size),
                      SizedBox(
                        width: 10,
                      ),
                      buildFeature(image: "images/camera.png", title: Camera),
                      SizedBox(
                        width: 10,
                      ),
                      buildFeature(
                          image: "images/processor.png", title: Processor),
                      SizedBox(
                        width: 10,
                      ),
                      buildFeature(image: "images/ram.png", title: Ram),
                      SizedBox(
                        width: 10,
                      ),
                      buildFeature(image: "images/battery.png", title: battery),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 8.0, left: 170, right: 8.0, bottom: 9.0),
                    child: Text(
                      Price,
                      style: TextStyle(color: Colors.green),
                    ),
                  )
                ],
              ),
              Image.network(
                "https://image.coolblue.be/max/500x500/products/1207173",
                height: 130,
                fit: BoxFit.fill,
                width: 80,
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

Widget Rashahlyitem(
    {imageUrl,
    name,
    Ranking,
    RankingText,
    battery,
    Ram,
    Processor,
    Camera,
    Screen_Size,
    setSate,
    Price,
    ind,
    Color Colore}) {
  bool loading = true;
  double ratingtxt = 3.5;
  int starCount = 6;
  return Material(
    child: IgnorePointer(
      ignoring: !loading,
      child: AnimatedOpacity(
        opacity: loading ? 1 : 0,
        duration: Duration(milliseconds: 500),
        child: Card(
          elevation: 1.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25),
                bottomLeft: Radius.circular(25),
                bottomRight: Radius.circular(25),
                topRight: Radius.circular(150)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 110.0, top: 10),
                    child: Text(
                      name,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'ArbFONTS',
                      ),
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      new Padding(
                        padding: new EdgeInsets.only(
                          bottom: 10.0,
                          right: 140,
                        ),
                        child: Row(
                          children: <Widget>[
                            new StarRating(
                              size: 15.0,
                              rating: ratingtxt,
                              color: Colors.orange,
                              borderColor: Colors.grey,
                              starCount: starCount,
                            ),
                            Text(
                              "$ratingtxt",
                              style: new TextStyle(fontSize: 10.0),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      buildFeature(
                          image: "images/screensize.png", title: Screen_Size),
                      SizedBox(
                        width: 10,
                      ),
                      buildFeature(image: "images/camera.png", title: Camera),
                      SizedBox(
                        width: 10,
                      ),
                      buildFeature(
                          image: "images/processor.png", title: Processor),
                      SizedBox(
                        width: 10,
                      ),
                      buildFeature(image: "images/ram.png", title: Ram),
                      SizedBox(
                        width: 10,
                      ),
                      buildFeature(image: "images/battery.png", title: battery),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 6.0, right: 20.0),
                        child: Container(
                          child: Center(child: Text(ind)),
                          color: Colore,
                          width: 40,
                          height: 40,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 6.0),
                        child: Image.asset(
                          "images/mokaranat.png",
                          height: 25,
                          width: 25,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 10.0, left: 90, right: 8.0, bottom: 9.0),
                        child: Text(
                          Price,
                          style: TextStyle(color: Colors.green),
                        ),
                      ),
                    ],
                  )
                ],
              ),
              Image.network(
                "https://image.coolblue.be/max/500x500/products/1207173",
                height: 130,
                fit: BoxFit.fill,
                width: 80,
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

Widget Mokaranatitem(
    {imageUrl1,
    imageUrl2,
    name1,
    name2,
    Ranking1,
    Ranking2,
    RankingText1,
    RankingText2,
    battery1,
    battery2,
    Ram1,
    Ram2,
    Processor1,
    Processor2,
    Camera1,
    Camera2,
    Screen_Size1,
    Screen_Size2,
    setSate1,
    setSate2,
    Price1,
    Price2,
    ind1,
    ind2,
    Colore1,
    Colore2,
    voteColor1,
    voteColor2}) {
  bool loading = true;
  double ratingtxt1 = 3.5;
  double ratingtxt2 = 3.5;
  int starCount1 = 6;
  int starCount2 = 6;
  return Material(
    child: IgnorePointer(
      ignoring: !loading,
      child: AnimatedOpacity(
        opacity: loading ? 1 : 0,
        duration: Duration(milliseconds: 500),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25)),
                  color: Colors.white,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 130.0),
                        child: Container(
                          child: Center(child: Text(ind2)),
                          color: Colore2,
                          width: 40,
                          height: 40,
                        ),
                      ),
                      Card(
                        child: Image.network(
                          imageUrl2,
                          width: 80,
                          height: 100,
                          fit: BoxFit.fitHeight,
                        ),
                        elevation: 5,
                        color: Colors.transparent,
                      ),
                      Text(name2,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 15,
                              fontFamily: 'ArbFONTS',
                              fontWeight: FontWeight.bold,
                              color: Colors.black)),
                      Row(
                        children: <Widget>[
                          new StarRating(
                            size: 15.0,
                            rating: ratingtxt2,
                            color: Colors.orange,
                            borderColor: Colors.grey,
                            starCount: starCount2,
                          ),
                          Text(
                            "$ratingtxt2",
                            style: new TextStyle(fontSize: 10.0),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25)),
                  color: Colors.white,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 130.0),
                        child: Container(
                          child: Center(child: Text(ind1)),
                          color: Colore1,
                          width: 40,
                          height: 40,
                        ),
                      ),
                      Card(
                        child: Image.network(
                          imageUrl1,
                          width: 80,
                          height: 100,
                          fit: BoxFit.fitHeight,
                        ),
                        elevation: 5,
                        color: Colors.transparent,
                      ),
                      Text(name1,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 15,
                              fontFamily: 'ArbFONTS',
                              fontWeight: FontWeight.bold,
                              color: Colors.black)),
                      Row(
                        children: <Widget>[
                          new StarRating(
                            size: 15.0,
                            rating: ratingtxt1,
                            color: Colors.orange,
                            borderColor: Colors.grey,
                            starCount: starCount1,
                          ),
                          Text(
                            "$ratingtxt1",
                            style: new TextStyle(fontSize: 10.0),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, top: 5.0),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Container(
                        child: Card(
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25)),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Stack(
                                    children: <Widget>[
                                      Center(
                                        child: Text(
                                          Screen_Size2,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 15),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      Positioned(
                                        child: Container(
                                          width: 10,
                                          height: 10,
                                          decoration: new BoxDecoration(
                                            color: voteColor2,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        right: 1,
                                        top: 3.5,
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            )),
                        width: 160,
                      ),
                      Container(
                        child: Card(
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25)),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Stack(
                                    children: <Widget>[
                                      Center(
                                        child: Text(
                                          Screen_Size1,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 15),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      Positioned(
                                        child: Container(
                                          width: 10,
                                          height: 10,
                                          decoration: new BoxDecoration(
                                            color: voteColor1,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        right: 1,
                                        top: 3.5,
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            )),
                        width: 160,
                      ),
                      BIOMF(title: "الشاشة", image: "images/screensize.png"),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Container(
                        child: Card(
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25)),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Stack(
                                    children: <Widget>[
                                      Center(
                                        child: Text(
                                          Camera2,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 15),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      Positioned(
                                        child: Container(
                                          width: 10,
                                          height: 10,
                                          decoration: new BoxDecoration(
                                            color: voteColor2,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        right: 1,
                                        top: 3.5,
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            )),
                        width: 160,
                      ),
                      Container(
                        child: Card(
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25)),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Stack(
                                    children: <Widget>[
                                      Center(
                                        child: Text(
                                          Camera1,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 15),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      Positioned(
                                        child: Container(
                                          width: 10,
                                          height: 10,
                                          decoration: new BoxDecoration(
                                            color: voteColor1,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        right: 1,
                                        top: 3.5,
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            )),
                        width: 160,
                      ),
                      BIOMF(title: "الكاميرا", image: "images/camera.png"),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Container(
                        child: Card(
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25)),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Stack(
                                    children: <Widget>[
                                      Center(
                                        child: Text(
                                          Processor2,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 15),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      Positioned(
                                        child: Container(
                                          width: 10,
                                          height: 10,
                                          decoration: new BoxDecoration(
                                            color: voteColor2,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        right: 1,
                                        top: 3.5,
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            )),
                        width: 160,
                      ),
                      Container(
                        child: Card(
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25)),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Stack(
                                    children: <Widget>[
                                      Center(
                                        child: Text(
                                          Processor1,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 15),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      Positioned(
                                        child: Container(
                                          width: 10,
                                          height: 10,
                                          decoration: new BoxDecoration(
                                            color: voteColor1,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        right: 1,
                                        top: 3.5,
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            )),
                        width: 160,
                      ),
                      BIOMF(title: "المعالج", image: "images/processor.png"),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Container(
                        child: Card(
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25)),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Stack(
                                    children: <Widget>[
                                      Center(
                                        child: Text(
                                          Ram2,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 15),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      Positioned(
                                        child: Container(
                                          width: 10,
                                          height: 10,
                                          decoration: new BoxDecoration(
                                            color: voteColor2,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        right: 1,
                                        top: 3.5,
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            )),
                        width: 160,
                      ),
                      Container(
                        child: Card(
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25)),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Stack(
                                    children: <Widget>[
                                      Center(
                                        child: Text(
                                          Ram1,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 15),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      Positioned(
                                        child: Container(
                                          width: 10,
                                          height: 10,
                                          decoration: new BoxDecoration(
                                            color: voteColor1,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        right: 1,
                                        top: 3.5,
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            )),
                        width: 160,
                      ),
                      BIOMF(title: "الرام", image: "images/ram.png"),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Container(
                        child: Card(
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25)),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Stack(
                                    children: <Widget>[
                                      Center(
                                        child: Text(
                                          battery2,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 15),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      Positioned(
                                        child: Container(
                                          width: 10,
                                          height: 10,
                                          decoration: new BoxDecoration(
                                            color: voteColor2,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        right: 1,
                                        top: 3.5,
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            )),
                        width: 160,
                      ),
                      Container(
                        child: Card(
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25)),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Stack(
                                    children: <Widget>[
                                      Center(
                                        child: Text(
                                          battery1,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 15),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      Positioned(
                                        child: Container(
                                          width: 10,
                                          height: 10,
                                          decoration: new BoxDecoration(
                                            color: voteColor1,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        right: 1,
                                        top: 3.5,
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            )),
                        width: 160,
                      ),
                      BIOMF(title: "البطارية", image: "images/battery.png"),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    ),
  );
}

Widget Modawanaitem({title, image, type, description, views,colortype}) {
  bool loading = true;
  return Material(
    child: IgnorePointer(
      ignoring: !loading,
      child: AnimatedOpacity(
        opacity: loading ? 1 : 0,
        duration: Duration(milliseconds: 500),
        child: Card(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Container(
                      width: 200,
                      child: Text(title,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 5,
                          textAlign: TextAlign.end,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 10,
                              fontFamily: 'ArbFONTS',
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Container(
                      width: 200,
                      child: Text(description,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 5,
                          textAlign: TextAlign.end,
                          style: TextStyle(
                              color: Colors.black26,
                              fontSize: 10,
                              fontFamily: 'ArbFONTS',
                              fontWeight: FontWeight.normal)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Text("مشاهدة",
                            textAlign: TextAlign.end,
                            style: TextStyle(
                                color: Colors.black87,
                                fontSize: 12,
                                fontFamily: 'ArbFONTS',
                                fontWeight: FontWeight.normal)),
                        Text(
                          views,
                          textAlign: TextAlign.end,
                          style: TextStyle(
                              color: Color(0xFF3BB73D),
                              fontSize: 15,
                              fontFamily: 'ArbFONTS',
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              Stack(
                alignment: Alignment.topRight,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ClipRRect(
                      child: Image.network(
                        image,
                        height: 150,
                        width: 100,
                        fit: BoxFit.fitHeight,
                      ),
                      borderRadius: new BorderRadius.circular(8.0),
                    ),
                  ),
                  new Align(alignment: Alignment.topRight,
                    child:Opacity(
                      opacity: 0.60,
                      child: Container(
                        width: 70,
                        height: 30,
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(30),
                              bottomLeft: Radius.circular(30),
                              topRight: Radius.circular(30)),
                          child: RaisedButton(
                            elevation: 1,
                            color: colortype,
                            child: Text(
                              type,
                              style: TextStyle(color:Colors.white ,fontSize: 10),
                            ),
                            onPressed: () {},
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(25),bottomRight: Radius.circular(25),topLeft: Radius.circular(25),topRight: Radius.circular(100))),
        ),
      ),
    ),
  );
}

//Buid Item of Mokaranat Feature
Widget BIOMF({image, title}) {
  return Column(
    children: <Widget>[
      Text(
        title,
        style: TextStyle(color: Colors.grey, fontSize: 10),
        textAlign: TextAlign.justify,
        maxLines: 2,
      ),
      Image.asset(image, height: 25, width: 25),
    ],
  );
}

Widget AdvItem({ProductImage, ProductName, ProductPrice, context}) {
  return Container(
    width: MediaQuery.of(context).size.width - 15,
    child: Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      elevation: 5,
      color: Color(0xFFFFC825),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround, children: <Widget>[
          Image.network(ProductImage,
              height: MediaQuery.of(context).size.height,
              fit: BoxFit.fitHeight,
              width: MediaQuery.of(context).size.width - 270),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text(ProductName,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 30,
                      fontFamily: 'ArbFONTS',
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF805100))),
              Text(ProductPrice + " EGP",
                  textAlign: TextAlign.start,
                  style: TextStyle(fontSize: 20, color: Color(0xFF805100))),
              Row(
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(30),
                        bottomLeft: Radius.circular(30),
                        topRight: Radius.circular(30)),
                    child: RaisedButton(
                      elevation: 2,
                      color: Color(0xFFF95B36),
                      child: Text(
                        "تفاصيل",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {},
                    ),
                  ),
                  SizedBox(
                    width: 50,
                  ),
                  Image.asset(
                    "images/mokaranat.png",
                    height: 25,
                    width: 25,
                  ),
                ],
              )
            ],
          )
        ],
      ),
    ),
  );
}

Widget buildFeature({image, title}) {
  return Column(
    children: <Widget>[
      Image.asset(image, height: 25, width: 25),
      Text(
        title,
        style: TextStyle(color: Colors.grey, fontSize: 10),
        textAlign: TextAlign.justify,
        maxLines: 2,
      )
    ],
  );
}

//Lists--------------------------------------------------------------------------------------
Widget Listofitems(context) {
  return Column(
    children: <Widget>[
      Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(30),
                  bottomLeft: Radius.circular(30),
                  topRight: Radius.circular(30)),
              child: RaisedButton(
                elevation: 1,
                color: Color(0xFF59B959),
                child: Text(
                  "فلترة",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {},
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 150),
            child: InkWell(
              child: Row(
                children: <Widget>[
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "عرض المزيد",
                    style: TextStyle(fontSize: 15, color: Color(0xFFC5C5C5)),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Icon(
                    Icons.arrow_back_ios,
                    color: Color(0xFFC5C5C5),
                    size: 20,
                  ),
                ],
              ),
              onTap: () {},
            ),
          ),
        ],
      ),
      Expanded(
        child: ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: 15,
            //news["articles"].length,
            itemBuilder: (context, index) {
              return item(
                battery: "3000MA",
                Camera: "48MP",
                name: "Apple Iphone XR",
                Price: "7.777 EGP",
                Processor: "SnapDragon 420",
                Ram: "6G",
                Screen_Size: "5.5",
              );
            }),
      ),
    ],
  );
}

Widget ListofRashahlyitems(context) {
  return Expanded(
    child: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: 15,
        itemBuilder: (context, index) {
          var indo = index + 1;
          Color grayf = Color(0xFF3BB73D);
          return Rashahlyitem(
            battery: "3000MA",
            Camera: "48MP",
            name: "Apple Iphone XR",
            Price: "7.777 EGP",
            Processor: "SnapDragon 420",
            Ram: "6G",
            Screen_Size: "5.5",
            ind: "$indo",
            Colore: grayf,
          );
        }),
  );
}

Widget AdvList() {
  return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: 15,
      //news["articles"].length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: AdvItem(
              ProductName: "Xiaomi Mi9",
              ProductImage:
                  "https://cdn-media.kimovil.com/default/0003/16/thumb_215135_default_big.png",
              ProductPrice: "7.777",
              context: context),
        );
      });
}

Widget ListofMokaranatitems(context) {
  return Expanded(
    child: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: 1,
        itemBuilder: (context, index) {
          var indo1 = index + 1;
          var indo2 = index + 2;
          Color Color2 = Color(0xFF3BB73D);
          Color Color1 = Color(0xFFFD5433);

          return Mokaranatitem(
            name1: "Apple iPhone XR",
            imageUrl1:
                "https://cdn-media.kimovil.com/default/0003/16/thumb_215135_default_big.png",
            ind1: "$indo1",
            Colore1: Color1,
            name2: "LG Q7",
            imageUrl2:
                "https://cdn-media.kimovil.com/default/0003/16/thumb_215135_default_big.png",
            Colore2: Color2,
            ind2: "$indo2",
            voteColor2: Color2,
            voteColor1: Color1,
            Screen_Size2: "6.5",
            battery2: "5000MA",
            Camera2: "63MP",
            Processor2: "Snapdragon 540",
            Ram2: "4G",
            battery1: "5000MA",
            Camera1: "48MP",
            Processor1: "Snapdragon 420",
            Screen_Size1: "5.5",
            Ram1: "6G",
          );
        }),
  );
}

Widget ListofModawanaitems(context) {
  return Expanded(
    child: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: 15,
        itemBuilder: (context, index) {
          return Modawanaitem(
              title:
                  "تحديث جديد ل سامسونج اس جالاكسي اس 9 يضيف المزيد من الايموجيز والرسائل الإستمرارية",
              image: "https://www.electrony.net/media/2018/08/Galaxy-S9.jpg",
              description: "بدأت شركة سامسونج في إصدار",
              views: "450",
            type: "مترجم",
            colortype: Color(0xFF69C86C)
          );
        }),
  );
}
