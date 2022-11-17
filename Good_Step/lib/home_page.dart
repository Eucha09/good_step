import 'package:flutter/material.dart';
import 'utils.dart';
import 'dart:async';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

// 실제로 앱 실행 시 전면부에 나올 홈페이지 및 집중시간 적용 시 이어지는 DarkPage 화면을 위한 다트 파일
// printDuration : 디지털 시계화면 출력 용도
String printDuration(Duration duration) {
  String twoDigits(int n) {
    if (n >= 10) return "$n";
    return "0$n";
  }

  //String twoDigitHours = twoDigits(duration.inHours); -> 절대 지우지 말 것
  String twoDigitMinutes = twoDigits(duration.inMinutes);
  String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
  return "$twoDigitMinutes:$twoDigitSeconds";
}

// 홈페이지 적용을 위한 위젯
class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  /* myValue : 원형 슬라이드로 적용한 시간을 저장하기 위한 용도. DarkPage에 시간을 전달하기 위한 변수이기도 함
     loLoo : 정수로 된 시간 변수 내용물을 문자열로 저장하기 위한 용도
     List<Color> pageColors = 홈페이지의 전체 화면 색상 정하는 용도
  */
  double myValue = 0;
  String? loLoo;
  final List<Color> pageColors = [HexColor('#24202E'), HexColor('#24202E')];

  @override
  void initState() {
    super.initState();
    myValue = 0;
    loLoo = "00:00";
  }

  //FlutterDialog는 우상단 소개 페이지 보여주는 버튼 && 소개 페이지
  void FlutterDialog() {
    showDialog(
        context: context,
        //barrierDismissible - Dialog를 제외한 다른 화면 터치 x
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            // RoundedRectangleBorder - Dialog 화면 모서리 둥글게 조절
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            //Dialog Main Title
            title: Column(
              children: <Widget>[
                new Text("We r.."),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "구구절절 구구절절 구구절절 구구절절\n구구절절 구구절절 구구절절 구구절절\n"
                      "구구절절 구구절절 구구절절 구구절절\n구구절절 구구절절 구구절절 구구절절\n"
                      "we R 대신 예쁘게 다시 그린 로고를 넣을 예정.\n"
                      "소개글 하단부에 인스타, 페이스북, 트위터 로고 && 링크 넣을 예정\n"
                      "구구절절 구구절절 구구절절 구구절절\n구구절절 구구절절 구구절절 구구절절\n"
                      "구구절절 구구절절 구구절절 구구절절\n구구절절 구구절절 구구절절 구구절절\n",
                ),
              ],
            ),
          );
        });
  }

  // 원형 슬라이더, 슬라이더 내부 버튼, 하단부 상징물을 화면에 띄우는 위젯
  @override
  Widget build(BuildContext context) {
    /* slider : 원형 슬라이더의 다양한 설정을 적용하기 위한 변수.
       SleekCircularSlider : 원형 슬라이더 정의
    */
    final slider = SleekCircularSlider(
      // appearance : 슬라이더 세부 설정 적용
        appearance: CircularSliderAppearance(
          // customWidths : 슬라이더가 돌아가는 구간(track), 슬라이더(progressBar), 궤적에 보이는 그림자(shadow) 크기 적용
          customWidths: CustomSliderWidths(
              trackWidth: 15,
              progressBarWidth: 8,
              shadowWidth: 15
          ),
          // curstomColors : 슬라이더 색깔을 정한다
          customColors: CustomSliderColors(
              dotColor: HexColor('#FFFFFF'),
              trackColor: HexColor('#000000'),
              progressBarColors: [HexColor('#1AB584'), HexColor('#797EF6')],
              shadowColor: HexColor('#000000'),
              shadowMaxOpacity: 0.05
          ),
          // startAngle : 슬라이더 시작 위치, angleRange: 슬라이더가 얼마나 돌아갈지, size : 슬라이더 크기
          startAngle: 270,
          angleRange: 360,
          size: 225.0,
        ),
        /* 슬라이더 원주 길이
           min : 원주가 최초로 시작하는 지점 크기, max : 원주를 돌아 끝에 달했을 때 크기, initialValue : 원주 시작점
         */
        min: 0,
        max: 7500,
        initialValue: 0,
        /* innerWidget : 슬라이더 내부에 뭐를 넣을지 결정. 여기서는 슬라이더 내부에 들어간 버튼을 의미
           double value : 슬라이더를 돌려서 멈춘 지점의 값
         */
        innerWidget: (double value) {
          // Center : 정중앙에 위젯 설치, SizedBox : 위젯 크기 설정, FittedBox : 위젯을 설정한 크기에 딱 맞춘다
          return Center(
              child : SizedBox(
                width: 200,
                height: 200,
                child: FittedBox(
                  child: FloatingActionButton(
                    backgroundColor: HexColor("#222331"),
                    onPressed: () {
                      // 버튼을 누르면 building context로 위젯 띄우고 그 위젯에 myValue 값 전달
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => DarkPage(myValue)),
                      );
                    },
                    // 버튼에 들어가는 상징물
                    child: Icon(Icons.nights_stay, size: 40, color: HexColor("#FFFDD0")),
                  )
                )
              )
          );
        },
        // value 값이 바뀔 때마다 바뀐 value 값을 myValue에 저장하고 디지털 시계 출력용으로 만든 문자열을 loLoo에 저장
        onChange: (double value) {
          print(value);
          setState(() {
            myValue = (value - value%300);
            loLoo = printDuration(Duration(seconds: myValue.toInt()));
          });
        }
    );
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight: 50,
        // title: Text(
        //   'Thanks, Your \'GoodStep\'',
        //   style: TextStyle(
        //     fontWeight: FontWeight.bold,
        //     fontSize: 25,
        //     color: Colors.lightGreenAccent,
        //   ),),
        actions: <Widget>[
          TextButton.icon(
            onPressed: () => FlutterDialog(),
            icon: Icon(
              Icons.add,
              size: 0.0,
              color: Colors.green,
            ),
            label: Text('we R..',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.green,
              ),
            ),
          )
        ],
        backgroundColor: HexColor("#24202E"),
      ),
      body: Container(
        // decoration : Container로 둘러싼 화면을 어떻게 꾸밀지 정하는 분야
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: pageColors,
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                tileMode: TileMode.clamp
            )),
        // 원형 슬라이더, 디지털 시계, 하단부 상징물을 세로로 배열에서 화면에 띄운다
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // 열심히 만들어 놓은 원형 슬라이더 설정을 저장해 놓은 slider 변수를 불러서 화면에 띄운다
            Center(
                child: slider
            ),
            // 원형 슬라이더와 일정 거리를 두고 디지털 시계용으로 만들어 놓은 문자열 loLoo를 출력
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
            // 하단부에 배치하기로 한 상징물 2개를 가로로 배열
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Icon(Icons.timer, size: 35, color: HexColor("#FFFFFF")),
                    Text(
                        '집중시간',
                        style: TextStyle(
                          fontSize: 13,
                          color: HexColor("#FFFFFF"),
                        ),
                    ),
                    Text(
                      '0.0',
                      style: TextStyle(
                        fontSize: 12,
                        color: HexColor("#FFFFFF"),
                      ),
                    )
                  ]
                ),
                Column(
                  children: <Widget>[
                    Icon(Icons.lightbulb, size: 35, color: HexColor("#FFFFFF")),
                    Text(
                      '집중도',
                      style: TextStyle(
                        fontSize: 13,
                        color: HexColor("#FFFFFF"),
                      )
                    ),
                    Text(
                      '0.0',
                      style: TextStyle(
                        fontSize: 12,
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

// 원형 슬라이더 내부 버튼을 누르고 튀어 나올 검은 화면을 정의할 클래스
class DarkPage extends StatefulWidget {
  // HomePageState에서 DarkPage로 넘겨준 myValue를 불러온다
  final double myValue;
  const DarkPage(this.myValue);

  @override
  DarkPageState createState() => DarkPageState();
}

class DarkPageState extends State<DarkPage> {
  /* _timer : 실제 시간과 같은 흐름을 적용하기 위한 객체
     loLoo : 디지털 시계 출력용 문자열
     trigger : 위 _timer를 적용하기 위한 스위치
     countTime : 시간이 지나가는 걸 세어줄 변수
     total : myValue 값을 저장하기 위한 변수
  */
  Timer? _timer;
  String? loLoo;
  bool trigger = true;
  double countTime = 0;
  double total = 0;

  @override
  void dispose() {
    // 본 클래스가 앱 상태에서 벗어날 시, timer도 종료
    _timer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    /* 본 클래스가 상태로 올라갈 때, total에 myValue 값을 적용,
       loLoo는 myValue를 디지털 시계로 변환한 값 저장, countTime은 시간을 세어주기 위해 0으로 초기화 */
    super.initState();
    total = widget.myValue;
    countTime = 0;
    loLoo = printDuration(Duration(seconds: total.toInt()));
  }

  // _start : timer 실행, 디지털 시계 출력, 사전에 설정한 집중시간을 넘겼을 시(countTime < total) 화면 빠져나오기를 적용하는 함수
  void _start() {
    const oneSec = const Duration(seconds: 1);

    var callback = (timer) => {
      setState(() {
        if (countTime < total) {
          countTime++;
          loLoo = printDuration(Duration(seconds: (total - countTime).toInt()));
        } else {
          Navigator.pop(context);
        }
      })
    };

    _timer = Timer.periodic(oneSec, callback);
  }

  @override
  Widget build(BuildContext context) {
    // _start() 함수를 한 번 실행하고 난 뒤, 추가 실행하지 않는다. 안 그러면 위젯 내부에서 여러번 _start가 중복됨
    if (trigger) {
        _start();
        trigger = false;
      }
    return Scaffold(
      // 화면 전체에 터치 이벤트를 넣기 위해 body 부분을 GestureDetector로 감싼다
      backgroundColor: HexColor("#000000"),
      body: GestureDetector(
        // behavior : 터치 이벤트가 적용되는 부분을 사전에 설정된 범위가 아닌 화면 전 범위로 설정
        behavior: HitTestBehavior.translucent,
        onTap: () {
          // tab하고 팝업창을 띄우기 위한 설정
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return Center(
                  child: Container(
                    // 팝업창 크기 적용
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: MediaQuery.of(context).size.height * 0.25,
                    // 팝업창 모양, 들어갈 문장 등 적용
                    child: AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15.0))
                  ),
                  contentPadding: EdgeInsets.only(top: 0),
                  content: Center(
                      child: Text(
                          '포기하시겠습니까?',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                        )
                      )),
                  // 팝업창에서 실제 이벤트가 벌어지는 부분
                  actions: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: HexColor('#64B5F6'),
                          foregroundColor: HexColor('#FFFFFF'),
                        ),
                        child: Text('예'),
                        onPressed: () {
                          // 예를 누르면 팝업창 빠져나오고 동시에 countTime = total이 되면서 검은 화면도 탈출
                          countTime = total;
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: HexColor('#64B5F6'),
                          foregroundColor: HexColor('#FFFFFF'),
                        ),
                          child: Text('아니오'),
                          onPressed: () {
                          // 아니오를 누르면 팝업창만 탈출
                            Navigator.of(context).pop();
                          },
                        )
                      ],
                    ),
                  ],
                ),
                  ),
                );
              }
          );
        },
          // 터치 이벤트가 없을 시, 아래 내용이 기본적으로 화면에 출력됨
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Center(
              // 디지털 시계를 출력하는 부분
              child: Text('$loLoo',
                style: TextStyle(
                  color: HexColor("#FFFFFF"),
                  fontSize: 70.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ]
        )
      ),
    );
  }
}

