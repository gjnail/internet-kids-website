import 'dart:math' as math;
import 'package:flutter/material.dart';

class GridPainter extends CustomPainter {
  final Animation<double> animation;
  final bool raveMode;
  final double intensity;
  final Color color;
  final List<Offset> ghostParticles;

  GridPainter({
    required this.animation,
    required this.raveMode,
    required this.intensity,
    required this.color,
    this.ghostParticles = const [],
  }) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    if (raveMode) {
      _paintRaveMode(canvas, size);
    } else if (ghostParticles.isNotEmpty && intensity > 0) {
      _paintGhostMode(canvas, size);
    } else {
      _paintDefaultMode(canvas, size);
    }
  }

  void _paintRaveMode(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(0.15)
      ..strokeWidth = 1.5;

    // Draw vertical lines
    for (double x = 0; x < size.width; x += 20) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        paint,
      );
    }

    // Draw horizontal lines
    for (double y = 0; y < size.height; y += 20) {
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        paint,
      );
    }

    // Draw diagonal lines
    final diagonalPaint = Paint()
      ..color = color.withOpacity(0.05)
      ..strokeWidth = 2;

    final offset = animation.value * 40;
    for (double x = -size.width; x < size.width * 2; x += 40) {
      canvas.drawLine(
        Offset(x + offset, 0),
        Offset(x + size.height + offset, size.height),
        diagonalPaint,
      );
    }
  }

  void _paintGhostMode(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(0.15)
      ..strokeWidth = 1.5;

    // Draw wavy grid
    for (double x = 0; x < size.width; x += 20) {
      final path = Path();
      path.moveTo(x, 0);
      for (double y = 0; y < size.height; y += 1) {
        final wave = math.sin((y + animation.value * 1000) * 0.01) * 2 * intensity;
        path.lineTo(x + wave, y);
      }
      canvas.drawPath(path, paint);
    }

    for (double y = 0; y < size.height; y += 20) {
      final path = Path();
      path.moveTo(0, y);
      for (double x = 0; x < size.width; x += 1) {
        final wave = math.sin((x + animation.value * 1000) * 0.01) * 2 * intensity;
        path.lineTo(x, y + wave);
      }
      canvas.drawPath(path, paint);
    }

    // Draw ghost particles
    final particlePaint = Paint()
      ..color = color.withOpacity(0.1 * intensity)
      ..strokeWidth = 1
      ..style = PaintingStyle.fill;

    for (final particle in ghostParticles) {
      final x = (particle.dx * size.width + animation.value * 100) % size.width;
      final y = (particle.dy * size.height + animation.value * 50) % size.height;
      canvas.drawCircle(
        Offset(x, y),
        3 * intensity,
        particlePaint,
      );
    }
  }

  void _paintDefaultMode(Canvas canvas, Size size) {
    final matrixGreen = const Color(0xFF00FF66);
    final characters = '01アイウエオカキクケコサシスセソタチツテト';
    final random = math.Random(42);
    final columnWidth = 14.0;
    final columns = (size.width / columnWidth).ceil();
    
    final List<double> columnSpeeds = List.generate(
      columns,
      (i) => 150.0 + random.nextDouble() * 200.0,
    );

    final List<int> columnLengths = List.generate(
      columns,
      (i) => 8 + random.nextInt(8),
    );

    // Draw the falling characters
    for (int col = 0; col < columns; col++) {
      final x = col * columnWidth;
      final speed = columnSpeeds[col];
      final length = columnLengths[col];
      final offset = (animation.value * speed) % (size.height + length * 16);

      for (int i = 0; i < length; i++) {
        final y = (offset + i * 16) % (size.height + length * 16) - 16;
        
        if (y < -16 || y > size.height) continue;

        final fade = i == 0 ? 1.0 : (1.0 - (i / length));
        final char = characters[random.nextInt(characters.length)];

        if (i == 0) {
          _drawCharacter(
            canvas,
            char,
            Offset(x, y),
            Color.lerp(Colors.white, matrixGreen, 0.3)!,
            16,
            true,
          );
        } else if (i == 1) {
          _drawCharacter(
            canvas,
            char,
            Offset(x, y),
            matrixGreen,
            14,
            true,
          );
        } else {
          _drawCharacter(
            canvas,
            char,
            Offset(x, y),
            matrixGreen.withOpacity(fade * 0.8),
            12,
            false,
          );
        }
      }
    }
  }

  void _drawCharacter(Canvas canvas, String char, Offset position, Color color, double size, bool glow) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: char,
        style: TextStyle(
          color: color,
          fontSize: size,
          fontWeight: glow ? FontWeight.bold : FontWeight.normal,
          height: 1,
        ),
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    textPainter.layout(
      minWidth: 16,
      maxWidth: 16,
    );

    if (glow) {
      final glowPaint = Paint()
        ..color = color.withOpacity(0.4)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);

      canvas.drawCircle(
        position + Offset(8, 8),
        8,
        glowPaint,
      );
    }

    textPainter.paint(
      canvas,
      position,
    );
  }

  @override
  bool shouldRepaint(GridPainter oldDelegate) => true;
} 