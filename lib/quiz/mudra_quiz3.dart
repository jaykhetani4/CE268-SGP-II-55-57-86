import 'dart:math';
import 'package:flutter/material.dart';

import '../dashboard.dart';

class MudraQuizPage3 extends StatefulWidget {
  const MudraQuizPage3({super.key});

  @override
  State<MudraQuizPage3> createState() => _MudraQuizPageState();
}

class _MudraQuizPageState extends State<MudraQuizPage3> {
  // Image and option data
  final List<String> allImages = List.generate(10, (index) => 'assets/quiz3/${index + 1}.png');
  final List<String> allOptions = [
    'હેલો', 'બહિરા', 'હા', 'મિત્ર', 'ના',
    'મા', 'બાપ', 'શૌચાલય', 'પથારી', 'નામ',
    'ભોજન', 'પાણી', 'સ્નાન', 'કામ', 'ઘર'
  ];


  List<QuizQuestion> questions = [];
  int currentQuestionIndex = 0;
  int? selectedOptionIndex;
  bool isSubmitted = false;
  bool isCorrect = false;
  int score = 0;

  @override
  void initState() {
    super.initState();
    generateRandomQuestions();
  }

  void generateRandomQuestions() {
    final random = Random();
    List<String> selectedImages = [...allImages]..shuffle();

    questions = selectedImages.take(10).map((imagePath) {
      // Extract the correct answer from the filename (e.g., 'assets/quiz1/1.png' -> '1')
      String filename = imagePath.split('/').last.split('.').first;
      int imageIndex = int.tryParse(filename) ?? 1; // Use 1 as fallback if parsing fails
      imageIndex = imageIndex.clamp(1, allOptions.length) - 1; // Ensure index is within bounds

      String correctAnswer = allOptions[imageIndex]; // Get corresponding Gujarati character

      // Generate unique options including the correct one
      List<String> options = [...allOptions.where((opt) => opt != correctAnswer)]..shuffle();
      options = options.take(3).toList(); // Pick 3 incorrect ones
      options.add(correctAnswer); // Add correct answer
      options.shuffle(); // Shuffle final options

      return QuizQuestion(
        imagePath: imagePath,
        options: options,
        correctAnswerIndex: options.indexOf(correctAnswer),
      );
    }).toList();

    setState(() {});
  }


  void selectOption(int index) {
    if (!isSubmitted) {
      setState(() {
        selectedOptionIndex = index;
      });
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
                child: const Text('Restart Quiz'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MudraDashboard()),
                  );
                },
                child: const Text('Complete'),
              ),
            ],
          ),
        );
      }
    });
  }

  void resetQuiz() {
    setState(() {
      currentQuestionIndex = 0;
      selectedOptionIndex = null;
      isSubmitted = false;
      score = 0;
      generateRandomQuestions(); // Generate new random questions
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final imageSize = screenSize.height * 0.35;
    final currentQuestion = questions[currentQuestionIndex];
    final progress = (currentQuestionIndex + 1) / questions.length;

    return Scaffold(
      backgroundColor: const Color(0xFFF7D44C),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
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

              LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.white.withOpacity(0.3),
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                minHeight: 10,
              ),

              const SizedBox(height: 10),

              const Text(
                'QUIZ TIME',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),

              const SizedBox(height: 20),

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
