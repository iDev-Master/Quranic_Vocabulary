import 'dart:math';
import 'package:flutter/material.dart';
import '../db.dart'; // Assuming you have a database to fetch words
import '../models.dart'; // Assuming Word is a model with 'word' and 'translation'

class MatchingGame extends StatefulWidget {
  final List<Word> words; // List of words to match

  MatchingGame({required this.words});

  @override
  _MatchingGameState createState() => _MatchingGameState();
}

class _MatchingGameState extends State<MatchingGame> {
  List<Word> shuffledWords = [];
  List<String> translations = [];
  List<bool> matched = [];
  int selectedWordIndex = -1;
  int selectedTranslationIndex = -1;
  int lives = 3;
  int totalMatches = 0;

  @override
  void initState() {
    super.initState();
    _shuffleWords();
  }

  // Shuffle words and translations separately to create the game layout
  void _shuffleWords() {
    shuffledWords = List.from(widget.words);
    translations = widget.words.map((word) => word.translation).toList();

    shuffledWords.shuffle();
    translations.shuffle();

    // Mark all pairs as unmatched at the start
    matched = List.filled(widget.words.length, false);
  }

  // Function to handle word selection
  void _selectWord(int index) {
    setState(() {
      selectedWordIndex = index;
    });

    // Check if both word and translation are selected
    if (selectedTranslationIndex != -1) {
      _checkMatch();
    }
  }

  // Function to handle translation selection
  void _selectTranslation(int index) {
    setState(() {
      selectedTranslationIndex = index;
    });

    // Check if both word and translation are selected
    if (selectedWordIndex != -1) {
      _checkMatch();
    }
  }

  // Check if the selected word and translation match
  void _checkMatch() {
    if (shuffledWords[selectedWordIndex].translation ==
        translations[selectedTranslationIndex]) {
      // Correct match
      setState(() {
        matched[selectedWordIndex] = true;
        totalMatches++;
      });

      // Reset selections
      selectedWordIndex = -1;
      selectedTranslationIndex = -1;

      // Check if the game is won
      if (totalMatches == widget.words.length) {
        _showVictoryDialog();
      }
    } else {
      // Incorrect match
      setState(() {
        lives--;
      });

      if (lives == 0) {
        _showGameOverDialog();
      }

      // Reset selections
      selectedWordIndex = -1;
      selectedTranslationIndex = -1;
    }
  }

  // Show a dialog when the user wins the game
  void _showVictoryDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Victory!'),
        content: Text('You matched all the words correctly.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context); // Return to previous screen
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  // Show a dialog when the user runs out of lives
  void _showGameOverDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Game Over'),
        content: Text('You ran out of lives.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context); // Return to previous screen
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Matching Game'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Display lives
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (index) {
                return Icon(
                  index < lives ? Icons.favorite : Icons.favorite_border,
                  color: Colors.red,
                );
              }),
            ),
            SizedBox(height: 20),
            // Display words and translations in two columns
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Column of words
                  Column(
                    children: List.generate(shuffledWords.length, (index) {
                      return GestureDetector(
                        onTap: matched[index] ? null : () => _selectWord(index),
                        child: Container(
                          margin: EdgeInsets.all(8),
                          padding: EdgeInsets.all(16),
                          color: selectedWordIndex == index
                              ? Colors.blueAccent
                              : Colors.grey[200],
                          child: Text(
                            shuffledWords[index].word,
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      );
                    }),
                  ),
                  // Column of translations
                  Column(
                    children: List.generate(translations.length, (index) {
                      return GestureDetector(
                        onTap: matched.contains(true) ? null : () => _selectTranslation(index),
                        child: Container(
                          margin: EdgeInsets.all(8),
                          padding: EdgeInsets.all(16),
                          color: selectedTranslationIndex == index
                              ? Colors.blueAccent
                              : Colors.grey[200],
                          child: Text(
                            translations[index],
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
