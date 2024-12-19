import 'dart:math' as math;
import 'package:flutter/material.dart';

class GridPainter extends CustomPainter {
  final Animation<double> animation;
  final bool raveMode;
  final double intensity;
  final Color color;
  final List<Offset> ghostParticles;
  final bool isLowPerformanceMode;

  GridPainter({
    required this.animation,
    required this.raveMode,
    required this.intensity,
    required this.color,
    this.ghostParticles = const [],
    this.isLowPerformanceMode = false,
  }) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) return;
    canvas.clipRect(Offset.zero & size);

    if (raveMode) {
      _paintRaveMode(canvas, size);
    } else if (ghostParticles.isNotEmpty && intensity > 0) {
      _paintGhostMode(canvas, size);
    } else {
      _paintCyberpunkMode(canvas, size);
    }
  }

  void _paintRaveMode(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(0.15)
      ..strokeWidth = 1.5
      ..isAntiAlias = false;

    final gridSpacing = 40.0;
    final verticalLines = (size.width / gridSpacing).ceil();
    final horizontalLines = (size.height / gridSpacing).ceil();

    // Draw vertical lines
    for (int i = 0; i < verticalLines; i++) {
      final x = i * gridSpacing;
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        paint,
      );
    }

    // Draw horizontal lines
    for (int i = 0; i < horizontalLines; i++) {
      final y = i * gridSpacing;
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        paint,
      );
    }

    // Draw diagonal lines
    final diagonalPaint = Paint()
      ..color = color.withOpacity(0.05)
      ..strokeWidth = 2
      ..isAntiAlias = false;

    final offset = (animation.value * 40) % 80;
    final diagonalCount = ((size.width + size.height) / 80).ceil();
    
    for (int i = -diagonalCount; i < diagonalCount * 2; i++) {
      final x = i * 80 + offset;
      canvas.drawLine(
        Offset(x, 0),
        Offset(x + size.height, size.height),
        diagonalPaint,
      );
    }
  }

  void _paintGhostMode(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(0.15)
      ..strokeWidth = 1.5
      ..isAntiAlias = false;

    final gridSpacing = 40.0;
    final verticalLines = (size.width / gridSpacing).ceil();
    final horizontalLines = (size.height / gridSpacing).ceil();

    // Draw vertical wavy lines
    for (int i = 0; i < verticalLines; i++) {
      final x = i * gridSpacing;
      final path = Path();
      path.moveTo(x, 0);
      
      for (double y = 0; y <= size.height; y += 2) {
        final wave = math.sin((y + animation.value * 500) * 0.02) * 2 * intensity;
        path.lineTo(x + wave, y);
      }
      canvas.drawPath(path, paint);
    }

    // Draw horizontal wavy lines
    for (int i = 0; i < horizontalLines; i++) {
      final y = i * gridSpacing;
      final path = Path();
      path.moveTo(0, y);
      
      for (double x = 0; x <= size.width; x += 2) {
        final wave = math.sin((x + animation.value * 500) * 0.02) * 2 * intensity;
        path.lineTo(x, y + wave);
      }
      canvas.drawPath(path, paint);
    }

    // Draw particles
    if (ghostParticles.isNotEmpty) {
      final particlePaint = Paint()
        ..color = color.withOpacity(0.1 * intensity)
        ..strokeWidth = 1
        ..style = PaintingStyle.fill
        ..isAntiAlias = false;

      final particleCount = math.min((ghostParticles.length * 0.5).round(), 50);
      for (var i = 0; i < particleCount; i++) {
        final particle = ghostParticles[i];
        final x = (particle.dx * size.width + animation.value * 50) % size.width;
        final y = (particle.dy * size.height + animation.value * 25) % size.height;
        canvas.drawCircle(
          Offset(x, y),
          2 * intensity,
          particlePaint,
        );
      }
    }
  }

  void _paintCyberpunkMode(Canvas canvas, Size size) {
    final time = animation.value;
    final scale = isLowPerformanceMode ? 1.5 : 1.0;
    
    // Draw hexagonal grid with reduced density on mobile
    _drawHexGrid(canvas, size, time, scale);
    
    // Draw fewer energy lines on mobile
    _drawEnergyLines(canvas, size, time, scale);
    
    // Draw fewer particles with simpler effects on mobile
    _drawEnhancedParticles(canvas, size, time, scale);
  }

  void _drawHexGrid(Canvas canvas, Size size, double time, double scale) {
    final hexSize = size.width * 0.15 * scale;
    final rows = (size.height / (hexSize * 0.75)).ceil();
    final cols = (size.width / (hexSize * math.sqrt(3) * 0.5)).ceil();

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..isAntiAlias = false;  // Disable antialiasing for better performance

    // Reduce the number of hexagons drawn based on performance mode
    final skipRate = isLowPerformanceMode ? 2 : 1;

    for (var row = -1; row <= rows; row += skipRate) {
      for (var col = -1; col <= cols; col += skipRate) {
        final xOffset = col * hexSize * math.sqrt(3) * 0.5;
        final yOffset = row * hexSize * 0.75 + (col.isEven ? hexSize * 0.375 : 0);
        
        final center = Offset(xOffset, yOffset);
        final distanceFromCenter = (center - Offset(size.width * 0.5, size.height * 0.5)).distance;
        final pulseEffect = math.sin(time * 2 - distanceFromCenter * 0.01) * 0.3 + 0.7;
        
        paint.color = Colors.cyan.withOpacity(0.15 * pulseEffect);
        
        final path = Path();
        for (var i = 0; i < 6; i++) {
          final angle = i * math.pi / 3;
          final point = Offset(
            xOffset + math.cos(angle) * hexSize * pulseEffect,
            yOffset + math.sin(angle) * hexSize * pulseEffect,
          );
          
          if (i == 0) {
            path.moveTo(point.dx, point.dy);
          } else {
            path.lineTo(point.dx, point.dy);
          }
        }
        path.close();
        
        canvas.drawPath(path, paint);
        
        // Only draw glow effect on high-performance mode
        if (!isLowPerformanceMode && pulseEffect > 0.8) {
          final glowPaint = Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2
            ..maskFilter = const MaskFilter.blur(BlurStyle.outer, 3)
            ..color = Colors.cyan.withOpacity(0.1 * (pulseEffect - 0.8));
          canvas.drawPath(path, glowPaint);
        }
      }
    }
  }

  void _drawEnergyLines(Canvas canvas, Size size, double time, double scale) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..isAntiAlias = false;  // Disable antialiasing for better performance

    // Reduce number of lines on mobile
    final numLines = isLowPerformanceMode ? 3 : 5;
    
    for (var i = 0; i < numLines; i++) {
      final path = Path();
      final startX = size.width * (i / (numLines - 1));
      path.moveTo(startX, 0);

      // Reduce number of control points on mobile
      final controlPoints = List.generate(isLowPerformanceMode ? 3 : 4, (index) {
        final progress = index / (isLowPerformanceMode ? 2 : 3);
        final wave = math.sin(time * 2 + i + progress * math.pi) * size.width * 0.2;
        return Offset(
          startX + wave,
          size.height * progress,
        );
      });

      if (isLowPerformanceMode) {
        path.quadraticBezierTo(
          controlPoints[1].dx, controlPoints[1].dy,
          controlPoints[2].dx, controlPoints[2].dy,
        );
      } else {
        path.cubicTo(
          controlPoints[1].dx, controlPoints[1].dy,
          controlPoints[2].dx, controlPoints[2].dy,
          controlPoints[3].dx, controlPoints[3].dy,
        );
      }

      // Only draw glow effect on high-performance mode
      if (!isLowPerformanceMode) {
        paint.color = Colors.cyan.withOpacity(0.1);
        paint.maskFilter = const MaskFilter.blur(BlurStyle.outer, 5);
        canvas.drawPath(path, paint);
      }

      paint.color = Colors.cyan.withOpacity(0.3);
      paint.maskFilter = null;
      canvas.drawPath(path, paint);
    }
  }

  void _drawEnhancedParticles(Canvas canvas, Size size, double time, double scale) {
    final particleCount = math.min(
      isLowPerformanceMode ? 20 : 40,
      (size.width * size.height / (isLowPerformanceMode ? 50000 : 25000)).round()
    );
    
    final particlePaint = Paint()
      ..style = PaintingStyle.fill
      ..isAntiAlias = false;  // Disable antialiasing for better performance

    for (var i = 0; i < particleCount; i++) {
      final seed = i * 0.1;
      final x = size.width * 0.5 + math.cos(time * 2 + seed) * size.width * 0.4;
      final y = size.height * 0.5 + math.sin(time * 3 + seed) * size.height * 0.4;
      
      // Simpler particle rendering on mobile
      final coreSize = isLowPerformanceMode ? 2 : (3 + math.sin(time * 4 + seed) * 1);
      particlePaint.color = Colors.cyan.withOpacity(0.6);
      canvas.drawCircle(Offset(x, y), coreSize, particlePaint);
      
      // Only draw glow and trails on high-performance mode
      if (!isLowPerformanceMode) {
        final glowPaint = Paint()
          ..style = PaintingStyle.fill
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3)
          ..color = Colors.cyan.withOpacity(0.3);
        canvas.drawCircle(Offset(x, y), coreSize * 2, glowPaint);
        
        final trailPaint = Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1
          ..color = Colors.cyan.withOpacity(0.2);
        
        final trailPath = Path();
        final trailLength = 20;
        for (var j = 0; j < trailLength; j++) {
          final t = j / trailLength;
          final trailX = x - math.cos(time * 2 + seed) * t * 20;
          final trailY = y - math.sin(time * 3 + seed) * t * 20;
          
          if (j == 0) {
            trailPath.moveTo(trailX, trailY);
          } else {
            trailPath.lineTo(trailX, trailY);
          }
        }
        canvas.drawPath(trailPath, trailPaint);
      }
    }
  }

  @override
  bool shouldRepaint(GridPainter oldDelegate) =>
    animation.value != oldDelegate.animation.value ||
    raveMode != oldDelegate.raveMode ||
    intensity != oldDelegate.intensity ||
    color != oldDelegate.color ||
    isLowPerformanceMode != oldDelegate.isLowPerformanceMode;
} 