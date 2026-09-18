import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  // Feature 1: one seed color per mode generates the whole Material 3 palette.
  static const Color lightSeed = Colors.amber;
  static const Color darkSeed = Colors.teal;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void changeTheme(ThemeMode mode) {
    setState(() {
      _themeMode = mode;
    });
  }

  // Custom themes here. Every surface and text color below is read from the
  // generated ColorScheme instead of being hand-picked, so changing a seed
  // restyles the app and keeps Material 3 contrast pairings intact.
  ThemeData themeFromSeed(Color seed, Brightness brightness) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: seed,
      brightness: brightness,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.surface,
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.primaryContainer,
        foregroundColor: colorScheme.onPrimaryContainer,
        centerTitle: true,
      ),
    );
  }

  ThemeData get lightTheme => themeFromSeed(MyApp.lightSeed, Brightness.light);

  ThemeData get darkTheme => themeFromSeed(MyApp.darkSeed, Brightness.dark);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Theme Lab',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: _themeMode,
      home: HomeScreen(themeMode: _themeMode, onThemeChanged: changeTheme),
    );
  }
}

// Step 4: create HomeScreen
class HomeScreen extends StatelessWidget {
  const HomeScreen({
    required this.themeMode,
    required this.onThemeChanged,
    super.key,
  });

  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: const Text('Theme Lab')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // step 5: Avatar
            CircleAvatar(
              radius: 45,
              backgroundColor: theme.colorScheme.primaryContainer,
              foregroundColor: theme.colorScheme.onPrimaryContainer,
              child: const Icon(Icons.person, size: 52),
            ),

            const SizedBox(height: 16),

            // Step 6: Text
            Text(
              'Flutter Theme Lab',
              style: theme.textTheme.titleLarge?.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            // Step 7: status badge
            const SizedBox(height: 24),
            AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeInOut,
              width: 220,
              height: 64,
              decoration: BoxDecoration(
                color: isDarkMode ? Colors.teal : Colors.amber,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    isDarkMode ? Icons.check_circle : Icons.circle_outlined,
                    size: 22,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                  const SizedBox(width: 10),
                  Flexible(
                    child: Text(
                      'Status: Online',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Step 8: add theme buttons
            const SizedBox(height: 28),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.light_mode),
                const SizedBox(width: 8),
                Switch(
                  value: themeMode == ThemeMode.dark,
                  onChanged: (isDark) {
                    onThemeChanged(isDark ? ThemeMode.dark : ThemeMode.light);
                  },
                ),
                const SizedBox(width: 8),
                const Icon(Icons.dark_mode),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
