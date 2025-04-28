import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class WhiteboardApp extends StatelessWidget {
  const WhiteboardApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Whiteboard',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.dark,
      ),
      themeMode: ThemeMode.system,
      home: const WhiteboardScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class WhiteboardScreen extends StatefulWidget {
  const WhiteboardScreen({Key? key}) : super(key: key);

  @override
  State<WhiteboardScreen> createState() => _WhiteboardScreenState();
}

class _WhiteboardScreenState extends State<WhiteboardScreen> {
  // Drawing state
  Color selectedColor = Colors.black;
  double strokeWidth = 5.0;
  List<DrawingPoint?> points = [];
  List<List<DrawingPoint?>> history = [];
  List<List<DrawingPoint?>> redoHistory = [];
  bool isErasing = false;
  bool isSaving = false;
  bool isLoading = false;
  String? savedBoardId;

  // Available colors for selection
  final List<Color> colors = [
    Colors.black,
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.yellow,
    Colors.purple,
    Colors.orange,
    Colors.brown,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Whiteboard'),
        actions: [
          // Save button
          IconButton(
            icon: isSaving
                ? const CircularProgressIndicator(color: Colors.white)
                : const Icon(Icons.save),
            onPressed: isSaving ? null : _saveDrawing,
            tooltip: 'Save Drawing',
          ),
          // Load button
          IconButton(
            icon: isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : const Icon(Icons.folder_open),
            onPressed: isLoading ? null : _loadDrawing,
            tooltip: 'Load Drawing',
          ),
        ],
      ),
      body: Stack(
        children: [
          // Drawing canvas
          GestureDetector(
            onPanStart: (details) {
              setState(() {
                redoHistory = [];
                points.add(
                  DrawingPoint(
                    id: DateTime.now().millisecondsSinceEpoch,
                    offsets: [details.localPosition],
                    color: isErasing ? Colors.white : selectedColor,
                    width: isErasing ? strokeWidth * 2 : strokeWidth,
                    isEraser: isErasing,
                  ),
                );
              });
            },
            onPanUpdate: (details) {
              setState(() {
                if (points.isNotEmpty) {
                  DrawingPoint? lastPoint = points.last;
                  if (lastPoint != null) {
                    lastPoint.offsets.add(details.localPosition);
                  }
                }
              });
            },
            onPanEnd: (_) {
              setState(() {
                history.add(List.from(points));
                points.add(null);
              });
            },
            child: CustomPaint(
              painter: WhiteboardPainter(points: points),
              size: Size.infinite,
            ),
          ),
          // Bottom toolbar
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.9),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Color selection
                  SizedBox(
                    height: 50,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: colors.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                selectedColor = colors[index];
                                isErasing = false;
                              });
                            },
                            child: CircleAvatar(
                              radius: 20,
                              backgroundColor: colors[index],
                              child: selectedColor == colors[index] && !isErasing
                                  ? const Icon(Icons.check, color: Colors.white)
                                  : null,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Tool controls
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Pen tool
                      ToolButton(
                        icon: Icons.edit,
                        isSelected: !isErasing,
                        onPressed: () {
                          setState(() {
                            isErasing = false;
                          });
                        },
                        tooltip: 'Pen',
                      ),
                      // Eraser tool
                      ToolButton(
                        icon: Icons.auto_fix_high,
                        isSelected: isErasing,
                        onPressed: () {
                          setState(() {
                            isErasing = true;
                          });
                        },
                        tooltip: 'Eraser',
                      ),
                      // Stroke width slider
                      Expanded(
                        child: Slider(
                          value: strokeWidth,
                          min: 1.0,
                          max: 20.0,
                          divisions: 19,
                          label: strokeWidth.round().toString(),
                          onChanged: (value) {
                            setState(() {
                              strokeWidth = value;
                            });
                          },
                        ),
                      ),
                      // Undo button
                      ToolButton(
                        icon: Icons.undo,
                        isEnabled: history.isNotEmpty,
                        onPressed: _undo,
                        tooltip: 'Undo',
                      ),
                      // Redo button
                      ToolButton(
                        icon: Icons.redo,
                        isEnabled: redoHistory.isNotEmpty,
                        onPressed: _redo,
                        tooltip: 'Redo',
                      ),
                      // Clear all button
                      ToolButton(
                        icon: Icons.delete,
                        isEnabled: points.isNotEmpty,
                        onPressed: _clearCanvas,
                        tooltip: 'Clear All',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Undo the last drawing action
  void _undo() {
    if (history.isNotEmpty) {
      setState(() {
        final lastPoints = history.removeLast();
        redoHistory.add(lastPoints);
        points = history.isNotEmpty ? List.from(history.last) : [];
        if (points.isNotEmpty && points.last != null) {
          points.add(null);
        }
      });
    }
  }

  // Redo the last undone action
  void _redo() {
    if (redoHistory.isNotEmpty) {
      setState(() {
        final redoPoints = redoHistory.removeLast();
        history.add(redoPoints);
        points = List.from(redoPoints);
      });
    }
  }

  // Clear the entire canvas
  void _clearCanvas() {
    setState(() {
      history.add(List.from(points));
      redoHistory = [];
      points = [];
    });
  }

  // Save the drawing to the API
  Future<void> _saveDrawing() async {
    setState(() {
      isSaving = true;
    });

    try {
      // Convert drawing data to JSON
      final drawingData = {
        'points': points.map((point) => point?.toJson()).toList(),
        'timestamp': DateTime.now().toIso8601String(),
      };

      // Mock API call
      await Future.delayed(const Duration(seconds: 1));

      // In a real app, you would use something like:
      // final response = await http.post(
      //   Uri.parse('https://your-api.com/whiteboards'),
      //   headers: {'Content-Type': 'application/json'},
      //   body: jsonEncode(drawingData),
      // );

      // Mock successful response
      final mockResponse = {
        'id': 'wb_${DateTime.now().millisecondsSinceEpoch}',
        'status': 'success',
      };

      setState(() {
        savedBoardId = mockResponse['id'];
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Drawing saved with ID: ${savedBoardId}')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving drawing: $e')),
      );
    } finally {
      setState(() {
        isSaving = false;
      });
    }
  }

  // Load a drawing from the API
  Future<void> _loadDrawing() async {
    // In a real app, you might show a dialog to select which drawing to load
    if (savedBoardId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No saved drawing to load')),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      // Mock API call
      await Future.delayed(const Duration(seconds: 1));

      // In a real app, you would use something like:
      // final response = await http.get(
      //   Uri.parse('https://your-api.com/whiteboards/$savedBoardId'),
      //   headers: {'Content-Type': 'application/json'},
      // );
      // final data = jsonDecode(response.body);

      // For demo purposes, we'll just reload the current drawing
      setState(() {
        // In a real app, you would parse the points from the API response
        // points = (data['points'] as List).map((p) => p != null ? DrawingPoint.fromJson(p) : null).toList();
        history.add(List.from(points));
        redoHistory = [];
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Drawing loaded from ID: $savedBoardId')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading drawing: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
}

// Custom painter for the whiteboard
class WhiteboardPainter extends CustomPainter {
  final List<DrawingPoint?> points;

  WhiteboardPainter({required this.points});

  @override
  void paint(Canvas canvas, Size size) {
    // Draw white background
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = Colors.white,
    );

    // Draw all points
    for (int i = 0; i < points.length; i++) {
      if (points[i] == null) continue;

      final point = points[i]!;
      final offsets = point.offsets;

      if (offsets.isEmpty) continue;

      final paint = Paint()
        ..color = point.color
        ..strokeWidth = point.width
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..style = PaintingStyle.stroke;

      if (point.isEraser) {
        paint.blendMode = BlendMode.clear;
      }

      final path = Path();
      path.moveTo(offsets[0].dx, offsets[0].dy);

      for (int j = 1; j < offsets.length; j++) {
        path.lineTo(offsets[j].dx, offsets[j].dy);
      }

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant WhiteboardPainter oldDelegate) {
    return oldDelegate.points != points;
  }
}

// Model class for drawing points
class DrawingPoint {
  final int id;
  final List<Offset> offsets;
  final Color color;
  final double width;
  final bool isEraser;

  DrawingPoint({
    required this.id,
    required this.offsets,
    required this.color,
    required this.width,
    this.isEraser = false,
  });

  // Convert to JSON for API storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'offsets': offsets.map((offset) => {'dx': offset.dx, 'dy': offset.dy}).toList(),
      'color': color.value,
      'width': width,
      'isEraser': isEraser,
    };
  }

  // Create from JSON for API loading
  factory DrawingPoint.fromJson(Map<String, dynamic> json) {
    return DrawingPoint(
      id: json['id'],
      offsets: (json['offsets'] as List)
          .map((o) => Offset(o['dx'], o['dy']))
          .toList(),
      color: Color(json['color']),
      width: json['width'],
      isEraser: json['isEraser'],
    );
  }
}

// Custom button widget for tools
class ToolButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final bool isSelected;
  final bool isEnabled;
  final String tooltip;

  const ToolButton({
    Key? key,
    required this.icon,
    required this.onPressed,
    this.isSelected = false,
    this.isEnabled = true,
    required this.tooltip,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: isSelected
            ? Theme.of(context).primaryColor
            : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: isEnabled ? onPressed : null,
          child: Container(
            padding: const EdgeInsets.all(8),
            child: Icon(
              icon,
              color: isSelected
                  ? Colors.white
                  : isEnabled
                  ? Theme.of(context).iconTheme.color
                  : Theme.of(context).disabledColor,
            ),
          ),
        ),
      ),
    );
  }
}

