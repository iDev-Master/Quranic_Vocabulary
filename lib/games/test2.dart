
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../constants.dart';
import '../models.dart';

class GamesPage extends StatefulWidget {
  final Word theWord;
  final int currentLevel;
  final int updateUnlockedLevels;

  GamesPage({
    required this.theWord,
    required this.currentLevel,
    required this.updateUnlockedLevels,
  });

  @override
  _GamesPageState createState() => _GamesPageState();
}

class _GamesPageState extends State<GamesPage> with TickerProviderStateMixin {
  int _answerCount = 0;
  int lives = 3; // Start with three lives
  bool _isAnswering = false;
  String _feedbackMessage = '';
  int? _selectedButtonIndex; // Track which button was pressed
  final AudioPlayer _audioPlayer = AudioPlayer(); // AudioPlayer instance
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _slideAnimation = Tween<Offset>(begin: const Offset(-2, 0), end: Offset.zero)
        .animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  Future<void> _playSound(bool isCorrect) async {
    String sound = isCorrect
        ? 'assets/sounds/correct.mp3'
        : 'assets/sounds/incorrect.mp3';
    await _audioPlayer.play(AssetSource(sound)); // Play sound from assets
  }

  void _endGame() {
    Navigator.pop(context);
  }

  void _answerQuestion(bool isCorrect, int index) {
    if (_isAnswering) return;

    setState(() {
      _isAnswering = true;
      _feedbackMessage = isCorrect ? "Молодец!" : "Неправильно!";
      _selectedButtonIndex = index; // Mark the button pressed
    });

    _playSound(isCorrect);
    _animationController.forward();

    Timer(const Duration(seconds: 3), () {
      setState(() {
        _isAnswering = false;
        _feedbackMessage = '';
        _selectedButtonIndex = null; // Reset the button selection
      });
      _animationController.reset();

      if (isCorrect) {
        score++;
      } else {
        lives--;
        if (lives <= 0) {
          _endGame();
          return;
        }
      }

      _answerCount++;
      if (_answerCount < 6) {
        // Continue to the next question
      } else {
        if (score / 10 > currentLevel) {
          currentLevel + 1;
        }
        Navigator.pop(context);
      }
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose(); // Dispose audio player
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white, // Set the screen background to white
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Уровень: ${widget.theWord.level}'),
            Row(
              children: List.generate(3, (index) {
                return Icon(
                  index < lives ? Icons.favorite : Icons.favorite_border,
                  color: Colors.white,
                );
              }),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.theWord.word,
                  style: const TextStyle(fontSize: 80, fontFamily: 'quranic'),
                ),
                const SizedBox(height: 25),
                const Text(
                  "Выберите правильный перевод:",
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 15),
                _buildAnswerButton(widget.theWord.ru, true, screenWidth, 0),
                _buildAnswerButton('Answer 2', false, screenWidth, 1),
                _buildAnswerButton('Answer 3', false, screenWidth, 2),
                _buildAnswerButton('Answer 4', false, screenWidth, 3),
                const SizedBox(height: 20),
                Text('Ответов: $_answerCount/6'),
                Text('Очки: $score'),
                const SizedBox(height: 20),
              ],
            ),
          ),
          // Modal feedback window
          if (_feedbackMessage.isNotEmpty)
            Positioned(
              left: 0,
              top: 100,
              child: SlideTransition(
                position: _slideAnimation,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.green.shade900,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    _feedbackMessage,
                    style: const TextStyle(
                      fontSize: 32,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAnswerButton(
      String text, bool isCorrect, double screenWidth, int index) {
    final isPressed = _selectedButtonIndex == index;

    return Container(
      width: screenWidth * 0.85, // Button width is 85% of the screen
      margin: const EdgeInsets.symmetric(vertical: 12),
      child: ElevatedButton(
        onPressed: _isAnswering ? null : () => _answerQuestion(isCorrect, index),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white, // Initial background color is white
          side: BorderSide(
            color: isPressed && isCorrect
                ? Colors.green
                : isPressed && !isCorrect
                ? Colors.red
                : Colors.grey,
            width: 1.5,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15), // Rounded corners
          ),
          shadowColor: Colors.grey.shade300,
          elevation: 5,
          textStyle: const TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontFamily: 'Arial', // Change font style
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 30.0,
            ),
          ),
        ),
      ),
    );
  }
}


// --- background color need to be changed
//
// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:audioplayers/audioplayers.dart';
// import '../constants.dart';
// import '../models.dart';
//
// class GamesPage extends StatefulWidget {
//   final Word theWord;
//   final int currentLevel;
//   final int updateUnlockedLevels;
//
//   GamesPage({
//     required this.theWord,
//     required this.currentLevel,
//     required this.updateUnlockedLevels,
//   });
//
//   @override
//   _GamesPageState createState() => _GamesPageState();
// }
//
// class _GamesPageState extends State<GamesPage> {
//   int _answerCount = 0;
//   int lives = 3; // Start with three lives
//   bool _isAnswering = false;
//   String _feedbackMessage = '';
//   int? _selectedButtonIndex; // Track which button was pressed
//   final AudioPlayer _audioPlayer = AudioPlayer(); // AudioPlayer instance
//
//   Future<void> _playSound(bool isCorrect) async {
//     String sound =
//     isCorrect ? 'assets/sounds/correct.mp3' : 'assets/sounds/incorrect.mp3';
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
//       _feedbackMessage = isCorrect ? "Молодец!" : "Неправильно!";
//       _selectedButtonIndex = index; // Mark the button pressed
//     });
//
//     _playSound(isCorrect);
//
//     Timer(const Duration(seconds: 3), () {
//       setState(() {
//         _isAnswering = false;
//         _feedbackMessage = '';
//         _selectedButtonIndex = null; // Reset the button selection
//       });
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
//         // Continue to the next question
//       } else {
//         if (score / 10 > currentLevel) {
//           currentLevel + 1;
//         }
//         Navigator.pop(context);
//       }
//     });
//   }
//
//   @override
//   void dispose() {
//     _audioPlayer.dispose(); // Dispose audio player
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//
//     return Scaffold(
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
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               widget.theWord.word,
//               style: const TextStyle(fontSize: 80, fontFamily: 'quranic'),
//             ),
//             const SizedBox(height: 25),
//             const Text(
//               "Выберите правильный перевод:",
//               style: TextStyle(fontSize: 18),
//             ),
//             const SizedBox(height: 15),
//             _buildAnswerButton(widget.theWord.ru, true, screenWidth, 0),
//             _buildAnswerButton('Answer 2', false, screenWidth, 1),
//             _buildAnswerButton('Answer 3', false, screenWidth, 2),
//             _buildAnswerButton('Answer 4', false, screenWidth, 3),
//             const SizedBox(height: 20),
//             Text('Ответов: $_answerCount/6'),
//             Text('Очки: $score'),
//             const SizedBox(height: 20),
//             if (_feedbackMessage.isNotEmpty)
//               Text(
//                 _feedbackMessage,
//                 style: TextStyle(
//                   fontSize: 32, // Larger font size for feedback
//                   color: _feedbackMessage == "Молодец!"
//                       ? Colors.green
//                       : Colors.red,
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildAnswerButton(
//       String text, bool isCorrect, double screenWidth, int index) {
//     final isPressed = _selectedButtonIndex == index;
//
//     return Container(
//       width: screenWidth * 0.85, // Button width is 85% of the screen
//       margin: const EdgeInsets.symmetric(vertical: 12),
//       child: ElevatedButton(
//         onPressed: _isAnswering ? null : () => _answerQuestion(isCorrect, index),
//         style: ElevatedButton.styleFrom(
//           backgroundColor: isPressed && isCorrect
//               ? Colors.green.shade50
//               : isPressed && !isCorrect
//               ? Colors.red.shade50
//               : Colors.white,
//           side: BorderSide(
//             color: isPressed && isCorrect
//                 ? Colors.green
//                 : isPressed && !isCorrect
//                 ? Colors.red
//                 : Colors.grey,
//             width: 1.5,
//           ),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(15), // Rounded corners
//           ),
//           shadowColor: Colors.grey.shade300,
//           elevation: 5,
//           textStyle: const TextStyle(
//             color: Colors.black,
//             fontSize: 20,
//             fontFamily: 'Arial', // Change font style
//           ),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(15.0),
//           child: Text(
//             text,
//             style: const TextStyle(
//               color: Colors.black87,
//               fontSize: 30.0,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }



// --------- working
// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:audioplayers/audioplayers.dart';
// import '../constants.dart';
// import '../models.dart';
//
// class GamesPage extends StatefulWidget {
//   final Word theWord;
//   final int currentLevel;
//   final int updateUnlockedLevels;
//
//   GamesPage({
//     required this.theWord,
//     required this.currentLevel,
//     required this.updateUnlockedLevels,
//   });
//
//   @override
//   _GamesPageState createState() => _GamesPageState();
// }
//
// class _GamesPageState extends State<GamesPage> {
//   int _answerCount = 0;
//   int lives = 3; // Start with three lives
//   bool _isAnswering = false;
//   String _feedbackMessage = '';
//   final AudioPlayer _audioPlayer = AudioPlayer(); // AudioPlayer instance
//
//   Future<void> _playSound(bool isCorrect) async {
//     String sound =
//         isCorrect ? 'assets/sounds/correct.mp3' : 'assets/sounds/incorrect.mp3';
//     await _audioPlayer.play(AssetSource(sound)); // Play sound from assets
//   }
//
//   void _endGame() {
//     int _lev = widget.theWord.level;
//     Navigator.pop(context);
//   }
//
//   void _answerQuestion(bool isCorrect) {
//     if (_isAnswering) return;
//
//     setState(() {
//       _isAnswering = true;
//       _feedbackMessage = isCorrect ? "Молодец!" : "Неправильно!";
//     });
//
//     _playSound(isCorrect);
//
//     Timer(const Duration(seconds: 3), () {
//       setState(() {
//         _isAnswering = false;
//         _feedbackMessage = '';
//       });
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
//         // Continue to the next question
//       } else {
//         if (score / 10 > currentLevel) {
//           currentLevel + 1;
//         }
//         Navigator.pop(context);
//       }
//     });
//   }
//
//   @override
//   void dispose() {
//     _audioPlayer.dispose(); // Dispose audio player
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//
//     return Scaffold(
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
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const SizedBox(height: 20),
//             Text(
//               widget.theWord.word,
//               style: const TextStyle(fontSize: 48),
//             ),
//             const SizedBox(height: 20),
//             _buildAnswerButton(widget.theWord.ru, true, screenWidth),
//             _buildAnswerButton('Answer 2', false, screenWidth),
//             _buildAnswerButton('Answer 3', false, screenWidth),
//             _buildAnswerButton('Answer 4', false, screenWidth),
//             const SizedBox(height: 20),
//             Text('Ответов: $_answerCount/6'),
//             Text('Очки: $score'),
//             const SizedBox(height: 20),
//             if (_feedbackMessage.isNotEmpty)
//               Text(
//                 _feedbackMessage,
//                 style: TextStyle(
//                   fontSize: 32, // Larger font size for feedback
//                   color: _feedbackMessage == "Молодец!"
//                       ? Colors.green
//                       : Colors.red,
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildAnswerButton(String text, bool isCorrect, double screenWidth) {
//     return Container(
//       width: screenWidth * 0.85, // Button width is 90% of the screen
//       margin: const EdgeInsets.symmetric(vertical: 12),
//       child: ElevatedButton(
//         onPressed: _isAnswering ? null : () => _answerQuestion(isCorrect),
//         style: ElevatedButton.styleFrom(
//           backgroundColor: _isAnswering && isCorrect
//               ? Colors.green.shade50
//               : _isAnswering && !isCorrect
//                   ? Colors.red.shade50
//                   : Colors.white,
//           side: BorderSide(
//             color: _isAnswering && isCorrect
//                 ? Colors.green
//                 : _isAnswering && !isCorrect
//                     ? Colors.red
//                     : Colors.grey,
//             width: 1.5,
//           ),
//           shadowColor: Colors.grey.shade300,
//           elevation: 5,
//           textStyle: const TextStyle(color: Colors.black, fontSize: 18),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(10.0),
//           child: Text(
//             text,
//             style: const TextStyle(
//               color: Colors.black87,
//               fontSize: 30.0,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// ------- Рабочий код; нужно изменить стили кнопок и тд
// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:audioplayers/audioplayers.dart';
// import '../constants.dart';
// import '../models.dart';
//
// class GamesPage extends StatefulWidget {
//   final Word theWord;
//   final int currentLevel;
//   final int updateUnlockedLevels;
//
//   GamesPage({
//     required this.theWord,
//     required this.currentLevel,
//     required this.updateUnlockedLevels,
//   });
//
//   @override
//   _GamesPageState createState() => _GamesPageState();
// }
//
// class _GamesPageState extends State<GamesPage> {
//   int _answerCount = 0;
//   late Timer _timer;
//   // double _progress = 1.0;
//   // int _timeLeft = testDuration;
//   bool _isAnswering = false;
//   String _feedbackMessage = '';
//   final AudioPlayer _audioPlayer = AudioPlayer(); // AudioPlayer instance
//
//   // void _startTimer() {
//   //   _timer = Timer.periodic(const Duration(milliseconds: 1000), (timer) {
//   //     setState(() {
//   //       _progress -= 1 / _timeLeft;
//   //       _timeLeft--;
//   //       if (_progress <= 0.0) {
//   //         _endGame();
//   //       }
//   //     });
//   //   });
//   // }
//   //
//   // void _resetTimer() {
//   //   _timer.cancel();
//   //   _progress = 1.0;
//   //   _timeLeft = testDuration;
//   //   _startTimer();
//   // }
//
//   Future<void> _playSound(bool isCorrect) async {
//     String sound = isCorrect ? 'assets/sounds/correct.mp3' : 'assets/sounds/incorrect.mp3';
//     await _audioPlayer.play(AssetSource(sound));  // Play sound from assets
//   }
//
//   void _endGame() {
//     int _lev = widget.theWord.level;
//     _timer.cancel();
//     Navigator.pop(context);
//   }
//
//   void _answerQuestion(bool isCorrect) {
//     if (_isAnswering) return;
//
//     setState(() {
//       _isAnswering = true;
//       _feedbackMessage = isCorrect ? "Молодец!" : "Неправильно!";
//     });
//
//     _playSound(isCorrect);
//
//     Timer(const Duration(seconds: 3), () {
//       setState(() {
//         _isAnswering = false;
//         _feedbackMessage = '';
//       });
//
//       if (isCorrect) {
//         score++;
//         // _resetTimer();
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
//         // Переход к следующему вопросу
//       } else {
//         if (score / 10 > currentLevel) {
//           currentLevel + 1;
//         }
//         Navigator.pop(context);
//       }
//     });
//   }
//
//   // @override
//   // void initState() {
//   //   super.initState();
//   //   _startTimer();
//   // }
//
//   @override
//   void dispose() {
//     _timer.cancel();
//     _audioPlayer.dispose(); // Dispose audio player
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
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
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const SizedBox(height: 20),
//             // LinearProgressIndicator(
//             //   value: _progress,
//             //   backgroundColor: Colors.grey[300],
//             //   color: Colors.blue,
//             //   minHeight: 20,
//             // ),
//             const SizedBox(height: 20),
//             Text(
//               widget.theWord.word,
//               style: const TextStyle(fontSize: 48),
//             ),
//             const SizedBox(height: 20),
//             _buildAnswerButton(widget.theWord.ru, true),
//             _buildAnswerButton('Answer 2', false),
//             _buildAnswerButton('Answer 3', false),
//             _buildAnswerButton('Answer 4', false),
//             const SizedBox(height: 20),
//             Text('Ответов: $_answerCount/6'),
//             Text('Очки: $score'),
//             const SizedBox(height: 20),
//             if (_feedbackMessage.isNotEmpty)
//               Text(
//                 _feedbackMessage,
//                 style: const TextStyle(fontSize: 24, color: Colors.green),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildAnswerButton(String text, bool isCorrect) {
//     return ElevatedButton(
//       onPressed: _isAnswering ? null : () => _answerQuestion(isCorrect),
//       style: ElevatedButton.styleFrom(
//         backgroundColor: _isAnswering && isCorrect
//             ? Colors.blue.shade100
//             : Colors.grey.shade200,
//         side: BorderSide(
//           color: isCorrect ? Colors.blue : Colors.red,
//           width: 2.0,
//         ),
//         textStyle: TextStyle(fontSize: 18),
//       ),
//       child: Text(text),
//     );
//   }
// }
//
//

// ------ рабочий код с временем
//
// import 'dart:async';
// import 'package:flutter/material.dart';
// import '../constants.dart';
// import '../models.dart';
//
// class GamesPage extends StatefulWidget {
//   final Word theWord;
//   final int currentLevel;
//   final int updateUnlockedLevels;
//
//   GamesPage({
//     required this.theWord,
//     required this.currentLevel,
//     required this.updateUnlockedLevels,
//   });
//
//   @override
//   _GamesPageState createState() => _GamesPageState();
// }
//
// class _GamesPageState extends State<GamesPage> {
//   int _answerCount = 0;
//   // int lives;
//   // int score = 0;
//   late Timer _timer;
//   double _progress = 1.0;
//   int _timeLeft = testDuration;
//
//   void _startTimer() {
//     _timer = Timer.periodic(const Duration(milliseconds: 1000), (timer) {
//       setState(() {
//         _progress -= 1 / _timeLeft;
//         _timeLeft--;
//         if (_progress <= 0.0) {
//           _endGame();
//         }
//       });
//     });
//   }
//
//   void _resetTimer() {
//     _timer.cancel();
//     _progress = 1.0;
//     _timeLeft = testDuration;
//     _startTimer();
//   }
//
//   void _endGame() {
//     int _lev = widget.theWord.level;
//     _timer.cancel();
//
//     Navigator.pop(
//       context,
//     );
//
//     // Navigator.pushAndRemoveUntil(
//     //   context,
//     //   MaterialPageRoute(builder: (context) => LessonPage(level: _lev)),
//     //   // ModalRoute.withName('/'), // Replace '/' with the name of the route you want to keep
//     //   (Route<dynamic> route) => false,
//     // );
//
//
//
//     // Navigator.push(
//     //   context,
//     //   MaterialPageRoute(
//     //     builder: (context) =>
//     //         LessonPage(level: _lev + 1),
//     //   ),
//     // );
//
//
//     // Navigator.push(
//     //     context,
//     //     MaterialPageRoute(
//     //         builder: (context) => GamesPage(
//     //           currentLevel: widget.theWord.level,
//     //           theWord: widget.theWord,
//     //           updateUnlockedLevels: _lev++,
//     //         )));
//
//     // Navigator.pushReplacement(
//     //   context,
//     //   MaterialPageRoute(builder: (context) => LessonPage(level: widget.currentLevel)),
//     // );
//   }
//
//   void _answerQuestion(bool isCorrect) {
//     setState(() {
//       if (isCorrect) {
//         score++;
//         _resetTimer();
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
//         // Continue asking questions
//       } else {
//         // Check if next level should be unlocked
//         if (score / 10 > currentLevel) {
//           currentLevel + 1;
//         }
//         Navigator.pop(
//           context,
//         );
//
//       }
//     });
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     _startTimer();
//   }
//
//   @override
//   void dispose() {
//     _timer.cancel();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text('Here will be the Score ${widget.theWord.level}'),
//
//             // Display lives
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
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
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const SizedBox(height: 20),
//
//             // Display progress bar as a timer
//             LinearProgressIndicator(
//               value: _progress,
//               backgroundColor: Colors.grey[300],
//               color: Colors.blue,
//               minHeight: 20,
//             ),
//             const SizedBox(height: 20),
//             // Display question
//             Text(
//               widget.theWord.word,
//               style: const TextStyle(fontSize: 48),
//             ),
//             const SizedBox(height: 20),
//             // Display 4 answer buttons
//             ElevatedButton(
//               onPressed: () => _answerQuestion(true),
//               child: Text(widget.theWord.ru),
//             ),
//             ElevatedButton(
//               onPressed: () => _answerQuestion(false),
//               child: const Text('Answer 2'),
//             ),
//             ElevatedButton(
//               onPressed: () => _answerQuestion(false),
//               child: const Text('Answer 3'),
//             ),
//             ElevatedButton(
//               onPressed: () => _answerQuestion(false),
//               child: const Text('Answer 4'),
//             ),
//             const SizedBox(height: 20),
//             // Show progress
//             Text('Answers given: $_answerCount/6'),
//             Text('Score: $score'),
//           ],
//         ),
//       ),
//     );
//   }
// }
//

// -------------
// import 'package:flutter/material.dart';
// import 'package:quranic_vocabulary/constants.dart';
// import 'package:quranic_vocabulary/levels.dart';
// import '../models.dart'; // Ensure this path is correct based on your project structure
//
// class GamesPage extends StatefulWidget {
//   final Word theWord;
//
//   GamesPage({required this.theWord});
//
//   @override
//   _GamesPageState createState() => _GamesPageState();
// }
//
// class _GamesPageState extends State<GamesPage> {
//   int _answerCount = 0;
//
//   // Assuming you have a list of words to generate incorrect options
//   // For simplicity, we'll use placeholder incorrect answers
//   final List<String> _incorrectAnswers = [
//     'Incorrect 1',
//     'Incorrect 2',
//     'Incorrect 3',
//   ];
//
//   // Function to handle answer selection
//   void _handleAnswer(String selectedAnswer) {
//     setState(() {
//       _answerCount++;
//       // You can add logic here to check if the answer is correct
//       // For now, we're just counting the number of answers
//
//       if (_answerCount == 1) {
//       currentLevel++;
//       }
//       if (_answerCount >= 6) {
//         // Navigate to LevelsPage after 6 answers
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => LevelsPage()),
//         );
//       } else {
//         // Optionally, show feedback or reset for the next question
//         // Since it's the same question repeated, no additional action is needed
//         // You can add a snackbar or any other feedback mechanism here
//       }
//     });
//   }
//
//   // Function to generate shuffled answer options
//   List<String> _getShuffledAnswers() {
//     List<String> answers = List.from(_incorrectAnswers);
//     answers.add(widget.theWord.ru); // Assuming 'ru' is the correct translation
//     answers.shuffle();
//     return answers;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     List<String> answerOptions = _getShuffledAnswers();
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Test for Level ${widget.theWord.level}'),
//         backgroundColor: Color(0xff205493),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             SizedBox(height: 20),
//             Text(
//               'Question ${_answerCount + 1} of 6',
//               style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//             ),
//             Divider(height: 30, thickness: 2),
//             Text(
//               'What is the correct translation of "${widget.theWord.word}"?',
//               style: TextStyle(fontSize: 20),
//               textAlign: TextAlign.center,
//             ),
//             SizedBox(height: 40),
//             // Display answer options as buttons
//             ...answerOptions.map((answer) {
//               return Container(
//                 width: double.infinity,
//                 margin: EdgeInsets.symmetric(vertical: 8),
//                 child: ElevatedButton(
//                   onPressed: () => _handleAnswer(answer),
//                   style: ElevatedButton.styleFrom(
//                     padding: EdgeInsets.symmetric(vertical: 16),
//                     primary: Colors.blueAccent,
//                   ),
//                   child: Text(
//                     answer,
//                     style: TextStyle(fontSize: 18),
//                   ),
//                 ),
//               );
//             }).toList(),
//             Spacer(),
//             // Display progress or any other information if needed
//           ],
//         ),
//       ),
//     );
//   }
// }
