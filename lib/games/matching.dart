

// --- normal one 2.0

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:quranic_vocabulary/constants.dart';
import '../db.dart'; // Assuming you have a database to fetch words
import '../models.dart'; // Assuming Word is a model with 'word' and 'translation'

class MatchingGame extends StatefulWidget {
  final List<List<int>> questionsIndexes;
  final int lives;
  final int currentLevel;

  const MatchingGame({
    super.key,
    required this.questionsIndexes,
    required this.lives,
    required this.currentLevel,
  });

  @override
  MatchingGameState createState() => MatchingGameState();
}

class MatchingGameState extends State<MatchingGame> {
  final List<dynamic> listQuestions = [];
  final List<dynamic> listAnswers = [];
  int? selectedQuestionIndex; // Track selected question
  int? selectedAnswerIndex; // Track selected answer
  bool isMatched = false; // To track if a match is found
  bool isIncorrect = false; // To track incorrect matches
  bool isProcessingMatch = false; // Track if the game is processing a match
  List<bool> matchedQuestions = []; // Track matched questions
  List<bool> matchedAnswers = []; // Track matched answers
  int myLives = 0;

  @override
  void initState() {
    myLives = widget.lives;
    super.initState();
    _initializeQuestions();
  }

  // Creating two list: words and translations
  Future<void> _initializeQuestions() async {
    final dbHelper = DatabaseHelper();

    for (int i in widget.questionsIndexes[1]) {
      Word? s = await dbHelper.getWord(i);
      if (s != null) {
        listQuestions.add([s.level, s.word]);
        listAnswers.add([s.level, s.ru]);
      }
    }

    listQuestions.shuffle();
    listAnswers.shuffle();

    // Initialize matched tracking lists
    matchedQuestions = List.generate(listQuestions.length, (index) => false);
    matchedAnswers = List.generate(listAnswers.length, (index) => false);

    setState(() {}); // Trigger rebuild after data fetch
  }

  void _checkMatch() {
    if (selectedQuestionIndex != null && selectedAnswerIndex != null) {
      // Block further selections while processing match
      isProcessingMatch = true;

      if (listQuestions[selectedQuestionIndex!][0] ==
          listAnswers[selectedAnswerIndex!][0]) {
        // Correct match
          score++;
        setState(() {
          isMatched = true;
          matchedQuestions[selectedQuestionIndex!] = true;
          matchedAnswers[selectedAnswerIndex!] = true;
        });

        // Delay before clearing selection and removing matched items
        Future.delayed(const Duration(seconds: 1), () {
          setState(() {
            selectedQuestionIndex = null;
            selectedAnswerIndex = null;
            isMatched = false;
            isProcessingMatch = false;
          });
          _checkGameCompletion(); // Check if game is complete
        });
      } else {
        // Incorrect match
        setState(() {
          myLives--;
          isIncorrect = true;
          _endGame();
        });

        // Delay before clearing incorrect selections
        Future.delayed(const Duration(seconds: 1), () {
          setState(() {
            selectedQuestionIndex = null;
            selectedAnswerIndex = null;
            isIncorrect = false;
            isProcessingMatch = false;
          });
        });
      }
    }
  }



  void _endGame() {

    if (myLives == 0) {
      // When a user runs out of lives, redirect to lesson page
      Future.delayed(const Duration(seconds: 1), () {
        Navigator.pop(context);
        // Navigator.pushReplacementNamed(context, '/lesson');
      });
    }

  }
  void _checkGameCompletion() {

    if (matchedQuestions.every((isMatched) => isMatched) &&
        matchedAnswers.every((isMatched) => isMatched)) {

      // All pairs matched, redirect to lesson page
      Future.delayed(const Duration(seconds: 0), () {
        Navigator.pop(context);
        // Navigator.pushReplacementNamed(context, '/lesson');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: const Text('Matching Game'),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Уровень: ${widget.currentLevel} | очки: $score'),
            Row(
              children: List.generate(3, (index) {
                return Icon(
                  index < myLives ? Icons.favorite : Icons.favorite_border,
                  color: Colors.white,
                );
              }),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Row(
            children: [
              // Questions Column
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: listQuestions.asMap().entries.map((i) {
                    int index = i.key;
                    String question = i.value[1];

                    return GestureDetector(
                      onTap: () {
                        if (!matchedQuestions[index] && !isProcessingMatch) {
                          setState(() {
                            selectedQuestionIndex = index;
                            _checkMatch(); // Check for match after selection
                          });
                        }
                      },
                      child: AnimatedOpacity(
                        opacity: matchedQuestions[index] ? 0.0 : 1.0,
                        duration: const Duration(milliseconds: 500),
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          padding: const EdgeInsets.all(8.0),
                          height: 80, // Fixed height to ensure consistency
                          decoration: BoxDecoration(
                            color: selectedQuestionIndex == index
                                ? (isMatched
                                ? Colors.green
                                : isIncorrect
                                ? Colors.red
                                : Colors.blue)
                                : Colors.transparent,
                            border: Border.all(color: Colors.blue),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(
                              question,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 40,
                                fontFamily: 'quranic',
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(width: 16.0), // Space between columns

              // Answers Column
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: listAnswers.asMap().entries.map((i) {
                    int index = i.key;
                    String answer = i.value[1];

                    return GestureDetector(
                      onTap: () {
                        if (!matchedAnswers[index] && !isProcessingMatch) {
                          setState(() {
                            selectedAnswerIndex = index;
                            _checkMatch(); // Check for match after selection
                          });
                        }
                      },
                      child: AnimatedOpacity(
                        opacity: matchedAnswers[index] ? 0.0 : 1.0,
                        duration: const Duration(milliseconds: 500),
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          padding: const EdgeInsets.all(8.0),
                          height: 80, // Fixed height to ensure consistency
                          decoration: BoxDecoration(
                            color: selectedAnswerIndex == index
                                ? (isMatched
                                ? Colors.green
                                : isIncorrect
                                ? Colors.red
                                : Colors.blue.shade200)
                                : Colors.transparent,
                            border: Border.all(color: Colors.blue),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(
                              answer,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 22,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}




// --------
// import 'dart:async';
// import 'package:flutter/material.dart';
// import '../db.dart'; // Assuming you have a database to fetch words
// import '../models.dart'; // Assuming Word is a model with 'word' and 'translation'
//
// class MatchingGame extends StatefulWidget {
//   final List<List<int>> questionsIndexes;
//
//   const MatchingGame({super.key, required this.questionsIndexes});
//
//   @override
//   MatchingGameState createState() => MatchingGameState();
// }
//
// class MatchingGameState extends State<MatchingGame> {
//   final List<dynamic> listQuestions = [];
//   final List<dynamic> listAnswers = [];
//   int? selectedQuestionIndex; // Track selected question
//   int? selectedAnswerIndex; // Track selected answer
//   bool isMatched = false; // To track if a match is found
//   bool isIncorrect = false; // To track incorrect matches
//   List<bool> matchedQuestions = []; // Track matched questions
//   List<bool> matchedAnswers = []; // Track matched answers
//
//   @override
//   void initState() {
//     super.initState();
//     _initializeQuestions();
//   }
//
//   Future<void> _initializeQuestions() async {
//     final dbHelper = DatabaseHelper();
//
//     for (int i in widget.questionsIndexes[1]) {
//       Word? s = await dbHelper.getWord(i);
//       if (s != null) {
//         listQuestions.add([s.level, s.word]);
//         listAnswers.add([s.level, s.ru]);
//       }
//     }
//
//     listQuestions.shuffle();
//     listAnswers.shuffle();
//
//     // Initialize matched tracking lists
//     matchedQuestions = List.generate(listQuestions.length, (index) => false);
//     matchedAnswers = List.generate(listAnswers.length, (index) => false);
//
//     setState(() {}); // Trigger rebuild after data fetch
//   }
//
//   void _checkMatch() {
//     if (selectedQuestionIndex != null && selectedAnswerIndex != null) {
//       if (listQuestions[selectedQuestionIndex!][0] ==
//           listAnswers[selectedAnswerIndex!][0]) {
//         // Correct match
//         setState(() {
//           isMatched = true;
//           matchedQuestions[selectedQuestionIndex!] = true;
//           matchedAnswers[selectedAnswerIndex!] = true;
//         });
//         Future.delayed(const Duration(seconds: 1), () {
//           setState(() {
//             selectedQuestionIndex = null;
//             selectedAnswerIndex = null;
//             isMatched = false;
//           });
//         });
//       } else {
//         // Incorrect match, highlight in red, then reset selections after delay
//         setState(() {
//           isIncorrect = true;
//         });
//         Future.delayed(const Duration(seconds: 1), () {
//           setState(() {
//             selectedQuestionIndex = null;
//             selectedAnswerIndex = null;
//             isIncorrect = false;
//           });
//         });
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Matching Game'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Center(
//           child: Row(
//             children: [
//               Expanded(
//                 child: Column(
//                   mainAxisAlignment: listQuestions.length == 1
//                       ? MainAxisAlignment.center
//                       : MainAxisAlignment.start,
//                   children: listQuestions.asMap().entries.map((i) {
//                     int index = i.key;
//                     String question = i.value[1];
//
//                     return GestureDetector(
//                       onTap: () {
//                         if (!matchedQuestions[index]) {
//                           setState(() {
//                             selectedQuestionIndex = index;
//                             _checkMatch(); // Check for match after selection
//                           });
//                         }
//                       },
//                       child: AnimatedOpacity(
//                         opacity: matchedQuestions[index] ? 0.0 : 1.0,
//                         duration: const Duration(milliseconds: 500),
//                         child: Container(
//                           margin: const EdgeInsets.symmetric(vertical: 8.0),
//                           padding: const EdgeInsets.all(8.0),
//                           height: 80, // Fixed height to ensure consistency
//                           // width: 80, // Fixed width to ensure consistency
//                           decoration: BoxDecoration(
//                             color: selectedQuestionIndex == index
//                                 ? (isMatched
//                                 ? Colors.green
//                                 : isIncorrect
//                                 ? Colors.red
//                                 : Colors.blue)
//                                 : Colors.transparent,
//                             border: Border.all(color: Colors.blue),
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                           child: Center(
//                             child: Text(
//                               question,
//                               style: const TextStyle(
//                                 color: Colors.black,
//                                 fontSize: 40,
//                                 fontFamily: 'quranic',
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     );
//                   }).toList(),
//                 ),
//               ),
//               const SizedBox(width: 16.0),
//               Expanded(
//                 child: Column(
//                   mainAxisAlignment: listAnswers.length == 1
//                       ? MainAxisAlignment.center
//                       : MainAxisAlignment.start,
//                   children: listAnswers.asMap().entries.map((i) {
//                     int index = i.key;
//                     String answer = i.value[1];
//
//                     return GestureDetector(
//                       onTap: () {
//                         if (!matchedAnswers[index]) {
//                           setState(() {
//                             selectedAnswerIndex = index;
//                             _checkMatch(); // Check for match after selection
//                           });
//                         }
//                       },
//                       child: AnimatedOpacity(
//                         opacity: matchedAnswers[index] ? 0.0 : 1.0,
//                         duration: const Duration(milliseconds: 500),
//                         child: Container(
//                           margin: const EdgeInsets.symmetric(vertical: 8.0),
//                           padding: const EdgeInsets.all(8.0),
//                           height: 80, // Fixed height to ensure consistency
//                           // width: 80, // Fixed width to ensure consistency
//                           decoration: BoxDecoration(
//                             color: selectedAnswerIndex == index
//                                 ? (isMatched
//                                 ? Colors.green
//                                 : isIncorrect
//                                 ? Colors.red
//                                 : Colors.blue.shade200)
//                                 : Colors.transparent,
//                             border: Border.all(color: Colors.blue),
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                           child: Center(
//                             child: Text(
//                               answer,
//                               style: const TextStyle(
//                                 color: Colors.black,
//                                 fontSize: 22,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     );
//                   }).toList(),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
//
// // -----------
// // import 'dart:async';
// // import 'package:flutter/material.dart';
// // import '../db.dart'; // Assuming you have a database to fetch words
// // import '../models.dart'; // Assuming Word is a model with 'word' and 'translation'
// // import '../constants.dart';
// //
// //
// // class MatchingGame extends StatefulWidget {
// //   final List<List<int>> questionsIndexes;
// //
// //   const MatchingGame({super.key, required this.questionsIndexes});
// //
// //   @override
// //   MatchingGameState createState() => MatchingGameState();
// // }
// //
// // class MatchingGameState extends State<MatchingGame> {
// //   final List<dynamic> listQuestions = [];
// //   final List<dynamic> listAnswers = [];
// //   int? selectedQuestionIndex; // Track selected question
// //   int? selectedAnswerIndex; // Track selected answer
// //   bool isMatched = false; // To track if a match is found
// //   bool isIncorrect = false; // To track incorrect matches
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     _initializeQuestions();
// //   }
// //
// //   Future<void> _initializeQuestions() async {
// //     final dbHelper = DatabaseHelper();
// //
// //     for (int i in widget.questionsIndexes[1]) {
// //       Word? s = await dbHelper.getWord(i);
// //       if (s != null) {
// //         listQuestions.add([s.level, s.word]);
// //         listAnswers.add([s.level, s.ru]);
// //       }
// //     }
// //
// //     listQuestions.shuffle();
// //     listAnswers.shuffle();
// //
// //     setState(() {}); // Trigger rebuild after data fetch
// //   }
// //
// //   void _checkMatch() {
// //     if (selectedQuestionIndex != null && selectedAnswerIndex != null) {
// //       if (listQuestions[selectedQuestionIndex!][0] ==
// //           listAnswers[selectedAnswerIndex!][0]) {
// //         // Correct match, highlight in green, then remove after delay
// //         setState(() {
// //           isMatched = true;
// //         });
// //         Future.delayed(const Duration(seconds: 1), () {
// //           setState(() {
// //             listQuestions.removeAt(selectedQuestionIndex!);
// //             listAnswers.removeAt(selectedAnswerIndex!);
// //             selectedQuestionIndex = null;
// //             selectedAnswerIndex = null;
// //             isMatched = false;
// //           });
// //         });
// //       } else {
// //         // Incorrect match, highlight in red, then reset selections after delay
// //         setState(() {
// //           isIncorrect = true;
// //         });
// //         Future.delayed(const Duration(seconds: 1), () {
// //           setState(() {
// //             selectedQuestionIndex = null;
// //             selectedAnswerIndex = null;
// //             isIncorrect = false;
// //           });
// //         });
// //       }
// //     }
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: Colors.white,
// //       appBar: AppBar(
// //         title: Row(
// //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //           children: [
// //             // Text('Уровень: ${widget.theWord.level}'),
// //             Row(
// //               children: List.generate(3, (index) {
// //                 return Icon(
// //                   index < lives ? Icons.favorite : Icons.favorite_border,
// //                   color: Colors.white,
// //                 );
// //               }),
// //             ),
// //           ],
// //         ),
// //       ),
// //
// //       // return Scaffold(
// //       //   appBar: AppBar(
// //       //     title: const Text('Matching Game'),
// //       //   ),
// //       body: Padding(
// //         padding: const EdgeInsets.all(16.0),
// //         child: Center(
// //           child: Row(
// //             children: [
// //               Expanded(
// //                 child: Column(
// //                   mainAxisAlignment: listQuestions.length == 1
// //                       ? MainAxisAlignment.center
// //                       : MainAxisAlignment.start,
// //                   children: listQuestions.asMap().entries.map((i) {
// //                     int index = i.key;
// //                     String question = i.value[1];
// //
// //                     return GestureDetector(
// //                       onTap: () {
// //                         setState(() {
// //                           selectedQuestionIndex = index;
// //                           _checkMatch(); // Check for match after selection
// //                         });
// //                       },
// //                       child: Container(
// //                         margin: const EdgeInsets.symmetric(vertical: 8.0),
// //                         padding: const EdgeInsets.all(16.0),
// //                         decoration: BoxDecoration(
// //                           color: selectedQuestionIndex == index
// //                               ? (isMatched
// //                                   ? Colors.green
// //                                   : isIncorrect
// //                                       ? Colors.red
// //                                       : Colors.blue)
// //                               : Colors.transparent,
// //                           border: Border.all(color: Colors.blue),
// //                           borderRadius: BorderRadius.circular(10),
// //                         ),
// //                         child: Center(
// //                           child: Text(
// //                             question,
// //                             style: const TextStyle(
// //                               color: Colors.black,
// //                               fontSize: 32,
// //                               fontFamily: 'quranic',
// //                             ),
// //                           ),
// //                         ),
// //                       ),
// //                     );
// //                   }).toList(),
// //                 ),
// //               ),
// //               const SizedBox(width: 16.0),
// //               Expanded(
// //                 child: Column(
// //                   mainAxisAlignment: listAnswers.length == 1
// //                       ? MainAxisAlignment.center
// //                       : MainAxisAlignment.start,
// //                   children: listAnswers.asMap().entries.map((i) {
// //                     int index = i.key;
// //                     String answer = i.value[1];
// //
// //                     return GestureDetector(
// //                       onTap: () {
// //                         setState(() {
// //                           selectedAnswerIndex = index;
// //                           _checkMatch(); // Check for match after selection
// //                         });
// //                       },
// //                       child: Container(
// //                         margin: const EdgeInsets.symmetric(vertical: 8.0),
// //                         padding: const EdgeInsets.all(16.0),
// //                         decoration: BoxDecoration(
// //                           color: selectedAnswerIndex == index
// //                               ? (isMatched
// //                                   ? Colors.green
// //                                   : isIncorrect
// //                                       ? Colors.red
// //                                       : Colors.blue.shade200)
// //                               : Colors.transparent,
// //                           border: Border.all(color: Colors.blue),
// //                           borderRadius: BorderRadius.circular(10),
// //                         ),
// //                         child: Center(
// //                           child: Text(
// //                             answer,
// //                             style: const TextStyle(
// //                               color: Colors.black,
// //                               fontSize: 32,
// //                             ),
// //                           ),
// //                         ),
// //                       ),
// //                     );
// //                   }).toList(),
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }
// //
// // // ------- stable 1/.0
// // // import 'package:flutter/material.dart';
// // // import '../db.dart'; // Assuming you have a database to fetch words
// // // import '../models.dart'; // Assuming Word is a model with 'word' and 'translation'
// // //
// // // class MatchingGame extends StatefulWidget {
// // //   final List<List<int>> questionsIndexes;
// // //
// // //   const MatchingGame({super.key, required this.questionsIndexes});
// // //
// // //   @override
// // //   MatchingGameState createState() => MatchingGameState();
// // // }
// // //
// // // class MatchingGameState extends State<MatchingGame> {
// // //   final List<dynamic> listQuestions = [];
// // //   final List<dynamic> listAnswers = [];
// // //   int? selectedQuestionIndex; // Track selected question
// // //   int? selectedAnswerIndex; // Track selected answer
// // //
// // //   @override
// // //   void initState() {
// // //     super.initState();
// // //     _initializeQuestions();
// // //   }
// // //
// // //   Future<void> _initializeQuestions() async {
// // //     final dbHelper = DatabaseHelper();
// // //
// // //     for (int i in widget.questionsIndexes[1]) {
// // //       Word? s = await dbHelper.getWord(i);
// // //       if (s != null) {
// // //         listQuestions.add([s.level, s.word]);
// // //         listAnswers.add([s.level, s.ru]);
// // //       }
// // //     }
// // //
// // //     listQuestions.shuffle();
// // //     listAnswers.shuffle();
// // //
// // //     setState(() {}); // Trigger rebuild after data fetch
// // //   }
// // //
// // //   void _checkMatch() {
// // //     if (selectedQuestionIndex != null && selectedAnswerIndex != null) {
// // //       // Check if both selected items match (level matches)
// // //       if (listQuestions[selectedQuestionIndex!][0] ==
// // //           listAnswers[selectedAnswerIndex!][0]) {
// // //         // Correct match, remove them or mark as matched
// // //         listQuestions.removeAt(selectedQuestionIndex!);
// // //         listAnswers.removeAt(selectedAnswerIndex!);
// // //       }
// // //       // Reset selections
// // //       selectedQuestionIndex = null;
// // //       selectedAnswerIndex = null;
// // //     }
// // //   }
// // //
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Scaffold(
// // //       appBar: AppBar(
// // //         title: const Text('Matching Game'),
// // //       ),
// // //       body: Padding(
// // //         padding: const EdgeInsets.all(16.0),
// // //         child: Center(
// // //           child: Row(
// // //             children: [
// // //               Expanded(
// // //                 child: Column(
// // //                   mainAxisAlignment: listQuestions.length == 1
// // //                       ? MainAxisAlignment.center
// // //                       : MainAxisAlignment.start,
// // //                   children: listQuestions.asMap().entries.map((i) {
// // //                     int index = i.key;
// // //                     String question = i.value[1];
// // //
// // //                     return GestureDetector(
// // //                       onTap: () {
// // //                         setState(() {
// // //                           selectedQuestionIndex = index;
// // //                           _checkMatch(); // Check for match after selection
// // //                         });
// // //                       },
// // //                       child: Container(
// // //                         margin: const EdgeInsets.symmetric(vertical: 8.0),
// // //                         padding: const EdgeInsets.all(16.0),
// // //                         decoration: BoxDecoration(
// // //                           color: selectedQuestionIndex == index
// // //                               ? Colors.blue
// // //                               : Colors.transparent,
// // //                           border: Border.all(color: Colors.blue),
// // //                           borderRadius: BorderRadius.circular(10),
// // //                         ),
// // //                         child: Center(
// // //                           child: Text(
// // //                             question,
// // //                             style: const TextStyle(
// // //                               color: Colors.black,
// // //                               fontSize: 32,
// // //                               fontFamily: 'quranic',
// // //                             ),
// // //                           ),
// // //                         ),
// // //                       ),
// // //                     );
// // //                   }).toList(),
// // //                 ),
// // //               ),
// // //               const SizedBox(width: 16.0),
// // //               Expanded(
// // //                 child: Column(
// // //                   mainAxisAlignment: listAnswers.length == 1
// // //                       ? MainAxisAlignment.center
// // //                       : MainAxisAlignment.start,
// // //                   children: listAnswers.asMap().entries.map((i) {
// // //                     int index = i.key;
// // //                     String answer = i.value[1];
// // //
// // //                     return GestureDetector(
// // //                       onTap: () {
// // //                         setState(() {
// // //                           selectedAnswerIndex = index;
// // //                           _checkMatch(); // Check for match after selection
// // //                         });
// // //                       },
// // //                       child: Container(
// // //                         margin: const EdgeInsets.symmetric(vertical: 8.0),
// // //                         padding: const EdgeInsets.all(16.0),
// // //                         decoration: BoxDecoration(
// // //                           color: selectedAnswerIndex == index
// // //                               ? Colors.blue.shade200
// // //                               : Colors.transparent,
// // //                           border: Border.all(color: Colors.blue),
// // //                           borderRadius: BorderRadius.circular(10),
// // //                         ),
// // //                         child: Center(
// // //                           child: Text(
// // //                             answer,
// // //                             style: const TextStyle(
// // //                               color: Colors.black,
// // //                               fontSize: 32,
// // //                             ),
// // //                           ),
// // //                         ),
// // //                       ),
// // //                     );
// // //                   }).toList(),
// // //                 ),
// // //               ),
// // //             ],
// // //           ),
// // //         ),
// // //       ),
// // //     );
// // //   }
// // // }
// // //
