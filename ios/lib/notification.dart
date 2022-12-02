import 'utils.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final notifications = FlutterLocalNotificationsPlugin();


//1. 앱로드시 실행할 기본설정
initNotification() async {

  //안드로이드용 아이콘파일 이름
  var androidSetting = AndroidInitializationSettings('app_icon');

  //ios에서 앱 로드시 유저에게 권한요청
  var iosSetting = DarwinInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestSoundPermission: true,
  );

  var initializationSettings = InitializationSettings(
      android: androidSetting,
      iOS: iosSetting,
  );
  await notifications.initialize(
    initializationSettings,
    //알림 누를때 함수실행하고 싶으면
    //onSelectNotification: 함수명추가
  );
}

showNotification() async {

  var androidDetails = AndroidNotificationDetails(
    // 알림채널 id, 알림종류
    '44',
    '집중화면 탈출 시 경고 알림',
    priority: Priority.high,
    importance: Importance.max,
    color: HexColor('#FFFFFF'),
  );

  var iosDetails = DarwinNotificationDetails(
    presentAlert: true,
    presentBadge: true,
    presentSound: true,
  );

  // 알림 id, 제목, 내용 맘대로 채우기
  notifications.show(
      1,
      // 제목, 내용
      '굿스텝',
     '집중화면으로 돌아와주시기를 바랍니다',
      NotificationDetails(android: androidDetails, iOS: iosDetails),
      // 부가정보
      payload:'부가정보'
  );
}

showNotification_res(int CctTime, int CctScore) async {
  CctScore = (CctScore / CctTime).toInt();
  CctTime = (CctTime / 60).toInt();
  String CctScoreGrade = '';

  if (92 <= CctScore) {
    CctScoreGrade = 'A+';
  } else if (86 <= CctScore) {
    CctScoreGrade = 'A';
  } else if (80 <= CctScore) {
    CctScoreGrade = 'A-';
  } else if (74 <= CctScore) {
    CctScoreGrade = 'B+';
  } else if (68 <= CctScore) {
    CctScoreGrade = 'B';
  } else if (62 <= CctScore) {
    CctScoreGrade = 'B-';
  } else if (56 <= CctScore) {
    CctScoreGrade = 'C+';
  } else if (46 <= CctScore) {
    CctScoreGrade = 'C';
  } else if (36 <= CctScore) {
    CctScoreGrade = 'D+';
  } else if (26 <= CctScore) {
    CctScoreGrade = 'D';
  } else {
    CctScoreGrade = 'F';
  }

  var androidDetails = AndroidNotificationDetails(
    // 알림채널 id, 알림종류
    '53',
    '집중화면 끝날 시 알림',
    priority: Priority.high,
    importance: Importance.max,
    color: HexColor('#FFFFFF'),
  );

  var iosDetails = DarwinNotificationDetails(
    presentAlert: true,
    presentBadge: true,
    presentSound: true,
  );

  // 알림 id, 제목, 내용 맘대로 채우기
  notifications.show(
      1,
      // 제목, 내용
      '굿스텝',
      '집중시간이 완료되었습니다.\n집중시간 : ${CctTime}분, 집중도: ${CctScoreGrade}(${CctScore})',
      NotificationDetails(android: androidDetails, iOS: iosDetails),
      // 부가정보
      payload:'부가정보'
  );
}