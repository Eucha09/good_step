import 'package:flutter/material.dart';
import 'utils.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

String printDuration(Duration duration) {
  String twoDigits(int n) {
    if (n >= 10) return "$n";
    return "0$n";
  }

  String twoDigitHours = twoDigits(duration.inHours);
  String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
//  String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
  return "$twoDigitHours:$twoDigitMinutes";
}

class HomePage_1 extends StatefulWidget {

  @override
  _HomePageState_1 createState() => _HomePageState_1();
}

class _HomePageState_1 extends State<HomePage_1> {
  double? myValue;
  String? loLoo;
  final List<Color> pageColors = [HexColor('#489482'), HexColor('#62AA80')];

  @override
  void initState() {
    super.initState();
    myValue = 0;
    loLoo = "00:00";
  }

  @override
  Widget build(BuildContext context) {
    final slider = SleekCircularSlider(
        appearance: CircularSliderAppearance(
          customWidths:
          CustomSliderWidths(trackWidth: 15, progressBarWidth: 10, shadowWidth: 15, handlerSize: 8),
          customColors:
          CustomSliderColors(
              dotColor: HexColor('#FFFFFF'),
              trackColor: HexColor('#000000'),
              progressBarColors: [HexColor('#C5EE71'), HexColor('#82C54D')],
              shadowColor: HexColor('#000000'),
              shadowMaxOpacity: 0.05
          ),
          /*infoProperties:
        InfoProperties(
          topLabelStyle: TextStyle(
              color: Colors.black, fontSize: 15, fontWeight: FontWeight.w400
          ),
          topLabelText: 'TURN OFF',
          bottomLabelStyle: TextStyle(
              color: Colors.black, fontSize: 15, fontWeight: FontWeight.w400
          ),
          bottomLabelText: 'TIME',
          mainLabelStyle: TextStyle(
              color: Colors.black, fontSize: 30.0, fontWeight: FontWeight.w600
          ),
          modifier: (double value) {
            final time = printDuration(Duration(seconds: value.toInt()));
            return '$time';
          }
      ),*/
          startAngle: 270,
          angleRange: 360,
          size: 225.0,
        ),
        min: 0,
        max: 86400,
        initialValue: 0,
        innerWidget: (double value) {
          return Center(
              child : SizedBox(
                  width: 180,
                  height: 180,
                  child: FittedBox(
                      child: FloatingActionButton(
                        backgroundColor: HexColor("#FFFFFF"),
                        onPressed: () {

                        },
                        child: Icon(Icons.power_settings_new_outlined, size: 40, color: HexColor("#C3C9BB")),
                      )
                  )
              )
          );
        },
        onChange: (double value) {
          print(value);
          setState(() {
            myValue = value;
            loLoo = printDuration(Duration(seconds: value.toInt()));
          });
        }
    );
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: pageColors,
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                tileMode: TileMode.clamp
            )),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(child: slider),
            Padding(
                padding: EdgeInsets.only(top: 40, bottom: 90),
                child: Text(
                    '$loLoo',
                    style: TextStyle(
                      color: HexColor("#FFFFFF"),
                      fontSize: 70.0,
                      fontWeight: FontWeight.w600,
                    )
                )
            ),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Column(
                      children: <Widget>[
                        Icon(Icons.timer, size: 25, color: HexColor("#FFFFFF")),
                        Text(
                          'Total',
                          style: TextStyle(
                            fontSize: 11,
                            color: HexColor("#FFFFFF"),
                          ),
                        ),
                        Text(
                          '0.0',
                          style: TextStyle(
                            fontSize: 9,
                            color: HexColor("#FFFFFF"),
                          ),
                        )
                      ]
                  ),
                  Column(
                      children: <Widget>[
                        Icon(Icons.energy_savings_leaf, size: 25, color: HexColor("#FFFFFF")),
                        Text(
                            'Eco',
                            style: TextStyle(
                              fontSize: 11,
                              color: HexColor("#FFFFFF"),
                            )
                        ),
                        Text(
                            '0.0',
                            style: TextStyle(
                              fontSize: 9,
                              color: HexColor("#FFFFFF"),
                            )
                        )
                      ]
                  ),
                ]
            )
          ],
        ),
      ),
    );
  }
}