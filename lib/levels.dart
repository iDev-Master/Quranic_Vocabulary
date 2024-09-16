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

