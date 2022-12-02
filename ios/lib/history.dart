import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'concentration.dart';
import 'home_page.dart';
import 'package:sqflite/sqflite.dart';
import 'utils.dart';

class HistoryPage extends StatefulWidget {
  final Future<Database> db;
  HistoryPage(this.db);

  @override
  State<StatefulWidget> createState() => _HistoryPage();
}

class _HistoryPage extends State<HistoryPage> {
  Future<List<Concentration>>? list;

  Future<List<Concentration>> getAllData() async {
    final Database database = await widget.db;
    final List<Map<String, dynamic>> maps = await database.query(
        'concentration');

    return List.generate(maps.length, (i) {
      return Concentration(
          date: maps[i]['date'].toString(),
          time: maps[i]['time'].toString(),
          cctTime: maps[i]['cctTime'],
          cctScore: maps[i]['cctScore'],
          id: maps[i]['id']
      );
    });
  }

  @override
  void initState() {
    super.initState();
    list = getAllData();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constrains) {
        Size _size = MediaQuery
            .of(context)
            .size;
        return CupertinoPageScaffold(
          backgroundColor: HexColor("#161A24"),
          navigationBar: CupertinoNavigationBar(
            backgroundColor: HexColor('#161A24'),
            middle: Container(
              /*decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors, Colors.grey],
                        begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),*/
                child: Column(
                    children: <Widget>[
                      Container(
                        child: Text('',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery
                            .of(context)
                            .size
                            .width,
                        child: Row(
                          children: <Widget>[
                            Container(
                              width: MediaQuery
                                  .of(context)
                                  .size
                                  .width * 0.3,
                              child: Center(child: Text('날짜', style: TextStyle(color: HexColor('#FFFFFF'))),),
                            ),
                            Container(
                              width: MediaQuery
                                  .of(context)
                                  .size
                                  .width * 0.3,
                              child: Center(child: Text('집중시간', style: TextStyle(color: HexColor('#FFFFFF'))),),
                            ),
                            Container(
                              width: MediaQuery
                                  .of(context)
                                  .size
                                  .width * 0.3,
                              child: Center(child: Text('집중도', style: TextStyle(color: HexColor('#FFFFFF'))),),
                            ),
                          ],
                        ),
                      ),
                    ]
                )
            ),
            // pinned: true,
          ),
          child: Container(
              child: FutureBuilder(
                builder: cctListBuilder,
                future: list,
              )
          ),
        );
      },
    );
  }

  String toGrade(int value) {
    if (92 <= value) {
      return 'A+';
    } else if (86 <= value) {
      return 'A';
    } else if (80 <= value) {
      return 'A-';
    } else if (74 <= value) {
      return 'B+';
    } else if (68 <= value) {
      return 'B';
    } else if (62 <= value) {
      return 'B-';
    } else if (56 <= value) {
      return 'C+';
    } else if (46 <= value) {
      return 'C';
    } else if (36 <= value) {
      return 'D+';
    } else if (26 <= value) {
      return 'D';
    } else if (0 < value) {
      return 'F';
    } else {
      return '-';
    }
  }

  Widget cctListBuilder(BuildContext context,
      AsyncSnapshot<List<Concentration>> snapshot) {
    switch (snapshot.connectionState) {
      case ConnectionState.none:
        return CircularProgressIndicator();
      case ConnectionState.waiting:
        return CircularProgressIndicator();
      case ConnectionState.active:
        return CircularProgressIndicator();
      case ConnectionState.done:
        if (snapshot.hasData) {
          return ListView.builder(
            itemBuilder: (context, index) {
              Concentration data = (snapshot.data as List<
                  Concentration>)[index];
              return Card(
                  color: HexColor('#D9DDDC'),
                  //Colors.teal[100 * (index % 9)],
                  child: Container(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        children: <Widget>[
                          Container(
                              width: MediaQuery.of(context).size.width * 0.3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Text('${data.date}'),
                                  Text('${data.time}'),
                                ],
                              )
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.3,
                            child: Center(child: Text('${printDuration_timer(Duration(seconds: (data.cctTime!).toInt()))}')),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.3,
                            child: Center(child: Text('${toGrade((data.cctScore!/data.cctTime!).toInt())} (${(data.cctScore!/data.cctTime!).toInt()})')),
                          ),
                        ],
                      )
                  )
              );
            },
            itemCount: (snapshot.data as List<Concentration>).length,
          );
        }
        else {
          return Text('No data');
        }
    }
  }
}