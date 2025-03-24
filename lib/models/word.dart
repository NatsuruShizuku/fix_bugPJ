// class Word {
//   final int? id;
//   final String descrip;
//   final List<int> contents;
//   final int matraID;

//   Word({
//     this.id,
//     required this.descrip,
//     required this.contents,
//     required this.matraID,
//   });

//   factory Word.fromMap(Map<String, dynamic> map) {
//     return Word(
//       id: map['id'],
//       descrip: map['descrip'],
//       contents: map['contents'] is List<int> ? map['contents'] : List<int>.from(map['contents']),
//       matraID: map['matraID'],
//     );
//   }
// }
import 'dart:typed_data'; // ต้องมี import นี้

class Word {
  final int id;
  final String descrip;
  final Uint8List contents; // เปลี่ยนชนิดข้อมูลเป็น Uint8List
  final int matraID;

  Word({
    required this.id,
    required this.descrip,
    required this.contents,
    required this.matraID,
  });

  factory Word.fromMap(Map<String, dynamic> map) {
    return Word(
      id: map['id'],
      descrip: map['descrip'],
      contents: map['contents'] is Uint8List 
          ? map['contents'] 
          : Uint8List.fromList(List<int>.from(map['contents'])), // แปลงให้ถูกต้อง
      matraID: map['matraID'],
    );
  }
}