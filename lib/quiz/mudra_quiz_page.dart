import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mudramitra/api_connections/api_connection.dart';

import '../Module2.dart';

class MudraQuizPage extends StatefulWidget {

  const MudraQuizPage({Key? key}) : super(key: key);

  @override
  State<MudraQuizPage> createState() => _MudraQuizPageState();
}

class _MudraQuizPageState extends State<MudraQuizPage> {
  final List<QuizQuestion> questions = [
    QuizQuestion(
      imagePath: 'assets/quiz1/1.png',
      options: ['અ', 'થ', 'ધ', 'ન'],
      correctAnswerIndex: 0,
    ),
    QuizQuestion(
      imagePath: 'assets/quiz1/2.png',
      options: ['ક', 'ખ', 'આ', 'ઘ'],
      correctAnswerIndex: 2,
    ),
    QuizQuestion(
      imagePath: 'assets/quiz1/3.png',
      options: ['અ', 'થ', 'ધ', 'ઈ'],
      correctAnswerIndex: 3,
    ),
    QuizQuestion(
      imagePath: 'assets/quiz1/4.png',
      options: ['ક', 'ખ', 'ઈ', 'ઘ'],
      correctAnswerIndex: 2,
    ),
    QuizQuestion(
      imagePath: 'assets/quiz1/5.png',
      options: ['અ', 'થ', 'ઉ', 'ન'],
      correctAnswerIndex: 2,
    ),
    QuizQuestion(
      imagePath: 'assets/quiz1/6.png',
      options: ['ઊ', 'થ', 'ધ', 'ન'],
      correctAnswerIndex: 0,
    ),
    QuizQuestion(
      imagePath: 'assets/quiz1/7.png',
      options: ['અ', 'થ', 'ધ', 'એ'],
      correctAnswerIndex: 3,
    ),
    QuizQuestion(
      imagePath: 'assets/quiz1/8.png',
      options: ['અ', 'ઐ', 'ધ', 'ન'],
      correctAnswerIndex: 1,
    ),
    QuizQuestion(
      imagePath: 'assets/quiz1/9.png',
      options: ['અ', 'થ', 'ધ', 'ઓ'],
      correctAnswerIndex: 3,
    ),
    QuizQuestion(
      imagePath: 'assets/quiz1/10.png',
      options: ['ઔ', 'થ', 'ધ', 'ન'],
      correctAnswerIndex: 0,
    ),
  ];

  int currentQuestionIndex = 0;
  int? selectedOptionIndex;
  bool isSubmitted = false;
  bool isCorrect = false;
  int score = 0;

  void selectOption(int index) {
    if (!isSubmitted) {
      setState(() {
        selectedOptionIndex = index;
      });
    }
  }Future<void> submitQuizResult(int userId, String quizName, int score, String awards) async {
    try{
      final url = Uri.parse(API.storeQuiz);
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "user_id": userId,
          "quiz_name": quizName,
          "score": score,
          "awards": awards,
        }),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data["success"]) {
          print("Quiz result saved successfully!");
        } else {
          print("Error: ${data["message"]}");
        }
      } else {
        print("Failed to connect to server.");
      }
    }catch (e)
    {
      print(e);
    }





  }



  void submitAnswer() {
    if (selectedOptionIndex == null) return;

    setState(() {
      isSubmitted = true;
      isCorrect = selectedOptionIndex == questions[currentQuestionIndex].correctAnswerIndex;
      if (isCorrect) score++;
    });

    Future.delayed(const Duration(seconds: 1), () {
      if (currentQuestionIndex < questions.length - 1) {
        setState(() {
          currentQuestionIndex++;
          selectedOptionIndex = null;
          isSubmitted = false;
        });
      } else {
        // Show results dialog when quiz is complete
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            title: const Text('Quiz Completed!'),
            content: Text('Your score: $score/${questions.length}'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  resetQuiz();
                },
                child: const Text('Retake Quiz'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Module2()),
                  );
                },
                child: const Text('Next Module'),
              ),
            ],
          ),
        );

      }
    });
  }
  String getAward(int score) {
    if (score == 10) return "Gold Medal 🏅";
    if (score >= 7) return "Silver Medal 🥈";
    if (score >= 5) return "Bronze Medal 🥉";
    return "Better Luck Next Time!";
  }

  void resetQuiz() {
    setState(() {
      currentQuestionIndex = 0;
      selectedOptionIndex = null;
      isSubmitted = false;
      score = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final imageSize = screenSize.height * 0.35; // Adjust image size based on screen height
    final currentQuestion = questions[currentQuestionIndex];
    final progress = (currentQuestionIndex + 1) / questions.length;

    return Scaffold(
      backgroundColor: const Color(0xFFF7D44C),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'MudraMitra',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.person,
                        size: 30,
                        color: Color(0xFFF7D44C),
                      ),
                    ),
                  ],
                ),
              ),

              // Progress bar
              LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.white.withOpacity(0.3),
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                minHeight: 10,
              ),

              const SizedBox(height: 10),

              // Quiz title
              const Text(
                'QUIZ TIME',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),

              const SizedBox(height: 20,width: 20,),

              // Question image
              Container(
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(0),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(0),
                  child: Image.asset(
                    currentQuestion.imagePath,
                    fit: BoxFit.cover,
                    width: imageSize,
                    height: imageSize,
                    errorBuilder: (context, error, stackTrace) =>
                    const Center(child: Text('Image not found')),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Options grid
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 2.5,
                  children: List.generate(
                    currentQuestion.options.length,
                        (index) => _buildOptionButton(currentQuestion.options[index], index),
                  ),
                ),
              ),

              // Submit button
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: ElevatedButton(
                  onPressed: selectedOptionIndex != null && !isSubmitted ? submitAnswer : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 3,
                  ),
                  child: const Text(
                    'SUBMIT',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptionButton(String option, int index) {
    Color backgroundColor = Colors.white;
    Color textColor = Colors.black;

    if (isSubmitted) {
      if (index == questions[currentQuestionIndex].correctAnswerIndex) {
        backgroundColor = Colors.green;
        textColor = Colors.white;
      } else if (index == selectedOptionIndex) {
        backgroundColor = Colors.red;
        textColor = Colors.white;
      }
    } else if (selectedOptionIndex == index) {
      backgroundColor = Colors.blue[100]!;
    }

    return GestureDetector(
      onTap: () => selectOption(index),
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: Text(
            option,
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}

class QuizQuestion {
  final String imagePath;
  final List<String> options;
  final int correctAnswerIndex;

  QuizQuestion({
    required this.imagePath,
    required this.options,
    required this.correctAnswerIndex,
  });
}