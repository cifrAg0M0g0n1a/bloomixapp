import 'package:flutter/material.dart';
import 'dart:async';


class ScreensaverScreen extends StatefulWidget {
  const ScreensaverScreen({super.key});

  @override
  _ScreensaverScreenState createState() => _ScreensaverScreenState();
}

class _ScreensaverScreenState extends State<ScreensaverScreen> {
  @override
  void initState() {
    super.initState();
    // Таймер для перехода на главный экран через 3 секунды
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, '/authorization');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.tertiary,
      body: Center(
        child: Text(
          'Bloomix',
          style: TextStyle(
            fontSize: 60,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontFamily: 'DancingScript',
          ),
        ),
      ),
    );
  }
}
