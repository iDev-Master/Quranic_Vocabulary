

import 'package:flutter/material.dart';
import 'dart:math';
import 'lesson.dart';
import 'constants.dart';
import 'games/questionary.dart';

class LevelsPage extends StatefulWidget {
  @override
  _LevelsPageState createState() => _LevelsPageState();
}

class _LevelsPageState extends State<LevelsPage> with TickerProviderStateMixin {
  final List<AnimationController> _controllers = [];
  final List<Animation<double>> _animations = [];
  final ScrollController _scrollController = ScrollController(); // Scroll controller for positioning

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

    // Scroll to show the current level slightly above the middle of the screen
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Define how many previous levels should be visible (e.g., 3 levels before current one)
      final double offset = max(0, (currentLevel - 3) * 135.0); // Assume 120px height per level
      _scrollController.animateTo(
        offset,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  // void changeLevel() {
  //   if (score >= 10 && currentLevel == 9) {
  //     currentLevel++;
  //   } else if (score >= 20 && currentLevel == 10) {
  //     currentLevel++;
  //   }
  //
  //   // if (score > 20) {
  //   //   currentLevel++;
  //   // } else if (score > 30) {
  //   //   currentLevel++;
  //   // } else if (score > 40) {
  //   //   currentLevel++;
  //   // } else if (score > 50) {
  //   //   currentLevel++;
  //   // }
  // }

  @override
  void dispose() {
    // Dispose all controllers and scroll controller
    for (var controller in _controllers) {
      controller.dispose();
    }
    _scrollController.dispose();
    super.dispose();
  }

  // Function to show a non-blocking pop-up message
  void _showLockedLevelMessage(int level) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        bottom: 60.0, // 60 points from the bottom
        left: MediaQuery.of(context).size.width * 0.1, // Center horizontally with padding
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8, // 80% of screen width
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5), // Set opacity to 0.5
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              'Pass level $level to open this level',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
        ),
      ),
    );

    // Insert the overlay entry into the Overlay
    overlay.insert(overlayEntry);

    // Remove the overlay after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      overlayEntry.remove();
    });
  }

  // var questionIndexGenerator = GenerateQuestionsIndexes(howManyTestQuestions: totalTests);

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
              "assets/images/background.jpg",
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(0.0),
              child: CustomScrollView(
                controller: _scrollController, // Scroll controller for positioning
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

                                        builder: (context) => LessonPage(
                                          level: index + 1,
                                          // questionsIndexes: questionIndexGenerator.generateQuestionIndexes(index + 1),
                                          // allQuestions: questionIndexGenerator.generateFirstList(index + 1),
                                        ),
                                      ),
                                    );
                                  } else {
                                    _showLockedLevelMessage(currentLevel); // Show the pop-up message
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
                                          color: isUnlocked
                                              ? (isCurrent
                                              ? levelLockedStyle.withOpacity(0.25)
                                              : levelUnlockedStyle.withOpacity(0.25))
                                              : currentLevelStyle.withOpacity(0.25),
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
                                          : const Icon(
                                        Icons.lock,
                                        color: Colors.white,
                                        size: 44,
                                      ),
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

