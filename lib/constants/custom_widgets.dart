import 'package:flutter/material.dart';

class FeedbackMessages {
  static const List<String> correctMessages = [
    "Молодец!",
    "Barakallah!",
    "Ma shaa Allah!",
    "Так держать!",
    "Правильно!",
  ];

  static const List<String> incorrectMessages = [
    "Неправильно!",
    "Не угадал",
    "Попробуй ещё раз!",
    "Ошибся",
  ];

  static Widget feedbackMessageWidget(String message, Color backgroundColor) {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 32,
          color: Colors.white,
        ),
      ),
    );
  }
}
