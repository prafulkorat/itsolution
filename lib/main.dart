import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Padding(
          padding: EdgeInsets.all(32.0),
          child: SquareAnimation(),
        ),
      ),
    );
  }
}

class SquareAnimation extends StatefulWidget {
  const SquareAnimation({super.key});

  @override
  State<SquareAnimation> createState() => _SquareAnimationState();
}

class _SquareAnimationState extends State<SquareAnimation> {
  static const double _squareSize = 50.0;
  double _position = 0;
  double _lastScreenWidth = 0;
  bool _wasAtRightEdge = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      double screenWidth = MediaQuery.of(context).size.width;
      double maxPosition = screenWidth - _squareSize;
      setState(() {
        _position = maxPosition / 2;
        _lastScreenWidth = screenWidth;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double screenWidth = constraints.maxWidth;
        double maxPosition = screenWidth - _squareSize;

        if (_lastScreenWidth != screenWidth) {
          if (_wasAtRightEdge) {
            _position = maxPosition;
          }
          _wasAtRightEdge = (_position >= _lastScreenWidth - _squareSize);
          _lastScreenWidth = screenWidth;
        }

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: _squareSize,
              width: double.infinity,
              child: Stack(
                children: [
                  AnimatedPositioned(
                    duration: const Duration(seconds: 1),
                    left: _position,
                    child: Container(
                      width: _squareSize,
                      height: _squareSize,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        border: Border.all(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: (_position == 0)
                      ? null
                      : () {
                    setState(() {
                      _position = 0;
                      _wasAtRightEdge = false;
                    });
                  },
                  child: const Text('Left'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: (_position == maxPosition)
                      ? null
                      : () {
                    setState(() {
                      _position = maxPosition;
                      _wasAtRightEdge = true;
                    });
                  },
                  child: const Text('Right'),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
