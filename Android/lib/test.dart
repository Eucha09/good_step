import 'package:flutter/material.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'concentration.dart';

class DatabaseTestApp extends StatefulWidget {
  final Future<Database> db;
  DatabaseTestApp(this.db);

  @override
  State<StatefulWidget> createState() => _DatabaseTestApp();
}

class _DatabaseTestApp extends State<DatabaseTestApp> {
  TextEditingController? dateController;
  TextEditingController? timeController;
  TextEditingController? cctTimeController;
  TextEditingController? cctScoreController;

  @override
  void initState() {
    //super.initState();
    dateController  = new TextEditingController();
    timeController  = new TextEditingController();
    cctTimeController = new TextEditingController();
    cctScoreController = new TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('집중도 데이터 생성'),
      ),
      body: Container(
          child: Center(
              child: Column(
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.all(10),
                      child: TextField(
                        controller: dateController,
                        decoration: InputDecoration(labelText: '날짜 yyyy-mm-dd'),
                      )
                  ),
                  Padding(
                      padding: EdgeInsets.all(10),
                      child: TextField(
                        controller: timeController,
                        decoration: InputDecoration(labelText: '시간 hh:mm'),
                      )
                  ),
                  Padding(
                      padding: EdgeInsets.all(10),
                      child: TextField(
                        controller: cctTimeController,
                        decoration: InputDecoration(labelText: '집중 시간'),
                      )
                  ),
                  Padding(
                      padding: EdgeInsets.all(10),
                      child: TextField(
                        controller: cctScoreController,
                        decoration: InputDecoration(labelText: '집중도'),
                      )
                  ),
                  ElevatedButton(
                    onPressed: () {
                      var now = new DateTime.now();
                      String date;
                      String time;
                      if (dateController!.value.text.isNotEmpty)
                        date = dateController!.value.text;
                      else
                        date = DateFormat('yyyy-MM-dd').format(now);
                      print("debug: ${dateController!.value.text} ${DateFormat('yyyy-MM-dd').format(now)}");
                      if (timeController!.value.text.isNotEmpty)
                        time = timeController!.value.text;
                      else
                        time = DateFormat('HH:mm').format(now);
                      Concentration data = Concentration(
                          date: date,
                          time: time,
                          cctTime: int.parse(cctTimeController!.value.text),
                          cctScore: int.parse(cctScoreController!.value.text)
                      );
                      //Navigator.of(context).pop(todo);
                      _insertData(data);
                    },
                    child: Text('생성하기'),
                  ),
                ],
              )
          )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed('/chart');
        },
        child: Icon(Icons.bar_chart),
      ),
    );
  }

  void _insertData(Concentration data) async {
    final Database database = await widget.db;
    await database.insert('concentration', data.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }
}