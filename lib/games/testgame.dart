// ---------- new ChatGPT:

import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:quranic_vocabulary/games/questionary.dart';
import '../constants.dart';
import '../models.dart';
import '../custom_widgets.dart';
import '../db.dart';



class TestGame extends StatefulWidget {
  final List<List<int>> allQuestions;
  final Word theWord;
  late final int currentLevel;
  // final int updateUnlockedLevels;

  TestGame({
    required this.theWord,
    required this.currentLevel,
    // required this.updateUnlockedLevels,
    required this.allQuestions
  });

  @override
  _TestGameState createState() => _TestGameState();
}

class _TestGameState extends State<TestGame> with TickerProviderStateMixin {
  int _answerCount = 0;
  int lives = 3;
  bool _isAnswering = false;
  String _feedbackMessage = '';
  int? _selectedButtonIndex;
  final AudioPlayer _audioPlayer = AudioPlayer();
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  late Color _messageBackgroundColor;

  List<Map<String, dynamic>>? shuffledAnswers; // Список ответов
  String currentWord = ''; // Новый вопрос (слово) в состоянии

  final DatabaseHelper dbHelper = DatabaseHelper();
  int mainIndex = 0;
  final _random = Random();

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

    prepareQuestion(widget.allQuestions[0][mainIndex]); // Загружаем первый вопрос
  }

  int generateRandomNumberInRange(int min, int max) {
    final random = Random();
    return min + random.nextInt(max - min + 1);
  }

  Future<void> prepareQuestion(int index) async {
    List<Word> testingQuestions = [];

    // Получаем правильный ответ (слово) из базы данных
    Word? correctWord = await dbHelper.getWord(index);
    if (correctWord != null) {
      testingQuestions.add(correctWord);

      // Обновляем текущее слово для отображения вопроса
      setState(() {
        currentWord = correctWord.word; // Сохраняем новое слово в состоянии
      });
    }

    // Получаем 3 неправильных ответа случайным образом
    List<int> wrongAnswersIndex = [];
    while (wrongAnswersIndex.length < 3) {
      int randomIndex = generateRandomNumberInRange(1, 125);
      if (!wrongAnswersIndex.contains(randomIndex)) {
        wrongAnswersIndex.add(randomIndex);
      }
    }

    // Добавляем неправильные ответы в список
    for (int num in wrongAnswersIndex) {
      Word? wrongAnswer = await dbHelper.getWord(num);
      if (wrongAnswer != null) {
        testingQuestions.add(wrongAnswer);
      }
    }

    // Перемешиваем ответы и обновляем состояние
    _shuffleAnswers(testingQuestions);
  }

  void _shuffleAnswers(List<Word> words) {
    shuffledAnswers = [
      {'text': words[0].ru, 'isCorrect': true}, // Правильный ответ
      {'text': words[1].ru, 'isCorrect': false},
      {'text': words[2].ru, 'isCorrect': false},
      {'text': words[3].ru, 'isCorrect': false},
    ];

    shuffledAnswers!.shuffle(); // Перемешиваем список ответов

    setState(() {}); // Обновляем интерфейс после перемешивания
  }

  // Остальные методы остаются такими же, как в предыдущем коде

  Future<void> _playSound(bool isCorrect) async {
    String sound = isCorrect
        ? 'assets/sounds/correct.mp3'
        : 'assets/sounds/incorrect.mp3';
    await _audioPlayer.play(AssetSource(sound));
  }

  void _endGame() {
    Navigator.pop(context);
  }

  void _answerQuestion(bool isCorrect, int index) {
    if (_isAnswering) return;

    setState(() {
      _isAnswering = true;
      _feedbackMessage = isCorrect
          ? FeedbackMessages.correctMessages[_random.nextInt(FeedbackMessages.correctMessages.length)]
          : FeedbackMessages.incorrectMessages[_random.nextInt(FeedbackMessages.incorrectMessages.length)];

      _selectedButtonIndex = index;
      _messageBackgroundColor = isCorrect ? Colors.green.shade900 : Colors.red.shade900;
    });

    _playSound(isCorrect);
    _animationController.forward();

    Timer(const Duration(seconds: 2), () {
      setState(() {
        _isAnswering = false;
        _feedbackMessage = '';
        _selectedButtonIndex = null;
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
      if (_answerCount < 10) {
        mainIndex++;
        prepareQuestion(widget.allQuestions[0][mainIndex]);
      } else {
        if (score / 10 > widget.currentLevel) {
          widget.currentLevel++;
        }
        Navigator.pop(context);
      }
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _animationController.dispose();
    super.dispose();
  }

  // Остальные методы остаются такими же, как в предыдущем коде

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
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
      body: shuffledAnswers == null
          ? const Center(child: CircularProgressIndicator()) // Показываем индикатор загрузки
          : Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Обновляемый вопрос (слово)
                Text(
                  currentWord, // Используем обновляемое слово из состояния
                  style: const TextStyle(fontSize: 80, fontFamily: 'quranic'),
                ),
                const SizedBox(height: 25),
                const Text(
                  "Выберите правильный перевод:",
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 15),
                ...shuffledAnswers!.asMap().entries.map((entry) {
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
                Text('Ответов: $_answerCount/x'),
                Text('Очки: $score'),
                const SizedBox(height: 20),
              ],
            ),
          ),
          if (_feedbackMessage.isNotEmpty)
            Positioned(
              left: 0,
              right: 0,
              bottom: 20,
              child: SlideTransition(
                position: _slideAnimation,
                child: FeedbackMessages.feedbackMessageWidget(
                  _feedbackMessage,
                  _messageBackgroundColor,
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

    Color backgroundColor;
    Color borderColor;
    Color textColor;

    if (isPressed) {
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
      backgroundColor = Colors.white;
      borderColor = Colors.grey;
      textColor = Colors.black87;
    }

    return Container(
      width: screenWidth * 0.85,
      margin: const EdgeInsets.symmetric(vertical: 12),
      child: ElevatedButton(
        onPressed: _isAnswering ? null : () => _answerQuestion(isCorrect, index),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(backgroundColor),
          side: MaterialStateProperty.all(
            BorderSide(color: borderColor, width: 1.5),
          ),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          padding: MaterialStateProperty.all(const EdgeInsets.symmetric(vertical: 12)),
        ),
        child: Text(
          text,
          style: TextStyle(fontSize: 18, color: textColor),
        ),
      ),
    );
  }
}

