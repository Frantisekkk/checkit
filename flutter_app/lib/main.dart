import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

void main() {
  runApp(const CheckitApp());
}

class CheckitApp extends StatelessWidget {
  const CheckitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Checkit',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        primaryColor: Colors.white,
        colorScheme: const ColorScheme.dark(
          primary: Colors.white,
          onPrimary: Colors.black,
          surface: Color(0xFF1C1C1E),
          onSurface: Colors.white,
          background: Colors.black,
          onBackground: Colors.white,
        ),
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            color: Colors.white,
            fontSize: 34,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.37,
          ),
          bodyLarge: TextStyle(
            color: Colors.white,
            fontSize: 17,
            letterSpacing: -0.41,
          ),
          bodyMedium: TextStyle(
            color: Color(0xFF8E8E93),
            fontSize: 15,
            letterSpacing: -0.24,
          ),
        ),
        fontFamily: '.SF Pro Text',
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 60),
                
                // Greeting
                Text(
                  'Welcome',
                  style: Theme.of(context).textTheme.displayLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  'Checkit',
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    fontWeight: FontWeight.w300,
                  ),
                ),
                const SizedBox(height: 60),
                
                // Instructions
                _buildInstructionSection(
                  context,
                  icon: Icons.share_outlined,
                  title: 'Share from Anywhere',
                  description: 'Open Instagram, TikTok, or any app with a video. Tap the share button and select Checkit.',
                ),
                const SizedBox(height: 32),
                
                _buildInstructionSection(
                  context,
                  icon: Icons.analytics_outlined,
                  title: 'Choose Analysis',
                  description: 'Select how you want to analyze the video: verify authenticity, get explanations, or explore ideas.',
                ),
                const SizedBox(height: 32),
                
                _buildInstructionSection(
                  context,
                  icon: Icons.insights_outlined,
                  title: 'Get Results',
                  description: 'Receive instant AI-powered analysis directly in the share extension.',
                ),
                const SizedBox(height: 80),
                
                // Divider
                Container(
                  height: 0.5,
                  color: const Color(0xFF38383A),
                ),
                const SizedBox(height: 40),
                
                // Note
                Text(
                  'Note',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'This app works through the iOS share extension. Share videos from other apps to get started.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 60),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInstructionSection(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: const Color(0xFF1C1C1E),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 22,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

