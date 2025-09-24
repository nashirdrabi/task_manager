import 'package:flutter/material.dart';
import 'package:task_manager_app/commons.dart';
import 'package:task_manager_app/main.dart';

import '../dashboard/ui/dashboard.dart';

// Separate Service for Data Preloading
class SplashService {
  Future<void> preloadResources() async {
    await Future.delayed(const Duration(seconds: 2));
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {


  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  Future<void> _navigateToHome() async {

    await Future.delayed(const Duration(seconds: 2));
    if
    (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Dashboard()),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animated Logo
            AnimatedScale(
              scale: 1.2,
              duration: const Duration(milliseconds: 900),
              child: getAssetImage('logo.png', height: 100),
            ),
            const SizedBox(height: 24),
           const  FadeIn(

              duration: const Duration(milliseconds: 1200),
             child: Text(
               "Task Manager",
               style: TextStyle(
                 fontSize: 32,
                 fontWeight: FontWeight.bold,
                 color: Colors.indigoAccent,
               ),
             ),
            ),
            const SizedBox(height: 32),
            CircularProgressIndicator(color: Colors.white),
          ],
        ),
      ),
    );
  }
}

// Simple fade-in animation widget
class FadeIn extends StatelessWidget {
  final Widget child;
  final Duration duration;
  const FadeIn({required this.child, required this.duration});
  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: duration,
      builder: (ctx, value, _) => Opacity(
        opacity: value,
        child: child,
      ),
    );
  }
}


