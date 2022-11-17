import 'dart:ui';
import 'utils.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DonatePage extends StatefulWidget {
  @override
  _AwesomeCarouselState createState() => _AwesomeCarouselState();
}

class _AwesomeCarouselState extends State<DonatePage> {

  List<String> data = [
    'assets/donation.jpeg',
    'assets/donation_brand.jpeg',
  ];

  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor("#161A24"),
      resizeToAvoidBottomInset : false,
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight: 50,
        title: Text(
          'Thanks, Your \'GoodStep\'',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
            color: Colors.lightGreenAccent,
          ),),
        backgroundColor: HexColor("#161A24"),
      ),
      body: SingleChildScrollView(
        child: Column(
          verticalDirection: VerticalDirection.down,
          children: <Widget>[
            Container(
              width: 400,
              height: 500,
              alignment: Alignment.center,
              child: Stack(children: [
                AnimatedSwitcher(
                  duration: Duration(milliseconds: 0),
                  child: Container(
                    key: ValueKey<String>(data[_currentPage]),
                    decoration: BoxDecoration(
                      color: HexColor("#161A24"),
                    ),
                  ),
                ),
                FractionallySizedBox(
                  heightFactor: 0.99,
                  child: PageView.builder(
                    itemCount: data.length,
                    onPageChanged: (int page) {
                      setState(() {
                        _currentPage = page;
                      });
                    },
                    itemBuilder: (BuildContext context, int index) {
                      return FractionallySizedBox(
                        widthFactor: 1,
                        child: Container(
                          margin: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(data[index]),
                              fit: BoxFit.fill,
                            ),
                            borderRadius: BorderRadius.circular(32),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                spreadRadius: 5,
                                blurRadius: 10,
                                offset: Offset(0, 5),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
              ),
            ),//기부증명서, 기부재단 소개
            Container(
              child: Text('\'GoodStep\'은 모든 수익을 기부합니다.', style: TextStyle(
                backgroundColor: HexColor("#161A24"),
                color: Colors.green,
                fontSize: 13,
                // decoration: TextDecoration.underline, //밑줄 기능인데 별로임
              ),),
            ),//굿스탭은 모든 수익을 기부합니다.
            SizedBox(
              height: 15,
            ),// 공백용도
            Container(
              height: 30,
              width: 180,
              decoration: BoxDecoration(
                color: HexColor("#161A24"),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black,
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Center(
                child: GestureDetector(
                  onTap: () {
                    final Uri url = Uri.parse("https://www.instagram.com/make_better_123/");
                    launchUrl(url);
                  },
                  child: Text(
                    '지난 기부내역(Click)',
                    style: TextStyle(
                      //fontWeight: FontWeight.bold,
                        color: Colors.lightGreenAccent,
                        fontSize: 20),
                  ),
                ),
              ),
            ),//지난 기부내역 (인스타 말고 웹페이지로 변경예정)
          ],
        ),
      ),
    );
  }
}