// import 'dart:typed_data';

// import 'package:flutter/material.dart';
// import 'package:flutter_application_0/animation/flip_animation.dart';
// import 'package:flutter_application_0/animation/matched_animation.dart';
// import 'package:flutter_application_0/animation/spin_animation.dart';
// import 'package:flutter_application_0/managers/game_manager.dart';
// import 'package:flutter_application_0/models/word.dart';
// import 'package:provider/provider.dart';

// class WordTile extends StatefulWidget {
//   const WordTile({
//     required this.index,
//     required this.word,
//     // required this.hasImage,
//     required this.isMatched,
//     Key? key,
//   }) : super(key: key);

//   final int index;
//   final Word word;
//   // final bool hasImage;
//   final bool isMatched;

//   @override
//   State<WordTile> createState() => _WordTileState();
// }

// class _WordTileState extends State<WordTile> {
//   bool _isCardFlipped = false;

//   @override
//   Widget build(BuildContext context) {
//     return SpinAnimation(
//       key: ValueKey<int>(widget.index),
//       child: Consumer<GameManager>(
//         builder: (_, notifier, __) {
//           if (widget.isMatched) {
//             return Container(
//               decoration: BoxDecoration(
//                 color: Colors.green.withOpacity(0.5),
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: const Center(
//                 child: Icon(
//                   Icons.check,
//                   size: 40,
//                   color: Colors.white,
//                 ),
//               ),
//             );
//           }

//           bool animate = checkAnimationRun(notifier);

//           return GestureDetector(
//             onTap: () {
//               if (!notifier.ignoreTaps &&
//                   !notifier.answeredWords.contains(widget.index) &&
//                   !notifier.tappedWords.containsKey(widget.index)) {
//                 notifier.tileTapped(index: widget.index, word: widget.word);
//               }
//             },
//             onDoubleTap: () {
//               // if (widget.hasImage &&
//                 if( widget.word.contents.isNotEmpty &&
//                   _isCardFlipped) { // ตรวจสอบการ์ดหงาย
//                 _showFullImage(context, widget.word.contents);
//               }
//             },
//             child: FlipAnimation(
//               word: MatchedAnimation(
//                 numberOfWordsAnswered: notifier.answeredWords.length,
//                 animate: notifier.answeredWords.contains(widget.index),
//                 child: Container(
//                   padding: const EdgeInsets.all(16),
//                   child: _buildImage(),
//                 ),
//               ),
//               animate: animate,
//               reverse: notifier.reverseFlip,
//               animationCompleted: (isForward) {
//                 notifier.onAnimationCompleted(isForward: isForward);
//               },
//               onFlipStateChanged: (isFront) {
//                 setState(() {
//                   _isCardFlipped = isFront; // อัปเดตสถานะการหงาย
//                 });
//               },
//             ),
//           );
//         },
//       ),
//     );
//   }

//   void _showFullImage(BuildContext context, List<int> imageBytes) {
//     showDialog(
//       context: context,
//       builder: (context) => ImageDialog(imageBytes: imageBytes),
//     );
//   }

//   Widget _buildImage() {
//     return Image.memory(
//           Uint8List.fromList(widget.word.contents),
//           fit: BoxFit.cover,
//         );
//   }

//   bool checkAnimationRun(GameManager notifier) {
//     bool animate = false;
//     if (notifier.canFlip) {
//       if (notifier.tappedWords.isNotEmpty &&
//           notifier.tappedWords.keys.last == widget.index) {
//         animate = true;
//       }
//       if (notifier.reverseFlip && !notifier.answeredWords.contains(widget.index)) {
//         animate = true;
//       }
//     }
//     return animate;
//   }
// }

// class ImageDialog extends StatelessWidget {
//   final List<int> imageBytes;
//   const ImageDialog({super.key, required this.imageBytes});

//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       backgroundColor: Colors.transparent,
//       insetPadding: const EdgeInsets.all(20),
//       child: GestureDetector(
//         onTap: () => Navigator.of(context).pop(),
//         child: InteractiveViewer(
//           panEnabled: true,
//           minScale: 0.5,
//           maxScale: 4.0,
//           child: Container(
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(16),
//               image: DecorationImage(
//                 image: MemoryImage(Uint8List.fromList(imageBytes)),
//                 fit: BoxFit.contain,
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_application_0/animation/flip_animation.dart';
import 'package:flutter_application_0/animation/matched_animation.dart';
import 'package:flutter_application_0/animation/spin_animation.dart';
import 'package:flutter_application_0/managers/game_manager.dart';
import 'package:flutter_application_0/models/word.dart';
import 'package:provider/provider.dart';

class WordTile extends StatelessWidget {
  const WordTile({
    required this.index,
    required this.word,
    Key? key,
    required bool isMatched,
  }) : super(key: key);

  final int index;
  final Word word;

  @override
  Widget build(BuildContext context) {
    return SpinAnimation(
      child: Consumer<GameManager>(
        builder: (_, notifier, __) {
          bool animate = checkAnimationRun(notifier);

          return GestureDetector(
              onTap: () {
                if (!notifier.ignoreTaps &&
                    !notifier.answeredWords.contains(index) &&
                    !notifier.tappedWords.containsKey(index)) {
                  notifier.tileTapped(index: index, word: word);
                }
              },
              child: FlipAnimation(
                delay: notifier.reverseFlip ? 1500 : 0,
                reverse: notifier.reverseFlip,
                animationCompleted: (isForward) {
                  notifier.onAnimationCompleted(isForward: isForward);
                },
                animate: animate,
                word: MatchedAnimation(
                  numberOfWordsAnswered: notifier.answeredWords.length,
                  animate: notifier.answeredWords.contains(index),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    // child: word.descrip.isNotEmpty
                    //     ? FittedBox(
                    //         fit: BoxFit.scaleDown,
                    //         child: Transform(
                    //             alignment: Alignment.center,
                    //             transform: Matrix4.rotationY(pi),
                    //             child:
                    //                 Text(word.descrip)
                    //                 )) // ใช้ descrip แทน text
                    //     : Image.memory(Uint8List.fromList(
                    //         word.contents)), // ใช้ contents แทน url
                    child: word.contents.isNotEmpty
                        ? Image.memory(
                            Uint8List.fromList(word.contents),
                            fit: BoxFit.cover,
                          )
                        : FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Transform(
                              alignment: Alignment.center,
                              transform: Matrix4.rotationY(pi),
                              child: Text(word.descrip),
                            ),
                          ),
                  ),
                ),
              ));
        },
      ),
    );
  }

  bool checkAnimationRun(GameManager notifier) {
    bool animate = false;

    if (notifier.canFlip) {
      if (notifier.tappedWords.isNotEmpty &&
          notifier.tappedWords.keys.last == index) {
        animate = true;
      }
      if (notifier.reverseFlip && !notifier.answeredWords.contains(index)) {
        animate = true;
      }
    }
    return animate;
  }

  Widget _buildImage(dynamic widget) {
    return Image.memory(
      Uint8List.fromList(widget.word.contents),
      fit: BoxFit.cover,
    );
  }
}
