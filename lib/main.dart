import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:html' as html;
import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const InternetKidsWebsite());
}

class TrailPoint {
  final Offset position;
  final double opacity;

  TrailPoint(this.position, this.opacity);
}

class InternetKidsWebsite extends StatelessWidget {
  const InternetKidsWebsite({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Internet Kids',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.cyan,
        scaffoldBackgroundColor: const Color(0xFF280040),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/distortion': (context) => const DistortionPage(),
        '/success': (context) => const SuccessPage(),
      },
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _raveMode = false;
  double _intensity = 0.0;
  final List<String> _raveText = [
    'UNTZ',
    'BOOM',
    'BASS',
    'DROP',
    'RAVE',
    'TECHNO',
  ];
  final List<Color> _raveColors = [
    Colors.cyan,
    Colors.purple,
    Colors.pink,
    const Color(0xFFFF00FF), // Hot pink
    const Color(0xFF00FF00), // Neon green
    const Color(0xFFFF3300), // Neon orange
  ];
  int _currentRaveIndex = 0;
  Timer? _raveTimer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();

    _startRaveTimer();
  }

  void _startRaveTimer() {
    _raveTimer?.cancel();
    if (_raveMode) {
      _raveTimer = Timer.periodic(const Duration(milliseconds: 200), (timer) {
        if (mounted && _raveMode) {
          setState(() {
            _currentRaveIndex = (_currentRaveIndex + 1) % _raveText.length;
            _intensity = math.sin(DateTime.now().millisecondsSinceEpoch * 0.01) * 0.5 + 0.5;
          });
        }
      });
    }
  }

  Color get _currentColor {
    if (!_raveMode) return Colors.cyan;
    
    // Mix between current and next color based on intensity
    final Color nextColor = _raveColors[(_currentRaveIndex + 1) % _raveColors.length];
    return Color.lerp(_raveColors[_currentRaveIndex], nextColor, _intensity)!;
  }

  @override
  void dispose() {
    _raveTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _toggleRaveMode() {
    setState(() {
      _raveMode = !_raveMode;
      if (!_raveMode) {
        _intensity = 0.0;
        _currentRaveIndex = 0;
      }
    });
    _startRaveTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Animated background
          CustomPaint(
            size: Size.infinite,
            painter: RaveGridPainter(
              animation: _controller,
              raveMode: _raveMode,
              intensity: _intensity,
              color: _currentColor,
              ghostParticles: const [],
            ),
          ),
          // Content
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 800),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 60),
                      // Rave mode toggle
                      Transform.scale(
                        scale: _raveMode ? 1.0 + _intensity * 0.1 : 1.0,
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: _currentColor,
                              width: _raveMode ? 2 + _intensity * 2 : 2,
                            ),
                            boxShadow: _raveMode
                                ? [
                                    BoxShadow(
                                      color: _currentColor.withOpacity(0.5),
                                      blurRadius: 20 * _intensity,
                                      spreadRadius: 5 * _intensity,
                                    )
                                  ]
                                : null,
                          ),
                          child: TextButton(
                            onPressed: _toggleRaveMode,
                            child: Text(
                              _raveMode ? 'RAVE MODE: ON' : 'RAVE MODE: OFF',
                              style: TextStyle(
                                color: _currentColor,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                shadows: _raveMode
                                    ? [
                                        Shadow(
                                          color: _currentColor,
                                          blurRadius: 20 * _intensity,
                                        )
                                      ]
                                    : null,
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Main title with glitch effect
                      Transform.scale(
                        scale: _raveMode ? 1.0 + _intensity * 0.05 : 1.0,
                        child: ShaderMask(
                          shaderCallback: (bounds) => LinearGradient(
                            colors: [
                              _currentColor,
                              _raveColors[(_currentRaveIndex + 1) % _raveColors.length],
                            ],
                          ).createShader(bounds),
                          child: Center(
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: Text(
                                'INTERNET KIDS',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: MediaQuery.of(context).size.width < 600 ? 48 : 72,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  shadows: [
                                    Shadow(
                                      color: _currentColor,
                                      offset: const Offset(4, 4),
                                      blurRadius: _raveMode ? 8 + _intensity * 12 : 8,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Animated rave text
                      Transform.scale(
                        scale: _raveMode ? 1.0 + _intensity * 0.2 : 1.0,
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: Text(
                            _raveMode ? _raveText[_currentRaveIndex] : "AUDIO PLUGINS",
                            key: ValueKey<String>(_raveMode ? _raveText[_currentRaveIndex] : "static"),
                            style: TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                              color: _currentColor,
                              shadows: _raveMode
                                  ? [
                                      Shadow(
                                        color: _currentColor,
                                        blurRadius: 20 * _intensity,
                                      )
                                    ]
                                  : null,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 60),
                      // Projects section
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: _currentColor.withOpacity(_raveMode ? 0.5 + _intensity * 0.5 : 0.5),
                          ),
                          color: Colors.black12,
                          boxShadow: _raveMode
                              ? [
                                  BoxShadow(
                                    color: _currentColor.withOpacity(0.3),
                                    blurRadius: 20 * _intensity,
                                    spreadRadius: 5 * _intensity,
                                  )
                                ]
                              : null,
                        ),
                        child: Column(
                          children: [
                            Transform.scale(
                              scale: _raveMode ? 1.0 + _intensity * 0.1 : 1.0,
                              child: Text(
                                'PROJECTS',
                                style: TextStyle(
                                  fontSize: 36,
                                  fontWeight: FontWeight.bold,
                                  color: _currentColor,
                                  shadows: _raveMode
                                      ? [
                                          Shadow(
                                            color: _currentColor,
                                            blurRadius: 20 * _intensity,
                                          )
                                        ]
                                      : null,
                                ),
                              ),
                            ),
                            const SizedBox(height: 30),
                            // Distortion Plugin Card
                            _buildProjectCard(
                              'DISTORTION',
                              'Destroy your kicks with style',
                              () => Navigator.pushNamed(context, '/distortion'),
                            ),
                            const SizedBox(height: 20),
                            // Coming Soon Card
                            _buildProjectCard(
                              'COMING SOON',
                              'More techno weapons incoming',
                              () {},
                              enabled: false,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 40),
                      // Social Links
                      Wrap(
                        spacing: 20,
                        runSpacing: 20,
                        alignment: WrapAlignment.center,
                        children: [
                          _buildSocialButton('SOUNDCLOUD', 'https://soundcloud.com/internetkidsmaketechno'),
                          _buildSocialButton('INSTAGRAM', 'https://instagram.com/internetkidsmaketechno'),
                          _buildSocialButton('YOUTUBE', 'https://youtube.com/@internetkidsmaketechno'),
                          _buildSocialButton('TIKTOK', 'https://tiktok.com/@internetkidsmaketechno'),
                          _buildSocialButton('TWITTER', 'https://twitter.com/internetkidstec'),
                        ],
                      ),
                      const SizedBox(height: 20),
                      // Footer
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(
                              color: _raveColors[_currentRaveIndex].withOpacity(0.3),
                            ),
                          ),
                        ),
                        child: Text(
                          '@internetkidsmaketechno',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: _raveColors[_currentRaveIndex],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProjectCard(String title, String description, VoidCallback onTap, {bool enabled = true}) {
    return MouseRegion(
      cursor: enabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
      child: GestureDetector(
        onTap: enabled ? onTap : null,
        child: Transform.scale(
          scale: enabled && _raveMode ? 1.0 + _intensity * 0.05 : 1.0,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              border: Border.all(
                color: enabled 
                  ? _currentColor
                  : _currentColor.withOpacity(0.3),
                width: _raveMode && enabled ? 2 + _intensity * 2 : 2,
              ),
              color: Colors.black26,
              boxShadow: _raveMode && enabled
                  ? [
                      BoxShadow(
                        color: _currentColor.withOpacity(0.3),
                        blurRadius: 20 * _intensity,
                        spreadRadius: 5 * _intensity,
                      )
                    ]
                  : null,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: enabled 
                      ? _currentColor
                      : _currentColor.withOpacity(0.3),
                    shadows: _raveMode && enabled
                        ? [
                            Shadow(
                              color: _currentColor,
                              blurRadius: 10 * _intensity,
                            )
                          ]
                        : null,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 18,
                    color: enabled ? Colors.white : Colors.white.withOpacity(0.3),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSocialButton(String text, String url) {
    return Transform.scale(
      scale: _raveMode ? 1.0 + _intensity * 0.1 : 1.0,
      child: ElevatedButton(
        onPressed: () => html.window.open(url, 'new'),
        style: ElevatedButton.styleFrom(
          backgroundColor: _currentColor,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          elevation: _raveMode ? 8 * _intensity : 2,
          shadowColor: _raveMode ? _currentColor : Colors.black,
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            shadows: _raveMode
                ? [
                    Shadow(
                      color: Colors.white,
                      blurRadius: 10 * _intensity,
                    )
                  ]
                : null,
          ),
        ),
      ),
    );
  }
}

// Rename existing HomePage to DistortionPage and keep its implementation
class DistortionPage extends StatefulWidget {
  const DistortionPage({super.key});

  @override
  State<DistortionPage> createState() => _DistortionPageState();
}

class _DistortionPageState extends State<DistortionPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _ghostMode = false;
  double _intensity = 0.0;
  Timer? _ghostTimer;
  final Color _ghostColor = const Color(0xFFFF0000); // Pure red
  final List<Offset> _ghostParticles = [];
  
  // Stripe payment link
  final String _paymentLink = 'https://buy.stripe.com/7sI28gbCX8ds4OAfYY';

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();

    // Initialize ghost particles
    for (int i = 0; i < 50; i++) {
      _ghostParticles.add(
        Offset(
          math.Random().nextDouble() * 2 - 1,
          math.Random().nextDouble() * 2 - 1,
        ),
      );
    }

    _startGhostTimer();
  }

  void _startGhostTimer() {
    _ghostTimer?.cancel();
    if (_ghostMode) {
      _ghostTimer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
        if (mounted && _ghostMode) {
          setState(() {
            _intensity = (math.sin(_controller.value * math.pi * 2) * 0.3 + 0.7).clamp(0.0, 1.0);
          });
        }
      });
    } else {
      setState(() {
        _intensity = 0.0;
      });
    }
  }

  Color get _currentColor => _ghostMode ? _ghostColor.withOpacity(_intensity) : Colors.cyan;

  @override
  void dispose() {
    _ghostTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _toggleGhostMode() {
    setState(() {
      _ghostMode = !_ghostMode;
      if (!_ghostMode) {
        _intensity = 0.0;
      }
    });
    _startGhostTimer();
  }

  void _handlePurchase() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF280040),
          title: Text(
            'PURCHASE',
            style: TextStyle(
              color: _currentColor,
              fontWeight: FontWeight.bold,
              shadows: _ghostMode
                  ? [
                      Shadow(
                        color: _currentColor,
                        blurRadius: 10 * _intensity,
                      )
                    ]
                  : null,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Transform.scale(
                scale: _ghostMode ? 1.0 + _intensity * 0.05 : 1.0,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: _currentColor.withOpacity(0.5),
                      width: _ghostMode ? 2 + _intensity * 2 : 2,
                    ),
                    color: Colors.black12,
                  ),
                  child: Column(
                    children: [
                      Text(
                        'INTERNET KIDS DISTORTION',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: _currentColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Includes:',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        '• AU/VST3 for macOS\n• VST3 for Windows',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        '\$15',
                        style: TextStyle(
                          color: _currentColor,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Transform.scale(
                scale: _ghostMode ? 1.0 + _intensity * 0.05 : 1.0,
                child: ElevatedButton(
                  onPressed: () {
                    html.window.open(_paymentLink, '_blank');
                    Navigator.pop(context);
                    
                    // Show success message
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Redirecting to secure payment page...',
                          style: TextStyle(color: Colors.white),
                        ),
                        backgroundColor: _currentColor.withOpacity(0.8),
                        duration: Duration(seconds: 3),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _currentColor,
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    elevation: _ghostMode ? 8 * _intensity : 2,
                    shadowColor: _ghostMode ? _currentColor : Colors.black,
                  ),
                  child: Text(
                    'BUY NOW',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      shadows: _ghostMode
                          ? [
                              Shadow(
                                color: Colors.white,
                                blurRadius: 10 * _intensity,
                              )
                            ]
                          : null,
                    ),
                  ),
                ),
              ),
            ],
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: BorderSide(
              color: _currentColor,
              width: _ghostMode ? 2 + _intensity * 2 : 2,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          body: Stack(
            children: [
              // Animated background
              CustomPaint(
                size: Size.infinite,
                painter: RaveGridPainter(
                  animation: _controller,
                  raveMode: _ghostMode,
                  intensity: _intensity,
                  color: _currentColor,
                  ghostParticles: _ghostParticles,
                ),
              ),
              // Content
              Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 800),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 60),
                          // Title
                          Transform.scale(
                            scale: _ghostMode ? 1.0 + _intensity * 0.05 : 1.0,
                            child: ShaderMask(
                              shaderCallback: (bounds) => LinearGradient(
                                colors: _ghostMode 
                                  ? [_currentColor, _currentColor.withRed(100)]
                                  : [_currentColor, Colors.purple],
                              ).createShader(bounds),
                              child: Text(
                                'INTERNET KIDS\nDISTORTION',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 48,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  shadows: [
                                    Shadow(
                                      color: _currentColor,
                                      offset: const Offset(4, 4),
                                      blurRadius: _ghostMode ? 8 + _intensity * 12 : 8,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 40),
                          // Price
                          Transform.scale(
                            scale: _ghostMode ? 1.0 + _intensity * 0.1 : 1.0,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: _currentColor,
                                  width: _ghostMode ? 2 + _intensity * 2 : 2,
                                ),
                                color: Colors.black26,
                                boxShadow: _ghostMode
                                    ? [
                                        BoxShadow(
                                          color: _currentColor.withOpacity(0.5),
                                          blurRadius: 20 * _intensity,
                                          spreadRadius: 5 * _intensity,
                                        )
                                      ]
                                    : null,
                              ),
                              child: Text(
                                '\$15',
                                style: TextStyle(
                                  fontSize: 72,
                                  fontWeight: FontWeight.bold,
                                  color: _currentColor,
                                  shadows: _ghostMode
                                      ? [
                                          Shadow(
                                            color: _currentColor,
                                            blurRadius: 10 * _intensity,
                                          )
                                        ]
                                      : null,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 40),
                          // Features
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: _currentColor.withOpacity(_ghostMode ? 0.5 + _intensity * 0.5 : 0.5),
                                width: _ghostMode ? 2 + _intensity * 2 : 2,
                              ),
                              color: Colors.black12,
                              boxShadow: _ghostMode
                                  ? [
                                      BoxShadow(
                                        color: _currentColor.withOpacity(0.3),
                                        blurRadius: 20 * _intensity,
                                        spreadRadius: 5 * _intensity,
                                      )
                                    ]
                                  : null,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                  child: Transform.scale(
                                    scale: _ghostMode ? 1.0 + _intensity * 0.1 : 1.0,
                                    child: Text(
                                      'FEATURES',
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: _currentColor,
                                        shadows: _ghostMode
                                            ? [
                                                Shadow(
                                                  color: _currentColor,
                                                  blurRadius: 10 * _intensity,
                                                )
                                              ]
                                            : null,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                _buildFeatureItem('Destroy your kicks with style'),
                                _buildFeatureItem('Ghost Mode for ethereal sounds'),
                                _buildFeatureItem('Real-time visualization'),
                                _buildFeatureItem('90s-inspired interface'),
                                _buildFeatureItem('AU/VST3 for macOS'),
                                _buildFeatureItem('VST3 for Windows'),
                              ],
                            ),
                          ),
                          const SizedBox(height: 40),
                          // Purchase button
                          Transform.scale(
                            scale: _ghostMode ? 1.0 + _intensity * 0.1 : 1.0,
                            child: ElevatedButton(
                              onPressed: _handlePurchase,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _currentColor,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 40,
                                  vertical: 20,
                                ),
                                elevation: _ghostMode ? 8 * _intensity : 2,
                                shadowColor: _ghostMode ? _currentColor : Colors.black,
                              ),
                              child: Text(
                                'BUY NOW',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  shadows: _ghostMode
                                      ? [
                                          Shadow(
                                            color: Colors.white,
                                            blurRadius: 10 * _intensity,
                                          )
                                        ]
                                      : null,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 40),
                          // Ghost mode toggle
                          Transform.scale(
                            scale: _ghostMode ? 1.0 + _intensity * 0.05 : 1.0,
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: _currentColor,
                                  width: _ghostMode ? 2 + _intensity * 2 : 2,
                                ),
                                boxShadow: _ghostMode
                                    ? [
                                        BoxShadow(
                                          color: _currentColor.withOpacity(0.5),
                                          blurRadius: 20 * _intensity,
                                          spreadRadius: 5 * _intensity,
                                        )
                                      ]
                                    : null,
                              ),
                              child: TextButton(
                                onPressed: _toggleGhostMode,
                                child: Text(
                                  _ghostMode ? 'GHOST MODE: ON' : 'GHOST MODE: OFF',
                                  style: TextStyle(
                                    color: _currentColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    shadows: _ghostMode
                                        ? [
                                            Shadow(
                                              color: _currentColor,
                                              blurRadius: 20 * _intensity,
                                            )
                                          ]
                                        : null,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        // Back button
        Positioned(
          top: 20,
          left: 20,
          child: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: _currentColor,
              size: 32,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ],
    );
  }

  Widget _buildFeatureItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Transform.scale(
        scale: _ghostMode ? 1.0 + _intensity * 0.05 : 1.0,
        child: Row(
          children: [
            Icon(
              Icons.star,
              color: _currentColor,
            ),
            const SizedBox(width: 10),
            Text(
              text,
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
                shadows: _ghostMode
                    ? [
                        Shadow(
                          color: _currentColor,
                          blurRadius: 5 * _intensity,
                        )
                      ]
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RaveGridPainter extends CustomPainter {
  final Animation<double> animation;
  final bool raveMode;
  final double intensity;
  final Color color;
  final List<Offset> ghostParticles;

  RaveGridPainter({
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
  bool shouldRepaint(RaveGridPainter oldDelegate) => true;
}

class SuccessPage extends StatelessWidget {
  const SuccessPage({super.key});

  Future<void> _handleMacDownload(BuildContext context) async {
    try {
      print('Starting Mac download process...');
      
      // Initialize Firebase if not already initialized
      if (Firebase.apps.isEmpty) {
        print('Initializing Firebase...');
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );
      }

      print('Getting Firebase Storage instance...');
      final storage = FirebaseStorage.instance;
      
      print('Creating references to Mac files...');
      final auRef = storage.ref().child('downloads/mac/au.pkg');
      final vst3Ref = storage.ref().child('downloads/mac/vst3.pkg');

      print('Getting download URLs...');
      final auUrl = await auRef.getDownloadURL();
      print('AU URL: $auUrl');
      final vst3Url = await vst3Ref.getDownloadURL();
      print('VST3 URL: $vst3Url');

      print('Opening download windows...');
      html.window.open(auUrl, '_blank');
      Future.delayed(const Duration(seconds: 1), () {
        html.window.open(vst3Url, '_blank');
      });
    } catch (e, stackTrace) {
      print('Download error: $e');
      print('Stack trace: $stackTrace');
      if (context.mounted) {
        _showErrorDialog(context, e);
      }
    }
  }

  Future<void> _handleWindowsDownload(BuildContext context) async {
    try {
      print('Starting Windows download process...');
      
      // Initialize Firebase if not already initialized
      if (Firebase.apps.isEmpty) {
        print('Initializing Firebase...');
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );
      }

      print('Getting Firebase Storage instance...');
      final storage = FirebaseStorage.instance;
      
      print('Creating reference to Windows file...');
      final windowsRef = storage.ref().child('downloads/windows/IKDistortion-Windows.zip');

      print('Getting download URL...');
      final windowsUrl = await windowsRef.getDownloadURL();
      print('Windows URL: $windowsUrl');

      print('Opening download window...');
      html.window.open(windowsUrl, '_blank');
    } catch (e, stackTrace) {
      print('Download error: $e');
      print('Stack trace: $stackTrace');
      if (context.mounted) {
        _showErrorDialog(context, e);
      }
    }
  }

  void _showErrorDialog(BuildContext context, dynamic error) {
    print('Showing error dialog: $error');
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF280040),
        title: const Text(
          'Download Error',
          style: TextStyle(color: Colors.cyan),
        ),
        content: SingleChildScrollView(
          child: Text(
            'Failed to start download: $error',
            style: const TextStyle(color: Colors.white),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'OK',
              style: TextStyle(color: Colors.cyan),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF280040),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.check_circle_outline,
                  color: Colors.cyan,
                  size: 80,
                ),
                const SizedBox(height: 20),
                const Text(
                  'THANK YOU FOR YOUR PURCHASE!',
                  style: TextStyle(
                    color: Colors.cyan,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.cyan.withOpacity(0.5)),
                    color: Colors.black12,
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'Choose your platform to download:',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () => _handleMacDownload(context),
                            icon: const Icon(Icons.apple),
                            label: const Text(
                              'DOWNLOAD FOR MAC',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.cyan,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 30,
                                vertical: 15,
                              ),
                            ),
                          ),
                          const SizedBox(width: 20),
                          ElevatedButton.icon(
                            onPressed: () => _handleWindowsDownload(context),
                            icon: const Icon(Icons.window),
                            label: const Text(
                              'DOWNLOAD FOR WINDOWS',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.cyan,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 30,
                                vertical: 15,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Note: Mac download includes both AU and VST3 plugins',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                const Text(
                  'Need help? Contact support@internetkidsmaketechno.com',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () => Navigator.pushReplacementNamed(context, '/'),
                  child: const Text(
                    'Return to Home',
                    style: TextStyle(
                      color: Colors.cyan,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
