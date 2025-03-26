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
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
      // margin: const EdgeInsets.symmetric(
      //   vertical: 50,
      //   horizontal: 60,
      // ),
      elevation: 8,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      color: Colors.greenAccent[700],
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Row(
          mainAxisSize: MainAxisSize.min, // ลดการขยายของ Row
          children: [
            Flexible(
              fit: FlexFit.loose,
              child: const Icon(
                Icons.celebration,
                size: 30,
              ),
            ),
            SizedBox(width: 40,),
            Flexible(
              fit: FlexFit.loose,
              child: Text(
                bestTime > 0 ? _formatBestTime(bestTime) : "--:--:--",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
