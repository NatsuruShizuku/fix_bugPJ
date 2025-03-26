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
     final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

    
    // return Card(
    // margin: EdgeInsets.symmetric(
    //   vertical: isPortrait ? 10 : 5,
    //   horizontal: isPortrait ? 30 : 15,
    // ),
    //   elevation: 8,
    //   clipBehavior: Clip.antiAlias,
    //   shape: RoundedRectangleBorder(
    //     borderRadius: BorderRadius.circular(15),
    //   ),
    //   color: Colors.red[700],
    //   child: Padding(
    //     // padding: const EdgeInsets.all(6.0),
    //      padding: EdgeInsets.all(isPortrait ? 8.0 : 4.0),
    //     child: Row(
    //       mainAxisSize: MainAxisSize.min,
    //       children: [
    //         // const Icon(Icons.timer, size: 24),
    //         // const SizedBox(width: 8),
    //         Icon(Icons.timer, size: isPortrait ? 24 : 20),
    //       SizedBox(width: isPortrait ? 8 : 4),
    //         Text(
    //           _formatTime(time),
    //           // style: const TextStyle(fontSize: 20.0),
    //           style: TextStyle(fontSize: isPortrait ? 20.0 : 16.0),
    //         ),
    //       ],
    //     ),
    //   ),
    // );
    return Card(
    margin: EdgeInsets.zero, // ลบ margin ทั้งหมด
    elevation: 4,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    child: Padding(
      padding: EdgeInsets.all(isPortrait ? 4.0 : 2.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.timer, size: isPortrait ? 18 : 16),
          SizedBox(width: 4),
          Text(
            _formatTime(time),
            style: TextStyle(fontSize: isPortrait ? 16.0 : 14.0),
          ),
        ],
      ),
    ),
  );
  }
}
