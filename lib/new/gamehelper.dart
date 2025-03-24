import 'package:flutter_application_0/database/database_helper_matchcard.dart';
import 'package:flutter_application_0/models/word.dart';

class GameHelper {
  static Future<List<Word>> generateGamePairs(int rows, int cols) async {
    final totalPairs = (rows * cols) ~/ 2;
    final allWords = await DatabaseHelper.getMatchedPairs();
    
    // จัดกลุ่มคำตาม matraID
    final matraGroups = <int, List<Word>>{};
    for (final word in allWords) {
      matraGroups.update(
        word.matraID,
        (list) => list..add(word),
        ifAbsent: () => [word],
      );
    }

    // กรองกลุ่มที่มีอย่างน้อย 2 ภาพ
    final validGroups = matraGroups.values.where((g) => g.length >= 2).toList();
    
    if (validGroups.length < totalPairs) {
      throw Exception('ไม่มีภาพเพียงพอสำหรับสร้างเกม');
    }

    // สุ่มเลือกกลุ่มและภาพ
    validGroups.shuffle();
    final selectedPairs = validGroups.sublist(0, totalPairs);
    
    final gameWords = <Word>[];
    for (final group in selectedPairs) {
      group.shuffle();
      gameWords.addAll(group.take(2)); // เลือก 2 ภาพจากกลุ่ม
    }

    gameWords.shuffle(); // สับลำดับภาพก่อนแสดง
    return gameWords;
  }
  
}
