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
    // setState(() => _bestTime = prefs.getInt('best_time') ?? 0);
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
  void dispose() {
    _gameTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('บอร์ด ${widget.rows}x${widget.cols}'),
      // ),
      body: Column(
        children: [
          // ตัวนับเวลาปัจจุบัน
          GameTimerMobile(time: _currentTime),
          // กริดเกมให้อยู่ตรงกลางหน้าจอ
          Expanded(
            child: Center(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  double gridPadding = 16 * 2; // padding ซ้ายขวา
                  double availableWidth = constraints.maxWidth - gridPadding;
                  double spacing = 8;
                  double totalSpacing = spacing * (widget.cols - 1);
                  double cardWidth =
                      (availableWidth - totalSpacing) / widget.cols;
                  // กำหนด childAspectRatio ตามที่ต้องการ (เช่น 0.8)
                  double cardHeight = cardWidth / 0.8;
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: widget.cols,
                      crossAxisSpacing: spacing,
                      mainAxisSpacing: spacing,
                      childAspectRatio: cardWidth / cardHeight,
                    ),
                    itemCount: widget.words.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () => _handleCardTap(index),
                        child: TweenAnimationBuilder<double>(
                          tween: Tween<double>(
                            begin: 0,
                            end: _revealedCards[index] ? 1 : 0,
                          ),
                          duration: const Duration(milliseconds: 300),
                          builder: (context, value, child) {
                            double angle = value * 3.1416;
                            // หากผ่านครึ่งแล้วให้กลับด้านให้ถูกต้อง (ไม่กลับกระจก)
                            if (value >= 0.5) {
                              return Transform(
                                transform: Matrix4.identity()
                                  ..setEntry(3, 2, 0.001)
                                  ..rotateY(angle - 3.1416),
                                alignment: Alignment.center,
                                child: child,
                              );
                            } else {
                              return Transform(
                                transform: Matrix4.identity()
                                  ..setEntry(3, 2, 0.001)
                                  ..rotateY(angle),
                                alignment: Alignment.center,
                                child: child,
                              );
                            }
                          },
                          child: _MemoryCard(
                            revealed: _revealedCards[index],
                            content: widget.words[index].contents,
                            isMatched: _matchedCards[index],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
          // ปรับ UI ของ BestTime ให้อยู่ในพื้นที่ที่เหมาะสม
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            margin: const EdgeInsets.only(bottom: 16),
            child: FittedBox(
              child: GameBestTimeMobile(
                bestTime: _bestTime,
                rows: widget.rows,
                cols: widget.cols,
              ),
            ),
          ),
        ],
      ),
    );
  }
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

  @override
  Widget build(BuildContext context) {
    return Card(
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
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
    return Container(
      decoration: BoxDecoration(
        border: isMatched ? Border.all(color: Colors.green, width: 3) : null,
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
