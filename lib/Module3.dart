import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:mudramitra/whiteboard.dart';

import 'Module3.dart';

class Module3 extends StatefulWidget {
  const Module3();

  @override
  State<Module3> createState() => _Module3();
}

class _Module3 extends State<Module3> {
  final List<Wordsdata> words = [
    Wordsdata(gujaratiChar: '1', imagePath: 'assets/words/1.png', audioPath: 'wordsaudio/1.mp3', example: 'હેલો'),
    Wordsdata(gujaratiChar: '2', imagePath: 'assets/words/2.png', audioPath: 'wordsaudio/2.mp3', example: 'બહિરા'),
    Wordsdata(gujaratiChar: '3', imagePath: 'assets/words/3.png', audioPath: 'wordsaudio/3.mp3', example: 'હા'),
    Wordsdata(gujaratiChar: '4', imagePath: 'assets/words/4.png', audioPath: 'wordsaudio/4.mp3', example: 'મિત્રો'),
    Wordsdata(gujaratiChar: '5', imagePath: 'assets/words/5.png', audioPath: 'wordsaudio/5.mp3', example: 'ના'),
    Wordsdata(gujaratiChar: '6', imagePath: 'assets/words/6.png', audioPath: 'wordsaudio/6.mp3', example: 'માં'),
    Wordsdata(gujaratiChar: '7', imagePath: 'assets/words/7.png', audioPath: 'wordsaudio/7.mp3', example: 'બાપ'),
    Wordsdata(gujaratiChar: '8', imagePath: 'assets/words/8.png', audioPath: 'wordsaudio/8.mp3', example: 'શૌચાલય'),
    Wordsdata(gujaratiChar: '9', imagePath: 'assets/words/9.png', audioPath: 'wordsaudio/9.mp3', example: 'પથારી'),
    Wordsdata(gujaratiChar: '10', imagePath: 'assets/words/10.png', audioPath: 'wordsaudio/10.mp3', example: 'નામ'),
    Wordsdata(gujaratiChar: '11', imagePath: 'assets/words/11.png', audioPath: 'wordsaudio/11.mp3', example: 'ભોજન'),
    Wordsdata(gujaratiChar: '12', imagePath: 'assets/words/12.png', audioPath: 'wordsaudio/12.mp3', example: 'પાણી '),
    Wordsdata(gujaratiChar: '13', imagePath: 'assets/words/13.png', audioPath: 'wordsaudio/13.mp3', example: 'સ્નાન'),
    Wordsdata(gujaratiChar: '14', imagePath: 'assets/words/14.png', audioPath: 'wordsaudio/14.mp3', example: 'કામ'),
    Wordsdata(gujaratiChar: '15', imagePath: 'assets/words/15.png', audioPath: 'wordsaudio/15.mp3', example: 'ઘર'),
  ];

  int currentIndex = 0;

  void goToPrevious() {
    setState(() {
      currentIndex = (currentIndex > 0) ? currentIndex - 1 : words.length - 1;
    });
  }

  void goToNext() {
    setState(() {
      currentIndex = (currentIndex < words.length - 1) ? currentIndex + 1 : 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MudraPage(
      wordsData: words[currentIndex],
      onPrevious: goToPrevious,
      onNext: goToNext,
    );
  }
}

class MudraPage extends StatefulWidget {
  final Wordsdata wordsData;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  const MudraPage({
    super.key,
    required this.wordsData,
    required this.onPrevious,
    required this.onNext,
  });

  @override
  State<MudraPage> createState() => _MudraPageState();
}

class _MudraPageState extends State<MudraPage> {
  // Improved AudioPlayer implementation
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool isPlaying = false;

  void playAudio() async {
    try {
      String correctedPath = widget.wordsData.audioPath.trim().replaceAll('"', '');
      print("Attempting to play audio from: $correctedPath");

      await _audioPlayer.setSource(AssetSource(correctedPath));
      await _audioPlayer.resume();

      print("Audio started playing...");
      setState(() => isPlaying = true);
    } catch (e) {
      print('Error playing audio: $e');
      setState(() => isPlaying = false);
    }
  }

  // Navigate to whiteboard screen
  void navigateToWhiteboard() {
    // This will be implemented separately as mentioned
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const WhiteboardApp()
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Get screen size for responsive layout
    final screenSize = MediaQuery.of(context).size;
    final imageSize = screenSize.height * 0.35; // Adjust image size based on screen height

    return Scaffold(
      backgroundColor: const Color(0xFFF7D44C),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              children: [
                // Header with logo and profile
                Padding(
                  padding: const EdgeInsets.all(12.0), // Reduced padding
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('MudraMitra',
                          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
                      const CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Icon(Icons.person, size: 30, color: Color(0xFFF7D44C)),
                      ),
                    ],
                  ),
                ),

                // Title
                const Text('શબ્દો',
                    style: TextStyle(fontSize: 42, fontWeight: FontWeight.bold, color: Colors.black)),
                Container(width: 200, height: 3, color: Colors.black),

                // Main content area - takes available space
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Image with 0 radius corners
                      ClipRRect(
                        borderRadius: BorderRadius.circular(0),
                        child: Image.asset(
                          widget.wordsData.imagePath,
                          fit: BoxFit.cover,
                          width: imageSize,
                          height: imageSize,
                        ),
                      ),

                      // Audio button and Whiteboard icon side by side
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Audio button
                          GestureDetector(
                            onTap: playAudio,
                            child: CircleAvatar(
                              radius: 35,
                              backgroundColor: Colors.white,
                              child: Icon(
                                  isPlaying ? Icons.volume_up : Icons.volume_up_outlined,
                                  size: 40,
                                  color: Colors.black
                              ),
                            ),
                          ),

                          const SizedBox(width: 30), // Space between buttons

                          // Whiteboard icon
                          GestureDetector(
                            onTap: navigateToWhiteboard,
                            child: const CircleAvatar(
                              radius: 35,
                              backgroundColor: Colors.white,
                              child: Icon(
                                Icons.edit, // Using edit icon for whiteboard
                                size: 40,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),

                          // Example text with FittedBox to prevent overflow
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20.0),
                              child: Text(
                                widget.wordsData.example,
                                style: const TextStyle(fontSize: 50, fontWeight: FontWeight.bold, color: Colors.black),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                // Attractive navigation buttons
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0, top: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Previous button
                      _buildNavigationButton(
                        icon: Icons.chevron_left,
                        onPressed: widget.onPrevious,
                        label: "Previous",
                      ),

                      const SizedBox(width: 30),

                      // Next button
                      _buildNavigationButton(
                        icon: Icons.chevron_right,
                        onPressed: widget.onNext,
                        label: "Next",
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  // Custom attractive navigation button
  Widget _buildNavigationButton({
    required IconData icon,
    required VoidCallback onPressed,
    required String label,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.black, Color(0xFF333333)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(15),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              children: [
                Icon(icon, size: 30, color: Colors.white),
                const SizedBox(width: 5),
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Wordsdata {
  final String gujaratiChar;
  final String imagePath;
  final String audioPath;
  final String example;

  Wordsdata({required this.gujaratiChar, required this.imagePath, required this.audioPath, required this.example});
}