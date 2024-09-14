

import 'package:flutter/material.dart';
import 'levels.dart';
import 'constants.dart';
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
                        const SizedBox(height:25),
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
            )
          ],
        ),
      ),
    ),
  );
}
}
