import 'package:flutter/material.dart';
import 'package:mudramitra/about_us_page.dart';
import 'package:mudramitra/module_selection_page.dart';
import 'package:mudramitra/quiz_selection_page.dart';
import 'package:mudramitra/whiteboard.dart';


class MudraDashboard extends StatelessWidget {
  const MudraDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFD54F), // Yellow background
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'MudraMitra Dashboard',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            // Profile and Greeting
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Welcome Back!',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.person,
                    size: 30,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            // Dashboard Options
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                children: [
                  _buildDashboardButton('Modules', Icons.book, context, () => ModulesPage()),
                  _buildDashboardButton('Quiz', Icons.quiz, context, () => QuizPage()),
                  _buildDashboardButton('Whiteboard', Icons.brush, context, () => WhiteboardPage()),
                  _buildDashboardButton('AboutUs', Icons.settings, context, () => SettingsPage()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardButton(String title, IconData icon, BuildContext context, Widget Function() pageBuilder) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => pageBuilder()), // Call function to create the page
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.black),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ✅ Modified ModulesPage to Accept userId
class ModulesPage extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return ModuleSelectionPage();
  }
}

// ✅ Modified QuizPage to Accept userId
class QuizPage extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return QuizSelectionPage();
  }
}

// ✅ Other pages remain unchanged
class WhiteboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WhiteboardApp();
  }
}

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const AboutUsPage();
  }
}
