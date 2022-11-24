import 'package:flutter/cupertino.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'root_page.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/services.dart';

// 메인 함수에서 실행 시 바로 MyApp 클래스를 앱 환경에서 구동하여 반환
void main() => runApp(MyApp());

// MaterialApp 즉, 안드로이드 환경을 고려한 앱이며 홈 화면은 RootPage 클래스로 구현
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    Future<Database> database = initDatabase();
    return CupertinoApp(
      debugShowCheckedModeBanner: false,
      home: AnimatedSplashScreen(
        splash: Image.asset('assets/splash.png'),
        duration: 1000,
        nextScreen: RootPage(database),
        splashIconSize: 150,
      ),
    );
  }

  Future<Database> initDatabase() async {
    return openDatabase(
      join(await getDatabasesPath(), 'goodstep_database.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE concentration(id INTEGER PRIMARY KEY AUTOINCREMENT, "
          "date TEXT, time TEXT, cctTime INTEGER, cctScore INTEGER)",
        );
      },
      version: 1,
    );
  }
}
