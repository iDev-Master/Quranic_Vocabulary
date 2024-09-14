
import 'dart:math';
import 'package:flutter/material.dart';
import '../models.dart';
import '../db.dart';

class TestGamePage extends StatefulWidget {
  final int currentLevel;

  const TestGamePage({required this.currentLevel});

  @override
  _TestGamePageState createState() => _TestGamePageState();
}

class _TestGamePageState extends State<TestGamePage> {
  late List<Question> _questions;
  late Word _currentWord;
  int _score = 0;
  int _currentQuestionIndex = 0;

  @override
  void initState() {
    super.initState();
    _initializeQuestions();
  }

  Future<void> _initializeQuestions() async {
    final dbHelper = DatabaseHelper();
    final List<Word> words = await dbHelper.getWords();

    // Filter words by the current level
    final List<Word> filteredWords = words.where((word) => word.level <= widget.currentLevel).toList();

    // Create a list of questions with 4 options
    _questions = await _generateQuestions(filteredWords);

    setState(() {
      // Update state with initialized questions
    });
  }

  Future<List<Question>> _generateQuestions(List<Word> words) async {
    final List<Question> questions = [];
    final random = Random();

    for (int i = 0; i < 6; i++) {
      // Select a random word for the question
      final Word correctWord = words[random.nextInt(words.length)];

      // Prepare answers
      final List<String> answers = [correctWord.ru];
      final Set<int> ids = {correctWord.level};

      // Add random answers
      while (answers.length < 4) {
        final Word randomWord = words[random.nextInt(words.length)];
        if (!ids.contains(randomWord.level)) {
          answers.add(randomWord.ru);
          ids.add(randomWord.level);
        }
      }

      // Shuffle answers
      answers.shuffle();

      // Create a question
      questions.add(Question(
        word: correctWord.word,
        answers: answers,
        correctAnswer: correctWord.ru,
      ));
    }

    return questions;
  }

  void _answerQuestion(String answer) {
    if (answer == _questions[_currentQuestionIndex].correctAnswer) {
      setState(() {
        _score++;
      });
    }

    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
      });
    } else {
      // Navigate to results or another page
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Test Game'),
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final question = _questions[_currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text('Test Game'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Score: $_score', style: TextStyle(fontSize: 18)),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(question.word, style: TextStyle(fontSize: 24)),
            ...question.answers.map((answer) => ElevatedButton(
              onPressed: () => _answerQuestion(answer),
              child: Text(answer),
            )),
          ],
        ),
      ),
    );
  }
}

class Question {
  final String word;
  final List<String> answers;
  final String correctAnswer;

  Question({
    required this.word,
    required this.answers,
    required this.correctAnswer,
  });
}


// ------
// import 'dart:math';
// import 'package:flutter/material.dart';
// import '../models.dart';
// import '../db.dart';
//
// class TestGamePage extends StatefulWidget {
//   final int currentLevel;
//   TestGamePage({required this.currentLevel});
//
//   @override
//   _TestGamePageState createState() => _TestGamePageState();
// }
//
// class _TestGamePageState extends State<TestGamePage> {
//   int _score = 0;
//   int _currentQuestionIndex = 0;
//   late List<Word> _questions;
//   late List<Word> _options;
//
//   @override
//   void initState() {
//     super.initState();
//     _loadQuestions();
//   }
//
//   Future<void> _loadQuestions() async {
//     final dbHelper = DatabaseHelper();
//     final List<Word> words = await dbHelper.getWords();
//
//     // Filter questions to include only up to the current level
//     final filteredWords = words.where((word) => word.level <= widget.currentLevel).toList();
//
//     final random = Random();
//     _questions = [];
//
//     // Pick 6 random questions
//     while (_questions.length < 6) {
//       final word = filteredWords[random.nextInt(filteredWords.length)];
//       if (!_questions.contains(word)) {
//         _questions.add(word);
//       }
//     }
//
//     setState(() {
//       _options = _generateOptionsForQuestion(_questions[_currentQuestionIndex]);
//     });
//   }
//
//   List<Word> _generateOptionsForQuestion(Word correctWord) {
//     final random = Random();
//     List<int> ids = [correctWord.level];
//
//     while (ids.length < 4) {
//       int randomId = random.nextInt(widget.currentLevel) + 1; // Ensure random ID is within the current level
//       if (!ids.contains(randomId)) {
//         ids.add(randomId);
//       }
//     }
//
//     List<Word> options = ids.map((id) {
//       return _questions.firstWhere((word) => word.level == id);
//     }).toList();
//
//     options.shuffle();
//     return options;
//   }
//
//   void _checkAnswer(Word selectedOption) {
//     if (selectedOption.level == _questions[_currentQuestionIndex].level) {
//       setState(() {
//         _score++;
//       });
//     }
//
//     setState(() {
//       _currentQuestionIndex++;
//       if (_currentQuestionIndex >= _questions.length) {
//         // Handle end of game
//         Navigator.pop(context);
//       } else {
//         _options = _generateOptionsForQuestion(_questions[_currentQuestionIndex]);
//       }
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Test Game'),
//         backgroundColor: Color(0xff205493),
//       ),
//       body: _questions.isEmpty ? Center(child: CircularProgressIndicator()) :
//       Column(
//         children: [
//           Container(
//             alignment: Alignment.topLeft,
//             padding: const EdgeInsets.all(10.0),
//             child: Text(
//               'Score: $_score',
//               style: TextStyle(fontSize: 20, color: Colors.white),
//             ),
//           ),
//           Expanded(
//             child: Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     _questions[_currentQuestionIndex].word,
//                     style: TextStyle(fontSize: 40),
//                   ),
//                   ..._options.map((option) {
//                     return ElevatedButton(
//                       onPressed: () => _checkAnswer(option),
//                       child: Text(option.ru),
//                     );
//                   }).toList(),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//       backgroundColor: Color(0xffe6e6e6),
//     );
//   }
// }
//



// ---------
// import 'dart:math';
// import 'package:flutter/material.dart';
// import '../models.dart';
// import '../db.dart'; // Import database helper
//
// Future<bool> runTestGame(BuildContext context) async {
//   final dbHelper = DatabaseHelper();
//   final List<Word> words = await dbHelper.getWords();
//
//   // Get a random word from the list
//   final random = Random();
//   final wordIndex = random.nextInt(words.length);
//   final correctWord = words[wordIndex];
//
//   // Create a list of IDs
//   List<int> ids = [correctWord.level];
//
//   // Add three more random levels to the list
//   while (ids.length < 4) {
//     int randomId = random.nextInt(125) + 1;
//     if (!ids.contains(randomId)) {
//       ids.add(randomId);
//     }
//   }
//
//   // Fetch the possible answers
//   List<Word> options = [];
//   for (int id in ids) {
//     final option = words.firstWhere((word) => word.level == id, orElse: () => throw Exception('Word not found'));
//     options.add(option);
//   }
//
//   // Shuffle the options
//   options.shuffle();
//
//   return await showDialog<bool>(
//     context: context,
//     builder: (context) => AlertDialog(
//       title: Text(correctWord.word),
//       content: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: options.map((option) {
//           return ListTile(
//             title: Text(option.ru),
//             onTap: () {
//               Navigator.of(context).pop(option.level == correctWord.level);
//             },
//           );
//         }).toList(),
//       ),
//     ),
//   ) ?? false;
// }
