import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'utils.dart';

class question_page extends StatefulWidget {
  @override
  _question_pageState createState() => _question_pageState();
}

class _question_pageState extends State<question_page> {
  int index = 0;
  List picture = [
    Image.asset(
      'assets/ex1.png',
      fit: BoxFit.contain,
    ),
    Image.asset(
      'assets/ex2.png',
      fit: BoxFit.contain,
    ),
    Image.asset(
      'assets/ex3.png',
      fit: BoxFit.contain,
    ),
    Image.asset(
      'assets/ex4.png',
      fit: BoxFit.contain,
    ),
    Image.asset(
      'assets/ex5.png',
      fit: BoxFit.contain,
    ),
    Image.asset(
      'assets/ex6.png',
      fit: BoxFit.contain,
    ),
  ];

  @override
  void initState() {
    super.initState();
    index = 0;
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
      body: GestureDetector(
          onTap: () {
            if (index < 5) {
              setState(() {
                index++;
              });
            } else {
              Navigator.pop(context);
            }
          },
          child: Container(
            color: HexColor("#222021"),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: picture[index],
          )),
    );
  }
}
