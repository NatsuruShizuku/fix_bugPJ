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
import 'dart:typed_data';

class Word {
  final int? id;
  final String descrip;
  final List<int> contents;
  final int matraID;

  Word({
    this.id,
    required this.descrip,
    required this.contents,
    required this.matraID,
  });

  factory Word.fromMap(Map<String, dynamic> map) {
    return Word(
      id: map['id'],
      descrip: map['descrip'],
      contents: map['contents'] is List<int> ? map['contents'] : List<int>.from(map['contents']),
      matraID: map['matraID'],
    );
  }
}