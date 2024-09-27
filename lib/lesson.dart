// --------
// Correct code:
import 'package:flutter/material.dart';
import 'models/models.dart';
import 'db/db.dart';
import 'games/testgame.dart';
import 'constants/constants.dart';
import './games/matching.dart';
import 'constants/questionary.dart';

class LessonPage extends StatelessWidget {
  final int level;
  // final List<List<int>> questionsIndexes;

  LessonPage({required this.level});
  // LessonPage({required this.level, required this.questionsIndexes});

  Future<Word?> getWordDetail(int level) async {
    final dbHelper = DatabaseHelper();
    return await dbHelper.getWord(level);
  }

  var questionIndexGenerator = GenerateQuestionsIndexes(howManyTestQuestions: totalTests);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Word?>(
      future: getWordDetail(level),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Loading...'),
            ),
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Error'),
            ),
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        } else if (!snapshot.hasData || snapshot.data == null) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('No Data'),
            ),
            body: Center(child: Text('No data found for level $level')),
          );
        }

        final word = snapshot.data!;
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Color(0xff205493),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Урок ${word.level}.'),
                Text('${word.occurrence} повторений'),
              ],
            ),
          ),
          body: Center(
            child: Container(
              color: const Color(0xffe6e6e6),
              child: Column(
                children: [
                  const SizedBox(height: 5),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(children: [

                        // Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                        //   Text(
                        //     word.type,
                        //     style:
                        //     const TextStyle(fontSize: 20, color: Colors.black87),
                        //     textAlign: TextAlign.end,
                        //   ),
                        //   const SizedBox(width: 20.0),
                        // ]),

                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Container(
                            alignment: Alignment.center,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.white70,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              children: [
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      const SizedBox(width: 20.0, height: 30.0),
                                      Text(
                                        word.type,
                                        style: const TextStyle(
                                            fontSize: 20,
                                            color: Colors.black38),
                                        textAlign: TextAlign.end,
                                      ),
                                    ]),
                                Text(
                                  word.word,
                                  style: const TextStyle(
                                      fontSize: 115, fontFamily: 'quranic'),
                                ),
                              ],
                            ),
                          ),
                        ),

                        Text(
                          word.ru,
                          style: const TextStyle(
                              fontSize: 35, color: Colors.black87),
                        ),
                        const SizedBox(height: 35),

                        Text(
                          word.exampleAr,
                          style: const TextStyle(
                              fontSize: 30,
                              fontFamily: "quranic",
                              color: Color(0xff651d32)),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),

                        Text(
                          word.exampleRu,
                          style: const TextStyle(
                              fontSize: 18, color: Color(0xff651d32)),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 50),

                        const Text(
                          "Комбинации этого слова:",
                          style: TextStyle(fontSize: 18, color: Colors.black87),
                          textAlign: TextAlign.center,
                        ),

                        Text(
                          word.combinations,
                          style: const TextStyle(
                            fontSize: 35,
                            color: Colors.black54,
                            fontFamily: 'quranic',
                          ),
                        ),
                        const SizedBox(height: 20),

                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,

                              // Routing to the matchingGame
                              // MaterialPageRoute(
                              //     builder: (context) => MatchingGame(
                              //       initialLives: lives,
                              //       questionsIndexes: questionsIndexes,
                              //     )),

                              // // Routing to the testGame now
                              MaterialPageRoute(
                                  builder: (context) => TestGame(
                                        currentLevel: word.level,
                                        theWord: word,
                                        allQuestionsIndexes: questionIndexGenerator.generateQuestionIndexes(word.level),
                                      )),
                            );
                          },
                          child: Text('Пройти ${word.level} уровень!'),
                        ),
                      ]),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
