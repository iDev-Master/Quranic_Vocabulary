
import 'dart:async';
import 'dart:math'; // Import Random
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
  late Color _messageBackgroundColor; // Background color for feedback message
  late List<Map<String, dynamic>> _shuffledAnswers; // Store answers and their correctness

  final _random = Random(); // Random generator

  // Lists of possible feedback messages
  final List<String> _correctMessages = [
    "Молодец!",
    "Отлично!",
    "Так держать!",
    "Правильно!",
    "Talatkhon!"
  ];

  final List<String> _incorrectMessages = [
    "Неправильно!",
    "Не угадал!",
    "Попробуй ещё раз!",
    "Ошибся!"
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _slideAnimation = Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
        .animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _shuffleAnswers(); // Shuffle answers on page load
  }

  // Function to shuffle the answers
  void _shuffleAnswers() {
    // Create a list of answer options (correct + incorrect answers)
    _shuffledAnswers = [
      {'text': widget.theWord.ru, 'isCorrect': true}, // Correct answer
      {'text': 'Answer 2', 'isCorrect': false},
      {'text': 'Answer 3', 'isCorrect': false},
      {'text': 'Answer 4', 'isCorrect': false},
    ];

    // Shuffle the list
    _shuffledAnswers.shuffle();
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
      // Choose a random feedback message from the correct or incorrect lists
      _feedbackMessage = isCorrect
          ? _correctMessages[_random.nextInt(_correctMessages.length)]
          : _incorrectMessages[_random.nextInt(_incorrectMessages.length)];

      _selectedButtonIndex = index; // Mark the button pressed
      _messageBackgroundColor = isCorrect ? Colors.green.shade900 : Colors.red.shade900; // Set message background color
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
        _shuffleAnswers(); // Shuffle answers for the next question
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
                  style: const TextStyle(fontSize: 80, fontFamily: 'quranic'), // Use Roboto
                ),
                const SizedBox(height: 25),
                const Text(
                  "Выберите правильный перевод:",
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 15),
                // Build answer buttons from the shuffled list
                ..._shuffledAnswers.asMap().entries.map((entry) {
                  int index = entry.key;
                  Map<String, dynamic> answer = entry.value;
                  return _buildAnswerButton(
                    answer['text'],
                    answer['isCorrect'],
                    screenWidth,
                    index,
                  );
                }).toList(),
                const SizedBox(height: 20),
                Text('Ответов: $_answerCount/6'),
                Text('Очки: $score'),
                const SizedBox(height: 20),
              ],
            ),
          ),
          // Modal feedback window at the bottom of the screen
          if (_feedbackMessage.isNotEmpty)
            Positioned(
              left: 0,
              right: 0,
              bottom: 20, // Position the message at the bottom of the screen
              child: SlideTransition(
                position: _slideAnimation,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: _messageBackgroundColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    _feedbackMessage,
                    textAlign: TextAlign.center,
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

    // Determine the button style based on whether the answer is correct or incorrect
    Color backgroundColor;
    Color borderColor;
    Color textColor;

    if (isPressed) {
      // If the button is pressed, apply the correct or incorrect style
      if (isCorrect) {
        backgroundColor = Colors.green.shade50;
        borderColor = Colors.green;
        textColor = Colors.green;
      } else {
        backgroundColor = Colors.red.shade50;
        borderColor = Colors.red;
        textColor = Colors.red;
      }
    } else {
      // Default style before any button is pressed
      backgroundColor = Colors.white;
      borderColor = Colors.grey;
      textColor = Colors.black87;
    }

    return Container(
      width: screenWidth * 0.85, // Button width is 85% of the screen
      margin: const EdgeInsets.symmetric(vertical: 12),
      child: ElevatedButton(
        onPressed: _isAnswering ? null : () => _answerQuestion(isCorrect, index),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(backgroundColor), // Custom background
          side: MaterialStateProperty.all(
            BorderSide(color: borderColor, width: 1.5), // Custom border
          ),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15), // Rounded corners
            ),
          ),
          elevation: MaterialStateProperty.all(5),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Text(
            text,
            style: TextStyle(
              color: textColor, // Dynamic text color
              fontSize: 30.0,
              fontFamily: 'Roboto', // Use Roboto font
            ),
          ),
        ),
      ),
    );
  }
}


