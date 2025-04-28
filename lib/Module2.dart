import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:mudramitra/whiteboard.dart';

class Module2 extends StatefulWidget {
  const Module2();

  @override
  State<Module2> createState() => _Module2();
}

class _Module2 extends State<Module2> {
  final List<NumberData> alphabets = [
    NumberData(gujaratiChar: '0', imagePath: 'assets/number/1.png', audioPath: 'numberaudio/1.mp3'),
    NumberData(gujaratiChar: '1', imagePath: 'assets/number/2.png', audioPath: 'numberaudio/2.mp3'),
    NumberData(gujaratiChar: '2', imagePath: 'assets/number/3.png', audioPath: 'numberaudio/3.mp3'),
    NumberData(gujaratiChar: '3', imagePath: 'assets/number/4.png', audioPath: 'numberaudio/4.mp3'),
    NumberData(gujaratiChar: '4', imagePath: 'assets/number/5.png', audioPath: 'numberaudio/5.mp3'),
    NumberData(gujaratiChar: '5', imagePath: 'assets/number/6.png', audioPath: 'numberaudio/6.mp3'),
    NumberData(gujaratiChar: '6', imagePath: 'assets/number/7.png', audioPath: 'numberaudio/7.mp3'),
    NumberData(gujaratiChar: '7', imagePath: 'assets/number/8.png', audioPath: 'numberaudio/8.mp3'),
    NumberData(gujaratiChar: '8', imagePath: 'assets/number/9.png', audioPath: 'numberaudio/9.mp3'),
    NumberData(gujaratiChar: '9', imagePath: 'assets/number/10.png', audioPath: 'numberaudio/10.mp3'),
    NumberData(gujaratiChar: '10', imagePath: 'assets/number/11.png', audioPath: 'numberaudio/11.mp3'),
  ];

  int currentIndex = 0;

  void goToPrevious() {
    setState(() {
      currentIndex = (currentIndex > 0) ? currentIndex - 1 : alphabets.length - 1;
    });
  }

  void goToNext() {
    setState(() {
      currentIndex = (currentIndex < alphabets.length - 1) ? currentIndex + 1 : 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MudraPage(
      alphabetData: alphabets[currentIndex],
      onPrevious: goToPrevious,
      onNext: goToNext,
    );
  }
}

class MudraPage extends StatefulWidget {
  final NumberData alphabetData;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  const MudraPage({
    super.key,
    required this.alphabetData,
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
      String correctedPath = widget.alphabetData.audioPath.trim().replaceAll('"', '');
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
                const Text('આંકડાઓ',
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
                          widget.alphabetData.imagePath,
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

class NumberData {
  final String gujaratiChar;
  final String imagePath;
  final String audioPath;

  NumberData({required this.gujaratiChar, required this.imagePath, required this.audioPath});
}