// import 'dart:async';
// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import 'package:flutter_application_0/models/word.dart';
// import 'package:flutter_application_0/new/gamebesttime.dart';
// import 'package:flutter_application_0/new/gametimer.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class GameBoard extends StatefulWidget {
//   final int rows;
//   final int cols;
//   final List<Word> words;

//   const GameBoard({
//     super.key,
//     required this.rows,
//     required this.cols,
//     required this.words,
//   });

//   @override
//   State<GameBoard> createState() => _GameBoardState();
// }

// class _GameBoardState extends State<GameBoard> {
//   late List<bool> _revealedCards;
//   late List<bool> _matchedCards;
//   int? _selectedIndex;
//   int _matchedPairs = 0;
//   late Duration _currentTime = Duration.zero;
//   late Timer _gameTimer;
//   int _bestTime = 0;

//   @override
//   void initState() {
//     super.initState();
//     _loadBestTime();
//     _startTimer();
//     _initializeGame();
//   }

//   void _startTimer() {
//     _gameTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
//       if (_matchedPairs < widget.words.length ~/ 2) {
//         setState(() => _currentTime += const Duration(seconds: 1));
//       }
//     });
//   }

//   String _getBestTimeKey() => 'best_time_${widget.rows}x${widget.cols}';

//   Future<void> _loadBestTime() async {
//     final prefs = await SharedPreferences.getInstance();
//     // setState(() => _bestTime = prefs.getInt('best_time') ?? 0);
//     setState(() => _bestTime = prefs.getInt(_getBestTimeKey()) ?? 0);
//   }

//   Future<void> _saveBestTime() async {
//     final currentBest = _bestTime;
//     if (currentBest == 0 || _currentTime.inSeconds < currentBest) {
//       final prefs = await SharedPreferences.getInstance();
//       await prefs.setInt(_getBestTimeKey(), _currentTime.inSeconds);
//       setState(() => _bestTime = _currentTime.inSeconds);
//     }
//   }

//   void _initializeGame() {
//     _revealedCards = List<bool>.filled(widget.words.length, false);
//     _matchedCards = List<bool>.filled(widget.words.length, false);
//     _selectedIndex = null;
//     _matchedPairs = 0;
//   }

//   Future<void> _handleCardTap(int index) async {
//     // หากการ์ดถูกเปิดหรือจับคู่แล้ว ให้ไม่ทำอะไร
//     if (_revealedCards[index] || _matchedCards[index]) return;

//     setState(() {
//       _revealedCards[index] = true;
//     });

//     if (_selectedIndex == null) {
//       _selectedIndex = index;
//     } else {
//       final firstIndex = _selectedIndex!;
//       final secondIndex = index;
//       final isMatched =
//           widget.words[firstIndex].matraID == widget.words[secondIndex].matraID;

//       if (isMatched) {
//         setState(() {
//           _matchedCards[firstIndex] = true;
//           _matchedCards[secondIndex] = true;
//           _matchedPairs++;
//         });
//         _selectedIndex = null;
//         if (_matchedPairs == widget.words.length ~/ 2) {
//           _showGameOverDialog();
//         }
//       } else {
//         // รอให้ผู้เล่นเห็นการ์ดทั้งสองก่อนกลับหน้าคว่ำ
//         await Future.delayed(const Duration(milliseconds: 800));
//         if (!mounted) return;
//         setState(() {
//           _revealedCards[firstIndex] = false;
//           _revealedCards[secondIndex] = false;
//           _selectedIndex = null;
//         });
//       }
//     }
//   }

//   void _showGameOverDialog() {
//     _gameTimer.cancel();
//     _saveBestTime();
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('เกมจบ!'),
//         content: const Text('คุณทำได้ดีมาก!'),
//         actions: [
//           TextButton(
//             onPressed: () {
//               Navigator.pop(context);
//               setState(() {
//                 _currentTime = Duration.zero;
//                 _startTimer();
//               });
//               _initializeGame();
//             },
//             child: const Text('เล่นอีกครั้ง'),
//           )
//         ],
//       ),
//     );
//   }

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     // ฟอร์ซ rebuild เมื่อ orientation เปลี่ยน
//     WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
//   }

//   @override
//   void dispose() {
//     _gameTimer.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // appBar: AppBar(
//       //   title: Text('บอร์ด ${widget.rows}x${widget.cols}'),
//       // ),
//       // body: Column(
//       body: OrientationBuilder(
//         builder: (context, orientation) {
//           return Column(
//             children: [
//               // ตัวนับเวลาปัจจุบัน
//               GameTimerMobile(time: _currentTime),
//               // กริดเกมให้อยู่ตรงกลางหน้าจอ
//               Expanded(
//                 child: Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: LayoutBuilder(
//                     builder: (context, constraints) {
//                       // คำนวณขนาดการ์ดตาม orientation
//                       double spacing = 1;
//                       double availableWidth = constraints.maxWidth;
//                       double availableHeight = constraints.maxHeight;

//                       // ปรับสูตรคำนวณสำหรับแนวตั้งและแนวนอน
//                       if (orientation == Orientation.portrait) {
//                         availableHeight *= 0.7; // เติมพื้นที่สำหรับส่วนอื่น
//                       } else {
//                         availableWidth *= 0.9; // ลดความกว้างเพื่อเว้นระยะขอบ
//                       }

//                       double cardWidth =
//                           (availableWidth - (widget.cols + 1) * spacing) /
//                               widget.cols;
//                       double cardHeight =
//                           (availableHeight - (widget.rows + 1) * spacing) /
//                               widget.rows;

//                       // จำกัดขนาดขั้นต่ำและสูงสุด
//                       cardWidth = cardWidth.clamp(20, 120);
//                       cardHeight = cardHeight.clamp(20, 120);

//                       return GridView.builder(
//                         // shrinkWrap: true,
//                         physics: const NeverScrollableScrollPhysics(),
//                         // padding: const EdgeInsets.all(16),
//                         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                           crossAxisCount: widget.cols,
//                           crossAxisSpacing: spacing,
//                           mainAxisSpacing: spacing,
//                           childAspectRatio: cardWidth / cardHeight,
//                         ),
//                         itemCount: widget.words.length,
//                         itemBuilder: (context, index) {
//                           return GestureDetector(
//                             onTap: () => _handleCardTap(index),
//                             child: TweenAnimationBuilder<double>(
//                               tween: Tween<double>(
//                                 begin: 0,
//                                 end: _revealedCards[index] ? 1 : 0,
//                               ),
//                               duration: const Duration(milliseconds: 300),
//                               builder: (context, value, child) {
//                                 double angle = value * 3.1416;
//                                 // หากผ่านครึ่งแล้วให้กลับด้านให้ถูกต้อง (ไม่กลับกระจก)
//                                 if (value >= 0.5) {
//                                   return Transform(
//                                     transform: Matrix4.identity()
//                                       ..setEntry(3, 2, 0.001)
//                                       ..rotateY(angle - 3.1416),
//                                     alignment: Alignment.center,
//                                     child: child,
//                                   );
//                                 } else {
//                                   return Transform(
//                                     transform: Matrix4.identity()
//                                       ..setEntry(3, 2, 0.001)
//                                       ..rotateY(angle),
//                                     alignment: Alignment.center,
//                                     child: child,
//                                   );
//                                 }
//                               },
//                               child: _MemoryCard(
//                                 revealed: _revealedCards[index],
//                                 content: widget.words[index].contents,
//                                 isMatched: _matchedCards[index],
//                               ),
//                             ),
//                           );
//                         },
//                       );
//                     },
//                   ),
//                 ),
//               ),
//               // ปรับ UI ของ BestTime ให้อยู่ในพื้นที่ที่เหมาะสม
//               Container(
//                 padding:
//                     const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//                 margin: const EdgeInsets.only(bottom: 16),
//                 child: FittedBox(
//                   child: GameBestTimeMobile(
//                     bestTime: _bestTime,
//                     rows: widget.rows,
//                     cols: widget.cols,
//                   ),
//                 ),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }
// }

// class _MemoryCard extends StatelessWidget {
//   final bool revealed;
//   final bool isMatched;
//   final Uint8List content;

//   const _MemoryCard({
//     required this.revealed,
//     required this.isMatched,
//     required this.content,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       child: AnimatedSwitcher(
//         duration: const Duration(milliseconds: 300),
//         switchInCurve: isMatched ? Curves.easeIn : Curves.easeInOut,
//         switchOutCurve: isMatched ? Curves.easeOut : Curves.easeInOut,
//         child: revealed
//             ? _CardFace(content: content, isMatched: isMatched)
//             : const _CardBack(),
//       ),
//     );
//   }
// }

// class _CardFace extends StatelessWidget {
//   final Uint8List content;
//   final bool isMatched;

//   const _CardFace({required this.content, required this.isMatched});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         border: isMatched ? Border.all(color: Colors.green, width: 3) : null,
//       ),
//       child: Image.memory(
//         content,
//         cacheWidth: 150,
//         cacheHeight: 150,
//       ),
//     );
//   }
// }

// class _CardBack extends StatelessWidget {
//   const _CardBack();

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(10),
//         color: Colors.blue,
//       ),
//       child: const Center(
//         child: Icon(Icons.question_mark, size: 40, color: Colors.white),
//       ),
//     );
//   }
// }
import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_application_0/models/word.dart';
import 'package:flutter_application_0/new/gamebesttime.dart';
import 'package:flutter_application_0/new/gametimer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GameBoard extends StatefulWidget {
  final int rows;
  final int cols;
  final List<Word> words;

  const GameBoard({
    super.key,
    required this.rows,
    required this.cols,
    required this.words,
  });

  @override
  State<GameBoard> createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
  late List<bool> _revealedCards;
  late List<bool> _matchedCards;
  int? _selectedIndex;
  int _matchedPairs = 0;
  late Duration _currentTime = Duration.zero;
  late Timer _gameTimer;
  int _bestTime = 0;

  @override
  void initState() {
    super.initState();
    _loadBestTime();
    _startTimer();
    _initializeGame();
  }

  void _startTimer() {
    _gameTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_matchedPairs < widget.words.length ~/ 2) {
        setState(() => _currentTime += const Duration(seconds: 1));
      }
    });
  }

  String _getBestTimeKey() => 'best_time_${widget.rows}x${widget.cols}';

  Future<void> _loadBestTime() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() => _bestTime = prefs.getInt(_getBestTimeKey()) ?? 0);
  }

  Future<void> _saveBestTime() async {
    final currentBest = _bestTime;
    if (currentBest == 0 || _currentTime.inSeconds < currentBest) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_getBestTimeKey(), _currentTime.inSeconds);
      setState(() => _bestTime = _currentTime.inSeconds);
    }
  }

  void _initializeGame() {
    _revealedCards = List<bool>.filled(widget.words.length, false);
    _matchedCards = List<bool>.filled(widget.words.length, false);
    _selectedIndex = null;
    _matchedPairs = 0;
  }

  Future<void> _handleCardTap(int index) async {
    // หากการ์ดถูกเปิดหรือจับคู่แล้ว ให้ไม่ทำอะไร
    if (_revealedCards[index] || _matchedCards[index]) return;

    setState(() {
      _revealedCards[index] = true;
    });

    if (_selectedIndex == null) {
      _selectedIndex = index;
    } else {
      final firstIndex = _selectedIndex!;
      final secondIndex = index;
      final isMatched =
          widget.words[firstIndex].matraID == widget.words[secondIndex].matraID;

      if (isMatched) {
        setState(() {
          _matchedCards[firstIndex] = true;
          _matchedCards[secondIndex] = true;
          _matchedPairs++;
        });
        _selectedIndex = null;
        if (_matchedPairs == widget.words.length ~/ 2) {
          _showGameOverDialog();
        }
      } else {
        // รอให้ผู้เล่นเห็นการ์ดทั้งสองก่อนกลับหน้าคว่ำ
        await Future.delayed(const Duration(milliseconds: 800));
        if (!mounted) return;
        setState(() {
          _revealedCards[firstIndex] = false;
          _revealedCards[secondIndex] = false;
          _selectedIndex = null;
        });
      }
    }
  }

  void _showGameOverDialog() {
    _gameTimer.cancel();
    _saveBestTime();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('เกมจบ!'),
        content: const Text('คุณทำได้ดีมาก!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _currentTime = Duration.zero;
                _startTimer();
              });
              _initializeGame();
            },
            child: const Text('เล่นอีกครั้ง'),
          )
        ],
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // ฟอร์ซ rebuild เมื่อ orientation เปลี่ยน
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  void dispose() {
    _gameTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OrientationBuilder(
        builder: (context, orientation) {
          final isPortrait = orientation == Orientation.portrait;
          return Column(
            children: [
              // ตัวนับเวลาปัจจุบัน
              Container(
                padding:
                    EdgeInsets.only(top: isPortrait ? 8.0 : 4.0, bottom: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: isPortrait ? 160 : 140, // จำกัดความกว้าง
                      child: GameTimerMobile(time: _currentTime),
                    ),
                    SizedBox(width: isPortrait ? 16 : 8),
                    SizedBox(
                      width: isPortrait ? 160 : 140, // จำกัดความกว้าง
                      child: GameBestTimeMobile(
                        bestTime: _bestTime,
                        rows: widget.rows,
                        cols: widget.cols,
                      ),
                    ),
                  ],
                ),
              ),

              // กริดเกมให้อยู่ตรงกลางหน้าจอ
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    double spacing =
                        isPortrait ? 4.0 : 3.0; // ระยะห่างน้อยที่สุด
                    double availableHeight =
                        constraints.maxHeight * 0.98; // ใช้พื้นที่เกือบทั้งหมด
                    double availableWidth = constraints.maxWidth * 0.98;

                    double cardWidth =
                        (availableWidth - (widget.cols + 1) * spacing) /
                            widget.cols;
                    double cardHeight =
                        (availableHeight - (widget.rows + 1) * spacing) /
                            widget.rows;

                    return Center(
                      child: SizedBox(
                        width: cardWidth * widget.cols +
                            spacing * (widget.cols - 1),
                        height: cardHeight * widget.rows +
                            spacing * (widget.rows - 1),
                        child: GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: widget.cols,
                            crossAxisSpacing: spacing,
                            mainAxisSpacing: spacing,
                            childAspectRatio: cardWidth / cardHeight,
                          ),
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () => _handleCardTap(index),
                              child: _MemoryCard(
                                revealed: _revealedCards[index],
                                content: widget.words[index].contents,
                                isMatched: _matchedCards[index],
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
// ส่วนแสดง BestTime
// Container(
//   padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//   margin: const EdgeInsets.only(bottom: 16),
//   child: FittedBox(
//     child: GameBestTimeMobile(
//       bestTime: _bestTime,
//       rows: widget.rows,
//       cols: widget.cols,
//     ),
//   ),
// ),
//             ],
//           );
//         },
//       ),
//     );
//   }
// }

class _MemoryCard extends StatelessWidget {
  final bool revealed;
  final bool isMatched;
  final Uint8List content;

  const _MemoryCard({
    required this.revealed,
    required this.isMatched,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    // return Card(
    //   child: AnimatedSwitcher(
    //     duration: const Duration(milliseconds: 300),
    //     switchInCurve: isMatched ? Curves.easeIn : Curves.easeInOut,
    //     switchOutCurve: isMatched ? Curves.easeOut : Curves.easeInOut,
    //     child: revealed
    //         ? _CardFace(content: content, isMatched: isMatched)
    //         : const _CardBack(),
    //   ),
    // );
//     }
// }
    return LayoutBuilder(
      builder: (context, constraints) {
        return Card(
              child: SizedBox(
                width: constraints.maxWidth,
                height: constraints.maxHeight,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: revealed
                      ? _CardFace(content: content, isMatched: isMatched)
                      : const _CardBack(),
                            ),
              ),
            );
        // return Card(
        //   margin: EdgeInsets.zero, // ลบ margin
        //   child: Container(
        //     decoration: BoxDecoration(
        //       border:
        //           isMatched ? Border.all(color: Colors.green, width: 2) : null,
        //     ),
        //     child: revealed
        //         ? Image.memory(content, fit: BoxFit.contain)
        //         : Center(child: Icon(Icons.question_mark, size: 24)),
        //   ),
        // );
      },
    );
  }
}

class _CardFace extends StatelessWidget {
  final Uint8List content;
  final bool isMatched;

  const _CardFace({required this.content, required this.isMatched});

  @override
  Widget build(BuildContext context) {
    // return Container(
    //   decoration: BoxDecoration(
    //     border: isMatched ? Border.all(color: Colors.green, width: 3) : null,
    //   ),
    //   child: Image.memory(
    //     content,
    //     fit: BoxFit.contain,
    //   ),
    // );
//   }
// }
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          width: constraints.maxWidth,
          height: constraints.maxHeight,
          decoration: BoxDecoration(
            border:
                isMatched ? Border.all(color: Colors.green, width: 3) : null,
          ),
          child: Image.memory(
            content,
            fit: BoxFit.contain,
          ),
        );
      },
    );
  }
}

class _CardBack extends StatelessWidget {
  const _CardBack();

  @override
  Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(10),
//         color: Colors.blue,
//       ),
//       child: const Center(
//         child: Icon(Icons.question_mark, size: 40, color: Colors.white),
//       ),
//     );
//   }
// }
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          width: constraints.maxWidth,
          height: constraints.maxHeight,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.blue,
          ),
          child: const Center(
            child: Icon(Icons.question_mark, color: Colors.white),
          ),
        );
      },
    );
  }
}
