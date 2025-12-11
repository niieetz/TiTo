import 'package:flutter/material.dart';
import 'package:tito/pace_to_distance/pacedistance_page.dart';
import 'package:tito/common/consts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TiTo',
      theme: ThemeData(
        colorSchemeSeed: const Color.fromARGB(255, 3, 107, 7),
        useMaterial3: true,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        colorSchemeSeed: Colors.blue,
        useMaterial3: true,
        brightness: Brightness.dark,
      ),
      home: const LauncherHome(),
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        final insets = MediaQuery.of(context).viewInsets;
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            viewInsets: insets.isNonNegative ? insets : EdgeInsets.zero,
          ),
          child: child!,
        );
      },
    );
  }
}

class LauncherHome extends StatelessWidget {
  const LauncherHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('TiTo Launcher')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Select an app to launch:'),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>
                        const MyHomePage(title: pace2distance),
                  ),
                );
              },
              child: const Text(pace2distance),
            ),
          ],
        ),
      ),
    );
  }
}
