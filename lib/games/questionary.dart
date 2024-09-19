

import 'package:flutter/material.dart';
import 'dart:math';


// questionary.dart

final List<List<int>> allQuestions = [
  [1, 1, 1, 1, 1, 1], // test Game
  [1, 2, 3, 4, 5, 6],
];


class GenerateQuestionsIndexes {
  late final int howManyQuestions;

  GenerateQuestionsIndexes({
    required this.howManyQuestions,
  });

  int generateRandomNumberInRange(int min, int max) {
    final random = Random();
    return min + random.nextInt(max - min + 1);
  }


  List<List<int>> generateFirstList(int currentLevel) {
    final List<List<int>> allQuestions2 = [List.filled(howManyQuestions, currentLevel)];

    // Replace half the questions with questions from previous levels only if currentLevel > 1
    if (currentLevel > 1) {
      int halfQuestions = howManyQuestions ~/ 2;

      for (int i = 0; i < halfQuestions; i++) {
        int questionIndex = generateRandomNumberInRange(0, howManyQuestions - 1); // Choose a random index
        int previousLevel = generateRandomNumberInRange(1, currentLevel - 1); // Random level from 1 to currentLevel - 1
        allQuestions2[0][questionIndex] = previousLevel; // Assign previous level question
      }
    }

    return allQuestions2;
  }

}












