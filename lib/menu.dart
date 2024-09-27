

import 'package:flutter/material.dart';
import 'levels.dart';
import 'constants/constants.dart';
import 'package:wave_linear_progress_indicator/wave_linear_progress_indicator.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
Widget build(BuildContext context) {
  return Scaffold(

    body: SafeArea(
      child: Center(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    // const SizedBox(height: 20),
                    SizedBox (
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: ElevatedButton(
                          style: menuButtonsTheme,
                            onPressed: () {
                              Navigator.push (
                                context,
                                MaterialPageRoute(builder: (context) => LevelsPage())
                              );
                            },
                            child: Column(
                              children: [
                                const SizedBox(height:15),
                                const Text("50% слов Корана",
                                style: TextStyle(
                                  fontSize: 35,
                                  fontWeight: FontWeight.bold
                                )),
                                const SizedBox(height:14),
                                const Text("Ваш прогресс:",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold
                                )),
                                //Need to update the code,
                                // so the value of the ProgressBar will change
                                // automatically inshaallah, async *
                                WaveLinearProgressIndicator(
                                  value: progress,
                                  enableBounceAnimation: true,
                                  borderRadius: 3.0,
                                  minHeight: 20,
                                  waveWidth: 12,
                                  waveColor: Colors.pinkAccent.shade200,
                                  waveBackgroundColor: Colors.white,
                                  labelDecoration: BoxDecoration(
                                    color: Colors.pinkAccent,
                                    borderRadius: BorderRadius.circular(7.0),
                                  ),

                                ),
                              ],
                            )),
                      )
                    ),

                    SizedBox (
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: ElevatedButton(
                              style: menuButtonsThemeLocked,
                              onPressed: () {
                                // Navigator.push (
                                //     context,
                                //     MaterialPageRoute(builder: (context) => LevelsPage())
                                // );
                              },
                              child: Column(
                                children: [
                                  const SizedBox(height:15),
                                  Row(
                                    children: const [
                                      Text("60% слов Корана",
                                          style: TextStyle(
                                              fontSize: 30,
                                              fontWeight: FontWeight.bold
                                          )),
                                      SizedBox(width: 35),
                                      Icon(Icons.lock),
                                    ],
                                  ),
                                  const SizedBox(height:25),
                                  //Need to update the code,
                                  // so the value of the ProgressBar will change
                                  // automatically inshaallah, async *
                                  WaveLinearProgressIndicator(
                                    value: 0,
                                    enableBounceAnimation: true,
                                    borderRadius: 3.0,
                                    minHeight: 20,
                                    waveWidth: 12,
                                    waveColor: Colors.black26,
                                    waveBackgroundColor: Colors.white,
                                    labelDecoration: BoxDecoration(
                                      color: Colors.black26,
                                      borderRadius: BorderRadius.circular(7.0),
                                    ),

                                  ),
                                ],
                              )),
                        )
                    ),

                    SizedBox (
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: ElevatedButton(
                              style: menuButtonsThemeLocked,
                              onPressed: () {
                                // Navigator.push (
                                //     context,
                                //     MaterialPageRoute(builder: (context) => null)
                                // );
                              },
                              child: Column(
                                children: [
                                  const SizedBox(height:15),
                                  Row(
                                    children: const [
                                      Text("85% слов Корана",
                                          style: TextStyle(
                                              fontSize: 30,
                                              fontWeight: FontWeight.bold
                                          )),
                                      SizedBox(width: 35),
                                      Icon(Icons.lock),
                                    ],
                                  ),
                                  const SizedBox(height:25),
                                  //Need to update the code,
                                  // so the value of the ProgressBar will change
                                  // automatically inshaallah, async *
                                  WaveLinearProgressIndicator(
                                    value: 0,
                                    enableBounceAnimation: true,
                                    borderRadius: 3.0,
                                    minHeight: 20,
                                    waveWidth: 12,
                                    waveColor: Colors.black26,
                                    waveBackgroundColor: Colors.white,
                                    labelDecoration: BoxDecoration(
                                      color: Colors.black26,
                                      borderRadius: BorderRadius.circular(7.0),
                                    ),

                                  ),
                                ],
                              )),
                        )
                    ),

                    SizedBox (
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: ElevatedButton(
                              style: menuButtonsThemeLocked,
                              onPressed: () {
                                // Navigator.push (
                                //     context,
                                //     MaterialPageRoute(builder: (context) => null)
                                // );
                              },
                              child: Column(
                                children: [
                                  const SizedBox(height:15),
                                  Row(
                                    children: const [
                                      Text("Суры 30 джузъа",
                                          style: TextStyle(
                                              fontSize: 30,
                                              fontWeight: FontWeight.bold
                                          )),
                                      SizedBox(width: 35),
                                      Icon(Icons.lock),
                                    ],
                                  ),
                                  const SizedBox(height:25),
                                  //Need to update the code,
                                  // so the value of the ProgressBar will change
                                  // automatically inshaallah, async *
                                  WaveLinearProgressIndicator(
                                    value: 0,
                                    enableBounceAnimation: true,
                                    borderRadius: 3.0,
                                    minHeight: 20,
                                    waveWidth: 12,
                                    waveColor: Colors.black26,
                                    waveBackgroundColor: Colors.white,
                                    labelDecoration: BoxDecoration(
                                      color: Colors.black26,
                                      borderRadius: BorderRadius.circular(7.0),
                                    ),

                                  ),
                                ],
                              )),
                        )
                    )


                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
}
