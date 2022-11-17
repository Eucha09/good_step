import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math';
import 'utils.dart';

class _PieChart extends CustomPainter {
  final int percentage;
  String res = "";
  final Color barColor;
  final double textScaleFactor;

  _PieChart({required this.percentage, required this.barColor, required this.textScaleFactor, required this.res});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint() // 화면에 그릴 때 쓸 paint를 정의
        ..color = barColor
        ..strokeWidth = 10.0 // 선의 길이를 정함
        ..style = PaintingStyle.stroke // 선의 스타일을 정함
        ..strokeCap = StrokeCap.square; // stroke 스타일을 정함

    double radius = min(size.width / 2 - paint.strokeWidth / 2,
        size.height / 2 - paint.strokeWidth / 2); // 원의 반지름을 구함, 선의 굵기에 영향을 받지 않게 보정
    Offset center = Offset(size.width / 2, size.height / 2); // 원이 위젯 가운데에 그려지게 좌표 정함
    canvas.drawCircle(center, radius, paint); // 원을 그린다
    double arcAngle = 2 * pi * (percentage / 100); // 호의 각도를 정한다
    paint..color = HexColor('#212B55'); // 호를 그릴 때 색깔을 바꿔줌
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), -pi / 2, arcAngle, false, paint); // 호를 그림
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
  double getFontSize(Size size, String text) {
    return size.width / text.length * textScaleFactor;
  }

  @override
  bool shouldRepaint(_PieChart old) {
    return old.percentage != percentage;
  }
}

class _LineChartWeekCC extends StatelessWidget {

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
    maxY: 100,
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
      fontSize: 7,
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
      fontSize: 7,
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
    color: const Color(0xFF4AF699),
    barWidth: 1,
    isStrokeCapRound: true,
    dotData: FlDotData(show: false),
    belowBarData: BarAreaData(
      show: true,
      color: const Color(0x5F4AF699),
    ),
    spots: const [
      FlSpot(0, 0),
      FlSpot(1, 5),
      FlSpot(2, 6),
      FlSpot(3, 9),
      FlSpot(4, 8),
      FlSpot(5, 4),
      FlSpot(6, 6),
      FlSpot(7, 11),
    ],
  );

  LineChartBarData get lineChartBarData1_2 => LineChartBarData(
    isCurved: true,
    color: Color(0xFFAA4CFC),
    barWidth: 1,
    isStrokeCapRound: true,
    dotData: FlDotData(show: false),
    belowBarData: BarAreaData(
      show: true,
      color: Color(0x5FAA4CFC),
    ),
    spots: const [
      FlSpot(0, 0),
      FlSpot(1, 1),
      FlSpot(2, 7),
      FlSpot(3, 2.8),
      FlSpot(4, 6),
      FlSpot(5, 8),
      FlSpot(6, 10),
      FlSpot(7, 1.2),
    ],
  );
}

class _LineChartMonthCC extends StatelessWidget {

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
    maxY: 100,
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
      fontSize: 7,
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
      fontSize: 7,
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
    color: const Color(0xFF4AF699),
    barWidth: 1,
    isStrokeCapRound: true,
    dotData: FlDotData(show: false),
    belowBarData: BarAreaData(
      show: true,
      color: const Color(0x5F4AF699),
    ),
    spots: const [
      FlSpot(0, 0),
      FlSpot(1, 5),
      FlSpot(2, 6),
      FlSpot(3, 9),
      FlSpot(4, 8),
      FlSpot(5, 4),
      FlSpot(6, 6),
      FlSpot(7, 11),
      FlSpot(8, 13),
      FlSpot(9, 12),
      FlSpot(10, 14),
      FlSpot(11, 15),
      FlSpot(12, 3),
      FlSpot(13, 5),
      FlSpot(14, 7),
      FlSpot(15, 8),
      FlSpot(16, 3),
      FlSpot(17, 2),
      FlSpot(18, 1),
      FlSpot(19, 3),
      FlSpot(20, 2),
      FlSpot(21, 4),
      FlSpot(22, 3),
      FlSpot(23, 5),
      FlSpot(24, 7),
      FlSpot(25, 8),
      FlSpot(26, 9),
      FlSpot(27, 2),
      FlSpot(28, 3),
      FlSpot(29, 6),
      FlSpot(30, 2),
      FlSpot(31, 1)
    ],
  );

  LineChartBarData get lineChartBarData1_2 => LineChartBarData(
    isCurved: true,
    color: Color(0xFFAA4CFC),
    barWidth: 1,
    isStrokeCapRound: true,
    dotData: FlDotData(show: false),
    belowBarData: BarAreaData(
      show: true,
      color: Color(0x5FAA4CFC),
    ),
    spots: const [
      FlSpot(0, 0),
      FlSpot(1, 1),
      FlSpot(2, 7),
      FlSpot(3, 2.8),
      FlSpot(4, 6),
      FlSpot(5, 8),
      FlSpot(6, 10),
      FlSpot(7, 1.2),
      FlSpot(8, 3),
      FlSpot(9, 6),
      FlSpot(10, 2.8),
      FlSpot(11, 7),
      FlSpot(12, 2.6),
      FlSpot(13, 3.9),
      FlSpot(14, 5),
      FlSpot(15, 6),
      FlSpot(16, 7),
      FlSpot(17, 9),
      FlSpot(18, 6),
      FlSpot(19, 2),
      FlSpot(20, 3),
      FlSpot(21, 4),
      FlSpot(22, 14),
      FlSpot(23, 8),
      FlSpot(24, 9),
      FlSpot(25, 7),
      FlSpot(26, 9),
      FlSpot(27, 3),
      FlSpot(28, 5),
      FlSpot(29, 4),
      FlSpot(30, 2),
      FlSpot(31, 3),
    ],
  );
}

class _LineChartWeek extends StatelessWidget {

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
    maxY: 15,
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
      fontSize: 7,
    );
    String text;
    switch (value.toInt()) {
      case 3:
        text = '3';
        break;
      case 6:
        text = '6';
        break;
      case 9:
        text = '9';
        break;
      case 12:
        text = '12';
        break;
      case 15:
        text = '15';
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
      fontSize: 7,
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
    color: const Color(0xFF4AF699),
    barWidth: 1,
    isStrokeCapRound: true,
    dotData: FlDotData(show: false),
    belowBarData: BarAreaData(
      show: true,
      color: const Color(0x5F4AF699),
    ),
    spots: const [
      FlSpot(0, 0),
      FlSpot(1, 5),
      FlSpot(2, 6),
      FlSpot(3, 9),
      FlSpot(4, 8),
      FlSpot(5, 4),
      FlSpot(6, 6),
      FlSpot(7, 11),
    ],
  );

  LineChartBarData get lineChartBarData1_2 => LineChartBarData(
    isCurved: true,
    color: Color(0xFFAA4CFC),
    barWidth: 1,
    isStrokeCapRound: true,
    dotData: FlDotData(show: false),
    belowBarData: BarAreaData(
      show: true,
      color: Color(0x5FAA4CFC),
    ),
    spots: const [
      FlSpot(0, 0),
      FlSpot(1, 1),
      FlSpot(2, 7),
      FlSpot(3, 2.8),
      FlSpot(4, 6),
      FlSpot(5, 8),
      FlSpot(6, 10),
      FlSpot(7, 1.2),
    ],
  );
}

class _LineChartMonth extends StatelessWidget {

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
    maxY: 15,
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
      fontSize: 7,
    );
    String text;
    switch (value.toInt()) {
      case 3:
        text = '3';
        break;
      case 6:
        text = '6';
        break;
      case 9:
        text = '9';
        break;
      case 12:
        text = '12';
        break;
      case 15:
        text = '15';
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
      fontSize: 7,
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
    color: const Color(0xFF4AF699),
    barWidth: 1,
    isStrokeCapRound: true,
    dotData: FlDotData(show: false),
    belowBarData: BarAreaData(
      show: true,
      color: const Color(0x5F4AF699),
    ),
    spots: const [
      FlSpot(0, 0),
      FlSpot(1, 5),
      FlSpot(2, 6),
      FlSpot(3, 9),
      FlSpot(4, 8),
      FlSpot(5, 4),
      FlSpot(6, 6),
      FlSpot(7, 11),
      FlSpot(8, 13),
      FlSpot(9, 12),
      FlSpot(10, 14),
      FlSpot(11, 15),
      FlSpot(12, 3),
      FlSpot(13, 5),
      FlSpot(14, 7),
      FlSpot(15, 8),
      FlSpot(16, 3),
      FlSpot(17, 2),
      FlSpot(18, 1),
      FlSpot(19, 3),
      FlSpot(20, 2),
      FlSpot(21, 4),
      FlSpot(22, 3),
      FlSpot(23, 5),
      FlSpot(24, 7),
      FlSpot(25, 8),
      FlSpot(26, 9),
      FlSpot(27, 2),
      FlSpot(28, 3),
      FlSpot(29, 6),
      FlSpot(30, 2),
      FlSpot(31, 1)
    ],
  );

  LineChartBarData get lineChartBarData1_2 => LineChartBarData(
    isCurved: true,
    color: Color(0xFFAA4CFC),
    barWidth: 1,
    isStrokeCapRound: true,
    dotData: FlDotData(show: false),
    belowBarData: BarAreaData(
      show: true,
      color: Color(0x5FAA4CFC),
    ),
    spots: const [
      FlSpot(0, 0),
      FlSpot(1, 1),
      FlSpot(2, 7),
      FlSpot(3, 2.8),
      FlSpot(4, 6),
      FlSpot(5, 8),
      FlSpot(6, 10),
      FlSpot(7, 1.2),
      FlSpot(8, 3),
      FlSpot(9, 6),
      FlSpot(10, 2.8),
      FlSpot(11, 7),
      FlSpot(12, 2.6),
      FlSpot(13, 3.9),
      FlSpot(14, 5),
      FlSpot(15, 6),
      FlSpot(16, 7),
      FlSpot(17, 9),
      FlSpot(18, 6),
      FlSpot(19, 2),
      FlSpot(20, 3),
      FlSpot(21, 4),
      FlSpot(22, 14),
      FlSpot(23, 8),
      FlSpot(24, 9),
      FlSpot(25, 7),
      FlSpot(26, 9),
      FlSpot(27, 3),
      FlSpot(28, 5),
      FlSpot(29, 4),
      FlSpot(30, 2),
      FlSpot(31, 3),
    ],
  );
}

class ChartPage extends StatefulWidget {
  @override
  _ChartPageState createState() => _ChartPageState();
}

class _ChartPageState extends State<ChartPage> {
  List<int> lastMonth = [];
  List<int> curMonth = [];
  int selectedPeriodCCT = 0;
  int selectedPeriodCC = 0;
  int selectedTabWeeksCCT = 0;
  int selectedTabMonthsCCT = 0;
  int selectedTabWeeksCC = 0;
  int selectedTabMonthsCC = 0;
  int limitedCCT = 162000;
  int limitedCC = 100;
  int totalCCT = 80000;
  int last_totalCCT = 60000;
  int totalCC = 50;
  int last_totalCC = 40;
  String totalCCTS = '';
  String totalCCS = '';

  List _periodsCCT = [
    _LineChartMonth(),
    _LineChartWeek(),
  ];

  List _TabColor = [
    HexColor('#564C4D'),
    HexColor('#212B55'),
  ];

  List _periodsCC = [
    _LineChartMonthCC(),
    _LineChartWeekCC(),
  ];

  @override
  void initState() {
    super.initState();
    selectedPeriodCCT = 0;
    selectedPeriodCC = 0;
    selectedTabMonthsCCT = 0;
    selectedTabWeeksCCT = 1;
    selectedTabMonthsCC = 0;
    selectedTabWeeksCC = 1;
    totalCCTS = (totalCCT/3600).toInt().toString();
    totalCCS = totalCC.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: HexColor('#24202E'),
        child: Column(
      children: <Widget>[
        SizedBox(
          height: 25,
        ),
        AspectRatio(
          aspectRatio: 1.9,
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(18)),
              gradient: LinearGradient(
                colors: [
                  HexColor('#212B55'),
                  HexColor('#212B55'),
                ],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
            child: Container(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    SizedBox(
                      height: 12,
                    ),
                      Text(
                        '  종합',
                      style: TextStyle(
                        color: HexColor('#FFFFFF'),
                        fontFamily: 'Cafe24',
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                        Row(
                          children: <Widget>[
                            SizedBox(
                              width: 12,
                            ),
                            Stack(
                              alignment: Alignment.center,
                          children: <Widget>[
                            Container(
                            child: CustomPaint(
                              size: Size(110, 110),
                              painter: _PieChart(
                                percentage: ((totalCCT / limitedCCT) * 100).toInt(),
                                textScaleFactor: 0.5,
                                barColor: Colors.amberAccent,
                                res: "",
                              ),
                            ),
                            ),
                            Container(
                              child: CustomPaint(
                              size: Size(85, 85),
                              painter: _PieChart(
                                percentage: ((totalCC / limitedCC) * 100).toInt(),
                                textScaleFactor: 0.5,
                                barColor: Colors.lightGreen,
                                res: "",
                              ),
                            ),
                            ),
                          ],
                        ),
                            SizedBox(
                              width: 12,
                            ),
                            Column(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Icon(
                                        Icons.timer,
                                    size: 45,
                                      color: HexColor('#FFFFFF'),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Row(
                                      children: <Widget>[
                                    Column(
                                      children: <Widget>[
                                        Text(
                                          '지난달',
                                          style: TextStyle(
                                            fontSize: 8,
                                            color: HexColor('#D3D3D3'),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          '${(last_totalCCT/3600).toInt().toString()}시간',
                                          style: TextStyle(
                                            fontFamily: 'Cafe24',
                                            fontSize: 13,
                                            color: HexColor('#FFFFFF')
                                          )
                                        ),
                                      ],
                                    ),
                                        SizedBox(
                                          width: 15,
                                        ),
                                        Column(
                                          children: <Widget>[
                                            Text(
                                              '이번달',
                                              style: TextStyle(
                                                fontSize: 8,
                                                color: HexColor('#D3D3D3'),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                                '${(totalCCT/3600).toInt().toString()}시간',
                                                style: TextStyle(
                                                    fontFamily: 'Cafe24',
                                                    fontSize: 13,
                                                    color: HexColor('#FFFFFF')
                                                )
                                            ),
                                          ],
                                        ),
              ],
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 25,
                                ),
                                Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.lightbulb,
                                      size: 45,
                                      color: HexColor('#FFFFFF'),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Column(
                                          children: <Widget>[
                                            Text(
                                              '지난달',
                                              style: TextStyle(
                                                fontSize: 8,
                                                color: HexColor('#D3D3D3'),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                                '${last_totalCC.toString()}시간',
                                                style: TextStyle(
                                                    fontFamily: 'Cafe24',
                                                    fontSize: 13,
                                                    color: HexColor('#FFFFFF')
                                                )
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          width: 15,
                                        ),
                                        Column(
                                          children: <Widget>[
                                            Text(
                                              '이번달',
                                              style: TextStyle(
                                                fontSize: 8,
                                                color: HexColor('#D3D3D3'),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                                '${totalCC.toString()}시간',
                                                style: TextStyle(
                                                    fontFamily: 'Cafe24',
                                                    fontSize: 13,
                                                    color: HexColor('#FFFFFF')
                                                )
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
          ],
                        ),
                  ],
                ),
            ),
          )
        ),
        SizedBox(
          height: 15,
        ),
        AspectRatio(
      aspectRatio: 1.9,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(18)),
          gradient: LinearGradient(
            colors: [
              HexColor('#212B55'),
              HexColor('#212B55'),
            ],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        ),
        child: Stack(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SizedBox(
                  height: 12,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                  '  집중시간',
                  style: TextStyle(
                    color: HexColor('#FFFFFF'),
                    fontSize: 20,
                    fontFamily: 'Cafe24',
                    letterSpacing: 2,
                  ),
                  textAlign: TextAlign.left,
                ),
                  SizedBox(
                    width: 150,
                  ),
                  Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Container(
                            height: 2,
                            width: 15,
                            color: Color(0xFFAA4CFC),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                              '저번',
                            style: TextStyle(
                              color: HexColor('#FFFFFF'),
                              fontSize: 6,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Container(
                            height: 2,
                            width: 15,
                            color: Color(0xFF4AF699)
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            '이번',
                            style: TextStyle(
                              color: HexColor('#FFFFFF'),
                              fontSize: 6,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  InkWell(
                    onTap: (){
                      setState(() {
                        selectedPeriodCCT = 1;
                        selectedTabWeeksCCT = 0;
                        selectedTabMonthsCCT = 1;
                      });
                  },
                    child: Container(
                      width: 30,
                      height: 15,
                      decoration: BoxDecoration(
                        color: _TabColor[selectedTabWeeksCCT],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          width: 1,
                          color: HexColor('#FFFFFF'),
                        ),
                      ),
                      child: Text(
                        '주',
                        style: TextStyle(
                          fontSize: 8,
                          color: HexColor('#FFFFFF'),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: (){
                      setState(() {
                        selectedPeriodCCT = 0;
                        selectedTabWeeksCCT = 1;
                        selectedTabMonthsCCT = 0;
                      });
                    },
                    child: Container(
                      width: 30,
                      height: 15,
                      decoration: BoxDecoration(
                        color: _TabColor[selectedTabMonthsCCT],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          width: 1,
                          color: HexColor('#FFFFFF'),
                        ),
                      ),
                      child: Text(
                          '달',
                        style: TextStyle(
                          fontSize: 8,
                          color: HexColor('#FFFFFF'),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
        ],
                ),
                SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16, left: 6),
                    child: _periodsCCT[selectedPeriodCCT],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ],
        ),
      ),
    ),
        SizedBox(
          height: 15,
        ),
        AspectRatio(
          aspectRatio: 1.9,
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(18)),
              gradient: LinearGradient(
                colors: [
                  HexColor('#212B55'),
                  HexColor('#212B55'),
                ],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
            child: Stack(
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    SizedBox(
                      height: 12,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          '  집중도',
                          style: TextStyle(
                            color: HexColor('#FFFFFF'),
                            fontSize: 20,
                            fontFamily: 'Cafe24',
                            letterSpacing: 2,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        SizedBox(
                          width: 170,
                        ),
                        Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Container(
                                  height: 2,
                                  width: 15,
                                  color: Color(0xFFAA4CFC),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  '저번',
                                  style: TextStyle(
                                    color: HexColor('#FFFFFF'),
                                    fontSize: 6,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Container(
                                    height: 2,
                                    width: 15,
                                    color: Color(0xFF4AF699)
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  '이번',
                                  style: TextStyle(
                                    color: HexColor('#FFFFFF'),
                                    fontSize: 6,
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        InkWell(
                          onTap: (){
                            setState(() {
                              selectedPeriodCC = 1;
                              selectedTabWeeksCC = 0;
                              selectedTabMonthsCC = 1;
                            });
                          },
                          child: Container(
                            width: 30,
                            height: 15,
                            decoration: BoxDecoration(
                              color: _TabColor[selectedTabWeeksCC],
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                width: 1,
                                color: HexColor('#FFFFFF'),
                              ),
                            ),
                            child: Text(
                              '주',
                              style: TextStyle(
                                fontSize: 8,
                                color: HexColor('#FFFFFF'),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: (){
                            setState(() {
                              selectedPeriodCC = 0;
                              selectedTabWeeksCC = 1;
                              selectedTabMonthsCC = 0;
                            });
                          },
                          child: Container(
                            width: 30,
                            height: 15,
                            decoration: BoxDecoration(
                              color: _TabColor[selectedTabMonthsCC],
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                width: 1,
                                color: HexColor('#FFFFFF'),
                              ),
                            ),
                            child: Text(
                             '달',
                              style: TextStyle(
                                fontSize: 8,
                                color: HexColor('#FFFFFF'),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 16, left: 6),
                        child: _periodsCC[selectedPeriodCC],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ]
    ),
    );
  }
}