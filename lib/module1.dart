import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:mudramitra/whiteboard.dart';

class Module1 extends StatefulWidget {
  const Module1();

  @override
  State<Module1> createState() => _MudraHomePageState();
}

class _MudraHomePageState extends State<Module1> {
  final List<AlphabetData> alphabets = [
    AlphabetData(gujaratiChar: 'અ', imagePath: 'assets/images/1.png', audioPath: 'audio/1.mp3', example: 'અંબા'),
    AlphabetData(gujaratiChar: 'આ', imagePath: 'assets/images/2.png', audioPath: 'audio/2.mp3', example: 'આમ'),
    AlphabetData(gujaratiChar: 'ઇ', imagePath: 'assets/images/3.png', audioPath: 'audio/3.mp3', example: 'ઇમલી'),
    AlphabetData(gujaratiChar: 'ઈ', imagePath: 'assets/images/4.png', audioPath: 'audio/4.mp3', example: 'ઈકળ'),
    AlphabetData(gujaratiChar: 'ઉ', imagePath: 'assets/images/5.png', audioPath: 'audio/5.mp3', example: 'ઉલ્લૂ'),
    AlphabetData(gujaratiChar: 'ઊ', imagePath: 'assets/images/6.png', audioPath: 'audio/6.mp3', example: 'ઊંટ'),
    AlphabetData(gujaratiChar: 'એ', imagePath: 'assets/images/7.png', audioPath: 'audio/7.mp3', example: 'એક'),
    AlphabetData(gujaratiChar: 'ઐ', imagePath: 'assets/images/8.png', audioPath: 'audio/8.mp3', example: 'ઐનક'),
    AlphabetData(gujaratiChar: 'ઓ', imagePath: 'assets/images/9.png', audioPath: 'audio/9.mp3', example: 'ઓખલી'),
    AlphabetData(gujaratiChar: 'ઔ', imagePath: 'assets/images/10.png', audioPath: 'audio/10.mp3', example: 'ઔષધિ'),
    AlphabetData(gujaratiChar: 'અં', imagePath: 'assets/images/11.png', audioPath: 'audio/11.mp3', example: 'અંધકાર'),
    AlphabetData(gujaratiChar: 'અઃ', imagePath: 'assets/images/12.png', audioPath: 'audio/12.mp3', example: 'અઃકાર'),
    AlphabetData(gujaratiChar: 'ક', imagePath: 'assets/images/13.png', audioPath: 'audio/13.mp3', example: 'કિતાબ'),
    AlphabetData(gujaratiChar: 'ખ', imagePath: 'assets/images/14.png', audioPath: 'audio/14.mp3', example: 'ખરગોશ'),
    AlphabetData(gujaratiChar: 'ગ', imagePath: 'assets/images/15.png', audioPath: 'audio/15.mp3', example: 'ગાય'),
    AlphabetData(gujaratiChar: 'ઘ', imagePath: 'assets/images/16.png', audioPath: 'audio/16.mp3', example: 'ઘડિયાળ'),
    AlphabetData(gujaratiChar: 'ચ', imagePath: 'assets/images/17.png', audioPath: 'audio/17.mp3', example: 'ચમચી'),
    AlphabetData(gujaratiChar: 'છ', imagePath: 'assets/images/18.png', audioPath: 'audio/18.mp3', example: 'છત્રી'),
    AlphabetData(gujaratiChar: 'જ', imagePath: 'assets/images/19.png', audioPath: 'audio/19.mp3', example: 'જલ'),
    AlphabetData(gujaratiChar: 'ઝ', imagePath: 'assets/images/20.png', audioPath: 'audio/20.mp3', example: 'ઝાડ'),
    AlphabetData(gujaratiChar: 'ટ', imagePath: 'assets/images/21.png', audioPath: 'audio/21.mp3', example: 'ટમેટું'),
    AlphabetData(gujaratiChar: 'ઠ', imagePath: 'assets/images/22.png', audioPath: 'audio/22.mp3', example: 'ઠપ્પો'),
    AlphabetData(gujaratiChar: 'ડ', imagePath: 'assets/images/23.png', audioPath: 'audio/23.mp3', example: 'ડંખ'),
    AlphabetData(gujaratiChar: 'ઢ', imagePath: 'assets/images/24.png', audioPath: 'audio/24.mp3', example: 'ઢોલ'),
    AlphabetData(gujaratiChar: 'ણ', imagePath: 'assets/images/25.png', audioPath: 'audio/25.mp3', example: 'ણમ'),
    AlphabetData(gujaratiChar: 'ત', imagePath: 'assets/images/26.png', audioPath: 'audio/26.mp3', example: 'તાળું'),
    AlphabetData(gujaratiChar: 'થ', imagePath: 'assets/images/27.png', audioPath: 'audio/27.mp3', example: 'થેલી'),
    AlphabetData(gujaratiChar: 'દ', imagePath: 'assets/images/28.png', audioPath: 'audio/28.mp3', example: 'દરવાજો'),
    AlphabetData(gujaratiChar: 'ધ', imagePath: 'assets/images/29.png', audioPath: 'audio/29.mp3', example: 'ધાબો'),
    AlphabetData(gujaratiChar: 'ન', imagePath: 'assets/images/30.png', audioPath: 'audio/30.mp3', example: 'નદી'),
    AlphabetData(gujaratiChar: 'પ', imagePath: 'assets/images/31.png', audioPath: 'audio/31.mp3', example: 'પંખી'),
    AlphabetData(gujaratiChar: 'ફ', imagePath: 'assets/images/32.png', audioPath: 'audio/32.mp3', example: 'ફળ'),
    AlphabetData(gujaratiChar: 'બ', imagePath: 'assets/images/33.png', audioPath: 'audio/33.mp3', example: 'બાલક'),
    AlphabetData(gujaratiChar: 'ભ', imagePath: 'assets/images/34.png', audioPath: 'audio/34.mp3', example: 'ભીષણ'),
    AlphabetData(gujaratiChar: 'મ', imagePath: 'assets/images/35.png', audioPath: 'audio/35.mp3', example: 'મકાન'),
    AlphabetData(gujaratiChar: 'ય', imagePath: 'assets/images/36.png', audioPath: 'audio/36.mp3', example: 'યજમાન'),
    AlphabetData(gujaratiChar: 'ર', imagePath: 'assets/images/37.png', audioPath: 'audio/37.mp3', example: 'રથ'),
    AlphabetData(gujaratiChar: 'લ', imagePath: 'assets/images/38.png', audioPath: 'audio/38.mp3', example: 'લાટ'),
    AlphabetData(gujaratiChar: 'વ', imagePath: 'assets/images/39.png', audioPath: 'audio/39.mp3', example: 'વાઘ'),
    AlphabetData(gujaratiChar: 'શ', imagePath: 'assets/images/40.png', audioPath: 'audio/40.mp3', example: 'શિયાળ'),
    AlphabetData(gujaratiChar: 'ષ', imagePath: 'assets/images/41.png', audioPath: 'audio/41.mp3', example: 'ષટ્કોણ'),
    AlphabetData(gujaratiChar: 'સ', imagePath: 'assets/images/42.png', audioPath: 'audio/42.mp3', example: 'સરસ'),
    AlphabetData(gujaratiChar: 'હ', imagePath: 'assets/images/43.png', audioPath: 'audio/43.mp3', example: 'હાથી'),
    AlphabetData(gujaratiChar: 'ળ', imagePath: 'assets/images/44.png', audioPath: 'audio/44.mp3', example: 'ળટ'),
    AlphabetData(gujaratiChar: 'ક્ષ', imagePath: 'assets/images/45.png', audioPath: 'audio/45.mp3', example: 'ક્ષેત્ર'),
    AlphabetData(gujaratiChar: 'જ્ઞ', imagePath: 'assets/images/46.png', audioPath: 'audio/46.mp3', example: 'જ્ઞાન'),
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
  final AlphabetData alphabetData;
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
                const Text('બારાખડી',
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
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Text(
                            widget.alphabetData.example,
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

class AlphabetData {
  final String gujaratiChar;
  final String imagePath;
  final String audioPath;
  final String example;

  AlphabetData({required this.gujaratiChar, required this.imagePath, required this.audioPath, required this.example});
}