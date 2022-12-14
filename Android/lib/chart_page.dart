import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:sqflite/sqflite.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:io';
import 'dart:core';
import 'concentration.dart';
import 'dart:math';
import 'utils.dart';

class _PieChart extends CustomPainter {
  /*
  percentage : 원형 도표에서 그려줄 호의 크기를 정해준다
  barColor : 원형 도표에서 그려지는 호 색깔
  textScaleFactor : 원형 도표 내부에 들어갈 글자 크기
  res : 원형 도표 내부에 들어갈 글자
  strokelen : 선 굵기
   */
  final int percentage;
  final Color barColor;
  final int strokelen;

  _PieChart(
      {required this.percentage,
      required this.barColor,
      required this.strokelen});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint() // 화면에 그릴 때 쓸 paint를 정의
      ..color = barColor
      ..strokeWidth = 5.0 // 선의 길이를 정함
      ..style = PaintingStyle.stroke // 선의 스타일을 정함
      ..strokeCap = StrokeCap.square; // stroke 스타일을 정함

    double radius = min(
        size.width / 2 - paint.strokeWidth / 2,
        size.height / 2 -
            paint.strokeWidth / 2); // 원의 반지름을 구함, 선의 굵기에 영향을 받지 않게 보정
    Offset center =
        Offset(size.width / 2, size.height / 2); // 원이 위젯 가운데에 그려지게 좌표 정함
    canvas.drawCircle(center, radius, paint); // 원을 그린다
    double arcAngle = 2 * pi * (percentage / 100); // 호의 각도를 정한다
    paint..color = HexColor('#161A24'); // 호를 그릴 때 색깔을 바꿔줌
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), -pi / 2,
        arcAngle, false, paint); // 호를 그림
    //drawText(canvas, size, res); // 텍스트를 화면에 표시
  }

  // 원의 중앙에 텍스트 적용
  /*void drawText(Canvas canvas, Size size, String text) {
    double fontSize = getFontSize(size, text);
    // textspan은 text 위젯과 동일
    TextSpan sp = TextSpan(style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold, color: HexColor('#FFFFFF')), text: text);
    TextPainter tp = TextPainter(text: sp, textDirection: TextDirection.ltr);

    // 텍스트 페인터에 그려질 텍스트의 크기와 방향을 정함
    tp.layout();
    double dx = size.width / 2 - tp.width / 2;
    double dy = size.height / 2 - tp.height / 2;

    Offset offset = Offset(dx, dy);
    tp.paint(canvas, offset);
  }*/

  // 화면 크기에 비례하도록 텍스트 폰트 크기를 정함
  /*double getFontSize(Size size, String text) {
    return size.width / text.length * textScaleFactor;
  }*/

  @override
  bool shouldRepaint(_PieChart old) {
    return old.percentage != percentage;
  }
}

class _LineChartWeekCC extends StatelessWidget {
  final List<int> Factor;
  final List<int> last_Factor;

  _LineChartWeekCC({required this.Factor, required this.last_Factor});

  @override
  Widget build(BuildContext context) {
    return LineChart(
      chartData,
      swapAnimationDuration: const Duration(milliseconds: 250),
    );
  }

  LineChartData get chartData => LineChartData(
        lineTouchData: lineTouchData,
        gridData: gridData,
        titlesData: titlesData,
        borderData: borderData,
        lineBarsData: lineBarsData1,
        minX: 0,
        maxX: 7,
        maxY: 100,
        minY: 0,
      );

  LineTouchData get lineTouchData => LineTouchData(
        handleBuiltInTouches: true,
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Colors.blueGrey.withOpacity(0.5),
        ),
      );

  FlTitlesData get titlesData => FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: bottomTitles,
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        leftTitles: AxisTitles(
          sideTitles: leftTitles(),
        ),
      );

  List<LineChartBarData> get lineBarsData1 => [
        curWeekBarData,
        lastWeekBarData,
      ];

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xF0FFFFFF),
      fontWeight: FontWeight.bold,
      fontSize: 8,
    );
    String text;
    switch (value.toInt()) {
      case 20:
        text = '20';
        break;
      case 40:
        text = '40';
        break;
      case 60:
        text = '60';
        break;
      case 80:
        text = '80';
        break;
      case 100:
        text = '100';
        break;
      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.center);
  }

  SideTitles leftTitles() => SideTitles(
        getTitlesWidget: leftTitleWidgets,
        showTitles: true,
        interval: 1,
        reservedSize: 15,
      );

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xF0FFFFFF),
      fontWeight: FontWeight.bold,
      fontSize: 8,
    );
    Widget text;
    switch (value.toInt()) {
      case 1:
        text = const Text('1', style: style);
        break;
      case 2:
        text = const Text('2', style: style);
        break;
      case 3:
        text = const Text('3', style: style);
        break;
      case 4:
        text = const Text('4', style: style);
        break;
      case 5:
        text = const Text('5', style: style);
        break;
      case 6:
        text = const Text('6', style: style);
        break;
      case 7:
        text = const Text('7', style: style);
        break;
      default:
        text = const Text('');
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 5,
      child: text,
    );
  }

  SideTitles get bottomTitles => SideTitles(
        showTitles: true,
        reservedSize: 15,
        interval: 1,
        getTitlesWidget: bottomTitleWidgets,
      );

  FlGridData get gridData => FlGridData(show: false);

  FlBorderData get borderData => FlBorderData(
        show: true,
        border: Border(
          bottom: BorderSide(color: Color(0xff4e4965), width: 0.2),
          left: BorderSide(color: Colors.transparent),
          right: BorderSide(color: Colors.transparent),
          top: BorderSide(color: Colors.transparent),
        ),
      );

  LineChartBarData get curWeekBarData => LineChartBarData(
        isCurved: true,
        preventCurveOverShooting: true,
        color: const Color(0xFF4AF699),
        barWidth: 1,
        isStrokeCapRound: true,
        dotData: FlDotData(show: false),
        belowBarData: BarAreaData(
          show: true,
          color: const Color(0x5F4AF699),
        ),
        spots: [
          FlSpot(0, 0),
          FlSpot(1, Factor[1].toDouble()),
          FlSpot(2, Factor[2].toDouble()),
          FlSpot(3, Factor[3].toDouble()),
          FlSpot(4, Factor[4].toDouble()),
          FlSpot(5, Factor[5].toDouble()),
          FlSpot(6, Factor[6].toDouble()),
          FlSpot(7, Factor[7].toDouble()),
        ],
      );

  LineChartBarData get lastWeekBarData => LineChartBarData(
        isCurved: true,
        preventCurveOverShooting: true,
        color: Color(0xFFAA4CFC),
        barWidth: 1,
        isStrokeCapRound: true,
        dotData: FlDotData(show: false),
        belowBarData: BarAreaData(
          show: true,
          color: Color(0x5FAA4CFC),
        ),
        spots: [
          FlSpot(0, 0),
          FlSpot(1, last_Factor[1].toDouble()),
          FlSpot(2, last_Factor[2].toDouble()),
          FlSpot(3, last_Factor[3].toDouble()),
          FlSpot(4, last_Factor[4].toDouble()),
          FlSpot(5, last_Factor[5].toDouble()),
          FlSpot(6, last_Factor[6].toDouble()),
          FlSpot(7, last_Factor[7].toDouble()),
        ],
      );
}

class _LineChartMonthCC extends StatelessWidget {
  final List<int> Factor;
  final List<int> last_Factor;

  _LineChartMonthCC({required this.Factor, required this.last_Factor});

  @override
  Widget build(BuildContext context) {
    return LineChart(
      chartData,
      swapAnimationDuration: const Duration(milliseconds: 250),
    );
  }

  LineChartData get chartData => LineChartData(
        lineTouchData: lineTouchData,
        gridData: gridData,
        titlesData: titlesData,
        borderData: borderData,
        lineBarsData: lineBarsData,
        minX: 0,
        maxX: 31,
        maxY: 100,
        minY: 0,
      );

  LineTouchData get lineTouchData => LineTouchData(
        handleBuiltInTouches: true,
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Colors.blueGrey.withOpacity(0.5),
        ),
      );

  FlTitlesData get titlesData => FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: bottomTitles,
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        leftTitles: AxisTitles(
          sideTitles: leftTitles(),
        ),
      );

  List<LineChartBarData> get lineBarsData => [
        curMonBarData,
        lastMonBarData,
      ];

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xF0FFFFFF),
      fontWeight: FontWeight.bold,
      fontSize: 8,
    );
    String text;
    switch (value.toInt()) {
      case 20:
        text = '20';
        break;
      case 40:
        text = '40';
        break;
      case 60:
        text = '60';
        break;
      case 80:
        text = '80';
        break;
      case 100:
        text = '100';
        break;
      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.center);
  }

  SideTitles leftTitles() => SideTitles(
        getTitlesWidget: leftTitleWidgets,
        showTitles: true,
        interval: 1,
        reservedSize: 15,
      );

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xF0FFFFFF),
      fontWeight: FontWeight.bold,
      fontSize: 8,
    );
    Widget text;
    switch (value.toInt()) {
      case 4:
        text = const Text('4', style: style);
        break;
      case 8:
        text = const Text('8', style: style);
        break;
      case 12:
        text = const Text('12', style: style);
        break;
      case 16:
        text = const Text('16', style: style);
        break;
      case 20:
        text = const Text('20', style: style);
        break;
      case 24:
        text = const Text('24', style: style);
        break;
      case 28:
        text = const Text('28', style: style);
        break;
      case 31:
        text = const Text('31', style: style);
        break;
      default:
        text = const Text('');
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 5,
      child: text,
    );
  }

  SideTitles get bottomTitles => SideTitles(
        showTitles: true,
        reservedSize: 15,
        interval: 1,
        getTitlesWidget: bottomTitleWidgets,
      );

  FlGridData get gridData => FlGridData(show: false);

  FlBorderData get borderData => FlBorderData(
        show: true,
        border: Border(
          bottom: BorderSide(color: Color(0xff4e4965), width: 0.2),
          left: BorderSide(color: Colors.transparent),
          right: BorderSide(color: Colors.transparent),
          top: BorderSide(color: Colors.transparent),
        ),
      );

  LineChartBarData get curMonBarData => LineChartBarData(
        isCurved: true,
        preventCurveOverShooting: true,
        color: const Color(0xFF4AF699),
        barWidth: 1,
        isStrokeCapRound: true,
        dotData: FlDotData(show: false),
        belowBarData: BarAreaData(
          show: true,
          color: const Color(0x5F4AF699),
        ),
        spots: [
          FlSpot(0, 0),
          FlSpot(1, Factor[1].toDouble()),
          FlSpot(2, Factor[2].toDouble()),
          FlSpot(3, Factor[3].toDouble()),
          FlSpot(4, Factor[4].toDouble()),
          FlSpot(5, Factor[5].toDouble()),
          FlSpot(6, Factor[6].toDouble()),
          FlSpot(7, Factor[7].toDouble()),
          FlSpot(8, Factor[8].toDouble()),
          FlSpot(9, Factor[9].toDouble()),
          FlSpot(10, Factor[10].toDouble()),
          FlSpot(11, Factor[11].toDouble()),
          FlSpot(12, Factor[12].toDouble()),
          FlSpot(13, Factor[13].toDouble()),
          FlSpot(14, Factor[14].toDouble()),
          FlSpot(15, Factor[15].toDouble()),
          FlSpot(16, Factor[16].toDouble()),
          FlSpot(17, Factor[17].toDouble()),
          FlSpot(18, Factor[18].toDouble()),
          FlSpot(19, Factor[19].toDouble()),
          FlSpot(20, Factor[20].toDouble()),
          FlSpot(21, Factor[21].toDouble()),
          FlSpot(22, Factor[22].toDouble()),
          FlSpot(23, Factor[23].toDouble()),
          FlSpot(24, Factor[24].toDouble()),
          FlSpot(25, Factor[25].toDouble()),
          FlSpot(26, Factor[26].toDouble()),
          FlSpot(27, Factor[27].toDouble()),
          FlSpot(28, Factor[28].toDouble()),
          FlSpot(29, Factor[29].toDouble()),
          FlSpot(30, Factor[30].toDouble()),
          FlSpot(31, Factor[31].toDouble())
        ],
      );

  LineChartBarData get lastMonBarData => LineChartBarData(
        isCurved: true,
        preventCurveOverShooting: true,
        color: Color(0xFFAA4CFC),
        barWidth: 1,
        isStrokeCapRound: true,
        dotData: FlDotData(show: false),
        belowBarData: BarAreaData(
          show: true,
          color: Color(0x5FAA4CFC),
        ),
        spots: [
          FlSpot(0, 0),
          FlSpot(1, last_Factor[1].toDouble()),
          FlSpot(2, last_Factor[2].toDouble()),
          FlSpot(3, last_Factor[3].toDouble()),
          FlSpot(4, last_Factor[4].toDouble()),
          FlSpot(5, last_Factor[5].toDouble()),
          FlSpot(6, last_Factor[6].toDouble()),
          FlSpot(7, last_Factor[7].toDouble()),
          FlSpot(8, last_Factor[8].toDouble()),
          FlSpot(9, last_Factor[9].toDouble()),
          FlSpot(10, last_Factor[10].toDouble()),
          FlSpot(11, last_Factor[11].toDouble()),
          FlSpot(12, last_Factor[12].toDouble()),
          FlSpot(13, last_Factor[13].toDouble()),
          FlSpot(14, last_Factor[14].toDouble()),
          FlSpot(15, last_Factor[15].toDouble()),
          FlSpot(16, last_Factor[16].toDouble()),
          FlSpot(17, last_Factor[17].toDouble()),
          FlSpot(18, last_Factor[18].toDouble()),
          FlSpot(19, last_Factor[19].toDouble()),
          FlSpot(20, last_Factor[20].toDouble()),
          FlSpot(21, last_Factor[21].toDouble()),
          FlSpot(22, last_Factor[22].toDouble()),
          FlSpot(23, last_Factor[23].toDouble()),
          FlSpot(24, last_Factor[24].toDouble()),
          FlSpot(25, last_Factor[25].toDouble()),
          FlSpot(26, last_Factor[26].toDouble()),
          FlSpot(27, last_Factor[27].toDouble()),
          FlSpot(28, last_Factor[28].toDouble()),
          FlSpot(29, last_Factor[29].toDouble()),
          FlSpot(30, last_Factor[30].toDouble()),
          FlSpot(31, last_Factor[31].toDouble()),
        ],
      );
}

class _LineChartWeek extends StatelessWidget {
  final List<int> Factor;
  final List<int> last_Factor;
  final int LimitedTime;

  _LineChartWeek(
      {required this.Factor,
      required this.last_Factor,
      required this.LimitedTime});

  @override
  Widget build(BuildContext context) {
    return LineChart(
      sampleData1,
      swapAnimationDuration: const Duration(milliseconds: 250),
    );
  }

  LineChartData get sampleData1 => LineChartData(
        lineTouchData: lineTouchData1,
        gridData: gridData,
        titlesData: titlesData1,
        borderData: borderData,
        lineBarsData: lineBarsData1,
        minX: 0,
        maxX: 7,
        maxY: LimitedTime * 60,
        minY: 0,
      );

  LineTouchData get lineTouchData1 => LineTouchData(
        handleBuiltInTouches: true,
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Colors.blueGrey.withOpacity(0.5),
        ),
      );

  FlTitlesData get titlesData1 => FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: bottomTitles,
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        leftTitles: AxisTitles(
          sideTitles: leftTitles(),
        ),
      );

  List<LineChartBarData> get lineBarsData1 => [
        lineChartBarData1_1,
        lineChartBarData1_2,
      ];

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xF0FFFFFF),
      fontWeight: FontWeight.bold,
      fontSize: 8,
    );
    String text;
    if (LimitedTime <= 3) {
      switch (value.toInt()) {
        case 1 * 60:
          text = '1';
          break;
        case 2 * 60:
          text = '2';
          break;
        case 3 * 60:
          text = '3';
          break;
        default:
          return Container();
      }
    } else if (LimitedTime <= 6) {
      switch (value.toInt()) {
        case 2 * 60:
          text = '2';
          break;
        case 4 * 60:
          text = '4';
          break;
        case 6 * 60:
          text = '6';
          break;
        default:
          return Container();
      }
    } else if (LimitedTime <= 9) {
      switch (value.toInt()) {
        case 3 * 60:
          text = '3';
          break;
        case 6 * 60:
          text = '6';
          break;
        case 9 * 60:
          text = '9';
          break;
        default:
          return Container();
      }
    } else if (LimitedTime <= 12) {
      switch (value.toInt()) {
        case 3 * 60:
          text = '3';
          break;
        case 6 * 60:
          text = '6';
          break;
        case 9 * 60:
          text = '9';
          break;
        case 12 * 60:
          text = '12';
          break;
        default:
          return Container();
      }
    } else if (LimitedTime <= 15) {
      switch (value.toInt()) {
        case 3 * 60:
          text = '3';
          break;
        case 6 * 60:
          text = '6';
          break;
        case 9 * 60:
          text = '9';
          break;
        case 12 * 60:
          text = '12';
          break;
        case 15 * 60:
          text = '15';
          break;
        default:
          return Container();
      }
    } else if (LimitedTime <= 18) {
      switch (value.toInt()) {
        case 3 * 60:
          text = '3';
          break;
        case 6 * 60:
          text = '6';
          break;
        case 9 * 60:
          text = '9';
          break;
        case 12 * 60:
          text = '12';
          break;
        case 15 * 60:
          text = '15';
          break;
        case 18 * 60:
          text = '18';
          break;
        default:
          return Container();
      }
    } else if (LimitedTime <= 21) {
      switch (value.toInt()) {
        case 3 * 60:
          text = '3';
          break;
        case 6 * 60:
          text = '6';
          break;
        case 9 * 60:
          text = '9';
          break;
        case 12 * 60:
          text = '12';
          break;
        case 15 * 60:
          text = '15';
          break;
        case 18 * 60:
          text = '18';
          break;
        case 21 * 60:
          text = '21';
          break;
        default:
          return Container();
      }
    } else {
      switch (value.toInt()) {
        case 3 * 60:
          text = '3';
          break;
        case 6 * 60:
          text = '6';
          break;
        case 9 * 60:
          text = '9';
          break;
        case 12 * 60:
          text = '12';
          break;
        case 15 * 60:
          text = '15';
          break;
        case 18 * 60:
          text = '18';
          break;
        case 21 * 60:
          text = '21';
          break;
        case 24 * 60:
          text = '24';
          break;
        default:
          return Container();
      }
    }

    return Text(text, style: style, textAlign: TextAlign.center);
  }

  SideTitles leftTitles() => SideTitles(
        getTitlesWidget: leftTitleWidgets,
        showTitles: true,
        interval: 1,
        reservedSize: 15,
      );

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xF0FFFFFF),
      fontWeight: FontWeight.bold,
      fontSize: 8,
    );
    Widget text;
    switch (value.toInt()) {
      case 1:
        text = const Text('1', style: style);
        break;
      case 2:
        text = const Text('2', style: style);
        break;
      case 3:
        text = const Text('3', style: style);
        break;
      case 4:
        text = const Text('4', style: style);
        break;
      case 5:
        text = const Text('5', style: style);
        break;
      case 6:
        text = const Text('6', style: style);
        break;
      case 7:
        text = const Text('7', style: style);
        break;
      default:
        text = const Text('');
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 5,
      child: text,
    );
  }

  SideTitles get bottomTitles => SideTitles(
        showTitles: true,
        reservedSize: 15,
        interval: 1,
        getTitlesWidget: bottomTitleWidgets,
      );

  FlGridData get gridData => FlGridData(show: false);

  FlBorderData get borderData => FlBorderData(
        show: true,
        border: Border(
          bottom: BorderSide(color: Color(0xff4e4965), width: 0.2),
          left: BorderSide(color: Colors.transparent),
          right: BorderSide(color: Colors.transparent),
          top: BorderSide(color: Colors.transparent),
        ),
      );

  LineChartBarData get lineChartBarData1_1 => LineChartBarData(
        isCurved: true,
        preventCurveOverShooting: true,
        color: const Color(0xFF4AF699),
        barWidth: 1,
        isStrokeCapRound: true,
        dotData: FlDotData(show: false),
        belowBarData: BarAreaData(
          show: true,
          color: const Color(0x5F4AF699),
        ),
        spots: [
          FlSpot(0, 0),
          FlSpot(1, Factor[1].toDouble()),
          FlSpot(2, Factor[2].toDouble()),
          FlSpot(3, Factor[3].toDouble()),
          FlSpot(4, Factor[4].toDouble()),
          FlSpot(5, Factor[5].toDouble()),
          FlSpot(6, Factor[6].toDouble()),
          FlSpot(7, Factor[7].toDouble()),
        ],
      );

  LineChartBarData get lineChartBarData1_2 => LineChartBarData(
        isCurved: true,
        preventCurveOverShooting: true,
        color: Color(0xFFAA4CFC),
        barWidth: 1,
        isStrokeCapRound: true,
        dotData: FlDotData(show: false),
        belowBarData: BarAreaData(
          show: true,
          color: Color(0x5FAA4CFC),
        ),
        spots: [
          FlSpot(0, 0),
          FlSpot(1, last_Factor[1].toDouble()),
          FlSpot(2, last_Factor[2].toDouble()),
          FlSpot(3, last_Factor[3].toDouble()),
          FlSpot(4, last_Factor[4].toDouble()),
          FlSpot(5, last_Factor[5].toDouble()),
          FlSpot(6, last_Factor[6].toDouble()),
          FlSpot(7, last_Factor[7].toDouble()),
        ],
      );
}

class _LineChartMonth extends StatelessWidget {
  final List<int> Factor;
  final List<int> last_Factor;
  final int LimitedTime;

  _LineChartMonth(
      {required this.Factor,
      required this.last_Factor,
      required this.LimitedTime});

  @override
  Widget build(BuildContext context) {
    return LineChart(
      sampleData1,
      swapAnimationDuration: const Duration(milliseconds: 250),
    );
  }

  LineChartData get sampleData1 => LineChartData(
        lineTouchData: lineTouchData1,
        gridData: gridData,
        titlesData: titlesData1,
        borderData: borderData,
        lineBarsData: lineBarsData1,
        minX: 0,
        maxX: 31,
        maxY: LimitedTime*60,
        minY: 0,
      );

  LineTouchData get lineTouchData1 => LineTouchData(
        handleBuiltInTouches: true,
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Colors.blueGrey.withOpacity(0.5),
        ),
      );

  FlTitlesData get titlesData1 => FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: bottomTitles,
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        leftTitles: AxisTitles(
          sideTitles: leftTitles(),
        ),
      );

  List<LineChartBarData> get lineBarsData1 => [
        lineChartBarData1_1,
        lineChartBarData1_2,
      ];

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xF0FFFFFF),
      fontWeight: FontWeight.bold,
      fontSize: 8,
    );
    String text;
    if (LimitedTime <= 3) {
      switch (value.toInt()) {
        case 1 * 60:
          text = '1';
          break;
        case 2 * 60:
          text = '2';
          break;
        case 3 * 60:
          text = '3';
          break;
        default:
          return Container();
      }
    } else if (LimitedTime <= 6) {
      switch (value.toInt()) {
        case 2 * 60:
          text = '2';
          break;
        case 4 * 60:
          text = '4';
          break;
        case 6 * 60:
          text = '6';
          break;
        default:
          return Container();
      }
    } else if (LimitedTime <= 9) {
      switch (value.toInt()) {
        case 3 * 60:
          text = '3';
          break;
        case 6 * 60:
          text = '6';
          break;
        case 9 * 60:
          text = '9';
          break;
        default:
          return Container();
      }
    } else if (LimitedTime <= 12) {
      switch (value.toInt()) {
        case 3 * 60:
          text = '3';
          break;
        case 6 * 60:
          text = '6';
          break;
        case 9 * 60:
          text = '9';
          break;
        case 12 * 60:
          text = '12';
          break;
        default:
          return Container();
      }
    } else if (LimitedTime <= 15) {
      switch (value.toInt()) {
        case 3 * 60:
          text = '3';
          break;
        case 6 * 60:
          text = '6';
          break;
        case 9 * 60:
          text = '9';
          break;
        case 12 * 60:
          text = '12';
          break;
        case 15 * 60:
          text = '15';
          break;
        default:
          return Container();
      }
    } else if (LimitedTime <= 18) {
      switch (value.toInt()) {
        case 3 * 60:
          text = '3';
          break;
        case 6 * 60:
          text = '6';
          break;
        case 9 * 60:
          text = '9';
          break;
        case 12 * 60:
          text = '12';
          break;
        case 15 * 60:
          text = '15';
          break;
        case 18 * 60:
          text = '18';
          break;
        default:
          return Container();
      }
    } else if (LimitedTime <= 21) {
      switch (value.toInt()) {
        case 3 * 60:
          text = '3';
          break;
        case 6 * 60:
          text = '6';
          break;
        case 9 * 60:
          text = '9';
          break;
        case 12 * 60:
          text = '12';
          break;
        case 15 * 60:
          text = '15';
          break;
        case 18 * 60:
          text = '18';
          break;
        case 21 * 60:
          text = '21';
          break;
        default:
          return Container();
      }
    } else {
      switch (value.toInt()) {
        case 3 * 60:
          text = '3';
          break;
        case 6 * 60:
          text = '6';
          break;
        case 9 * 60:
          text = '9';
          break;
        case 12 * 60:
          text = '12';
          break;
        case 15 * 60:
          text = '15';
          break;
        case 18 * 60:
          text = '18';
          break;
        case 21 * 60:
          text = '21';
          break;
        case 24 * 60:
          text = '24';
          break;
        default:
          return Container();
      }
    }

    return Text(text, style: style, textAlign: TextAlign.center);
  }

  SideTitles leftTitles() => SideTitles(
        getTitlesWidget: leftTitleWidgets,
        showTitles: true,
        interval: 1,
        reservedSize: 15,
      );

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xF0FFFFFF),
      fontWeight: FontWeight.bold,
      fontSize: 8,
    );
    Widget text;
    switch (value.toInt()) {
      case 4:
        text = const Text('4', style: style);
        break;
      case 8:
        text = const Text('8', style: style);
        break;
      case 12:
        text = const Text('12', style: style);
        break;
      case 16:
        text = const Text('16', style: style);
        break;
      case 20:
        text = const Text('20', style: style);
        break;
      case 24:
        text = const Text('24', style: style);
        break;
      case 28:
        text = const Text('28', style: style);
        break;
      case 31:
        text = const Text('31', style: style);
        break;
      default:
        text = const Text('');
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 5,
      child: text,
    );
  }

  SideTitles get bottomTitles => SideTitles(
        showTitles: true,
        reservedSize: 15,
        interval: 1,
        getTitlesWidget: bottomTitleWidgets,
      );

  FlGridData get gridData => FlGridData(show: false);

  FlBorderData get borderData => FlBorderData(
        show: true,
        border: Border(
          bottom: BorderSide(color: Color(0xff4e4965), width: 0.2),
          left: BorderSide(color: Colors.transparent),
          right: BorderSide(color: Colors.transparent),
          top: BorderSide(color: Colors.transparent),
        ),
      );

  LineChartBarData get lineChartBarData1_1 => LineChartBarData(
        isCurved: true,
        preventCurveOverShooting: true,
        color: const Color(0xFF4AF699),
        barWidth: 1,
        isStrokeCapRound: true,
        dotData: FlDotData(show: false),
        belowBarData: BarAreaData(
          show: true,
          color: const Color(0x5F4AF699),
        ),
        spots: [
          FlSpot(0, 0),
          FlSpot(1, Factor[1].toDouble()),
          FlSpot(2, Factor[2].toDouble()),
          FlSpot(3, Factor[3].toDouble()),
          FlSpot(4, Factor[4].toDouble()),
          FlSpot(5, Factor[5].toDouble()),
          FlSpot(6, Factor[6].toDouble()),
          FlSpot(7, Factor[7].toDouble()),
          FlSpot(8, Factor[8].toDouble()),
          FlSpot(9, Factor[9].toDouble()),
          FlSpot(10, Factor[10].toDouble()),
          FlSpot(11, Factor[11].toDouble()),
          FlSpot(12, Factor[12].toDouble()),
          FlSpot(13, Factor[13].toDouble()),
          FlSpot(14, Factor[14].toDouble()),
          FlSpot(15, Factor[15].toDouble()),
          FlSpot(16, Factor[16].toDouble()),
          FlSpot(17, Factor[17].toDouble()),
          FlSpot(18, Factor[18].toDouble()),
          FlSpot(19, Factor[19].toDouble()),
          FlSpot(20, Factor[20].toDouble()),
          FlSpot(21, Factor[21].toDouble()),
          FlSpot(22, Factor[22].toDouble()),
          FlSpot(23, Factor[23].toDouble()),
          FlSpot(24, Factor[24].toDouble()),
          FlSpot(25, Factor[25].toDouble()),
          FlSpot(26, Factor[26].toDouble()),
          FlSpot(27, Factor[27].toDouble()),
          FlSpot(28, Factor[28].toDouble()),
          FlSpot(29, Factor[29].toDouble()),
          FlSpot(30, Factor[30].toDouble()),
          FlSpot(31, Factor[31].toDouble())
        ],
      );

  LineChartBarData get lineChartBarData1_2 => LineChartBarData(
        isCurved: true,
        preventCurveOverShooting: true,
        color: Color(0xFFAA4CFC),
        barWidth: 1,
        isStrokeCapRound: true,
        dotData: FlDotData(show: false),
        belowBarData: BarAreaData(
          show: true,
          color: Color(0x5FAA4CFC),
        ),
        spots: [
          FlSpot(0, 0),
          FlSpot(1, last_Factor[1].toDouble()),
          FlSpot(2, last_Factor[2].toDouble()),
          FlSpot(3, last_Factor[3].toDouble()),
          FlSpot(4, last_Factor[4].toDouble()),
          FlSpot(5, last_Factor[5].toDouble()),
          FlSpot(6, last_Factor[6].toDouble()),
          FlSpot(7, last_Factor[7].toDouble()),
          FlSpot(8, last_Factor[8].toDouble()),
          FlSpot(9, last_Factor[9].toDouble()),
          FlSpot(10, last_Factor[10].toDouble()),
          FlSpot(11, last_Factor[11].toDouble()),
          FlSpot(12, last_Factor[12].toDouble()),
          FlSpot(13, last_Factor[13].toDouble()),
          FlSpot(14, last_Factor[14].toDouble()),
          FlSpot(15, last_Factor[15].toDouble()),
          FlSpot(16, last_Factor[16].toDouble()),
          FlSpot(17, last_Factor[17].toDouble()),
          FlSpot(18, last_Factor[18].toDouble()),
          FlSpot(19, last_Factor[19].toDouble()),
          FlSpot(20, last_Factor[20].toDouble()),
          FlSpot(21, last_Factor[21].toDouble()),
          FlSpot(22, last_Factor[22].toDouble()),
          FlSpot(23, last_Factor[23].toDouble()),
          FlSpot(24, last_Factor[24].toDouble()),
          FlSpot(25, last_Factor[25].toDouble()),
          FlSpot(26, last_Factor[26].toDouble()),
          FlSpot(27, last_Factor[27].toDouble()),
          FlSpot(28, last_Factor[28].toDouble()),
          FlSpot(29, last_Factor[29].toDouble()),
          FlSpot(30, last_Factor[30].toDouble()),
          FlSpot(31, last_Factor[31].toDouble()),
        ],
      );
}

class ChartPage extends StatefulWidget {
  final Future<Database> db;
  ChartPage(this.db);

  @override
  _ChartPageState createState() => _ChartPageState();
}

class _ChartPageState extends State<ChartPage> {
  Future<List<Concentration>>? cctList;
  final ImagePicker _picker = ImagePicker();
  File? _setImage;

  // DB에서 자료를 긁어와 만들 리스트
  List<int> lastMonthCC = [
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
  ];
  List<int> curMonthCC = [
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
  ];
  List<int> lastMonthCCT = [
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
  ];
  List<int> curMonthCCT = [
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
  ];
  List<int> lastWeekCC = [
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
  ];
  List<int> curWeekCC = [
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
  ];
  List<int> lastWeekCCT = [
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
  ];
  List<int> curWeekCCT = [
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
  ];
  // 탭 변경에 따라 화면 전환할 스위치
  int selectedTabWeeks = 0;
  int selectedTabMonths = 0;
  int selectedPeriodCCT = 0;
  int selectedPeriodCC = 0;
  // 집중시간, 집중도 최대값
  int limitedCCT = 0;
  int limitedCCTW = 0;
  int limitedCC = 100;
  // 지난주(월), 이번주(월) 집중시간 및 집중도 총합
  int totalCCT = 0;
  int totalCCTW = 0;
  int last_totalCCT = 0;
  int last_totalCCTW = 0;
  int totalCC = 0;
  int totalCCW = 0;
  int last_totalCC = 0;
  int last_totalCCW = 0;
  // 주, 달 집중시간 최대값을 정하기 위한 변수
  int maxTimeWeek = 0;
  int maxTimeMon = 0;
  // 스위치 전환에 따른 총합값 변환을 위한 변수
  int insertLimitedCCT = 0;
  int insertTotalCCT = 0;
  int insertLastCCT = 0;
  int insertIntTotalCC = 0;
  int insertIntLastCC = 0;
  String insertTotalCC = '';
  String insertLastCC = '';
  // DB에서 필요한 내용물을 전부 불러왔는지 확인을 위한 future int
  Future<int>? checkDB;
  Future<int>? checkPIC;
  // 집중도 등급을 저장하기 위한 변수
  String GradeMonthCC = '';
  String GradeWeekCC = '';
  String GradeLastMonthCC = '';
  String GradeLastWeekCC = '';

  void CCTDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                height: MediaQuery.of(context).size.height * 0.23,
                child: AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15.0))),
                  contentPadding: EdgeInsets.only(top: 0),
                  title: Text('집중시간이란?\n',
                      style: TextStyle(
                        //fontFamily: 'pyeongchang',
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      )),
                  content: Padding(
                    padding: EdgeInsets.only(left: 15),
                    child: Column(children: <Widget>[
                      Row(children: <Widget>[
                        Container(
                          width: 5,
                          height: 5,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: HexColor('#000000'),
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          '집중시간 : 총 집중한 시간을 시 단위로 저장',
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      ]),
                      Row(
                        children: <Widget>[
                          Container(
                            width: 5,
                            height: 5,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: HexColor('#000000'),
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            '세로축은 시간, 가로축은 일자',
                            style: TextStyle(
                              fontSize: 12,
                            ),
                          ),
                        ],
                      )
                    ]),
                  ),
                ),
              ),
            ),
          );
        });
  }

  void CCDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                height: MediaQuery.of(context).size.height * 0.23,
                child: AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15.0))),
                  contentPadding: EdgeInsets.only(top: 0),
                  title: Text(
                    '집중도란?\n',
                    style: TextStyle(
                      //fontFamily: 'pyeongchang',
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  content: Padding(
                    padding: EdgeInsets.only(left: 15),
                    child: Column(children: <Widget>[
                      Row(children: <Widget>[
                        Container(
                          width: 5,
                          height: 5,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: HexColor('#000000'),
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text('집중도 : 감소한 수치 * 가중치(집중시간)',
                            style: TextStyle(
                              fontSize: 12,
                            )),
                      ]),
                      Row(
                        children: <Widget>[
                          Container(
                            width: 5,
                            height: 5,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: HexColor('#000000'),
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text('세로축 : 집중도, 가로축 : 일자',
                              style: TextStyle(
                                fontSize: 12,
                              )),
                        ],
                      )
                    ]),
                  ),
                ),
              ),
            ),
          );
        });
  }

  // periods CC처럼 DB값을 불러와 chart에 적용한 내용물을 불러오는 리스트
  late List _periodsCCT = [
    MonthCCTBuilder,
    WeekCCTBuilder,
  ];

  // week, month 선택 시, 선택된 대상과 비대상에 그어진 밑줄 색
  List _TabColor = [
    HexColor('#161A24'),
    HexColor('#FFFFFF'),
  ];

  // periodsCCT와 동일 용도. 불러오는 값이 집중도란 것만 다름.
  late List _periodsCC = [
    MonthCCBuilder,
    WeekCCBuilder,
  ];

  // week, month 변경 시, 이번 주/달, 다음 주/달 중 맞는 부븐을 표시
  List _changePeriods = [
    '달',
    '주',
  ];

  // image를 사진첩에서 공수해온다
  Future<int> gsImage(bool isGet) async {
    final prefs = await SharedPreferences.getInstance();
    if (isGet) {
      final directory = await getApplicationDocumentsDirectory();
      XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      final File temp = File(image!.path);
      final _path = directory.path;
      setState(() {
        _setImage = temp;
      });
      await temp.copy('$_path/_setImage');
      prefs.setString('setImage', _setImage!.path);
    } else {
      setState(() {
        _setImage = File(prefs.getString('setImage').toString());
      });
    }
    return 1;
  }

  // 리스트화된 DB 내용물을 그래프에 뿌려주기 위해 해당 리스트에 값을 저장
  void initMonthList(List<Concentration> list) {
    for (int i = 0; i < list.length; i++) {
      // 2022-10-02
      int day = int.parse(list[i].date!.substring(8, 10));
      curMonthCCT[day] = (list[i].cctTime! / 60).toInt();
      curMonthCC[day] = (list[i].cctScore! / list[i].cctTime!).toInt();
    }
  }

  void initLastMonthList(List<Concentration> list) {
    for (int i = 0; i < list.length; i++) {
      // 2022-10-02
      int day = int.parse(list[i].date!.substring(8, 10));
      lastMonthCCT[day] = (list[i].cctTime! / 60).toInt();
      lastMonthCC[day] = (list[i].cctScore! / list[i].cctTime!).toInt();
    }
  }

  void initWeekList(List<Concentration> list) {
    for (int i = 0; i < list.length; i++) {
      int day = int.parse(list[i].date!.substring(8, 10));
      var now = DateTime.now();
      var lastmonth_lastday = DateTime(now.year, now.month, 0).toString();
      var parse_lastday = DateTime.parse(lastmonth_lastday);
      String Slastmonth_lastday = '${parse_lastday.day}';
      int lastday_month = int.parse(Slastmonth_lastday);
      var firstday = now.subtract(Duration(days: now.weekday - 1));
      String week_first = DateFormat('dd').format(firstday);
      int week_firstday = int.parse(week_first);
      if (week_firstday > day) {
        week_firstday = week_firstday - lastday_month;
      }
      int weekday = day - week_firstday + 1;
      curWeekCCT[weekday] = (list[i].cctTime! / 60).toInt();
      curWeekCC[weekday] = (list[i].cctScore! / list[i].cctTime!).toInt();
      print('curWeekCC[${weekday}] : ${curWeekCC[weekday]}');
    }
  }

  void initLastWeekList(List<Concentration> list) {
    for (int i = 0; i < list.length; i++) {
      int day = int.parse(list[i].date!.substring(8, 10));
      var now = DateTime.now();
      var lastmonth_lastday = DateTime(now.year, now.month, 0).toString();
      var parse_lastday = DateTime.parse(lastmonth_lastday);
      String Slastmonth_lastday = '${parse_lastday.day}';
      int lastday_month = int.parse(Slastmonth_lastday);
      var firstday = now.subtract(Duration(days: now.weekday + 6));
      String week_first = DateFormat('dd').format(firstday);
      int week_firstday = int.parse(week_first);
      if (week_firstday > day) {
        week_firstday = week_firstday - lastday_month;
      }
      int weekday = day - week_firstday + 1;
      lastWeekCCT[weekday] = (list[i].cctTime! / 60).toInt();
      lastWeekCC[weekday] = (list[i].cctScore! / list[i].cctTime!).toInt();
    }
  }

  // DB에서 해당하는 주, 달 값을 긁어오기 위한 함수
  Future<int> getDB() async {
    final Database database = await widget.db;
    List<Map<String, dynamic>> maps;
    List<Concentration> list;

    // 이번달 데이터 추출
    maps = await database.rawQuery(
        "SELECT date, SUM(cctTime) AS cctTime, SUM(cctScore) AS cctScore "
        "FROM concentration "
        "WHERE strftime('%Y-%m', date) = strftime('%Y-%m', 'now', 'localtime') "
        "GROUP BY date "
        "ORDER BY date");
    list = List.generate(maps.length, (i) {
      return Concentration(
          date: maps[i]['date'].toString(),
          cctTime: maps[i]['cctTime'],
          cctScore: maps[i]['cctScore']);
    });
    initMonthList(list);

    // 저번달 데이터 추출
    maps = await database.rawQuery(
        "SELECT date, SUM(cctTime) AS cctTime, SUM(cctScore) AS cctScore "
        "FROM concentration "
        "WHERE strftime('%Y-%m', date) = strftime('%Y-%m', 'now', 'localtime', '-1 months') "
        "GROUP BY date "
        "ORDER BY date");
    list = List.generate(maps.length, (i) {
      return Concentration(
          date: maps[i]['date'].toString(),
          cctTime: maps[i]['cctTime'],
          cctScore: maps[i]['cctScore']);
    });
    initLastMonthList(list);

    // 이번주 데이터 추출
    maps = await database.rawQuery(
        "SELECT date, SUM(cctTime) AS cctTime, SUM(cctScore) AS cctScore "
        "FROM concentration "
        "WHERE strftime('%Y-%m-%d', date) >= strftime('%Y-%m-%d', 'now', 'localtime', '-6 days', 'weekday 1') "
        "GROUP BY date "
        "ORDER BY date");
    list = List.generate(maps.length, (i) {
      return Concentration(
          date: maps[i]['date'].toString(),
          cctTime: maps[i]['cctTime'],
          cctScore: maps[i]['cctScore']);
    });
    initWeekList(list);

    // 저번주 데이터 추출
    maps = await database.rawQuery(
        "SELECT date, SUM(cctTime) AS cctTime, SUM(cctScore) AS cctScore "
        "FROM concentration "
        "WHERE strftime('%Y-%m-%d', date) >= strftime('%Y-%m-%d', 'now', 'localtime', '-13 days', 'weekday 1') "
        "AND strftime('%Y-%m-%d', date) <= strftime('%Y-%m-%d', 'now', 'localtime', '-7 days', 'weekday 0') "
        "GROUP BY date "
        "ORDER BY date");
    list = List.generate(maps.length, (i) {
      return Concentration(
          date: maps[i]['date'].toString(),
          cctTime: maps[i]['cctTime'],
          cctScore: maps[i]['cctScore']);
    });
    initLastWeekList(list);

    // 오래된 데이터 삭제(2달전 데이터)
    database.rawDelete("DELETE FROM concentration "
        "WHERE strftime('%Y-%m', date) <= strftime('%Y-%m', 'now', 'localtime', '-2 months')");

    _initTotal();
    return 1;
  }

  // 위 리스트가 DB 내용을 전부 긁어올 때까지 기다리는 시간 동안 값 대신 보여줄 위젯
  Widget MonthCCTBuilder(BuildContext context, AsyncSnapshot<int> snapshot) {
    switch (snapshot.connectionState) {
      case ConnectionState.none:
        return CircularProgressIndicator();
      case ConnectionState.waiting:
        return CircularProgressIndicator();
      case ConnectionState.active:
        return CircularProgressIndicator();
      case ConnectionState.done:
        return _LineChartMonth(Factor: curMonthCCT, last_Factor: lastMonthCCT, LimitedTime: maxTimeMon);
    }
  }

  Widget WeekCCTBuilder(BuildContext context, AsyncSnapshot<int> snapshot) {
    switch (snapshot.connectionState) {
      case ConnectionState.none:
        return CircularProgressIndicator();
      case ConnectionState.waiting:
        return CircularProgressIndicator();
      case ConnectionState.active:
        return CircularProgressIndicator();
      case ConnectionState.done:
        return _LineChartWeek(Factor: curWeekCCT, last_Factor: lastWeekCCT, LimitedTime: maxTimeWeek,);
    }
  }

  Widget MonthCCBuilder(BuildContext context, AsyncSnapshot<int> snapshot) {
    switch (snapshot.connectionState) {
      case ConnectionState.none:
        return CircularProgressIndicator();
      case ConnectionState.waiting:
        return CircularProgressIndicator();
      case ConnectionState.active:
        return CircularProgressIndicator();
      case ConnectionState.done:
        return _LineChartMonthCC(Factor: curMonthCC, last_Factor: lastMonthCC);
    }
  }

  Widget WeekCCBuilder(BuildContext context, AsyncSnapshot<int> snapshot) {
    switch (snapshot.connectionState) {
      case ConnectionState.none:
        return CircularProgressIndicator();
      case ConnectionState.waiting:
        return CircularProgressIndicator();
      case ConnectionState.active:
        return CircularProgressIndicator();
      case ConnectionState.done:
        return _LineChartWeekCC(Factor: curWeekCC, last_Factor: lastWeekCC);
    }
  }

  Widget totalCCBuilder(BuildContext context, AsyncSnapshot<int> snapshot) {
    switch (snapshot.connectionState) {
      case ConnectionState.none:
        return CircularProgressIndicator();
      case ConnectionState.waiting:
        return CircularProgressIndicator();
      case ConnectionState.active:
        return CircularProgressIndicator();
      case ConnectionState.done:
        return Text('$insertTotalCC',
            style: TextStyle(
                //fontFamily: 'harsh',
                fontSize: MediaQuery.of(context).size.width * 0.04,
                fontWeight: FontWeight.w400,
                color: HexColor('#FFFFFF')));
    }
  }

  Widget totalLastCCBuilder(BuildContext context, AsyncSnapshot<int> snapshot) {
    switch (snapshot.connectionState) {
      case ConnectionState.none:
        return CircularProgressIndicator();
      case ConnectionState.waiting:
        return CircularProgressIndicator();
      case ConnectionState.active:
        return CircularProgressIndicator();
      case ConnectionState.done:
        return Text('$insertLastCC',
            style: TextStyle(
                //fontFamily: 'harsh',
                fontWeight: FontWeight.w400,
                fontSize: MediaQuery.of(context).size.width * 0.04,
                color: HexColor('#FFFFFF')));
    }
  }

  Widget totalCCTBuilder(BuildContext context, AsyncSnapshot<int> snapshot) {
    switch (snapshot.connectionState) {
      case ConnectionState.none:
        return CircularProgressIndicator();
      case ConnectionState.waiting:
        return CircularProgressIndicator();
      case ConnectionState.active:
        return CircularProgressIndicator();
      case ConnectionState.done:
        return Text('${(insertTotalCCT / 3600).toInt().toString()} 시간',
            style: TextStyle(
                fontFamily: 'pyeongchang',
                fontSize: MediaQuery.of(context).size.width * 0.04,
                color: HexColor('#FFFFFF')));
    }
  }

  Widget totalLastCCTBuilder(
      BuildContext context, AsyncSnapshot<int> snapshot) {
    switch (snapshot.connectionState) {
      case ConnectionState.none:
        return CircularProgressIndicator();
      case ConnectionState.waiting:
        return CircularProgressIndicator();
      case ConnectionState.active:
        return CircularProgressIndicator();
      case ConnectionState.done:
        return Text('${(insertLastCCT / 3600).toInt().toString()} 시간',
            style: TextStyle(
                fontFamily: 'pyeongchang',
                fontSize: MediaQuery.of(context).size.width * 0.04,
                color: HexColor('#FFFFFF')));
    }
  }

  Widget circularGraphCCTBuilder(
      BuildContext context, AsyncSnapshot<int> snapshot) {
    switch (snapshot.connectionState) {
      case ConnectionState.none:
        return Text('',
            style: TextStyle(
              color: HexColor('#FFFFFF'),
            ));
      case ConnectionState.waiting:
        return Text('',
            style: TextStyle(
              color: HexColor('#FFFFFF'),
            ));
      case ConnectionState.active:
        return Text('',
            style: TextStyle(
              color: HexColor('#FFFFFF'),
            ));
      case ConnectionState.done:
        return CustomPaint(
          size: Size(
            MediaQuery.of(context).size.height * 0.15,
            MediaQuery.of(context).size.height * 0.15,
          ),
          painter: _PieChart(
            percentage:
                (((insertLimitedCCT - insertTotalCCT) / insertLimitedCCT) * 100)
                    .toInt(),
            barColor: HexColor('#FFD740'),
            strokelen: (MediaQuery.of(context).size.width * 0.2).toInt(),
          ),
        );
    }
  }

  Widget circularGraphCCBuilder(
      BuildContext context, AsyncSnapshot<int> snapshot) {
    switch (snapshot.connectionState) {
      case ConnectionState.none:
        return Text('',
            style: TextStyle(
              color: HexColor('#FFFFFF'),
            ));
      case ConnectionState.waiting:
        return Text('',
            style: TextStyle(
              color: HexColor('#FFFFFF'),
            ));
      case ConnectionState.active:
        return Text('',
            style: TextStyle(
              color: HexColor('#FFFFFF'),
            ));
      case ConnectionState.done:
        return CustomPaint(
          size: Size(
            MediaQuery.of(context).size.height * 0.13,
            MediaQuery.of(context).size.height * 0.13,
          ),
          painter: _PieChart(
            percentage:
                (((limitedCC - insertIntTotalCC) / limitedCC) * 100).toInt(),
            barColor: HexColor('#90EE90'),
            strokelen: (MediaQuery.of(context).size.width * 0.2).toInt(),
          ),
        );
    }
  }

  Widget circularPhotoBuilder(
      BuildContext context, AsyncSnapshot<int> snapshot) {
    switch (snapshot.connectionState) {
      case ConnectionState.none:
        return Icon(CupertinoIcons.photo);
      case ConnectionState.waiting:
        return Icon(CupertinoIcons.photo);
      case ConnectionState.active:
        return Icon(CupertinoIcons.photo);
      case ConnectionState.done:
        return ClipOval(
          child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.1,
              width: MediaQuery.of(context).size.height * 0.1,
              child: _setImage!.existsSync()
                  ? Image.file(File(_setImage!.path), fit: BoxFit.cover)
                  : Icon(CupertinoIcons.photo)),
        );
    }
  }

  void _insertDB() {
    /*
    들어가야 하는 내용
    1. DB 변환 : CC는 일자 별 총 시간으로 한 번 씩 나누고 들어가야 함, CCT는 삽입 전에 3600으로 나눌 것
    2. 일자 확인 : 현재 일자(Datetime) 기준, 속하는 달을 이번달 리스트, 과거는 저번달 리스트
    3. DB 없을 때 처리 : 원하는 일자에 DB가 존재하지 않으면 해당 배열값은 0.
     */
    checkDB = getDB();
    checkPIC = gsImage(false);
  }

  // DB에서 가져온 값이 저장된 리스트를 이용하여 주, 월 총합을 표기할 수 있는 값을 만듬
  void _initTotal() {
    int curweekcount = 0;
    int lastweekcount = 0;
    int curcount = 0;
    int lastcount = 0;
    for (int i = 1; i <= 31; i++) {
      if (i <= 7) {
        if (curWeekCCT[i] > maxTimeWeek) {
          maxTimeWeek = curWeekCCT[i];
        }
        if (lastWeekCCT[i] > maxTimeWeek) {
          maxTimeWeek = lastWeekCCT[i];
        }
        if (curWeekCCT[i] != 0 || curWeekCC[i] != 0) {
          curweekcount += 1;
        }
        if (lastWeekCCT[i] != 0 || lastWeekCC[i] != 0) {
          lastweekcount += 1;
        }
        if (curMonthCCT[i] > maxTimeMon) {
          maxTimeMon = curMonthCCT[i];
        }
        if (lastMonthCCT[i] > maxTimeMon) {
          maxTimeMon = lastMonthCCT[i];
        }
        totalCCTW += curWeekCCT[i];
        totalCCW += curWeekCC[i];
        last_totalCCTW += lastWeekCCT[i];
        last_totalCCW += lastWeekCC[i];
      }
      if (curMonthCCT[i] != 0 || curMonthCC[i] != 0) {
        curcount += 1;
      }
      if (lastMonthCCT[i] != 0 || lastMonthCC[i] != 0) {
        lastcount += 1;
      }
      totalCCT += curMonthCCT[i];
      totalCC += curMonthCC[i];
      last_totalCCT += lastMonthCCT[i];
      last_totalCC += lastMonthCC[i];
    }
    maxTimeMon = maxTimeMon % 60 == 0
        ? (maxTimeMon / 60).toInt()
        : (maxTimeMon / 60).toInt() + 1;
    maxTimeWeek = maxTimeWeek % 60 == 0
        ? (maxTimeWeek / 60).toInt()
        : (maxTimeWeek / 60).toInt() + 1;
    if (curcount == 0) {
      curcount = 1;
    }
    if (lastcount == 0) {
      lastcount = 1;
    }
    if (curweekcount == 0) {
      curweekcount = 1;
    }
    if (lastweekcount == 0) {
      lastweekcount = 1;
    }
    last_totalCC = (last_totalCC / lastcount).toInt();
    last_totalCCW = (last_totalCCW / lastweekcount).toInt();
    totalCC = (totalCC / curcount).toInt();
    totalCCW = (totalCCW / curweekcount).toInt();
    totalCCTW *= 60;
    totalCCT *= 60;
    last_totalCCTW *= 60;
    last_totalCCT *= 60;
    if (92 <= totalCC) {
      GradeMonthCC = 'A+';
    } else if (86 <= totalCC) {
      GradeMonthCC = 'A';
    } else if (80 <= totalCC) {
      GradeMonthCC = 'A-';
    } else if (74 <= totalCC) {
      GradeMonthCC = 'B+';
    } else if (68 <= totalCC) {
      GradeMonthCC = 'B';
    } else if (62 <= totalCC) {
      GradeMonthCC = 'B-';
    } else if (56 <= totalCC) {
      GradeMonthCC = 'C+';
    } else if (46 <= totalCC) {
      GradeMonthCC = 'C';
    } else if (36 <= totalCC) {
      GradeMonthCC = 'D+';
    } else if (26 <= totalCC) {
      GradeMonthCC = 'D';
    } else if (0 < totalCC) {
      GradeMonthCC = 'F';
    } else {
      GradeMonthCC = '-';
    }

    if (92 <= last_totalCC) {
      GradeLastMonthCC = 'A+';
    } else if (86 <= last_totalCC) {
      GradeLastMonthCC = 'A';
    } else if (80 <= last_totalCC) {
      GradeLastMonthCC = 'A-';
    } else if (74 <= last_totalCC) {
      GradeLastMonthCC = 'B+';
    } else if (68 <= last_totalCC) {
      GradeLastMonthCC = 'B';
    } else if (62 <= last_totalCC) {
      GradeLastMonthCC = 'B-';
    } else if (56 <= last_totalCC) {
      GradeLastMonthCC = 'C+';
    } else if (46 <= last_totalCC) {
      GradeLastMonthCC = 'C';
    } else if (36 <= last_totalCC) {
      GradeLastMonthCC = 'D+';
    } else if (26 <= last_totalCC) {
      GradeLastMonthCC = 'D';
    } else if (0 < last_totalCC) {
      GradeLastMonthCC = 'F';
    } else {
      GradeLastMonthCC = '-';
    }

    if (92 <= totalCCW) {
      GradeWeekCC = 'A+';
    } else if (86 <= totalCCW) {
      GradeWeekCC = 'A';
    } else if (80 <= totalCCW) {
      GradeWeekCC = 'A-';
    } else if (74 <= totalCCW) {
      GradeWeekCC = 'B+';
    } else if (68 <= totalCCW) {
      GradeWeekCC = 'B';
    } else if (62 <= totalCCW) {
      GradeWeekCC = 'B-';
    } else if (56 <= totalCCW) {
      GradeWeekCC = 'C+';
    } else if (46 <= totalCCW) {
      GradeWeekCC = 'C';
    } else if (36 <= totalCCW) {
      GradeWeekCC = 'D+';
    } else if (26 <= totalCCW) {
      GradeWeekCC = 'D';
    } else if (0 < totalCCW) {
      GradeWeekCC = 'F';
    } else {
      GradeWeekCC = '-';
    }

    if (92 <= last_totalCCW) {
      GradeLastWeekCC = 'A+';
    } else if (86 <= last_totalCCW) {
      GradeLastWeekCC = 'A';
    } else if (80 <= last_totalCCW) {
      GradeLastWeekCC = 'A-';
    } else if (74 <= last_totalCCW) {
      GradeLastWeekCC = 'B+';
    } else if (68 <= last_totalCCW) {
      GradeLastWeekCC = 'B';
    } else if (62 <= last_totalCCW) {
      GradeLastWeekCC = 'B-';
    } else if (56 <= last_totalCCW) {
      GradeLastWeekCC = 'C+';
    } else if (46 <= last_totalCCW) {
      GradeLastWeekCC = 'C';
    } else if (36 <= last_totalCCW) {
      GradeLastWeekCC = 'D+';
    } else if (26 <= last_totalCCW) {
      GradeLastWeekCC = 'D';
    } else if (0 < last_totalCCW) {
      GradeLastWeekCC = 'F';
    } else {
      GradeLastWeekCC = '-';
    }

    if (maxTimeMon <= 3) {
      maxTimeMon = 3;
    } else if (maxTimeMon <= 6) {
      maxTimeMon = 6;
    } else if (maxTimeMon <= 9) {
      maxTimeMon = 9;
    } else if (maxTimeMon <= 12) {
      maxTimeMon = 12;
    } else if (maxTimeMon <= 15) {
      maxTimeMon = 15;
    } else if (maxTimeMon <= 18) {
      maxTimeMon = 18;
    } else if (maxTimeMon <= 21) {
      maxTimeMon = 21;
    } else {
      maxTimeMon = 24;
    }

    if (maxTimeWeek <= 3) {
      maxTimeWeek = 3;
    } else if (maxTimeWeek <= 6) {
      maxTimeWeek = 6;
    } else if (maxTimeWeek <= 9) {
      maxTimeWeek = 9;
    } else if (maxTimeWeek <= 12) {
      maxTimeWeek = 12;
    } else if (maxTimeWeek <= 15) {
      maxTimeWeek = 15;
    } else if (maxTimeWeek <= 18) {
      maxTimeWeek = 18;
    } else if (maxTimeWeek <= 21) {
      maxTimeWeek = 21;
    } else {
      maxTimeWeek = 24;
    }

    limitedCCT = maxTimeMon == 0 ? 1 : (maxTimeMon * 3600 * 31);
    limitedCCTW = maxTimeWeek == 0 ? 1 : (maxTimeWeek * 3600 * 7);
    insertTotalCC = GradeWeekCC;
    insertLastCC = GradeLastWeekCC;
    insertTotalCCT = totalCCTW;
    insertLastCCT = last_totalCCTW;
    insertLimitedCCT = limitedCCTW;
    insertIntTotalCC = totalCCW;
    insertIntLastCC = last_totalCCW;
  }

  @override
  void initState() {
    super.initState();
    selectedPeriodCCT = 1;
    selectedPeriodCC = 1;
    selectedTabMonths = 0;
    selectedTabWeeks = 1;
    _insertDB();
    insertTotalCC = GradeWeekCC;
    insertLastCC = GradeLastWeekCC;
    insertTotalCCT = totalCCTW;
    insertLastCCT = last_totalCCTW;
    insertLimitedCCT = limitedCCTW;
    insertIntTotalCC = totalCCW;
    insertIntLastCC = last_totalCCW;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: HexColor('#161A24'),
      child: Column(children: <Widget>[
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.05,
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.25,
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '  종합',
                      style: TextStyle(
                        color: HexColor('#FFFFFF'),
                        fontFamily: 'pyeongchang',
                        fontSize: MediaQuery.of(context).size.height * 0.03,
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      fit: FlexFit.tight,
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).size.height * 0.003,
                      ),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: _TabColor[selectedTabWeeks],
                            width: MediaQuery.of(context).size.height * 0.002,
                          ),
                        ),
                      ),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            selectedPeriodCCT = 1;
                            selectedPeriodCC = 1;
                            selectedTabWeeks = 1;
                            selectedTabMonths = 0;
                            insertLimitedCCT = limitedCCTW;
                            insertTotalCCT = totalCCTW;
                            insertTotalCC = GradeWeekCC;
                            insertLastCCT = last_totalCCTW;
                            insertLastCC = GradeLastWeekCC;
                            insertIntTotalCC = totalCCW;
                            insertIntLastCC = last_totalCCW;
                          });
                        },
                        child: Text(
                          'Week',
                          style: TextStyle(
                            fontSize:
                                MediaQuery.of(context).size.height * 0.017,
                            color: HexColor('#FFFFFF'),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.025),
                    Container(
                      padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).size.height * 0.003,
                      ),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: _TabColor[selectedTabMonths],
                            width: MediaQuery.of(context).size.height * 0.002,
                          ),
                        ),
                      ),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            selectedPeriodCCT = 0;
                            selectedPeriodCC = 0;
                            selectedTabWeeks = 0;
                            selectedTabMonths = 1;
                            insertLastCC = GradeLastMonthCC;
                            insertLastCCT = last_totalCCT;
                            insertLimitedCCT = limitedCCT;
                            insertTotalCC = GradeMonthCC;
                            insertTotalCCT = totalCCT;
                            insertIntTotalCC = totalCC;
                            insertIntLastCC = last_totalCC;
                          });
                        },
                        child: Text(
                          'Month',
                          style: TextStyle(
                            fontSize:
                                MediaQuery.of(context).size.height * 0.017,
                            color: HexColor('#FFFFFF'),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.05,
                    ),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                Row(
                  children: <Widget>[
                    Flexible(
                      flex: 1,
                      fit: FlexFit.loose,
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.1,
                      ),
                    ),
                    Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        Container(
                            child: FutureBuilder(
                          builder: circularGraphCCTBuilder,
                          future: checkDB,
                        )),
                        Container(
                            child: FutureBuilder(
                          builder: circularGraphCCBuilder,
                          future: checkDB,
                        )),
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          height: MediaQuery.of(context).size.height * 0.11,
                          child: FittedBox(
                            child: FloatingActionButton(
                              backgroundColor: HexColor('#161A24'),
                              onPressed: () {
                                gsImage(true);
                                print('path: ${_setImage!.path}');
                              },
                              child: FutureBuilder(
                                builder: circularPhotoBuilder,
                                future: checkPIC,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Flexible(
                      flex: 1,
                      fit: FlexFit.tight,
                      child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.3),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Icon(
                              CupertinoIcons.timer,
                              size: MediaQuery.of(context).size.height * 0.06,
                              color: Colors.amberAccent,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.03,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.45,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.2,
                                    child: Column(
                                      children: <Widget>[
                                        Text(
                                          '저번${_changePeriods[selectedTabWeeks]}',
                                          style: TextStyle(
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.03,
                                            fontWeight: FontWeight.w800,
                                            color: HexColor('#D3D3D3'),
                                          ),
                                        ),
                                        SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.01,
                                        ),
                                        FutureBuilder(
                                          builder: totalLastCCTBuilder,
                                          future: checkDB,
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.015,
                                  ),
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.2,
                                    child: Column(
                                      children: <Widget>[
                                        Text(
                                          '이번${_changePeriods[selectedTabWeeks]}',
                                          style: TextStyle(
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.03,
                                            fontWeight: FontWeight.w800,
                                            color: HexColor('#D3D3D3'),
                                          ),
                                        ),
                                        SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.01,
                                        ),
                                        FutureBuilder(
                                          builder: totalCCTBuilder,
                                          future: checkDB,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02,
                        ),
                        Row(
                          children: <Widget>[
                            Icon(
                              CupertinoIcons.lightbulb,
                              size: MediaQuery.of(context).size.height * 0.06,
                              color: Colors.lightGreen,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.03,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.45,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.2,
                                    child: Column(
                                      children: <Widget>[
                                        Text(
                                          '저번${_changePeriods[selectedTabWeeks]}',
                                          style: TextStyle(
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.03,
                                            fontWeight: FontWeight.w800,
                                            color: HexColor('#D3D3D3'),
                                          ),
                                        ),
                                        SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.01,
                                        ),
                                        FutureBuilder(
                                          builder: totalLastCCBuilder,
                                          future: checkDB,
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.015,
                                  ),
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.2,
                                    child: Column(
                                      children: <Widget>[
                                        Text(
                                          '이번${_changePeriods[selectedTabWeeks]}',
                                          style: TextStyle(
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.03,
                                            fontWeight: FontWeight.w800,
                                            color: HexColor('#D3D3D3'),
                                          ),
                                        ),
                                        SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.01,
                                        ),
                                        FutureBuilder(
                                          builder: totalCCBuilder,
                                          future: checkDB,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.05),
                  ],
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.01,
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.25,
          child: Stack(
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.01,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        '  집중시간',
                        style: TextStyle(
                          color: HexColor('#FFFFFF'),
                          fontSize: MediaQuery.of(context).size.width * 0.05,
                          fontFamily: 'pyeongchang',
                          letterSpacing: 2,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      SizedBox(width: MediaQuery.of(context).size.width * 0.03),
                      GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          return CCTDialog();
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.05,
                          child: Icon(CupertinoIcons.question_circle,
                              size: MediaQuery.of(context).size.width * 0.05,
                              color: HexColor('#FFFFFF')),
                        ),
                      ),
                      Flexible(
                        flex: 1,
                        fit: FlexFit.tight,
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                        ),
                      ),
                      Row(
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                              color: Color(0xFFAA4CFC),
                              shape: BoxShape.circle,
                            ),
                            width: MediaQuery.of(context).size.width * 0.02,
                            height: MediaQuery.of(context).size.width * 0.02,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.015,
                          ),
                          Text(
                            '저번${_changePeriods[selectedTabWeeks]}',
                            style: TextStyle(
                              color: HexColor('#FFFFFF'),
                              fontSize:
                                  MediaQuery.of(context).size.height * 0.015,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                      Row(
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                              color: Color(0xFF4AF699),
                              shape: BoxShape.circle,
                            ),
                            width: MediaQuery.of(context).size.width * 0.02,
                            height: MediaQuery.of(context).size.height * 0.02,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.015,
                          ),
                          Text(
                            '이번${_changePeriods[selectedTabWeeks]}',
                            style: TextStyle(
                              color: HexColor('#FFFFFF'),
                              fontSize:
                                  MediaQuery.of(context).size.height * 0.015,
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.05,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 16, left: 6),
                      child: FutureBuilder(
                        builder: _periodsCCT[selectedPeriodCCT],
                        future: checkDB,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.01,
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.03,
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.25,
          child: Stack(
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.01,
                  ),
                  Row(
                    children: <Widget>[
                      Text(
                        '  집중도',
                        style: TextStyle(
                          color: HexColor('#FFFFFF'),
                          fontSize: MediaQuery.of(context).size.width * 0.05,
                          fontFamily: 'pyeongchang',
                          letterSpacing: 2,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      SizedBox(width: MediaQuery.of(context).size.width * 0.03),
                      GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          return CCDialog();
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.05,
                          child: Icon(CupertinoIcons.question_circle,
                              size: MediaQuery.of(context).size.width * 0.05,
                              color: HexColor('#FFFFFF')),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 16, left: 6),
                      child: FutureBuilder(
                        builder: _periodsCC[selectedPeriodCC],
                        future: checkDB,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.01,
                  ),
                ],
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
