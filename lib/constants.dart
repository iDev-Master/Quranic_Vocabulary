// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';

const int totalLevels = 125;
// const int Levels_in_a_line = 5;
// const int Levels_in_a_line_landscape = 10;
const int Duration_of_the_animation = 500;
const int menuAnimationDelay = 20;

double progress = 0.3;
int currentLevel = 9;
int score = 0;
int lives = 3;

// STYLES OF MENU PAGE
final ButtonStyle menuButtonsTheme = ElevatedButton.styleFrom(
    backgroundColor: Colors.blue,
    // backgroundColor: Color(0xff205493),
    foregroundColor: Colors.white,
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
    textStyle: const TextStyle(
      fontSize: 30,
    ),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)));



// STYLES OF LEVELS PAGE
const Color levelUnlockedStyle = Colors.lightBlueAccent;
const Color levelLockedStyle = Colors.amberAccent;
const Color currentLevelStyle = Colors.grey;



// STYLES OF GAMES PAGE
// Test
int testDuration = 20;
int totalTests = 6;

