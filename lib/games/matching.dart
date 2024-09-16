// import 'dart:async';
// import 'dart:math';
// import 'package:flutter/material.dart';
// import 'package:audioplayers/audioplayers.dart';
// import '../custom_widgets.dart';
// import '../models.dart'; // Import your models
//
// class MatchingGamePage extends StatefulWidget {
//   final List<int> wordIndexes; // List of word indexes for the matching game
//
//   MatchingGamePage({required this.wordIndexes});
//
//   @override
//   _MatchingGamePageState createState() => _MatchingGamePageState();
// }
//
// class _MatchingGamePageState extends State<MatchingGamePage> {
//   final AudioPlayer _audioPlayer = AudioPlayer(); // Audio player instance
//   List<Word> _words = [];
//   List<String> _translations = [];
//   List<String> _shuffledTranslations = [];
//   Map<String, String> _wordToTranslation = {};
//   String? _selectedWord;
//   String? _selectedTranslation;
//   int lives = 3; // Start with three lives
//   final _random = Random();
//
//   @override
//   void initState() {
//     super.initState();
//     _loadWords();
//   }
//
//   Future<void> _loadWords() async {
//     // Simulate loading words from the database
//     // Replace this with actual database queries
//     List<Word> words = await fetchWordsFromDatabase(widget.wordIndexes);
//     setState(() {
//       _words = words;
//       _translations = words.map((w) => w.translation).toList();
//       _shuffledTranslations = List.from(_translations)..shuffle();
//       _wordToTranslation = Map.fromIterable(words,
//           key: (w) => w.word,
//           value: (w) => w.translation);
//     });
//   }
//
//   Future<void> _playSound(bool isCorrect) async {
//     String sound = isCorrect
//         ? 'assets/sounds/correct.mp3'
//         : 'assets/sounds/incorrect.mp3';
//     await _audioPlayer.play(AssetSource(sound));
//   }
//
//   void _handleWordSelection(String word) {
//     setState(() {
//       _selectedWord = word;
//     });
//   }
//
//   void _handleTranslationSelection(String translation) {
//     if (_selectedWord == null) return;
//
//     if (_wordToTranslation[_selectedWord] == translation) {
//       _playSound(true);
//       _showFeedbackMessage("Correct!", Colors.green);
//       _removeMatchedPair(_selectedWord!, translation);
//     } else {
//       _playSound(false);
//       _showFeedbackMessage("Try Again!", Colors.red);
//       setState(() {
//         _selectedWord = null;
//         lives--;
//         if (lives <= 0) {
//           Navigator.pop(context); // End the game
//         }
//       });
//     }
//   }
//
//   void _removeMatchedPair(String word, String translation) {
//     setState(() {
//       _words.removeWhere((w) => w.word == word);
//       _translations.remove(translation);
//       _shuffledTranslations.remove(translation);
//       _selectedWord = null;
//     });
//   }
//
//   void _showFeedbackMessage(String message, Color color) {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           backgroundColor: color,
//           title: Text(message, style: TextStyle(color: Colors.white)),
//           content: SizedBox(
//             height: 60,
//             child: Center(
//               child: CircularProgressIndicator(),
//             ),
//           ),
//         );
//       },
//     );
//     Timer(const Duration(seconds: 1), () {
//       Navigator.of(context).pop(); // Close the dialog after 1 second
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Matching Game"),
//         actions: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Center(
//               child: Text('Lives: $lives'),
//             ),
//           ),
//         ],
//       ),
//       body: _words.isEmpty
//           ? Center(child: Text("No words to display"))
//           : Row(
//         children: [
//           Expanded(
//             child: ListView(
//               children: _words.map((word) {
//                 return ListTile(
//                   title: Text(word.word),
//                   tileColor: _selectedWord == word.word
//                       ? Colors.blue.shade100
//                       : Colors.white,
//                   onTap: () => _handleWordSelection(word.word),
//                 );
//               }).toList(),
//             ),
//           ),
//           Expanded(
//             child: ListView(
//               children: _shuffledTranslations.map((translation) {
//                 return ListTile(
//                   title: Text(translation),
//                   tileColor: _selectedTranslation == translation
//                       ? Colors.blue.shade100
//                       : Colors.white,
//                   onTap: () => _handleTranslationSelection(translation),
//                 );
//               }).toList(),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
