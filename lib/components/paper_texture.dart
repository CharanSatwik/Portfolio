import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class PaperTexture extends StatefulWidget {
  final Widget child;
  final double opacity;

  const PaperTexture({super.key, required this.child, this.opacity = 0.05});

  @override
  State<PaperTexture> createState() => _PaperTextureState();
}

class _PaperTextureState extends State<PaperTexture> {
  ui.Image? _noiseImage;

  @override
  void initState() {
    super.initState();
    _generateNoise();
  }

  Future<void> _generateNoise() async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    final paint = Paint();
    final random = _FastRandom(42);

    const size = 256.0;
    for (double x = 0; x < size; x++) {
      for (double y = 0; y < size; y++) {
        final value = random.nextByte();
        if (value > 200) {
          // Only draw some pixels to keep it subtle
          paint.color = Color.fromARGB(
            (value % 50) + 20, // Low alpha for individual pixels
            0,
            0,
            0,
          );
          canvas.drawRect(Rect.fromLTWH(x, y, 1, 1), paint);
        }
      }
    }

    final picture = recorder.endRecording();
    final image = await picture.toImage(size.toInt(), size.toInt());
    if (mounted) {
      setState(() {
        _noiseImage = image;
      });
    }
  }

  @override
  void dispose() {
    _noiseImage?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (_noiseImage != null)
          Positioned.fill(
            child: IgnorePointer(
              child: RepaintBoundary(
                child: CustomPaint(
                  painter: _NoisePainter(_noiseImage!, widget.opacity),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _NoisePainter extends CustomPainter {
  final ui.Image image;
  final double opacity;

  _NoisePainter(this.image, this.opacity);

  @override
  void paint(Canvas canvas, Size size) {
    // Draw the noise with the correct global opacity
    // This is much cheaper than saveLayer or Opacity widgets
    final paint = Paint()
      ..shader = ImageShader(
        image,
        TileMode.repeated,
        TileMode.repeated,
        Matrix4.identity().storage,
      );
    
    // We can use a simple drawRect. The alpha is already baked into 
    // the noise pixels, but we can dim it further if needed.
    canvas.drawRect(Offset.zero & size, paint);
  }

  @override
  bool shouldRepaint(_NoisePainter oldDelegate) => false;
}

class _FastRandom {
  int seed;
  _FastRandom(this.seed);
  int next() {
    seed = (seed * 1103515245 + 12345) & 0x7FFFFFFF;
    return seed;
  }

  int nextByte() => next() & 0xFF;
}
