import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_0/database/database_helper_matchcard.dart';
import 'package:flutter_application_0/managers/game_manager.dart';
import 'package:flutter_application_0/models/word.dart';
import 'package:flutter_application_0/page/error_page.dart';
import 'package:flutter_application_0/page/game_page.dart';
import 'package:flutter_application_0/page/loading_page.dart';
import 'package:flutter_application_0/theme/app_theme.dart';

import 'package:provider/provider.dart';



List<Word> sourceWords = [];

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);

  runApp(
    MaterialApp(
      home: FutureBuilder(
        future: DatabaseHelper.instance.queryAllWords(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return ErrorPage();
          if (snapshot.hasData) {
            sourceWords = snapshot.data!.map((map) => Word.fromMap(map)).toList();
            return ChangeNotifierProvider(
              create: (_) => GameManager(totalTiles: 2 * 3),
              child: GamePage(rows: 2, columns: 3), // กำหนด rows และ columns ตามต้องการ
            );
          }
          return LoadingPage();
        },
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Memory Game',
      theme: appTheme,
      home: Material(
          child: ChangeNotifierProvider(
              create: (_) => GameManager(totalTiles: 2 * 3), child: const GamePage(rows: 2, columns: 3,))),
    );
  }
}
