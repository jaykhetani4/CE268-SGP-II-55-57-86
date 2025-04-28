import 'package:flutter/material.dart';
import 'package:mudramitra/quiz/mudra_quiz2.dart';
import 'package:mudramitra/quiz/mudra_quiz3.dart';
import 'package:mudramitra/quiz/mudra_quiz_page.dart';
import '../about_us_page.dart';

class QuizSelectionPage extends StatelessWidget {

  const QuizSelectionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7D44C), // Yellow background color
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AboutUsPage()),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Logo
            const Icon(
              Icons.lightbulb_outline,
              size: 100,
              color: Colors.white,
            ),
            const SizedBox(height: 10),
            // App Name
            const Text(
              'MudraMitra',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 40),
            // Divider
            const Divider(
              color: Colors.black,
              thickness: 1,
              indent: 50,
              endIndent: 50,
            ),
            // Module 1 Button
            ModuleButton(
              title: 'Q1 - બારાખડી',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MudraQuizPage()),
                );
              },
            ),
            // Divider
            const Divider(
              color: Colors.black,
              thickness: 1,
              indent: 50,
              endIndent: 50,
            ),
            // Module 2 Button
            ModuleButton(
              title: 'Q2 - આંકડાઓ',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MudraQuizPage2()),
                );
              },
            ),
            // Divider
            const Divider(
              color: Colors.black,
              thickness: 1,
              indent: 50,
              endIndent: 50,
            ),
            // Module 3 Button
            ModuleButton(
              title: 'Q3 - શબ્દો',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MudraQuizPage3()),
                );
              },
            ),
            // Divider
            const Divider(
              color: Colors.black,
              thickness: 1,
              indent: 50,
              endIndent: 50,
            ),
          ],
        ),
      ),
    );
  }
}

class ModuleButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;

  const ModuleButton({
    super.key,
    required this.title,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 50.0),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          minimumSize: const Size(double.infinity, 60),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 2,
        ),
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}