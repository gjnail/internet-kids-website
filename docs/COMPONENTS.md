# Website Components Documentation

## Core Components

### 1. Main App Structure
```dart
class InternetKidsWebsite extends StatelessWidget {
  // Root application widget
  // Handles routing and theme
}
```

### 2. Pages
```dart
class HomePage extends StatefulWidget {
  // Main landing page
  // Features project showcase and rave mode
}

class DistortionPage extends StatefulWidget {
  // Product page for distortion plugin
  // Features ghost mode and purchase options
}
```

## UI Components

### 1. Project Cards
```dart
Widget _buildProjectCard(String title, String description, VoidCallback onTap, {bool enabled = true}) {
  // Features:
  - Hover effects
  - Dynamic scaling
  - Glow effects in rave mode
  - Disabled state handling
}
```

### 2. Social Buttons
```dart
Widget _buildSocialButton(String text, String url) {
  // Features:
  - External link handling
  - Animated scaling
  - Dynamic colors
  - Hover effects
}
```

### 3. Mode Toggle Buttons
```dart
// Rave Mode Toggle
Container(
  child: TextButton(
    onPressed: _toggleRaveMode,
    child: Text('RAVE MODE: ON/OFF'),
  ),
)

// Ghost Mode Toggle
Container(
  child: TextButton(
    onPressed: _toggleGhostMode,
    child: Text('GHOST MODE: ON/OFF'),
  ),
)
```

## Layout Components

### 1. Main Content Layout
```dart
Center(
  child: ConstrainedBox(
    constraints: BoxConstraints(maxWidth: 800),
    child: SingleChildScrollView(
      // Main content container
      // Responsive and scrollable
    ),
  ),
)
```

### 2. Section Containers
```dart
Container(
  width: double.infinity,
  padding: EdgeInsets.all(20),
  decoration: BoxDecoration(
    // Dynamic borders
    // Background effects
    // Shadow effects
  ),
)
```

## Interactive Elements

### 1. Purchase Dialog
```dart
void _handlePurchase() {
  showDialog(
    // Features:
    - Platform selection
    - Dynamic styling
    - Payment integration
    - Animated transitions
  );
}
```

### 2. Navigation Elements
```dart
IconButton(
  icon: Icon(Icons.arrow_back),
  // Back navigation
  // Dynamic colors
  // Hover effects
)
```

## Custom Painters

### 1. RaveGridPainter
```dart
class RaveGridPainter extends CustomPainter {
  // Background animation system
  // Multiple painting modes
  // Performance optimized
}
```

### 2. Matrix Effect
```dart
void _drawCharacter(
  Canvas canvas,
  String char,
  Offset position,
  Color color,
  double size,
  bool glow,
) {
  // Character rendering
  // Glow effects
  // Efficient text painting
}
```

## State Management

### 1. Animation States
```dart
// Controller
late AnimationController _controller;

// Mode States
bool _raveMode = false;
bool _ghostMode = false;

// Animation Values
double _intensity = 0.0;
int _currentRaveIndex = 0;
```

### 2. Timer Management
```dart
Timer? _raveTimer;
Timer? _ghostTimer;

// Cleanup
@override
void dispose() {
  _raveTimer?.cancel();
  _ghostTimer?.cancel();
  _controller.dispose();
  super.dispose();
}
```

## Styling Components

### 1. Text Styles
```dart
TextStyle(
  fontSize: 48,
  fontWeight: FontWeight.bold,
  color: _currentColor,
  shadows: [
    Shadow(
      color: _currentColor,
      blurRadius: 20 * _intensity,
    )
  ],
)
```

### 2. Container Styles
```dart
BoxDecoration(
  border: Border.all(
    color: _currentColor,
    width: _raveMode ? 2 + _intensity * 2 : 2,
  ),
  boxShadow: _raveMode ? [
    BoxShadow(
      color: _currentColor.withOpacity(0.5),
      blurRadius: 20 * _intensity,
      spreadRadius: 5 * _intensity,
    )
  ] : null,
)
```

## Responsive Design

### 1. Breakpoint Handling
```dart
ConstrainedBox(
  constraints: BoxConstraints(maxWidth: 800),
  // Responsive container
  // Adaptive layout
)
```

### 2. Dynamic Sizing
```dart
// Text Scaling
fontSize: MediaQuery.of(context).size.width < 600 ? 36 : 48,

// Padding Adaptation
padding: EdgeInsets.symmetric(
  horizontal: MediaQuery.of(context).size.width < 600 ? 10 : 20,
)
```

## Performance Components

### 1. Repaint Boundaries
```dart
RepaintBoundary(
  child: CustomPaint(
    painter: RaveGridPainter(...),
  ),
)
```

### 2. Cached Elements
```dart
final TextPainter _cachedPainter = TextPainter(
  textDirection: TextDirection.ltr,
  textAlign: TextAlign.center,
);
```

## Future Component Considerations

### 1. Planned Widgets
1. Audio visualization components
2. Interactive particle systems
3. Custom shader effects
4. Advanced animation controllers

### 2. Optimization Opportunities
1. Widget splitting for better rebuilding
2. Cached painting operations
3. Lazy loading components
4. Memory-efficient animations 