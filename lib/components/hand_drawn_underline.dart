import 'dart:math' as math;
import 'package:flutter/material.dart';

class HandDrawnUnderline extends StatefulWidget {
  final Widget child;
  final Color color;
  final bool animate;

  const HandDrawnUnderline({
    super.key,
    required this.child,
    this.color = const Color(0xFF2563EB),
    this.animate = false,
  });

  @override
  State<HandDrawnUnderline> createState() => _HandDrawnUnderlineState();
}

class _HandDrawnUnderlineState extends State<HandDrawnUnderline>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutQuart,
    );
    if (widget.animate) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(HandDrawnUnderline oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.animate && !oldWidget.animate) {
      _controller.forward();
    } else if (!widget.animate && oldWidget.animate) {
      _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return CustomPaint(
          painter: _UnderlinePainter(
            color: widget.color,
            progress: _animation.value,
          ),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

class _UnderlinePainter extends CustomPainter {
  final Color color;
  final double progress;

  _UnderlinePainter({required this.color, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    if (progress == 0) return;

    final paint = Paint()
      ..color = color
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final path = Path();
    final y = size.height - 2;
    
    path.moveTo(0, y);
    
    // Draw an irregular line
    for (double i = 1; i <= 20; i++) {
      final x = (size.width / 20) * i;
      final dy = math.sin(i * 0.5) * 1.5;
      path.lineTo(x, y + dy);
    }

    final pathMetrics = path.computeMetrics().first;
    final extractPath = pathMetrics.extractPath(0, pathMetrics.length * progress);
    
    canvas.drawPath(extractPath, paint);
  }

  @override
  bool shouldRepaint(covariant _UnderlinePainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.color != color;
}
