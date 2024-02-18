import 'dart:math';

import 'package:flutter/material.dart';

class WaterRipple extends StatefulWidget {
  final int count;
  final Color color;

  const WaterRipple(
      {Key? key, this.count = 3, this.color = const Color(0xFF0080ff)})
      : super(key: key);

  @override
  _WaterRippleState createState() => _WaterRippleState();
}

class _WaterRippleState extends State<WaterRipple>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 2000))
          ..repeat();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: WaterRipplePainter(_controller.value,
              count: widget.count, color: widget.color),
        );
      },
    );
  }
}

class WaterRipplePainter extends CustomPainter {
  final double progress;
  final int count;
  final Color color;

  Paint _paint = Paint()..style = PaintingStyle.fill;

  WaterRipplePainter(this.progress,
      {this.count = 3, this.color = const Color(0xFF0080ff)});

  @override
  void paint(Canvas canvas, Size size) {
    double radius = 100;

    for (int i = count; i >= 0; i--) {
      final double opacity = (1.0 - ((i + progress) / (count + 1)));
      final Color _color = color.withOpacity(opacity);
      _paint..color = _color;
      _paint..style = PaintingStyle.stroke;
      _paint..strokeWidth = 20;
      double _radius = radius * ((i + progress) / (count + 1)) + 80;

      canvas.drawArc(
          Rect.fromCircle(
              center: Offset(size.width / 2, size.height / 2), radius: _radius),
          -5 * pi / 4,
          2 * pi / 4,
          false,
          _paint);

      canvas.drawArc(
          Rect.fromCircle(
              center: Offset(size.width / 2, size.height / 2), radius: _radius),
          -1 * pi / 4,
          2 * pi / 4,
          false,
          _paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class WaterRipplePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Container(height: 200, width: 200, child: WaterRipple())),
    );
  }
}
