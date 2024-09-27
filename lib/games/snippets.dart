// //
// //
// // // ------- updating now
// // import 'dart:async';
// // import 'dart:math';
// // import 'package:flutter/material.dart';
// // import 'package:audioplayers/audioplayers.dart';
// // import '../constants.dart';
// // import '../models.dart';
// // import '../custom_widgets.dart';
// //
// // class TestGame extends StatefulWidget {
// //   final List<List<int>> allQuestions;
// //   final Word theWord;
// //   late final int currentLevel;
// //
// //   TestGame({
// //     required this.theWord,
// //     required this.currentLevel,
// //     required this.allQuestions
// //   });
// //
// //   @override
// //   late List<Word> _listOfWords; // Store answers and their correctness
// //   // getWord(allQue)
// //
// //
// //   @override
// //   _TestGameState createState() => _TestGameState();
// //
// //
// // }
// //
// // class _TestGameState extends State<TestGame> with TickerProviderStateMixin {
// //   int _answerCount = 0;
// //   int lives = 3; // Start with three lives
// //   bool _isAnswering = false;
// //   String _feedbackMessage = '';
// //   int? _selectedButtonIndex; // Track which button was pressed
// //   final AudioPlayer _audioPlayer = AudioPlayer(); // AudioPlayer instance
// //   late AnimationController _animationController;
// //   late Animation<Offset> _slideAnimation;
// //   late Color _messageBackgroundColor; // Background color for feedback message
// //   late List<Map<String, dynamic>> _shuffledAnswers; // Store answers and their correctness
// //
// //
// //   late List<Word> _listOfWords; // Store answers and their correctness
// //
// //
// //   final _random = Random(); // Random generator
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     _animationController = AnimationController(
// //       vsync: this,
// //       duration: const Duration(milliseconds: 500),
// //     );
// //     _slideAnimation = Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
// //         .animate(CurvedAnimation(
// //       parent: _animationController,
// //       curve: Curves.easeInOut,
// //     ));
// //
// //     _shuffleAnswers(); // Shuffle answers on page load
// //   }
// //
// //   // Function to shuffle the answers
// //   void _shuffleAnswers() {
// //     // Create a list of answer options (correct + incorrect answers)
// //     _shuffledAnswers = [
// //       {'text': widget.theWord.ru, 'isCorrect': true}, // Correct answer
// //       {'text': 'Answer 2', 'isCorrect': false},
// //       {'text': 'Answer 3', 'isCorrect': false},
// //       {'text': 'Answer 4', 'isCorrect': false},
// //     ];
// //
// //     // Shuffle the list
// //     _shuffledAnswers.shuffle();
// //   }
// //
// //   Future<void> _playSound(bool isCorrect) async {
// //     String sound = isCorrect
// //         ? 'assets/sounds/correct.mp3'
// //         : 'assets/sounds/incorrect.mp3';
// //     await _audioPlayer.play(AssetSource(sound)); // Play sound from assets
// //   }
// //
// //   void _endGame() {
// //     Navigator.pop(context);
// //   }
// //
// //   void _answerQuestion(bool isCorrect, int index) {
// //     if (_isAnswering) return;
// //
// //     setState(() {
// //       _isAnswering = true;
// //       // Choose a random feedback message from the correct or incorrect lists
// //       _feedbackMessage = isCorrect
// //           ? FeedbackMessages.correctMessages[_random.nextInt(FeedbackMessages.correctMessages.length)]
// //           : FeedbackMessages.incorrectMessages[_random.nextInt(FeedbackMessages.incorrectMessages.length)];
// //
// //       _selectedButtonIndex = index; // Mark the button pressed
// //       _messageBackgroundColor = isCorrect ? Colors.green.shade900 : Colors.red.shade900; // Set message background color
// //     });
// //
// //     _playSound(isCorrect);
// //     _animationController.forward();
// //
// //     Timer(const Duration(seconds: 2), () {
// //       setState(() {
// //         _isAnswering = false;
// //         _feedbackMessage = '';
// //         _selectedButtonIndex = null; // Reset the button selection
// //       });
// //       _animationController.reset();
// //
// //       if (isCorrect) {
// //         score++;
// //       } else {
// //         lives--;
// //         if (lives <= 0) {
// //           _endGame();
// //           return;
// //         }
// //       }
// //
// //       _answerCount++;
// //       if (_answerCount < 6) {
// //         _shuffleAnswers(); // Shuffle answers for the next question
// //       } else {
// //         if (score / 10 > widget.currentLevel) {
// //           widget.currentLevel++;
// //         }
// //         Navigator.pop(context);
// //       }
// //     });
// //   }
// //
// //   @override
// //   void dispose() {
// //     _audioPlayer.dispose(); // Dispose audio player
// //     _animationController.dispose();
// //     super.dispose();
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     final screenWidth = MediaQuery.of(context).size.width;
// //
// //     return Scaffold(
// //       backgroundColor: Colors.white, // Set the screen background to white
// //       appBar: AppBar(
// //         title: Row(
// //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //           children: [
// //             Text('Уровень: ${widget.theWord.level}'),
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
// //       body: Stack(
// //         children: [
// //           Center(
// //             child: Column(
// //               mainAxisAlignment: MainAxisAlignment.center,
// //               children: [
// //                 Text(
// //                   widget.theWord.word,
// //                   style: const TextStyle(fontSize: 80, fontFamily: 'quranic'), // Use Roboto
// //                 ),
// //                 const SizedBox(height: 25),
// //                 const Text(
// //                   "Выберите правильный перевод:",
// //                   style: TextStyle(fontSize: 18),
// //                 ),
// //                 const SizedBox(height: 15),
// //                 // Build answer buttons from the shuffled list
// //                 ..._shuffledAnswers.asMap().entries.map((entry) {
// //                   int index = entry.key;
// //                   Map<String, dynamic> answer = entry.value;
// //                   return _buildAnswerButton(
// //                     answer['text'],
// //                     answer['isCorrect'],
// //                     screenWidth,
// //                     index,
// //                   );
// //                 }).toList(),
// //                 const SizedBox(height: 20),
// //                 Text('Ответов: $_answerCount/6'),
// //                 Text('Очки: $score'),
// //                 const SizedBox(height: 20),
// //               ],
// //             ),
// //           ),
// //           // Modal feedback window at the bottom of the screen
// //           if (_feedbackMessage.isNotEmpty)
// //             Positioned(
// //               left: 0,
// //               right: 0,
// //               bottom: 20, // Position the message at the bottom of the screen
// //               child: SlideTransition(
// //                 position: _slideAnimation,
// //                 child: FeedbackMessages.feedbackMessageWidget(
// //                   _feedbackMessage,
// //                   _messageBackgroundColor,
// //                 ),
// //               ),
// //             ),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   Widget _buildAnswerButton(
// //       String text, bool isCorrect, double screenWidth, int index) {
// //     final isPressed = _selectedButtonIndex == index;
// //
// //     // Determine the button style based on whether the answer is correct or incorrect
// //     Color backgroundColor;
// //     Color borderColor;
// //     Color textColor;
// //
// //     if (isPressed) {
// //       // If the button is pressed, apply the correct or incorrect style
// //       if (isCorrect) {
// //         backgroundColor = Colors.green.shade50;
// //         borderColor = Colors.green;
// //         textColor = Colors.green;
// //       } else {
// //         backgroundColor = Colors.red.shade50;
// //         borderColor = Colors.red;
// //         textColor = Colors.red;
// //       }
// //     } else {
// //       // Default style before any button is pressed
// //       backgroundColor = Colors.white;
// //       borderColor = Colors.grey;
// //       textColor = Colors.black87;
// //     }
// //
// //     return Container(
// //       width: screenWidth * 0.85, // Button width is 85% of the screen
// //       margin: const EdgeInsets.symmetric(vertical: 12),
// //       child: ElevatedButton(
// //         onPressed: _isAnswering ? null : () => _answerQuestion(isCorrect, index),
// //         style: ButtonStyle(
// //           backgroundColor: MaterialStateProperty.all(backgroundColor), // Custom background
// //           side: MaterialStateProperty.all(
// //             BorderSide(color: borderColor, width: 1.5), // Custom border
// //           ),
// //           shape: MaterialStateProperty.all(
// //             RoundedRectangleBorder(
// //               borderRadius: BorderRadius.circular(15), // Rounded corners
// //             ),
// //           ),
// //           elevation: MaterialStateProperty.all(5),
// //         ),
// //         child: Padding(
// //           padding: const EdgeInsets.all(15.0),
// //           child: Text(
// //             text,
// //             style: TextStyle(
// //               color: textColor, // Dynamic text color
// //               fontSize: 30.0,
// //               fontFamily: 'Roboto', // Use Roboto font
// //             ),
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }
// //
//
// // ------- works fine now
// import 'dart:async';
// import 'dart:math';
// import 'package:flutter/material.dart';
// import 'package:audioplayers/audioplayers.dart';
// import '../constants.dart';
// import '../models.dart';
// import '../custom_widgets.dart';
//
// class TestGame extends StatefulWidget {
//   final List<List<int>> allQuestions;
//   final Word theWord;
//   late final int currentLevel;
//   // final int updateUnlockedLevels;
//
//   TestGame({
//     required this.theWord,
//     required this.currentLevel,
//     // required this.updateUnlockedLevels,
//     required this.allQuestions
//   });
//
//   @override
//   _TestGameState createState() => _TestGameState();
// }
//
// class _TestGameState extends State<TestGame> with TickerProviderStateMixin {
//   int _answerCount = 0;
//   int lives = 3; // Start with three lives
//   bool _isAnswering = false;
//   String _feedbackMessage = '';
//   int? _selectedButtonIndex; // Track which button was pressed
//   final AudioPlayer _audioPlayer = AudioPlayer(); // AudioPlayer instance
//   late AnimationController _animationController;
//   late Animation<Offset> _slideAnimation;
//   late Color _messageBackgroundColor; // Background color for feedback message
//   late List<Map<String, dynamic>> _shuffledAnswers; // Store answers and their correctness
//
//   final _random = Random(); // Random generator
//
//   @override
//   void initState() {
//     super.initState();
//     _animationController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 500),
//     );
//     _slideAnimation = Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
//         .animate(CurvedAnimation(
//       parent: _animationController,
//       curve: Curves.easeInOut,
//     ));
//
//     _shuffleAnswers(); // Shuffle answers on page load
//   }
//
//   // Function to shuffle the answers
//   void _shuffleAnswers() {
//     // Create a list of answer options (correct + incorrect answers)
//     _shuffledAnswers = [
//       {'text': widget.theWord.ru, 'isCorrect': true}, // Correct answer
//       {'text': 'Answer 2', 'isCorrect': false},
//       {'text': 'Answer 3', 'isCorrect': false},
//       {'text': 'Answer 4', 'isCorrect': false},
//     ];
//
//     // Shuffle the list
//     _shuffledAnswers.shuffle();
//   }
//
//   Future<void> _playSound(bool isCorrect) async {
//     String sound = isCorrect
//         ? 'assets/sounds/correct.mp3'
//         : 'assets/sounds/incorrect.mp3';
//     await _audioPlayer.play(AssetSource(sound)); // Play sound from assets
//   }
//
//   void _endGame() {
//     Navigator.pop(context);
//   }
//
//   void _answerQuestion(bool isCorrect, int index) {
//     if (_isAnswering) return;
//
//     setState(() {
//       _isAnswering = true;
//       // Choose a random feedback message from the correct or incorrect lists
//       _feedbackMessage = isCorrect
//           ? FeedbackMessages.correctMessages[_random.nextInt(FeedbackMessages.correctMessages.length)]
//           : FeedbackMessages.incorrectMessages[_random.nextInt(FeedbackMessages.incorrectMessages.length)];
//
//       _selectedButtonIndex = index; // Mark the button pressed
//       _messageBackgroundColor = isCorrect ? Colors.green.shade900 : Colors.red.shade900; // Set message background color
//     });
//
//     _playSound(isCorrect);
//     _animationController.forward();
//
//     Timer(const Duration(seconds: 2), () {
//       setState(() {
//         _isAnswering = false;
//         _feedbackMessage = '';
//         _selectedButtonIndex = null; // Reset the button selection
//       });
//       _animationController.reset();
//
//       if (isCorrect) {
//         score++;
//       } else {
//         lives--;
//         if (lives <= 0) {
//           _endGame();
//           return;
//         }
//       }
//
//       _answerCount++;
//       if (_answerCount < 6) {
//         _shuffleAnswers(); // Shuffle answers for the next question
//       } else {
//         if (score / 10 > widget.currentLevel) {
//           widget.currentLevel++;
//         }
//         Navigator.pop(context);
//       }
//     });
//   }
//
//   @override
//   void dispose() {
//     _audioPlayer.dispose(); // Dispose audio player
//     _animationController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//
//     return Scaffold(
//       backgroundColor: Colors.white, // Set the screen background to white
//       appBar: AppBar(
//         title: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text('Уровень: ${widget.theWord.level}'),
//             Row(
//               children: List.generate(3, (index) {
//                 return Icon(
//                   index < lives ? Icons.favorite : Icons.favorite_border,
//                   color: Colors.white,
//                 );
//               }),
//             ),
//           ],
//         ),
//       ),
//       body: Stack(
//         children: [
//           Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text(
//                   widget.theWord.word,
//                   style: const TextStyle(fontSize: 80, fontFamily: 'quranic'), // Use Roboto
//                 ),
//                 const SizedBox(height: 25),
//                 const Text(
//                   "Выберите правильный перевод:",
//                   style: TextStyle(fontSize: 18),
//                 ),
//                 const SizedBox(height: 15),
//                 // Build answer buttons from the shuffled list
//                 ..._shuffledAnswers.asMap().entries.map((entry) {
//                   int index = entry.key;
//                   Map<String, dynamic> answer = entry.value;
//                   return _buildAnswerButton(
//                     answer['text'],
//                     answer['isCorrect'],
//                     screenWidth,
//                     index,
//                   );
//                 }).toList(),
//                 const SizedBox(height: 20),
//                 Text('Ответов: $_answerCount/6'),
//                 Text('Очки: $score'),
//                 const SizedBox(height: 20),
//               ],
//             ),
//           ),
//           // Modal feedback window at the bottom of the screen
//           if (_feedbackMessage.isNotEmpty)
//             Positioned(
//               left: 0,
//               right: 0,
//               bottom: 20, // Position the message at the bottom of the screen
//               child: SlideTransition(
//                 position: _slideAnimation,
//                 child: FeedbackMessages.feedbackMessageWidget(
//                   _feedbackMessage,
//                   _messageBackgroundColor,
//                 ),
//               ),
//             ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildAnswerButton(
//       String text, bool isCorrect, double screenWidth, int index) {
//     final isPressed = _selectedButtonIndex == index;
//
//     // Determine the button style based on whether the answer is correct or incorrect
//     Color backgroundColor;
//     Color borderColor;
//     Color textColor;
//
//     if (isPressed) {
//       // If the button is pressed, apply the correct or incorrect style
//       if (isCorrect) {
//         backgroundColor = Colors.green.shade50;
//         borderColor = Colors.green;
//         textColor = Colors.green;
//       } else {
//         backgroundColor = Colors.red.shade50;
//         borderColor = Colors.red;
//         textColor = Colors.red;
//       }
//     } else {
//       // Default style before any button is pressed
//       backgroundColor = Colors.white;
//       borderColor = Colors.grey;
//       textColor = Colors.black87;
//     }
//
//     return Container(
//       width: screenWidth * 0.85, // Button width is 85% of the screen
//       margin: const EdgeInsets.symmetric(vertical: 12),
//       child: ElevatedButton(
//         onPressed: _isAnswering ? null : () => _answerQuestion(isCorrect, index),
//         style: ButtonStyle(
//           backgroundColor: MaterialStateProperty.all(backgroundColor), // Custom background
//           side: MaterialStateProperty.all(
//             BorderSide(color: borderColor, width: 1.5), // Custom border
//           ),
//           shape: MaterialStateProperty.all(
//             RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(15), // Rounded corners
//             ),
//           ),
//           elevation: MaterialStateProperty.all(5),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(15.0),
//           child: Text(
//             text,
//             style: TextStyle(
//               color: textColor, // Dynamic text color
//               fontSize: 30.0,
//               fontFamily: 'Roboto', // Use Roboto font
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
//
//
//
// // //-------- version 2 Doesn't work properly yet.
// // import 'dart:async';
// // import 'dart:math';
// // import 'package:flutter/material.dart';
// // import 'package:audioplayers/audioplayers.dart';
// // import '../constants.dart';
// // import '../models.dart';
// // import '../custom_widgets.dart';
// // import '../db.dart';
// //
// // class TestGame extends StatefulWidget {
// //   final List<List<int>> allQuestions;
// //   final Word theWord;
// //   late final int currentLevel;
// //
// //   TestGame({
// //     required this.theWord,
// //     required this.currentLevel,
// //     required this.allQuestions
// //   });
// //
// //   @override
// //   _TestGameState createState() => _TestGameState();
// // }
// //
// // class _TestGameState extends State<TestGame> with TickerProviderStateMixin {
// //   int _answerCount = 0;
// //   int lives = 3; // Start with three lives
// //   bool _isAnswering = false;
// //   String _feedbackMessage = '';
// //   int? _selectedButtonIndex; // Track which button was pressed
// //   final AudioPlayer _audioPlayer = AudioPlayer(); // AudioPlayer instance
// //   late AnimationController _animationController;
// //   late Animation<Offset> _slideAnimation;
// //   late Color _messageBackgroundColor; // Background color for feedback message
// //   late List<Map<String, dynamic>> _shuffledAnswers; // Store answers and their correctness
// //
// //   final _random = Random(); // Random generator
// //   late List<Word> _otherWords; // List to hold other words for wrong answers
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     _animationController = AnimationController(
// //       vsync: this,
// //       duration: const Duration(milliseconds: 500),
// //     );
// //     _slideAnimation = Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
// //         .animate(CurvedAnimation(
// //       parent: _animationController,
// //       curve: Curves.easeInOut,
// //     ));
// //
// //     _fetchOtherWords(); // Fetch other words on page load
// //   }
// //
// //   Future<void> _fetchOtherWords() async {
// //     final dbHelper = DatabaseHelper();
// //     final List<Word> allWords = await dbHelper.getWords(); // Fetch all words from DB
// //     List<Word> otherWords = [];
// //
// //     // Exclude the current word and find three different words for wrong answers
// //     for (Word word in allWords) {
// //       if (word.level != widget.theWord.level &&
// //           word.word != widget.theWord.word &&
// //           word.ru != widget.theWord.ru &&
// //           otherWords.length < 3) {
// //         otherWords.add(word);
// //       }
// //     }
// //
// //     setState(() {
// //       _otherWords = otherWords;
// //       _shuffleAnswers(); // Shuffle answers once the other words are fetched
// //     });
// //   }
// //
// //   // Function to shuffle the answers
// //   void _shuffleAnswers() {
// //     // Create a list of answer options (correct + incorrect answers)
// //     _shuffledAnswers = [
// //       {'text': widget.theWord.ru, 'isCorrect': true}, // Correct answer
// //       ..._otherWords.map((word) => {'text': word.ru, 'isCorrect': false}).toList()
// //     ];
// //
// //     // Shuffle the list
// //     _shuffledAnswers.shuffle();
// //   }
// //
// //   Future<void> _playSound(bool isCorrect) async {
// //     String sound = isCorrect
// //         ? 'assets/sounds/correct.mp3'
// //         : 'assets/sounds/incorrect.mp3';
// //     await _audioPlayer.play(AssetSource(sound)); // Play sound from assets
// //   }
// //
// //   void _endGame() {
// //     Navigator.pop(context);
// //   }
// //
// //   void _answerQuestion(bool isCorrect, int index) {
// //     if (_isAnswering) return;
// //
// //     setState(() {
// //       _isAnswering = true;
// //       _feedbackMessage = isCorrect
// //           ? FeedbackMessages.correctMessages[_random.nextInt(FeedbackMessages.correctMessages.length)]
// //           : FeedbackMessages.incorrectMessages[_random.nextInt(FeedbackMessages.incorrectMessages.length)];
// //
// //       _selectedButtonIndex = index; // Mark the button pressed
// //       _messageBackgroundColor = isCorrect ? Colors.green.shade900 : Colors.red.shade900; // Set message background color
// //     });
// //
// //     _playSound(isCorrect);
// //     _animationController.forward();
// //
// //     Timer(const Duration(seconds: 2), () {
// //       setState(() {
// //         _isAnswering = false;
// //         _feedbackMessage = '';
// //         _selectedButtonIndex = null; // Reset the button selection
// //       });
// //       _animationController.reset();
// //
// //       if (isCorrect) {
// //         score++;
// //       } else {
// //         lives--;
// //         if (lives <= 0) {
// //           _endGame();
// //           return;
// //         }
// //       }
// //
// //       _answerCount++;
// //       if (_answerCount < 6) {
// //         _shuffleAnswers(); // Shuffle answers for the next question
// //       } else {
// //         if (score / 10 > widget.currentLevel) {
// //           widget.currentLevel++;
// //         }
// //         Navigator.pop(context);
// //       }
// //     });
// //   }
// //
// //   @override
// //   void dispose() {
// //     _audioPlayer.dispose(); // Dispose audio player
// //     _animationController.dispose();
// //     super.dispose();
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     final screenWidth = MediaQuery.of(context).size.width;
// //
// //     return Scaffold(
// //       backgroundColor: Colors.white, // Set the screen background to white
// //       appBar: AppBar(
// //         title: Row(
// //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //           children: [
// //             Text('Уровень: ${widget.theWord.level}'),
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
// //       body: Stack(
// //         children: [
// //           Center(
// //             child: Column(
// //               mainAxisAlignment: MainAxisAlignment.center,
// //               children: [
// //                 Text(
// //                   widget.theWord.word,
// //                   style: const TextStyle(fontSize: 80, fontFamily: 'quranic'), // Use Roboto
// //                 ),
// //                 const SizedBox(height: 25),
// //                 const Text(
// //                   "Выберите правильный перевод:",
// //                   style: TextStyle(fontSize: 18),
// //                 ),
// //                 const SizedBox(height: 15),
// //                 // Build answer buttons from the shuffled list
// //                 ..._shuffledAnswers.asMap().entries.map((entry) {
// //                   int index = entry.key;
// //                   Map<String, dynamic> answer = entry.value;
// //                   return _buildAnswerButton(
// //                     answer['text'],
// //                     answer['isCorrect'],
// //                     screenWidth,
// //                     index,
// //                   );
// //                 }).toList(),
// //                 const SizedBox(height: 20),
// //                 Text('Ответов: $_answerCount/6'),
// //                 Text('Очки: $score'),
// //                 const SizedBox(height: 20),
// //               ],
// //             ),
// //           ),
// //           // Modal feedback window at the bottom of the screen
// //           if (_feedbackMessage.isNotEmpty)
// //             Positioned(
// //               left: 0,
// //               right: 0,
// //               bottom: 60, // Position the message 60 points above the bottom of the screen
// //               child: SlideTransition(
// //                 position: _slideAnimation,
// //                 child: FeedbackMessages.feedbackMessageWidget(
// //                   _feedbackMessage,
// //                   _messageBackgroundColor,
// //                 ),
// //               ),
// //             ),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   Widget _buildAnswerButton(
// //       String text, bool isCorrect, double screenWidth, int index) {
// //     final isPressed = _selectedButtonIndex == index;
// //
// //     // Determine the button style based on whether the answer is correct or incorrect
// //     Color backgroundColor;
// //     Color borderColor;
// //     Color textColor;
// //
// //     if (isPressed) {
// //       // If the button is pressed, apply the correct or incorrect style
// //       if (isCorrect) {
// //         backgroundColor = Colors.green.shade50;
// //         borderColor = Colors.green;
// //         textColor = Colors.green;
// //       } else {
// //         backgroundColor = Colors.red.shade50;
// //         borderColor = Colors.red;
// //         textColor = Colors.red;
// //       }
// //     } else {
// //       // Default style before any button is pressed
// //       backgroundColor = Colors.white;
// //       borderColor = Colors.grey;
// //       textColor = Colors.black87;
// //     }
// //
// //     return Container(
// //       width: screenWidth * 0.85, // Button width is 85% of the screen
// //       margin: const EdgeInsets.symmetric(vertical: 12),
// //       child: ElevatedButton(
// //         onPressed: _isAnswering ? null : () => _answerQuestion(isCorrect, index),
// //         style: ButtonStyle(
// //           backgroundColor: MaterialStateProperty.all(backgroundColor), // Custom background
// //           side: MaterialStateProperty.all(
// //             BorderSide(color: borderColor, width: 1.5), // Custom border
// //           ),
// //           shape: MaterialStateProperty.all(
// //             RoundedRectangleBorder(
// //               borderRadius: BorderRadius.circular(15), // Rounded corners
// //             ),
// //           ),
// //           elevation: MaterialStateProperty.all(5),
// //         ),
// //         child: Padding(
// //           padding: const EdgeInsets.all(15.0),
// //           child: Text(
// //             text,
// //             style: TextStyle(
// //               color: textColor, // Dynamic text color
// //               fontSize: 30.0,
// //               fontFamily: 'Roboto', // Use Roboto font
// //             ),
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }
// //
// //
// // ----- Method 2
// // import 'dart:async';
// // import 'dart:math';
// // import 'package:flutter/material.dart';
// // import 'package:audioplayers/audioplayers.dart';
// // import '../constants.dart';
// // import '../models.dart';
// // import '../custom_widgets.dart';
// // import '../db.dart'; // Import the database helper
// //
// // class TestGame extends StatefulWidget {
// //   final List<List<int>> allQuestions;
// //   final Word theWord;
// //   late final int currentLevel;
// //
// //   TestGame({
// //     required this.theWord,
// //     required this.currentLevel,
// //     required this.allQuestions
// //   });
// //
// //   @override
// //   _TestGameState createState() => _TestGameState();
// // }
// //
// // class _TestGameState extends State<TestGame> with TickerProviderStateMixin {
// //   int _answerCount = 0;
// //   int lives = 3; // Start with three lives
// //   bool _isAnswering = false;
// //   String _feedbackMessage = '';
// //   int? _selectedButtonIndex; // Track which button was pressed
// //   final AudioPlayer _audioPlayer = AudioPlayer(); // AudioPlayer instance
// //   late AnimationController _animationController;
// //   late Animation<Offset> _slideAnimation;
// //   late Color _messageBackgroundColor; // Background color for feedback message
// //   List<Map<String, dynamic>> _shuffledAnswers = []; // Initialize with an empty list
// //
// //   final _random = Random(); // Random generator
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     _animationController = AnimationController(
// //       vsync: this,
// //       duration: const Duration(milliseconds: 500),
// //     );
// //     _slideAnimation = Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
// //         .animate(CurvedAnimation(
// //       parent: _animationController,
// //       curve: Curves.easeInOut,
// //     ));
// //
// //     _prepareQuestion(); // Prepare answers for the current question
// //   }
// //
// //   // Function to shuffle the answers
// //   Future<void> _prepareQuestion() async {
// //     List<Word> words = [widget.theWord];
// //
// //     // Fetch three unique words for incorrect answers
// //     while (words.length < 4) {
// //       int randomLevel = _random.nextInt(widget.currentLevel) + 1; // Generate random level between 1 and current level
// //       Word word = await _getUniqueWord(randomLevel, words);
// //
// //       if (word != null) {
// //         words.add(word);
// //       }
// //     }
// //
// //     // Create a list of answer options (correct + incorrect answers)
// //     setState(() {
// //       _shuffledAnswers = words.map((word) =>
// //       {'text': word.ru, 'isCorrect': word.level == widget.theWord.level}
// //       ).toList();
// //
// //       // Shuffle the list
// //       _shuffledAnswers.shuffle();
// //     });
// //   }
// //
// //   // Function to get a unique word from the database
// //   Future<Word> _getUniqueWord(int level, List<Word> existingWords) async {
// //     final dbHelper = DatabaseHelper();
// //     Word? word;
// //
// //     do {
// //       word = await dbHelper.getWord(level);
// //     } while (word == null || existingWords.any((w) => w.word == word?.word || w.ru == word?.ru));
// //
// //     return word;
// //   }
// //
// //   Future<void> _playSound(bool isCorrect) async {
// //     String sound = isCorrect
// //         ? 'assets/sounds/correct.mp3'
// //         : 'assets/sounds/incorrect.mp3';
// //     await _audioPlayer.play(AssetSource(sound)); // Play sound from assets
// //   }
// //
// //   void _endGame() {
// //     Navigator.pop(context);
// //   }
// //
// //   void _answerQuestion(bool isCorrect, int index) {
// //     if (_isAnswering) return;
// //
// //     setState(() {
// //       _isAnswering = true;
// //       // Choose a random feedback message from the correct or incorrect lists
// //       _feedbackMessage = isCorrect
// //           ? FeedbackMessages.correctMessages[_random.nextInt(FeedbackMessages.correctMessages.length)]
// //           : FeedbackMessages.incorrectMessages[_random.nextInt(FeedbackMessages.incorrectMessages.length)];
// //
// //       _selectedButtonIndex = index; // Mark the button pressed
// //       _messageBackgroundColor = isCorrect ? Colors.green.shade900 : Colors.red.shade900; // Set message background color
// //     });
// //
// //     _playSound(isCorrect);
// //     _animationController.forward();
// //
// //     Timer(const Duration(seconds: 2), () {
// //       setState(() {
// //         _isAnswering = false;
// //         _feedbackMessage = '';
// //         _selectedButtonIndex = null; // Reset the button selection
// //       });
// //       _animationController.reset();
// //
// //       if (isCorrect) {
// //         score++;
// //       } else {
// //         lives--;
// //         if (lives <= 0) {
// //           _endGame();
// //           return;
// //         }
// //       }
// //
// //       _answerCount++;
// //       if (_answerCount < 6) {
// //         _prepareQuestion(); // Prepare answers for the next question
// //       } else {
// //         if (score / 10 > widget.currentLevel) {
// //           widget.currentLevel++;
// //         }
// //         Navigator.pop(context);
// //       }
// //     });
// //   }
// //
// //   @override
// //   void dispose() {
// //     _audioPlayer.dispose(); // Dispose audio player
// //     _animationController.dispose();
// //     super.dispose();
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     final screenWidth = MediaQuery.of(context).size.width;
// //
// //     return Scaffold(
// //       backgroundColor: Colors.white, // Set the screen background to white
// //       appBar: AppBar(
// //         title: Row(
// //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //           children: [
// //             Text('Уровень: ${widget.theWord.level}'),
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
// //       body: Stack(
// //         children: [
// //           Center(
// //             child: _shuffledAnswers.isEmpty
// //                 ? const CircularProgressIndicator() // Show loading indicator if answers are not ready
// //                 : Column(
// //               mainAxisAlignment: MainAxisAlignment.center,
// //               children: [
// //                 Text(
// //                   widget.theWord.word,
// //                   style: const TextStyle(fontSize: 80, fontFamily: 'quranic'), // Use Roboto
// //                 ),
// //                 const SizedBox(height: 25),
// //                 const Text(
// //                   "Выберите правильный перевод:",
// //                   style: TextStyle(fontSize: 18),
// //                 ),
// //                 const SizedBox(height: 15),
// //                 // Build answer buttons from the shuffled list
// //                 ..._shuffledAnswers.asMap().entries.map((entry) {
// //                   int index = entry.key;
// //                   Map<String, dynamic> answer = entry.value;
// //                   return _buildAnswerButton(
// //                     answer['text'],
// //                     answer['isCorrect'],
// //                     screenWidth,
// //                     index,
// //                   );
// //                 }).toList(),
// //                 const SizedBox(height: 20),
// //                 Text('Ответов: $_answerCount/6'),
// //                 Text('Очки: $score'),
// //                 const SizedBox(height: 20),
// //               ],
// //             ),
// //           ),
// //           // Modal feedback window at the bottom of the screen
// //           if (_feedbackMessage.isNotEmpty)
// //             Positioned(
// //               left: 0,
// //               right: 0,
// //               bottom: 20, // Position the message at the bottom of the screen
// //               child: SlideTransition(
// //                 position: _slideAnimation,
// //                 child: FeedbackMessages.feedbackMessageWidget(
// //                   _feedbackMessage,
// //                   _messageBackgroundColor,
// //                 ),
// //               ),
// //             ),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   Widget _buildAnswerButton(
// //       String text, bool isCorrect, double screenWidth, int index) {
// //     final isPressed = _selectedButtonIndex == index;
// //
// //     // Determine the button style based on whether the answer is correct or incorrect
// //     Color backgroundColor;
// //     Color borderColor;
// //     Color textColor;
// //
// //     if (isPressed) {
// //       // If the button is pressed, apply the correct or incorrect style
// //       if (isCorrect) {
// //         backgroundColor = Colors.green.shade50;
// //         borderColor = Colors.green;
// //         textColor = Colors.green;
// //       } else {
// //         backgroundColor = Colors.red.shade50;
// //         borderColor = Colors.red;
// //         textColor = Colors.red;
// //       }
// //     } else {
// //       // Default style before any button is pressed
// //       backgroundColor = Colors.white;
// //       borderColor = Colors.grey;
// //       textColor = Colors.black87;
// //     }
// //
// //     return Container(
// //       width: screenWidth * 0.85, // Button width is 85% of the screen
// //       margin: const EdgeInsets.symmetric(vertical: 12),
// //       child: ElevatedButton(
// //         onPressed: _isAnswering ? null : () => _answerQuestion(isCorrect, index),
// //         style: ButtonStyle(
// //           backgroundColor: MaterialStateProperty.all(backgroundColor), // Custom background
// //           side: MaterialStateProperty.all(
// //             BorderSide(color: borderColor, width: 1.5), // Custom border
// //           ),
// //           shape: MaterialStateProperty.all(
// //             RoundedRectangleBorder(
// //               borderRadius: BorderRadius.circular(15), // Rounded corners
// //             ),
// //           ),
// //           elevation: MaterialStateProperty.all(5),
// //         ),
// //         child: Padding(
// //           padding: const EdgeInsets.all(15.0),
// //           child: Text(
// //             text,
// //             style: TextStyle(
// //               color: textColor, // Dynamic text color
// //               fontSize: 30.0,
// //               fontFamily: 'Roboto', // Use Roboto font
// //             ),
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }
// //
// //
// //
// // class TestGame extends StatefulWidget {
// //   final List<List<int>> allQuestions;
// //   final Word theWord;
// //   late final int currentLevel;
// //
// //   TestGame({
// //     required this.theWord,
// //     required this.currentLevel,
// //     required this.allQuestions
// //   });
// //
// //   @override
// //   _TestGameState createState() => _TestGameState();
// // }
// //
// // class _TestGameState extends State<TestGame> with TickerProviderStateMixin {
// //   int _answerCount = 0;
// //   int lives = 3; // Start with three lives
// //   bool _isAnswering = false;
// //   String _feedbackMessage = '';
// //   int? _selectedButtonIndex; // Track which button was pressed
// //   final AudioPlayer _audioPlayer = AudioPlayer(); // AudioPlayer instance
// //   late AnimationController _animationController;
// //   late Animation<Offset> _slideAnimation;
// //   late Color _messageBackgroundColor; // Background color for feedback message
// //   late List<Map<String, dynamic>> _shuffledAnswers; // Store answers and their correctness
// //
// //   final _random = Random(); // Random generator
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     _animationController = AnimationController(
// //       vsync: this,
// //       duration: const Duration(milliseconds: 500),
// //     );
// //     _slideAnimation = Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
// //         .animate(CurvedAnimation(
// //       parent: _animationController,
// //       curve: Curves.easeInOut,
// //     ));
// //
// //     _prepareQuestion(); // Prepare answers for the current question
// //   }
// //
// //   // Function to shuffle the answers
// //   Future<void> _prepareQuestion() async {
// //     List<Word> words = [widget.theWord];
// //
// //     // Fetch three unique words for incorrect answers
// //     while (words.length < 4) {
// //       int randomLevel = _random.nextInt(widget.currentLevel) + 1; // Generate random level between 1 and current level
// //       Word word = await _getUniqueWord(randomLevel, words);
// //
// //       if (word != null) {
// //         words.add(word);
// //       }
// //     }
// //
// //     // Create a list of answer options (correct + incorrect answers)
// //     _shuffledAnswers = words.map((word) =>
// //     {'text': word.ru, 'isCorrect': word.level == widget.theWord.level}
// //     ).toList();
// //
// //     // Shuffle the list
// //     _shuffledAnswers.shuffle();
// //   }
// //
// //   // Function to get a unique word from the database
// //   Future<Word> _getUniqueWord(int level, List<Word> existingWords) async {
// //     final dbHelper = DatabaseHelper();
// //     Word? word;
// //
// //     do {
// //       word = await dbHelper.getWord(level);
// //     } while (word == null || existingWords.any((w) => w.word == word?.word || w.ru == word?.ru));
// //
// //     return word;
// //   }
// //
// //   Future<void> _playSound(bool isCorrect) async {
// //     String sound = isCorrect
// //         ? 'assets/sounds/correct.mp3'
// //         : 'assets/sounds/incorrect.mp3';
// //     await _audioPlayer.play(AssetSource(sound)); // Play sound from assets
// //   }
// //
// //   void _endGame() {
// //     Navigator.pop(context);
// //   }
// //
// //   void _answerQuestion(bool isCorrect, int index) {
// //     if (_isAnswering) return;
// //
// //     setState(() {
// //       _isAnswering = true;
// //       // Choose a random feedback message from the correct or incorrect lists
// //       _feedbackMessage = isCorrect
// //           ? FeedbackMessages.correctMessages[_random.nextInt(FeedbackMessages.correctMessages.length)]
// //           : FeedbackMessages.incorrectMessages[_random.nextInt(FeedbackMessages.incorrectMessages.length)];
// //
// //       _selectedButtonIndex = index; // Mark the button pressed
// //       _messageBackgroundColor = isCorrect ? Colors.green.shade900 : Colors.red.shade900; // Set message background color
// //     });
// //
// //     _playSound(isCorrect);
// //     _animationController.forward();
// //
// //     Timer(const Duration(seconds: 2), () {
// //       setState(() {
// //         _isAnswering = false;
// //         _feedbackMessage = '';
// //         _selectedButtonIndex = null; // Reset the button selection
// //       });
// //       _animationController.reset();
// //
// //       if (isCorrect) {
// //         score++;
// //       } else {
// //         lives--;
// //         if (lives <= 0) {
// //           _endGame();
// //           return;
// //         }
// //       }
// //
// //       _answerCount++;
// //       if (_answerCount < 6) {
// //         _prepareQuestion(); // Prepare answers for the next question
// //       } else {
// //         if (score / 10 > widget.currentLevel) {
// //           widget.currentLevel++;
// //         }
// //         Navigator.pop(context);
// //       }
// //     });
// //   }
// //
// //   @override
// //   void dispose() {
// //     _audioPlayer.dispose(); // Dispose audio player
// //     _animationController.dispose();
// //     super.dispose();
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     final screenWidth = MediaQuery.of(context).size.width;
// //
// //     return Scaffold(
// //       backgroundColor: Colors.white, // Set the screen background to white
// //       appBar: AppBar(
// //         title: Row(
// //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //           children: [
// //             Text('Уровень: ${widget.theWord.level}'),
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
// //       body: Stack(
// //         children: [
// //           Center(
// //             child: Column(
// //               mainAxisAlignment: MainAxisAlignment.center,
// //               children: [
// //                 Text(
// //                   widget.theWord.word,
// //                   style: const TextStyle(fontSize: 80, fontFamily: 'quranic'), // Use Roboto
// //                 ),
// //                 const SizedBox(height: 25),
// //                 const Text(
// //                   "Выберите правильный перевод:",
// //                   style: TextStyle(fontSize: 18),
// //                 ),
// //                 const SizedBox(height: 15),
// //                 // Build answer buttons from the shuffled list
// //                 ..._shuffledAnswers.asMap().entries.map((entry) {
// //                   int index = entry.key;
// //                   Map<String, dynamic> answer = entry.value;
// //                   return _buildAnswerButton(
// //                     answer['text'],
// //                     answer['isCorrect'],
// //                     screenWidth,
// //                     index,
// //                   );
// //                 }).toList(),
// //                 const SizedBox(height: 20),
// //                 Text('Ответов: $_answerCount/6'),
// //                 Text('Очки: $score'),
// //                 const SizedBox(height: 20),
// //               ],
// //             ),
// //           ),
// //           // Modal feedback window at the bottom of the screen
// //           if (_feedbackMessage.isNotEmpty)
// //             Positioned(
// //               left: 0,
// //               right: 0,
// //               bottom: 20, // Position the message at the bottom of the screen
// //               child: SlideTransition(
// //                 position: _slideAnimation,
// //                 child: FeedbackMessages.feedbackMessageWidget(
// //                   _feedbackMessage,
// //                   _messageBackgroundColor,
// //                 ),
// //               ),
// //             ),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   Widget _buildAnswerButton(
// //       String text, bool isCorrect, double screenWidth, int index) {
// //     final isPressed = _selectedButtonIndex == index;
// //
// //     // Determine the button style based on whether the answer is correct or incorrect
// //     Color backgroundColor;
// //     Color borderColor;
// //     Color textColor;
// //
// //     if (isPressed) {
// //       // If the button is pressed, apply the correct or incorrect style
// //       if (isCorrect) {
// //         backgroundColor = Colors.green.shade50;
// //         borderColor = Colors.green;
// //         textColor = Colors.green;
// //       } else {
// //         backgroundColor = Colors.red.shade50;
// //         borderColor = Colors.red;
// //         textColor = Colors.red;
// //       }
// //     } else {
// //       // Default style before any button is pressed
// //       backgroundColor = Colors.white;
// //       borderColor = Colors.grey;
// //       textColor = Colors.black87;
// //     }
// //
// //     return Container(
// //       width: screenWidth * 0.85, // Button width is 85% of the screen
// //       margin: const EdgeInsets.symmetric(vertical: 12),
// //       child: ElevatedButton(
// //         onPressed: _isAnswering ? null : () => _answerQuestion(isCorrect, index),
// //         style: ButtonStyle(
// //           backgroundColor: MaterialStateProperty.all(backgroundColor), // Custom background
// //           side: MaterialStateProperty.all(
// //             BorderSide(color: borderColor, width: 1.5), // Custom border
// //           ),
// //           shape: MaterialStateProperty.all(
// //             RoundedRectangleBorder(
// //               borderRadius: BorderRadius.circular(15), // Rounded corners
// //             ),
// //           ),
// //           elevation: MaterialStateProperty.all(5),
// //         ),
// //         child: Padding(
// //           padding: const EdgeInsets.all(15.0),
// //           child: Text(
// //             text,
// //             style: TextStyle(
// //               color: textColor, // Dynamic text color
// //               fontSize: 30.0,
// //               fontFamily: 'Roboto', // Use Roboto font
// //             ),
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }
// //
// //
// //
// // import 'dart:math';
// //
// // import 'package:audioplayers/audioplayers.dart';
// // import 'package:flutter/material.dart';
// // import '../db.dart';
// // import '../models.dart';
// //
// // class _TestGameState extends State<TestGame> with TickerProviderStateMixin {
// //   int _currentQuestionIndex = 0;
// //   int _answerCount = 0;
// //   int lives = 3;
// //   bool _isAnswering = false;
// //   String _feedbackMessage = '';
// //   int? _selectedButtonIndex;
// //   final AudioPlayer _audioPlayer = AudioPlayer();
// //   late AnimationController _animationController;
// //   late Animation<Offset> _slideAnimation;
// //   late Color _messageBackgroundColor;
// //   late List<Map<String, dynamic>> _shuffledAnswers;
// //   final _random = Random();
// //
// //   final DatabaseHelper _dbHelper = DatabaseHelper(); // Initialize DatabaseHelper
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     _animationController = AnimationController(
// //       vsync: this,
// //       duration: const Duration(milliseconds: 500),
// //     );
// //     _slideAnimation = Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
// //         .animate(CurvedAnimation(
// //       parent: _animationController,
// //       curve: Curves.easeInOut,
// //     ));
// //
// //     _loadQuestion();
// //   }
// //
// //   Future<void> _loadQuestion() async {
// //     if (_currentQuestionIndex >= widget.allQuestions.length) {
// //       _endGame();
// //       return;
// //     }
// //
// //     int questionIndex = widget.allQuestions[_currentQuestionIndex][0];
// //     Word? questionWord = await _dbHelper.getWord(questionIndex); // Fetch the question word
// //
// //     if (questionWord != null) {
// //       _generateAnswers(questionWord);
// //     } else {
// //       // Handle case where question word is not found
// //       setState(() {
// //         _feedbackMessage = "Question word not found!";
// //         _messageBackgroundColor = Colors.red.shade900;
// //       });
// //     }
// //   }
// //
// //   void _generateAnswers(Word questionWord) async {
// //     List<Word> allWords = await _dbHelper.getWords(); // Fetch all words from the database
// //     List<Word> options = [questionWord];
// //
// //     while (options.length < 4) {
// //       Word randomWord = allWords[_random.nextInt(allWords.length)];
// //       if (!options.contains(randomWord)) {
// //         options.add(randomWord);
// //       }
// //     }
// //
// //     options.shuffle();
// //     _shuffledAnswers = options.map((word) => {
// //       'text': word.ru, // Adjust based on your word type
// //       'isCorrect': word == questionWord,
// //     }).toList();
// //     setState(() {});
// //   }
// //
// //   Future<void> _playSound(bool isCorrect) async {
// //     String sound = isCorrect
// //         ? 'assets/sounds/correct.mp3'
// //         : 'assets/sounds/incorrect.mp3';
// //     await _audioPlayer.play(AssetSource(sound));
// //   }
// //
// //   void _endGame() {
// //     Navigator.pop(context);
// //   }
// //
// //   void _answerQuestion(bool isCorrect, int index) {
// //     if (_isAnswering) return;
// //
// //     setState(() {
// //       _isAnswering = true;
// //       _feedbackMessage = isCorrect
// //           ? FeedbackMessages.correctMessages[_random.nextInt(FeedbackMessages.correctMessages.length)]
// //           : FeedbackMessages.incorrectMessages[_random.nextInt(FeedbackMessages.incorrectMessages.length)];
// //       _selectedButtonIndex = index;
// //       _messageBackgroundColor = isCorrect ? Colors.green.shade900 : Colors.red.shade900;
// //     });
// //
// //     _playSound(isCorrect);
// //     _animationController.forward();
// //
// //     Timer(const Duration(seconds: 2), () {
// //       setState(() {
// //         _isAnswering = false;
// //         _feedbackMessage = '';
// //         _selectedButtonIndex = null;
// //       });
// //       _animationController.reset();
// //
// //       if (isCorrect) {
// //         score++;
// //       } else {
// //         lives--;
// //         if (lives <= 0) {
// //           _endGame();
// //           return;
// //         }
// //       }
// //
// //       _answerCount++;
// //       _currentQuestionIndex++;
// //       if (_currentQuestionIndex < widget.allQuestions.length) {
// //         _loadQuestion();
// //       } else {
// //         Navigator.pop(context);
// //       }
// //     });
// //   }
// //
// //   @override
// //   void dispose() {
// //     _audioPlayer.dispose();
// //     _animationController.dispose();
// //     super.dispose();
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     final screenWidth = MediaQuery.of(context).size.width;
// //
// //     return Scaffold(
// //       backgroundColor: Colors.white,
// //       appBar: AppBar(
// //         title: Row(
// //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //           children: [
// //             Text('Уровень: ${widget.currentLevel}'),
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
// //       body: Stack(
// //         children: [
// //           Center(
// //             child: Column(
// //               mainAxisAlignment: MainAxisAlignment.center,
// //               children: [
// //                 Text(
// //                   'Word Placeholder', // Display the question word here
// //                   style: const TextStyle(fontSize: 80, fontFamily: 'quranic'),
// //                 ),
// //                 const SizedBox(height: 25),
// //                 const Text(
// //                   "Выберите правильный перевод:",
// //                   style: TextStyle(fontSize: 18),
// //                 ),
// //                 const SizedBox(height: 15),
// //                 if (_shuffledAnswers.isNotEmpty)
// //                   ..._shuffledAnswers.asMap().entries.map((entry) {
// //                     int index = entry.key;
// //                     Map<String, dynamic> answer = entry.value;
// //                     return _buildAnswerButton(
// //                       answer['text'],
// //                       answer['isCorrect'],
// //                       screenWidth,
// //                       index,
// //                     );
// //                   }).toList(),
// //                 const SizedBox(height: 20),
// //                 Text('Ответов: $_answerCount/${widget.allQuestions.length}'),
// //                 Text('Очки: $score'),
// //                 const SizedBox(height: 20),
// //               ],
// //             ),
// //           ),
// //           if (_feedbackMessage.isNotEmpty)
// //             Positioned(
// //               left: 0,
// //               right: 0,
// //               bottom: 20,
// //               child: SlideTransition(
// //                 position: _slideAnimation,
// //                 child: FeedbackMessages.feedbackMessageWidget(
// //                   _feedbackMessage,
// //                   _messageBackgroundColor,
// //                 ),
// //               ),
// //             ),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   Widget _buildAnswerButton(
// //       String text, bool isCorrect, double screenWidth, int index) {
// //     final isPressed = _selectedButtonIndex == index;
// //
// //     Color backgroundColor;
// //     Color borderColor;
// //     Color textColor;
// //
// //     if (isPressed) {
// //       if (isCorrect) {
// //         backgroundColor = Colors.green.shade50;
// //         borderColor = Colors.green;
// //         textColor = Colors.green;
// //       } else {
// //         backgroundColor = Colors.red.shade50;
// //         borderColor = Colors.red;
// //         textColor = Colors.red;
// //       }
// //     } else {
// //       backgroundColor = Colors.white;
// //       borderColor = Colors.grey;
// //       textColor = Colors.black87;
// //     }
// //
// //     return Container(
// //       width: screenWidth * 0.85,
// //       margin: const EdgeInsets.symmetric(vertical: 12),
// //       child: ElevatedButton(
// //         onPressed: _isAnswering ? null : () => _answerQuestion(isCorrect, index),
// //         style: ButtonStyle(
// //           backgroundColor: MaterialStateProperty.all(backgroundColor),
// //           side: MaterialStateProperty.all(
// //             BorderSide(color: borderColor, width: 1.5),
// //           ),
// //           shape: MaterialStateProperty.all(
// //             RoundedRectangleBorder(
// //               borderRadius: BorderRadius.circular(15),
// //             ),
// //           ),
// //           elevation: MaterialStateProperty.all(5),
// //         ),
// //         child: Padding(
// //           padding: const EdgeInsets.all(15.0),
// //           child: Text(
// //             text,
// //             style: TextStyle(
// //               color: textColor,
// //               fontSize: 30.0,
// //               fontFamily: 'Roboto',
// //             ),
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }
