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

class _GameBoardState extends State<GameBoard>
    with SingleTickerProviderStateMixin {
  late List<bool> _revealedCards;
  late List<bool> _matchedCards; // เพิ่มสถานะติดตามการจับคู่
  int? _selectedIndex;
  int _matchedPairs = 0;
  late AnimationController _animationController;
  final Map<int, bool> _isAnimating = {};
  late Duration _currentTime = Duration.zero;
  late Timer _gameTimer;
  int _bestTime = 0;

  @override
  void initState() {
    super.initState();
    _loadBestTime();
    _startTimer();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _initializeGame();
  }

  void _startTimer() {
    _gameTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_matchedPairs < widget.words.length ~/ 2) {
        setState(() => _currentTime += const Duration(seconds: 1));
      }
    });
  }

  Future<void> _loadBestTime() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() => _bestTime = prefs.getInt('best_time') ?? 0);
  }

  Future<void> _saveBestTime() async {
    if (_bestTime == 0 || _currentTime.inSeconds < _bestTime) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('best_time', _currentTime.inSeconds);
      setState(() => _bestTime = _currentTime.inSeconds);
    }
  }

  void _initializeGame() {
    _revealedCards = List<bool>.filled(widget.words.length, false);
    _matchedCards = List<bool>.filled(widget.words.length, false);
    _selectedIndex = null;
    _matchedPairs = 0;
    _isAnimating.clear();
  }

  Future<void> _handleCardTap(int index) async {
    if (_revealedCards[index] || _isAnimating[index] == true) return;

    _isAnimating[index] = true;
    await _animationController.forward();

    if (!mounted) return;
    setState(() => _revealedCards[index] = true);

    if (_selectedIndex == null) {
      _selectedIndex = index;
    } else {
      // final first = widget.words[_selectedIndex!];
      // final second = widget.words[index];
      final firstIndex = _selectedIndex!;
      final secondIndex = index;
      final isMatched =
          widget.words[firstIndex].matraID == widget.words[secondIndex].matraID;

      // if (first.matraID == second.matraID) {
      //   _matchedPairs++;
      //   _selectedIndex = null;
      //   if (_matchedPairs == widget.words.length ~/ 2) {
      //     _showGameOverDialog();
      //   }
      // } else {
      //   await Future.delayed(const Duration(milliseconds: 800));
      //   if (!mounted) return;
      //   setState(() {
      //     _revealedCards[_selectedIndex!] = false;
      //     _revealedCards[index] = false;
      //     _selectedIndex = null;
      //   });
      // }
      if (isMatched) {
        // ตั้งค่าการ์ดที่จับคู่สำเร็จ
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
        await Future.delayed(const Duration(milliseconds: 800));
        if (!mounted) return;
        setState(() {
          _revealedCards[firstIndex] = false;
          _revealedCards[secondIndex] = false;
        });
      }
      _selectedIndex = null;
    }

    await _animationController.reverse();
    _isAnimating[index] = false;
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
          // TextButton(
          //   onPressed: () {
          //     Navigator.pop(context);
          //     _initializeGame();
          //   },
          //   child: const Text('เล่นอีกครั้ง'),
          // ),
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
  void dispose() {
    _gameTimer.cancel();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('บอร์ด ${widget.rows}x${widget.cols}'),
      ),
      // body: GridView.builder(
      //   padding: const EdgeInsets.all(16),
      //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      //     crossAxisCount: widget.cols,
      //     crossAxisSpacing: 8,
      //     mainAxisSpacing: 8,
      //     childAspectRatio: 0.8,
      //   ),
      //   itemCount: widget.words.length,
      //   itemBuilder: (context, index) {
      //     return AnimatedBuilder(
      //       animation: _animationController,
      //       builder: (context, child) {
      //         if (_matchedCards[index]) {
      //           return child!;
      //         }
      //         return GestureDetector(
      //           onTap: () => _handleCardTap(index),
      //           child: Transform(
      //             transform: Matrix4.identity()
      //               ..setEntry(3, 2, 0.001)
      //               ..rotateY(_animationController.value * 3.1416),
      //             alignment: Alignment.center,
      //             child: child,
      //           ),
      //         );
      //       },
      //       child: _MemoryCard(
      //         revealed: _revealedCards[index],
      //         content: widget.words[index].contents,
      //         isMatched: _matchedCards[index],
      //       ),
      //     );
      //   },
      // ),
      body: Column(
        children: [
          // ตัวนับเวลาปัจจุบัน
          GameTimerMobile(time: _currentTime),

          // กริดเกม
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: widget.cols,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 0.8,
              ),
              itemCount: widget.words.length,
              itemBuilder: (context, index) {
                return AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    if (_matchedCards[index]) {
                      return child!;
                    }
                    return GestureDetector(
                      onTap: () => _handleCardTap(index),
                      child: Transform(
                        transform: Matrix4.identity()
                          ..setEntry(3, 2, 0.001)
                          ..rotateY(_animationController.value * 3.1416),
                        alignment: Alignment.center,
                        child: child,
                      ),
                    );
                  },
                  child: _MemoryCard(
                    revealed: _revealedCards[index],
                    content: widget.words[index].contents,
                    isMatched: _matchedCards[index],
                  ),
                );
              },
            ),
          ),

          // เวลาดีที่สุด
          GameBestTimeMobile(bestTime: _bestTime),
        ],
      ),
    );
  }
  //   @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     body: GridView.builder(
  //       itemBuilder: (context, index) {
  //         return AnimatedBuilder(
  //           animation: _animationController,
  //           builder: (context, child) {
  //             // ไม่แสดง Animation ถ้าการ์ดถูกจับคู่
  //             if (_matchedCards[index]) {
  //               return child!;
  //             }
  //             return GestureDetector(
  //               onTap: () => _handleCardTap(index),
  //               child: Transform(
  //                 transform: Matrix4.identity()
  //                   ..setEntry(3, 2, 0.001)
  //                   ..rotateY(_animationController.value * 3.1416),
  //                 alignment: Alignment.center,
  //                 child: child,
  //               ),
  //             );
  //           },
  //           child: _MemoryCard(
  //             revealed: _matchedCards[index] || _revealedCards[index],
  //             content: widget.words[index].contents,
  //             isMatched: _matchedCards[index], // ส่งสถานะการจับคู่
  //           ),
  //         );
  //       },
  //     ),
  //   );
  // }
}

class _MemoryCard extends StatelessWidget {
  final bool revealed;
  final bool isMatched;
  final Uint8List content;

  const _MemoryCard({
    required this.revealed,
    required this.isMatched,
    required this.content,
  });

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 4,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: AnimatedSwitcher(
//         duration: const Duration(milliseconds: 300),
//         child: revealed
//             ? _CardFace(content: content)
//             : const _CardBack(),
//       ),
//     );
//   }
// }
  @override
  Widget build(BuildContext context) {
    return Card(
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        // ปิดการ Animation ถ้าจับคู่แล้ว
        switchInCurve: isMatched ? Curves.easeIn : Curves.easeInOut,
        switchOutCurve: isMatched ? Curves.easeOut : Curves.easeInOut,
        child: revealed
            ? _CardFace(content: content, isMatched: isMatched)
            : const _CardBack(),
      ),
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
    //     borderRadius: BorderRadius.circular(10),
    //     color: Colors.white,
    //   ),
    //   child: Center(
    //     child: Image.memory(
    //       content,
    //       cacheWidth: 150,
    //       cacheHeight: 150,
    //       fit: BoxFit.contain,
    //     ),
    //   ),
    // );
    return Container(
      decoration: BoxDecoration(
        border: isMatched
            ? Border.all(
                color: Colors.green, width: 3) // เน้นการ์ดที่จับคู่แล้ว
            : null,
      ),
      child: Image.memory(
        content,
        cacheWidth: 150,
        cacheHeight: 150,
      ),
    );
  }
}

class _CardBack extends StatelessWidget {
  const _CardBack();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.blue,
      ),
      child: const Center(
        child: Icon(Icons.question_mark, size: 40, color: Colors.white),
      ),
    );
  }
}
