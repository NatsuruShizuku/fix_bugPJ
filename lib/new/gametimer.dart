import 'package:flutter/material.dart';

class GameTimerMobile extends StatelessWidget {
  const GameTimerMobile({
    required this.time,
    super.key,
  });

  final Duration time;

  String _formatTime(Duration d) => 
    d.toString().split('.').first.padLeft(8, "0");

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 30,
      ),
      elevation: 8,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      color: Colors.red[700],
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              fit: FlexFit.loose,
              child: Icon(
                Icons.timer,
                size: 30,
              ),
            ),
            Flexible(
              fit: FlexFit.loose,
              child: Text(
                textAlign: TextAlign.center,
                _formatTime(time),
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