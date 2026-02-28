import 'package:anchor/core/services/session_manager.dart';
import 'package:anchor/features/auth/pages/lock_screen.dart';
import 'package:anchor/main.dart';
import 'package:flutter/material.dart';

class LifecycleLockWrapper extends StatefulWidget {
  final Widget child;
  const LifecycleLockWrapper({super.key, required this.child});

  @override
  State<LifecycleLockWrapper> createState() => _LifecycleLockWrapperState();
}

// Notice the "with WidgetsBindingObserver" added here!
class _LifecycleLockWrapperState extends State<LifecycleLockWrapper> with WidgetsBindingObserver {
  
  @override
  void initState() {
    super.initState();
    // Tell Flutter: "Hey, notify me when the app goes to the background!"
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    // Stop listening if this widget is ever destroyed
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // This is the magic function that the OS calls automatically
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    // AppLifecycleState.paused means the app is completely in the background
    // (User went to home screen, opened another app, or locked their phone)
    if (state == AppLifecycleState.paused) {
      _lockApp();
    }
  }

  void _lockApp() {
    // Only trigger the lock if they are currently logged in
    if (SessionManager().isLoggedIn) {
      print("🔒 App went to background. Locking app...");
      
      // 1. Wipe the encryption key and user data from RAM
      // SessionManager().clear();

      // 2. Force the UI back to the login/lock screen
      // (This assumes you still have navigatorKey set up in main.dart)
      navigatorKey.currentState?.pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LockScreen()), 
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // We just return the child directly. No extra touch listeners needed!
    return widget.child;
  }
}