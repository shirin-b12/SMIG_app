import 'package:flutter/material.dart';

class DashedCirclePainter extends CustomPainter {
  final Color lineColor;

  DashedCirclePainter({this.lineColor = Colors.blue});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = lineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    double dashWidth = 10.0, dashSpace = 5.0, startPoint = 0.0;
    final circlePath = Path()..addOval(Rect.fromCircle(center: Offset(size.width / 2, size.height / 2), radius: size.width / 2));
    final pathMetric = circlePath.computeMetrics().first;

    while (startPoint < pathMetric.length) {
      final endPoint = startPoint + dashWidth;
      final dashPath = pathMetric.extractPath(startPoint, endPoint);
      canvas.drawPath(dashPath, paint);
      startPoint = endPoint + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
