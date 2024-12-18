# Animation Systems Documentation

## Overview
The Internet Kids website features three distinct animation modes: Default (Matrix), Rave, and Ghost. Each mode provides unique visual effects and interactions.

## RaveGridPainter

### Core Implementation
```dart
class RaveGridPainter extends CustomPainter {
  final Animation<double> animation;
  final bool raveMode;
  final double intensity;
  final Color color;
  final List<Offset> ghostParticles;
}
```

### Mode-Specific Implementations

#### 1. Default Mode (Matrix)
```dart
void _paintDefaultMode(Canvas canvas, Size size) {
  // Matrix-style falling characters
  // Character set: '01アイウエオカキクケコサシスセソタチツテト'
  // Features:
  - Leading bright character
  - Trailing fade effect
  - Variable speeds per column
  - Random character selection
}
```

#### 2. Rave Mode
```dart
void _paintRaveMode(Canvas canvas, Size size) {
  // Grid-based animation
  // Features:
  - Animated grid lines
  - Moving diagonal lines
  - Color cycling
  - Intensity-based opacity
}
```

#### 3. Ghost Mode
```dart
void _paintGhostMode(Canvas canvas, Size size) {
  // Ethereal wave effects
  // Features:
  - Wavy grid patterns
  - Floating particles
  - Sin-wave based distortion
  - Dynamic intensity
}
```

## Text Animation System

### Rave Text Cycling
```dart
final List<String> _raveText = [
  'UNTZ',
  'BOOM',
  'BASS',
  'DROP',
  'RAVE',
  'TECHNO',
];
```

### Implementation Details
- 200ms cycle interval
- Smooth transitions
- Scale transformations
- Dynamic color effects

### Timer Management
```dart
void _startRaveTimer() {
  _raveTimer?.cancel();
  if (_raveMode) {
    _raveTimer = Timer.periodic(Duration(milliseconds: 200), ...);
  }
}
```

## Color Animation System

### Color Palette
```dart
final List<Color> _raveColors = [
  Colors.cyan,
  Colors.purple,
  Colors.pink,
  Color(0xFFFF00FF), // Hot pink
  Color(0xFF00FF00), // Neon green
  Color(0xFFFF3300), // Neon orange
];
```

### Color Interpolation
- Smooth transitions between colors
- Intensity-based blending
- Dynamic opacity
- Glow effects

## Transform Animations

### Scale Transforms
```dart
Transform.scale(
  scale: _raveMode ? 1.0 + _intensity * 0.1 : 1.0,
  child: Widget(...),
)
```

### Features
- Smooth scaling
- Intensity-based modifications
- Performance optimized
- Hardware accelerated

## Particle System

### Ghost Particles
```dart
final List<Offset> _ghostParticles = List.generate(
  50,
  (i) => Offset(
    math.Random().nextDouble() * 2 - 1,
    math.Random().nextDouble() * 2 - 1,
  ),
);
```

### Particle Animation
- Continuous movement
- Opacity variations
- Size fluctuations
- Random distribution

## Performance Considerations

### Optimization Techniques
1. Efficient Custom Painting
   - Minimal repaints
   - Optimized calculations
   - Smart caching

2. Timer Management
   - Proper cleanup
   - State-based activation
   - Memory leak prevention

3. Animation Controllers
   - Single controller per page
   - Efficient disposal
   - Resource management

### Best Practices
1. Use `repaint` boundary when needed
2. Implement shouldRepaint correctly
3. Optimize particle count
4. Cache frequently used objects

## Animation Timing

### Default Mode
- Character fall speed: 150-350 pixels/second
- Column length: 8-16 characters
- Random seed: 42 (consistent patterns)

### Rave Mode
- Text cycle: 200ms
- Color transition: Continuous
- Scale pulsing: Sin-wave based
- Intensity: 0.0 - 1.0

### Ghost Mode
- Wave frequency: Based on animation value
- Particle speed: Moderate
- Intensity pulsing: 50ms intervals
- Wave amplitude: Intensity dependent

## Future Enhancements

### Planned Features
1. More particle effects
2. Advanced color schemes
3. Interactive animations
4. Audio-reactive elements
5. Custom shader effects

### Performance Improvements
1. WebGL acceleration
2. Batch rendering
3. Adaptive quality
4. Memory optimization 