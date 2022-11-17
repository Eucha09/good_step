import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'root_page.dart';

// 메인 함수에서 실행 시 바로 MyApp 클래스를 앱 환경에서 구동하여 반환
void main() => runApp(MyApp());

// MaterialApp 즉, 안드로이드 환경을 고려한 앱이며 홈 화면은 RootPage 클래스로 구현
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AnimatedSplashScreen(
        splash: Image.asset('assets/splash.png'),
        duration: 1000,
        nextScreen: RootPage(),
        splashIconSize: 150,
      ),
    );
  }
}