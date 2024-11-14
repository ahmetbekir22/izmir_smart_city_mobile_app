import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'package:smart_city_app/features/auth/views/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  // bool _showFirstText = false;
  // bool _showSecondText = false;
  bool _imageLoaded = false;
  bool _loadingImage = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation1;
  late Animation<double> _fadeAnimation2;

  final double kentLeftPadding = 40.0;
  final double rehberimLeftPadding = 120.0;
  final double bottomPadding = 40.0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _fadeAnimation1 = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    _fadeAnimation2 = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.5, 1.0, curve: Curves.easeIn),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_loadingImage) {
      _loadingImage = true;
      _loadImage();
    }
  }

  Future<void> _loadImage() async {
    try {
      await precacheImage(const AssetImage('assets/images/city.png'), context);
      if (mounted) {
        setState(() {
          _imageLoaded = true;
        });
        _startAnimation();
      }
    } catch (e) {
      print('Resim yükleme hatası: $e');
    }
  }

  void _startAnimation() {
    _animationController.forward();

    Future.delayed(const Duration(milliseconds: 1000), () {
      Get.off(() => const HomePage());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          if (_imageLoaded)
            Image.asset(
              'assets/images/city.png',
              fit: BoxFit.cover,
              filterQuality: FilterQuality.high,
            ),
          Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(bottom: bottomPadding),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FadeTransition(
                    opacity: _fadeAnimation1,
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.only(left: kentLeftPadding),
                      child: const Text(
                        'Kent',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 45,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: 3,
                          shadows: [
                            Shadow(
                              offset: Offset(2.0, 2.0),
                              blurRadius: 4.0,
                              color: Colors.black45,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 2),
                  FadeTransition(
                    opacity: _fadeAnimation2,
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.only(left: rehberimLeftPadding),
                      child: const Text(
                        'Rehberim',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 45,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: 2,
                          shadows: [
                            Shadow(
                              offset: Offset(2.0, 2.0),
                              blurRadius: 4.0,
                              color: Colors.black45,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
