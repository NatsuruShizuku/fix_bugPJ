import 'package:flutter/material.dart';

class GameBestTimeMobile extends StatelessWidget {
  const GameBestTimeMobile({
    required this.bestTime,
    required this.rows,
    required this.cols,
    super.key,
  });

  final int bestTime;
  final int rows;
  final int cols;

  String _formatBestTime(int seconds) =>
      Duration(seconds: seconds).toString().split('.').first.padLeft(8, "0");

  @override
  Widget build(BuildContext context) {
    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    return Card(
      // margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
      margin: EdgeInsets.symmetric(
      vertical: isPortrait ? 10 : 5,
      horizontal: isPortrait ? 30 : 15,
    ),
      elevation: 8,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      color: Colors.greenAccent[700],
      child: Padding(
        // padding: const EdgeInsets.all(6.0),
        padding: EdgeInsets.all(isPortrait ? 8.0 : 4.0),
        child: Column(
          mainAxisSize: MainAxisSize.min, // ลดการขยายของ Row
          children: [
            Text(
              '${rows}x${cols}',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // const Icon(Icons.celebration, size: 24),
                // const SizedBox(width: 8),
                Icon(Icons.timer, size: isPortrait ? 24 : 20),
          SizedBox(width: isPortrait ? 8 : 4),
                Text(
                  bestTime > 0 ? _formatBestTime(bestTime) : "--:--:--",
                  // style: const TextStyle(fontSize: 20.0),
                  style: TextStyle(fontSize: isPortrait ? 20.0 : 16.0),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
