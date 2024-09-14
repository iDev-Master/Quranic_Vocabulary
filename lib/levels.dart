import 'package:flutter/material.dart';
import 'dart:math';
import 'lesson.dart';
import 'constants.dart';

class LevelsPage extends StatefulWidget {
  @override
  _LevelsPageState createState() => _LevelsPageState();
}

class _LevelsPageState extends State<LevelsPage> with TickerProviderStateMixin {
  final List<AnimationController> _controllers = [];
  final List<Animation<double>> _animations = [];

  @override
  void initState() {
    super.initState();

    // Initialize animation controllers and animations for each item
    for (int i = 0; i < totalLevels; i++) {
      final controller = AnimationController(
        duration: const Duration(milliseconds: Duration_of_the_animation),
        vsync: this,
      );
      final animation = Tween<double>(begin: 0.0, end: 1.0).animate(controller);

      // Add the controller and animation to the lists
      _controllers.add(controller);
      _animations.add(animation);

      // Start animation with a delay
      Future.delayed(Duration(milliseconds: i * menuAnimationDelay), () {
        controller.forward();
      });
    }
  }

  @override
  void dispose() {
    // Dispose all controllers
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Уровни'),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              // "background.jpg",
              "assets/images/background.jpg",
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(0.0),
              child: CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(00, 20, 0, 100),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          bool isUnlocked = index + 1 <= currentLevel;
                          bool isCurrent = index + 1 == currentLevel;
                          final angle = (index + 10) * 0.25;
                          final offsetX = 145 * cos(angle);
                          final offsetY = 00 * sin(angle);

                          return Transform.translate(
                            offset: Offset(offsetX, offsetY),
                            child: FadeTransition(
                              opacity: _animations[index],
                              child: GestureDetector(
                                onTap: () {
                                  if (isUnlocked) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            LessonPage(level: index + 1),
                                      ),
                                    );
                                  }
                                },
                                child: Center(
                                  child: Container(
                                    width: 80.0,
                                    height: 80.0,
                                    margin: const EdgeInsets.all(20.0),
                                    decoration: BoxDecoration(
                                      color: isUnlocked
                                          ? (isCurrent
                                              ? levelLockedStyle
                                              : levelUnlockedStyle)
                                          : currentLevelStyle,
                                      borderRadius: BorderRadius.circular(80),
                                      boxShadow: [
                                        BoxShadow(
                                          // color: Colors.deepOrange.withOpacity(0.25),

                                          color: isUnlocked
                                              ? (isCurrent
                                                  ? levelLockedStyle
                                                      .withOpacity(0.25)
                                                  : levelUnlockedStyle
                                                      .withOpacity(0.25))
                                              : currentLevelStyle
                                                  .withOpacity(0.25),

                                          spreadRadius: 2,
                                          blurRadius: 8,
                                          offset: const Offset(4, 4),
                                        ),
                                      ],
                                    ),
                                    child: Center(
                                      child: isUnlocked
                                          ? Text(
                                              '${index + 1}',
                                              style: TextStyle(
                                                color: isCurrent
                                                    ? Colors.black
                                                    : Colors.white,
                                                fontSize: 35,
                                                fontWeight: isCurrent
                                                    ? FontWeight.bold
                                                    : FontWeight.normal,
                                              ),
                                            )
                                          : Icon(Icons.lock,
                                              color: Colors.white, size: 44),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                        childCount: totalLevels,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ----------
// import 'package:flutter/material.dart';
// import 'dart:math';
//
// import 'lesson.dart';
// import 'constants.dart';
//
// // Define the icon and color for locked levels
// const Icon lockedIcon = Icon(Icons.lock, color: Colors.red);
// const Color lockedColor = Colors.grey;
// const Color unlockedColor = Colors.lightBlueAccent;
// const Color currentLevelColor = Colors.greenAccent;
//
// class LevelsPage extends StatefulWidget {
//   @override
//   _LevelsPageState createState() => _LevelsPageState();
// }
//
// class _LevelsPageState extends State<LevelsPage> with TickerProviderStateMixin {
//   final List<AnimationController> _controllers = [];
//   final List<Animation<double>> _animations = [];
//
//   @override
//   void initState() {
//     super.initState();
//
//     // Initialize animation controllers and animations for each item
//     for (int i = 0; i < Total_levels; i++) {
//       final controller = AnimationController(
//         duration: const Duration(milliseconds: Duration_of_the_animation),
//         vsync: this,
//       );
//       final animation = Tween<double>(begin: 0.0, end: 1.0).animate(controller);
//
//       // Add the controller and animation to the lists
//       _controllers.add(controller);
//       _animations.add(animation);
//
//       // Start animation with a delay
//       Future.delayed(Duration(milliseconds: i * Delay), () {
//         controller.forward();
//       });
//     }
//   }
//
//   @override
//   void dispose() {
//     // Dispose all controllers
//     for (var controller in _controllers) {
//       controller.dispose();
//     }
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Уровни'),
//       ),
//       body: Stack(
//         children: [
//           Positioned.fill(
//             child: Image.asset(
//               "assets/images/background.jpg",
//               fit: BoxFit.cover,
//             ),
//           ),
//           SafeArea(
//             child: Padding(
//               padding: const EdgeInsets.all(0.0),
//               child: CustomScrollView(
//                 slivers: [
//                   SliverPadding(
//                     padding: const EdgeInsets.fromLTRB(00, 20, 0, 100),
//                     sliver: SliverList(
//                       delegate: SliverChildBuilderDelegate(
//                             (context, index) {
//                           // Calculate the position of each square to form a spiral pattern
//                           final angle = (index + 10) * 0.25;
//                           final offsetX = 145 * cos(angle);
//                           final offsetY = 00 * sin(angle);
//
//                           // Determine level state (locked/unlocked)
//                           bool isLocked = index + 1 > currentLevel;
//                           bool isCurrent = index + 1 == currentLevel;
//                           Color color = isCurrent
//                               ? currentLevelColor
//                               : isLocked
//                               ? lockedColor
//                               : unlockedColor;
//
//                           return Transform.translate(
//                             offset: Offset(offsetX, offsetY),
//                             child: FadeTransition(
//                               opacity: _animations[index],
//                               child: GestureDetector(
//                                 onTap: isLocked
//                                     ? null
//                                     : () {
//                                   Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                       builder: (context) => LessonPage(level: index + 1),
//                                     ),
//                                   );
//                                 },
//                                 child: Center(
//                                   child: Container(
//                                     width: 80.0,
//                                     height: 80.0,
//                                     margin: const EdgeInsets.all(20.0),
//                                     decoration: BoxDecoration(
//                                       color: color,
//                                       borderRadius: BorderRadius.circular(80),
//                                       boxShadow: [
//                                         BoxShadow(
//                                           color: Colors.deepOrange.withOpacity(0.25), // Shadow color with transparency
//                                           spreadRadius: 2, // How much the shadow will spread
//                                           blurRadius: 8, // Softness of the shadow
//                                           offset: const Offset(4, 4), // Position of the shadow (x, y)
//                                         ),
//                                       ],
//                                     ),
//                                     child: Center(
//                                       child: isLocked
//                                           ? lockedIcon
//                                           : Text(
//                                         '${index + 1}', // Display the number
//                                         style: const TextStyle(
//                                           color: Colors.white,
//                                           fontSize: 35,
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           );
//                         },
//                         childCount: Total_levels,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
//

// ---------------
// import 'package:flutter/material.dart';
// import 'dart:math';
//
// import 'lesson.dart';
// import 'constants.dart';
//
// class LevelsPage extends StatefulWidget {
//   @override
//   _LevelsPageState createState() => _LevelsPageState();
// }
//
// class _LevelsPageState extends State<LevelsPage> with TickerProviderStateMixin {
//   final List<AnimationController> _controllers = [];
//   final List<Animation<double>> _animations = [];
//
//   @override
//   void initState() {
//     super.initState();
//
//     // Initialize animation controllers and animations for each item
//     for (int i = 1; i <= Total_levels; i++) {
//       final controller = AnimationController(
//         duration: const Duration(milliseconds: Duration_of_the_animation),
//         vsync: this,
//       );
//       final animation = Tween<double>(begin: 0.0, end: 1.0).animate(controller);
//
//       // Add the controller and animation to the lists
//       _controllers.add(controller);
//       _animations.add(animation);
//
//       // Start animation with a delay
//       Future.delayed(Duration(milliseconds: i * Delay), () {
//         controller.forward();
//       });
//     }
//   }
//
//   @override
//   void dispose() {
//     // Dispose all controllers
//     for (var controller in _controllers) {
//       controller.dispose();
//     }
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Уровни'),
//       ),
//       body: Stack(
//         children: [
//           Positioned.fill(
//             child: Image.asset(
//               "assets/images/background.jpg",
//               fit: BoxFit.cover,
//             ),
//           ),
//           SafeArea(
//             child: Padding(
//               padding: const EdgeInsets.all(0.0),
//               child: CustomScrollView(
//                 slivers: [
//                   SliverPadding(
//                     padding: const EdgeInsets.fromLTRB(00, 20, 0, 100),
//                     sliver: SliverList(
//                       delegate: SliverChildBuilderDelegate(
//                             (context, index) {
//                           final level = index + 1;
//                           final isLocked = level > currentLevel;
//
//                           // Calculate the position of each square to form a spiral pattern
//                           final angle = (index + 10) * 0.25;
//                           final offsetX = 145 * cos(angle);
//                           final offsetY = 00 * sin(angle);
//
//                           return Transform.translate(
//                             offset: Offset(offsetX, offsetY),
//                             child: FadeTransition(
//                               opacity: _animations[index],
//                               child: GestureDetector(
//                                 onTap: () {
//                                   if (!isLocked) {
//                                     Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                         builder: (context) => LessonPage(level: level),
//                                       ),
//                                     );
//                                   }
//                                 },
//                                 child: Center(
//                                   child: Container(
//                                     width: 80.0,
//                                     height: 80.0,
//                                     margin: const EdgeInsets.all(20.0),
//                                     decoration: BoxDecoration(
//                                       color: isLocked
//                                           ? Colors.grey // Color for locked levels
//                                           : Colors.lightBlueAccent,
//                                       borderRadius: BorderRadius.circular(80),
//                                       boxShadow: [
//                                         BoxShadow(
//                                           color: Colors.deepOrange.withOpacity(0.25),
//                                           spreadRadius: 2,
//                                           blurRadius: 8,
//                                           offset: const Offset(4, 4),
//                                         ),
//                                       ],
//                                     ),
//                                     child: Center(
//                                       child: Stack(
//                                         children: [
//                                           if (isLocked)
//                                             Positioned.fill(
//                                               child: Align(
//                                                 alignment: Alignment.center,
//                                                 child: Icon(
//                                                   Icons.lock,
//                                                   color: Colors.white,
//                                                   size: 30,
//                                                 ),
//                                               ),
//                                             ),
//                                           Center(
//                                             child: Text(
//                                               '$level', // Display the number
//                                               style: TextStyle(
//                                                 color: isLocked ? Colors.black38 : Colors.white,
//                                                 fontSize: 35,
//                                               ),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           );
//                         },
//                         childCount: Total_levels,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// ---------------
//
// import 'package:flutter/material.dart';
// import 'dart:math';
//
// import 'lesson.dart';
// import 'constants.dart';
//
// class LevelsPage extends StatefulWidget {
//   @override
//   _LevelsPageState createState() => _LevelsPageState();
// }
//
// class _LevelsPageState extends State<LevelsPage> with TickerProviderStateMixin {
//   final List<AnimationController> _controllers = [];
//   final List<Animation<double>> _animations = [];
//
//   @override
//   void initState() {
//     super.initState();
//
//     // Initialize animation controllers and animations for each item
//     for (int i = currentLevel; i < Total_levels; i++) {
//       final controller = AnimationController(
//         duration: const Duration(milliseconds: Duration_of_the_animation),
//         vsync: this,
//       );
//       final animation = Tween<double>(begin: 0.0, end: 1.0).animate(controller);
//
//       // Add the controller and animation to the lists
//       _controllers.add(controller);
//       _animations.add(animation);
//
//       // Start animation with a delay
//       Future.delayed(Duration(milliseconds: i * Delay), () {
//         controller.forward();
//       });
//     }
//   }
//
//   @override
//   void dispose() {
//     // Dispose all controllers
//     for (var controller in _controllers) {
//       controller.dispose();
//     }
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Уровни'),
//       ),
//       body: Stack(
//         children: [
//           Positioned.fill(
//               child: Image.asset(
//                   // "background.jpg",
//                   "assets/images/background.jpg",
//                 fit: BoxFit.cover,
//               ),
//           ),
//         SafeArea(
//           child: Padding(
//             padding: const EdgeInsets.all(0.0),
//             child: CustomScrollView(
//               slivers: [
//                 SliverPadding(
//                   padding: const EdgeInsets.fromLTRB(00, 20, 0, 100),
//                   sliver: SliverList(
//                     delegate: SliverChildBuilderDelegate(
//                           (context, index) {
//                         // Calculate the position of each square to form a spiral pattern
//                         final angle = (index + 10) * 0.25;
//                         final offsetX = 145 * cos(angle);
//                         final offsetY = 00 * sin(angle);
//
//                         return Transform.translate(
//                           offset: Offset(offsetX, offsetY),
//                           child: FadeTransition(
//                             opacity: _animations[index],
//                             child: GestureDetector(
//                               onTap: () {
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (context) => LessonPage(level: index + 1),
//                                   ),
//                                 );
//                               },
//                               child: Center(
//                                 child: Container(
//                                   width: 80.0,
//                                   height: 80.0,
//                                   margin: const EdgeInsets.all(20.0),
//                                   decoration: BoxDecoration(
//                                     color: Colors.lightBlueAccent,
//                                     borderRadius: BorderRadius.circular(80),
//                                     boxShadow: [
//                                       BoxShadow(
//                                       color: Colors.deepOrange.withOpacity(0.25), // Shadow color with transparency
//                                       spreadRadius: 2, // How much the shadow will spread
//                                       blurRadius: 8, // Softness of the shadow
//                                       offset: const Offset(4, 4), // Position of the shadow (x, y)
//                                       ),
//                                     ],
//                                   ),
//                                   child: Center(
//                                     child: Text(
//                                       '${index + 1}', // Display the number
//                                       style: const TextStyle(
//                                         color: Colors.white,
//                                         fontSize: 35,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               )
//
//
//
//
//                               // child: Container(
//                               //   width: 50,
//                               //   // height: 80,
//                               //   margin: const EdgeInsets.all(00.0),
//                               //   decoration: BoxDecoration(
//                               //     color: Colors.lightBlueAccent,
//                               //     borderRadius: BorderRadius.circular(80),
//                               //   ),
//                               //   child: Center(
//                               //     child: Text(
//                               //       '${index + 1}', // Display the number
//                               //       style: const TextStyle(
//                               //         color: Colors.white,
//                               //         fontSize: 35,
//                               //       ),
//                               //     ),
//                               //   ),
//                               // ),
//
//
//
//                             ),
//                           ),
//                         );
//                       },
//                       childCount: Total_levels,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//         ],
//       ),
//     );
//   }
// }
//
//
//
// // --------------
// //
// // import 'package:flutter/material.dart';
// // import 'lesson.dart';
// // import 'constants.dart';
// //
// // class LevelsPage extends StatefulWidget {
// //   @override
// //   _LevelsPageState createState() => _LevelsPageState();
// // }
// //
// // class _LevelsPageState extends State<LevelsPage> with TickerProviderStateMixin {
// //   final List<AnimationController> _controllers = [];
// //   final List<Animation<double>> _animations = [];
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //
// //     // Initialize animation controllers and animations for each item
// //     for (int i = currentLevel; i < Total_levels; i++) {
// //       final controller = AnimationController(
// //         duration: const Duration(milliseconds: Duration_of_the_animation),
// //         vsync: this,
// //       );
// //       final animation = Tween<double>(begin: 0.0, end: 1.0).animate(controller);
// //
// //       // Add the controller and animation to the lists
// //       _controllers.add(controller);
// //       _animations.add(animation);
// //
// //       // Start animation with a delay
// //       Future.delayed(Duration(milliseconds: i * Delay), () {
// //         controller.forward();
// //       });
// //     }
// //   }
// //
// //   @override
// //   void dispose() {
// //     // Dispose all controllers
// //     for (var controller in _controllers) {
// //       controller.dispose();
// //     }
// //     super.dispose();
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     // Determine screen orientation
// //     final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
// //
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text('Уровни'),
// //       ),
// //       body: SafeArea(
// //         child: Padding(
// //           padding: EdgeInsets.symmetric(
// //             horizontal: isPortrait ? 8.0 : 16.0, // Adjust padding for landscape
// //             vertical: isPortrait ? 18.0 : 8.0, // Adjust padding for landscape
// //           ),
// //           child: GridView.builder(
// //             gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
// //               crossAxisCount: isPortrait ? Levels_in_a_line : Levels_in_a_line_landscape, // Change number of columns based on orientation
// //             ),
// //             itemCount: Total_levels, // Total number of squares
// //             itemBuilder: (context, index) {
// //               return FadeTransition(
// //                 opacity: _animations[index],
// //                 child: GestureDetector(
// //                   onTap: () {
// //                     Navigator.push(
// //                       context,
// //                       MaterialPageRoute(
// //                         builder: (context) => LessonPage(level: index + 1),
// //                       ),
// //                     );
// //                   },
// //                   child: Container(
// //                     margin: const EdgeInsets.all(4.0),
// //                     color: Colors.lightBlueAccent,
// //                     // color : Colors.primaries[index % Colors.primaries.length],
// //                     child: Center(
// //                       child: Text(
// //                         '${index + 1}', // Display the number
// //                         style: TextStyle(
// //                           color: Colors.white,
// //                           fontSize: isPortrait ? 30 : 20, // Adjust font size for landscape
// //                         ),
// //                       ),
// //                     ),
// //                   ),
// //                 ),
// //               );
// //             },
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }
// //
