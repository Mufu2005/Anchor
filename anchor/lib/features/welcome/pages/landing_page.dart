import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import './initialization_page.dart'; // We will navigate here next

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.voidBlack, // Pure black background
      body: Center(
        child: GestureDetector(
          onTap: () {
            // Navigate to the next screen (Login Page)
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const InitializationPage()),
            );
          },
          // The "Hit Box" - ensures the tap works even on transparent parts of the image
          behavior: HitTestBehavior.opaque, 
          child: Container(
            padding: const EdgeInsets.all(40), // Increases the tap area for better UX
            child: Image.asset(
              'assets/images/logo.png', // Your logo file
              width: 120,               // Adjust size based on your design preference
              color: AppTheme.fogWhite, // Forces the logo to be White (optional)
            ),
            
            // NOTE: If you haven't added the image file yet, 
            // comment out the 'child: Image.asset...' lines above 
            // and uncomment the line below to test with a standard icon:
            
            // child: Icon(Icons.anchor, size: 100, color: AppTheme.fogWhite),
          ),
        ),
      ),
    );
  }
}