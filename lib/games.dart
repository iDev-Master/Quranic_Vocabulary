import 'package:flutter/material.dart';
import 'games/test.dart';

class GamesPage extends StatelessWidget {
  final int currentLevel;

  GamesPage({required this.currentLevel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Games'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Current Level: $currentLevel', style: TextStyle(fontSize: 24)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TestGamePage(currentLevel: currentLevel),
                  ),
                );
              },
              child: Text('Start Test Game'),
            ),
          ],
        ),
      ),
    );
  }
}



// ----------
//
// import 'package:flutter/material.dart';
// import 'games/test.dart'; // Import the test game logic
//
// class GamesPage extends StatefulWidget {
//   @override
//   _GamesPageState createState() => _GamesPageState();
// }
//
// class _GamesPageState extends State<GamesPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Games')),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => TestGamePage()),
//                 );
//               },
//               child: Text('Start Test Game'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }








// ---------
// import 'package:flutter/material.dart';
// import 'games/test.dart'; // Import the test game logic
//
// class GamesPage extends StatefulWidget {
//   @override
//   _GamesPageState createState() => _GamesPageState();
// }
//
// class _GamesPageState extends State<GamesPage> {
//   int score = 0;
//
//   Future<void> _runTestGames() async {
//     for (int i = 0; i < 6; i++) {
//       bool correct = await runTestGame(context); // Pass context here
//       if (correct) {
//         setState(() {
//           score++;
//         });
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Games')),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text('Score: $score', style: TextStyle(fontSize: 24)),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _runTestGames,
//               child: Text('Start Test Game'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }



// import 'games/test.dart';
//
// export 'games/test.dart';
