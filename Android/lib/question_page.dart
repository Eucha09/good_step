import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'utils.dart';

class question_page extends StatefulWidget {
  @override
  _question_pageState createState() => _question_pageState();
}

class _question_pageState extends State<question_page> {
  int _currentPage = 0;
  List data = [
    'assets/ex1.png',
    'assets/ex2.png',
    'assets/ex3.png',
    'assets/ex4.png',
    'assets/ex5.png',
    'assets/ex6.png',
  ];

  @override
  void initState() {
    super.initState();
    _currentPage = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          '앱 가이드',
          textAlign: TextAlign.center,
          style: TextStyle(
            //fontFamily: 'pyeongchang',
            fontSize: 22,
            color: HexColor('#FFFFFF'),
          ),
        ),
        leading: IconButton(
          padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.02),
          onPressed: () => Navigator.pop(context),
          icon: Icon(CupertinoIcons.arrow_left, color: HexColor('#FFFFFF')),
        ),
        backgroundColor: HexColor("#222021"),
      ),
      body: Container(
        color: HexColor('#222021'),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        alignment: Alignment.center,
        child: Stack(children: [
          AnimatedSwitcher(
            duration: Duration(milliseconds: 0),
            child: Container(
              key: ValueKey<String>(data[_currentPage]),
              decoration: BoxDecoration(
                color: HexColor("#222021"),
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
                    decoration: BoxDecoration(
                      color: HexColor('#222021'),
                      image: DecorationImage(
                        image: AssetImage(data[index]),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
        ),
      ),
    );
  }
}
