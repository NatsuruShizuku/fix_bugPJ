// import 'package:flutter/material.dart';
// import 'package:flutter_application_0/managers/audio_manager.dart';
// import 'package:flutter_application_0/models/word.dart';
// import 'package:shared_preferences/shared_preferences.dart';


// class GameManager extends ChangeNotifier {
//   Map<int, Word> tappedWords = {};
//   bool canFlip = false,
//       reverseFlip = false,
//       ignoreTaps = false,
//       roundCompleted = false;
//   List<int> answeredWords = [];
//  final int totalTiles;

//   GameManager({required this.totalTiles});

//   tileTapped({required int index, required Word word}) {
//     ignoreTaps = true;
//     if (tappedWords.length <= 1) {
//       tappedWords.addEntries([MapEntry(index, word)]);
//       canFlip = true;
//     } else {
//       canFlip = false;
//     }

//     notifyListeners();
//   }

// Future<void> _updatePersistentMatchedPairs(int delta) async {
//   final prefs = await SharedPreferences.getInstance();
//   int currentTotal = prefs.getInt('persistentMatchedPairs') ?? 0;
//   await prefs.setInt('persistentMatchedPairs', currentTotal + delta);
// }

//   onAnimationCompleted({required bool isForward}) async {
//     if (tappedWords.length == 2) {
//       if (isForward) {
//         if (tappedWords.entries.elementAt(0).value.matraID == 
//               tappedWords.entries.elementAt(1).value.matraID) {
//           answeredWords.addAll(tappedWords.keys);
//           if (answeredWords.length == 6) {
//             await AudioManager.playAudio('Round');
//             roundCompleted = true;
//           } else {
//             await AudioManager.playAudio('Correct');
//           }
//           tappedWords.clear();
//           canFlip = true;
//           ignoreTaps = false;
//         } else {
//           await AudioManager.playAudio('Incorrect');
//           reverseFlip = true;
//         }
//       } else {
//         reverseFlip = false;
//         tappedWords.clear();
//         ignoreTaps = false;
//       }
//     } else {
//       canFlip = false;
//       ignoreTaps = false;
//     }

//     notifyListeners();
//   }
// }


import 'package:flutter/material.dart';
import 'package:flutter_application_0/managers/audio_manager.dart';
import 'package:flutter_application_0/models/word.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GameManager extends ChangeNotifier {
  Map<int, Word> tappedWords = {};
  bool isPaused = false;
  bool canFlip = false,
      reverseFlip = false,
      ignoreTaps = false,
      roundCompleted = false;
  List<int> answeredWords = [];
  // bool hasImage;
  final int totalTiles;
  int moves = 0;
  
  // ตัวแปรนับจำนวนคู่ที่จับได้ในรอบเกมปัจจุบัน
  int successfulMatches = 0;

  // GameManager({required this.hasImage, required this.totalTiles});
    GameManager({required this.totalTiles});

  // เมื่อมีการแตะที่ tile ให้เพิ่ม moves และเก็บข้อมูล tile ที่ถูกแตะ
  tileTapped({required int index, required Word word}) {
    moves++;
    ignoreTaps = true;
    if (tappedWords.length <= 1) {
      tappedWords.addEntries([MapEntry(index, word)]);
      canFlip = true;
    } else {
      canFlip = false;
    }
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // เมธอดนี้จะถูกเรียกเมื่อ animation พลิกการ์ดเสร็จสิ้น
  onAnimationCompleted({required bool isForward}) async {
    if (tappedWords.length == 2) {
      if (isForward) {
        bool isMatch = tappedWords.entries.elementAt(0).value.matraID ==
            tappedWords.entries.elementAt(1).value.matraID;

        if (isMatch) {
          answeredWords.addAll(tappedWords.keys);
          // เพิ่มจำนวนคู่ที่จับได้ในรอบนี้
          successfulMatches++;
          // อัปเดตข้อมูลคู่ที่จับได้แบบถาวรใน SharedPreferences
          await _updatePersistentMatchedPairs(1);

          if (answeredWords.length == totalTiles) {
            await AudioManager.playAudio('Round');
            roundCompleted = true;
          } else {
            await AudioManager.playAudio('Correct');
          }
          tappedWords.clear(); // เคลียร์ข้อมูลเมื่อจับคู่ถูกต้อง
          canFlip = true;
          ignoreTaps = false;
        } else {
          await AudioManager.playAudio('Incorrect');
          reverseFlip = true; // ตั้งค่า reverseFlip เพื่อพลิกกลับเมื่อจับคู่ไม่ถูกต้อง
        }
      } else {
        reverseFlip = false;
        tappedWords.clear(); // เคลียร์ข้อมูลหลังพลิกกลับ
        canFlip = true;
        ignoreTaps = false;
      }
    } else {
      canFlip = false;
      ignoreTaps = false;
    }
    notifyListeners();
  }
  
  // เมธอดสำหรับรีเซ็ตสถานะของเกมใหม่ (จะรีเซ็ต moves, successfulMatches และข้อมูลอื่นๆ)
  void resetGame() {
    moves = 0;
    tappedWords.clear();
    answeredWords.clear();
    roundCompleted = false;
    successfulMatches = 0;
    canFlip = false;
    reverseFlip = false;
    ignoreTaps = false;
    isPaused = false;
    notifyListeners();
  }
  
  // อัปเดตจำนวนคู่ที่จับได้แบบถาวรใน SharedPreferences
  Future<void> _updatePersistentMatchedPairs(int delta) async {
    final prefs = await SharedPreferences.getInstance();
    int currentTotal = prefs.getInt('persistentMatchedPairs') ?? 0;
    currentTotal += delta;
    await prefs.setInt('persistentMatchedPairs', currentTotal);
  }
}