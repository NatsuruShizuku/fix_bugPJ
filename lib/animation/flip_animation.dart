// // import 'dart:math';

// // import 'package:flutter/material.dart';

// // class FlipAnimation extends StatefulWidget {
// //   const FlipAnimation(
// //       {required this.word,
// //       required this.animate,
// //       required this.reverse,
// //       required this.animationCompleted,
// //       this.delay = 0,
// //       Key? key})
// //       : super(key: key);

// //   final Widget word;
// //   final bool animate;
// //   final bool reverse;
// //   final Function(bool) animationCompleted;
// //   final int delay;

// //   @override
// //   State<FlipAnimation> createState() => _FlipAnimationState();
// // }

// // class _FlipAnimationState extends State<FlipAnimation>
// //     with SingleTickerProviderStateMixin {
// //   late AnimationController _controller;
// //   late Animation<double> _animation;

// //   @override
// //   void initState() {
// //     super.initState();
// //     _controller = AnimationController(
// //         duration: const Duration(milliseconds: 1200), vsync: this)
// //       ..addStatusListener((status) {
// //         if (status == AnimationStatus.completed) {
// //           widget.animationCompleted.call(true);
// //         }
// //         if (status == AnimationStatus.dismissed) {
// //           widget.animationCompleted.call(false);
// //         }
// //       });

// //     _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
// //         CurvedAnimation(parent: _controller, curve: Curves.bounceInOut));
// //   }

// //   @override
// //   void didUpdateWidget(covariant FlipAnimation oldWidget) {
// //     Future.delayed(Duration(milliseconds: widget.delay), () {
// //       if (mounted) {
// //         if (widget.animate) {
// //           if (widget.reverse) {
// //             _controller.reverse();
// //           } else {
// //             _controller.reset();
// //             _controller.forward();
// //           }
// //         }
// //       }
// //     });

// //     super.didUpdateWidget(oldWidget);
// //   }

// //   @override
// //   void dispose() {
// //     _controller.dispose();
// //     super.dispose();
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return AnimatedBuilder(
// //       animation: _controller,
// //       builder: (context, child) => Transform(
// //           alignment: Alignment.center,
// //           transform: Matrix4.identity()
// //             ..rotateY(_animation.value * pi)
// //             ..setEntry(3, 2, 0.005),
// //           child: _controller.value >= 0.50
// //               ? widget.word
// //               : Container(
// //                   decoration: BoxDecoration(
// //                       color: Colors.deepPurple,
// //                       borderRadius: BorderRadius.circular(8)),
// //                   child: const Icon(
// //                     Icons.question_mark,
// //                     size: 50,
// //                     color: Colors.white,
// //                   ))),
// //     );
// //   }
// // }
// import 'dart:math';
// import 'package:flutter/material.dart';

// class FlipAnimation extends StatefulWidget {
//   const FlipAnimation({
//     required this.word,
//     required this.animate,
//     required this.reverse,
//     required this.animationCompleted,
//     this.delay = 0,
//     Key? key,
//   }) : super(key: key);

//   final Widget word;
//   final bool animate;
//   final bool reverse;
//   final Function(bool) animationCompleted;
//   final int delay;

//   @override
//   State<FlipAnimation> createState() => _FlipAnimationState();
// }

// class _FlipAnimationState extends State<FlipAnimation>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _animation;
//   bool _isFront = true;

  // @override
  // void initState() {
  //   super.initState();
  //   _controller = AnimationController(
  //     duration: const Duration(milliseconds: 800),
  //     vsync: this,
  //   )..addStatusListener((status) {
  //       if (status == AnimationStatus.completed) {
  //         setState(() => _isFront = !_isFront);
  //         widget.animationCompleted.call(true);
  //       }
  //       if (status == AnimationStatus.dismissed) {
  //         widget.animationCompleted.call(false);
  //       }
  //     });

  //   _animation = Tween<double>(begin: 0.0, end: pi).animate(
  //     CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
  //   );
  // }

//   // @override
//   // void didUpdateWidget(covariant FlipAnimation oldWidget) {
//   //   super.didUpdateWidget(oldWidget);
//   //   if (!oldWidget.animate && widget.animate) {
//   //     Future.delayed(Duration(milliseconds: widget.delay), () {
//   //       if (mounted) {
//   //         if (widget.reverse) {
//   //           _controller.reverse();
//   //         } else {
//   //           _controller.reset();
//   //           _controller.forward();
//   //         }
//   //       }
//   //     });
//   //   }
//   // }
//   @override
// void didUpdateWidget(covariant FlipAnimation oldWidget) {
//   // ตรวจสอบเฉพาะเมื่อค่า animate เปลี่ยนจาก false เป็น true
//   if (widget.animate != oldWidget.animate || widget.reverse != oldWidget.reverse) {
//     Future.delayed(Duration(milliseconds: widget.delay), () {
//       if (mounted) {
//         if (widget.animate) {
//           if (widget.reverse) {
//             if (_controller.status != AnimationStatus.dismissed) {
//               _controller.reverse();
//             }
//           } else {
//             if (_controller.status != AnimationStatus.completed) {
//               _controller.reset();
//               _controller.forward();
//             }
//           }
//         }
//       }
//     });
//   }
//   super.didUpdateWidget(oldWidget);
// }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedBuilder(
//       animation: _controller,
//       builder: (context, child) {
//         final isBack = _animation.value >= pi / 2;
//         return Transform(
//           alignment: Alignment.center,
//           transform: Matrix4.identity()
//             ..rotateY(_animation.value)
//             ..setEntry(3, 2, 0.005),
//           child: AnimatedSwitcher(
//             duration: const Duration(milliseconds: 300),
//             child: isBack
//                 ? widget.word
//                 : Container(
//                     key: ValueKey(_isFront),
//                     decoration: BoxDecoration(
//                       color: Colors.deepPurple,
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     child: const Icon(
//                       Icons.question_mark,
//                       size: 50,
//                       color: Colors.white,
//                     ),
//                   ),
//           ),
//         );
//       },
//     );
//   }
// }
