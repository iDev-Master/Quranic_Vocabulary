

import 'dart:math';



final List<List<int>> allQuestions = [
  [1, 1, 1, 1, 1, 1], // test Game
  [1, 2, 3, 4, 5, 6],
];


class GenerateQuestionsIndexes {
  late final int howManyTestQuestions;

  GenerateQuestionsIndexes({
    required this.howManyTestQuestions,
  });

  int generateRandomNumberInRange(int min, int max) {
    final random = Random();
    return min + random.nextInt(max - min + 1);
  }


  List<List<int>> generateQuestionIndexes(int currentLevel) {
    List<List<int>> resultList = [[],[]];
    resultList[0] = generateFirstList(currentLevel);
    resultList[1] = generateSecondList(currentLevel);

    return resultList;
  }


  List<int> generateFirstList(int currentLevel) {
  /*
  Generates a list of int. Length of which is = to howManyTestQuestions
  ~ Half of the list will be equal to currentLevel,
  the other half will be 1 <= numbers <= currentLevel;
  */

    final List<int> allQuestions2 = List.filled(howManyTestQuestions, currentLevel);
    int totalNumQuestion = howManyTestQuestions;
    // switch (currentLevel) {
    //   case 1:
    //   howManyTestQuestions = 2;
    //   break;
    //   case 2:
    //   howManyTestQuestions = 2;
    //   break;
    //   case 3:
    //   howManyTestQuestions = 4;
    //   break;
    //   case 4:
    //   howManyTestQuestions = 4;
    //   break;
    // }

    // if (currentLevel == 1) {
    //   totalNumQuestion = 2;
    // } else if (currentLevel == 2) {
    //   totalNumQuestion = 2;
    // } else if (currentLevel == 3) {
    //   totalNumQuestion = 4;
    // } else if (currentLevel == 4) {
    //   totalNumQuestion = 4;
    // }



    if (currentLevel > 1) {
      int halfQuestions = howManyTestQuestions ~/ 2;

      for (int i = 0; i < halfQuestions; i++) {
        int questionIndex = generateRandomNumberInRange(0, howManyTestQuestions - 1); // Choose a random index
        int previousLevel = generateRandomNumberInRange(1, currentLevel - 1); // Random level from 1 to currentLevel - 1
        allQuestions2[questionIndex] = previousLevel; // Assign previous level question
      }
    }



    return allQuestions2;
  }


  List<int> generateSecondList(int currentLevel) {
  /* This function generates indexes for the Matching Game
  If current level is less than 6, then first X words will be in the game
  if current level is greater than 6, then random questions will be in the game

  Current level's word will replace first word of the list
  */

    List<int> questionsIndexesList = [];

    if (currentLevel <= 6) {
      questionsIndexesList = List.filled(currentLevel, 1);
    }

    if (currentLevel < 1) {
      print("Error while Generating indexses for the second list");
    } else if (currentLevel <= 6) {
      for (int i = 1; i <= currentLevel; i++) {
        questionsIndexesList[i-1] = i;
      }
    } else if (currentLevel <= 125) {
      int j = 0;
      while (questionsIndexesList.length < 6) {
        int aNewElement = generateRandomNumberInRange(1, currentLevel);
        if (!questionsIndexesList.contains(aNewElement)) {
          questionsIndexesList.add(aNewElement);
          j++;
        }
      }
    }

    if (!questionsIndexesList.contains(currentLevel) &&
        questionsIndexesList != 0) {
      questionsIndexesList[0] = currentLevel;
    }

    questionsIndexesList.shuffle();
        return questionsIndexesList;
  }


}












