// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_application_0/database/database_helper_matchcard.dart';
// import 'package:flutter_application_0/managers/game_manager.dart';
// import 'package:flutter_application_0/models/word.dart';
// import 'package:flutter_application_0/page/error_page.dart';
// import 'package:flutter_application_0/page/game_page.dart';
// import 'package:flutter_application_0/page/loading_page.dart';
// import 'package:flutter_application_0/theme/app_theme.dart';

// import 'package:provider/provider.dart';



// List<Word> sourceWords = [];

// Future main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   SystemChrome.setPreferredOrientations(
//       [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);

//   runApp(
//     MaterialApp(
//       home: FutureBuilder(
//         future: DatabaseHelper.instance.queryAllWords(),
//         builder: (context, snapshot) {
//           if (snapshot.hasError) return ErrorPage();
//           if (snapshot.hasData) {
//             sourceWords = snapshot.data!.map((map) => Word.fromMap(map)).toList();
//             return ChangeNotifierProvider(
//               create: (_) => GameManager(totalTiles: 2 * 3),
//               child: GamePage(rows: 2, columns: 3), // กำหนด rows และ columns ตามต้องการ
//             );
//           }
//           return LoadingPage();
//         },
//       ),
//     ),
//   );
// }

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Memory Game',
//       theme: appTheme,
//       home: Material(
//           child: ChangeNotifierProvider(
//               create: (_) => GameManager(totalTiles: 2 * 3), child: const GamePage(rows: 2, columns: 3,))),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_application_0/models/word.dart';
import 'package:flutter_application_0/new/gameboard.dart';
import 'package:flutter_application_0/new/gamehelper.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'เกมจับคู่ภาพ',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const MainMenu(),
    );
  }
}

class MainMenu extends StatefulWidget {
  const MainMenu({super.key});

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('เลือกขนาดบอร์ด'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          children: [
            _buildSizeButton('2x2', 2, 2),
            _buildSizeButton('2x3', 2, 3),
            _buildSizeButton('2x4', 2, 4),
            _buildSizeButton('3x4', 3, 4),
            _buildSizeButton('4x4', 4, 4),
          ],
        ),
      ),
    );
  }

  Widget _buildSizeButton(String label, int rows, int cols) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onPressed: () async {
        try {
          final words = await GameHelper.generateGamePairs(rows, cols);
          if (!mounted) return;
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => GameBoard(
                rows: rows,
                cols: cols,
                words: words,
              ),
            ),
          );
        } catch (e) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(e.toString()),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Text(
        label,
        style: const TextStyle(fontSize: 20),
      ),
    );
  }
}