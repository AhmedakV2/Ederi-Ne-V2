import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; 
import 'package:firebase_messaging/firebase_messaging.dart'; 
import 'package:shared_preferences/shared_preferences.dart'; 
import '../../data/data_controller.dart'; 
import 'auth_screen.dart';
import '../../core/theme/app_theme.dart';
import '../navigation/main_navigation.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  
  late Animation<Offset> _logoSlideAnimation;
  late Animation<double> _textFadeAnimation;
  late Animation<Offset> _textSlideAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _logoSlideAnimation = Tween<Offset>(
      begin: const Offset(-2.0, 0.0), 
      end: Offset.zero,              
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOutBack), 
    ));

    _textFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 1.0, curve: Curves.easeIn), 
      ),
    );

    _textSlideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.5), 
      end: Offset.zero,              
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.5, 1.0, curve: Curves.easeOut),
    ));

    _controller.forward();

    _checkUserSession();
  }

  
  Future<void> _saveUserToken(User user) async {
    try {
      FirebaseMessaging messaging = FirebaseMessaging.instance;
      
     
      await messaging.requestPermission();
      
     
      String? token = await messaging.getToken();
      
      if (token != null) {
       
        await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
          'fcmToken': token,
        });
        debugPrint("FCM Token Kaydedildi: $token");
      }
    } catch (e) {
      debugPrint("Token hatası: $e");
      
    }
  }

  
  void _checkUserSession() async {
    
    await Future.delayed(const Duration(seconds: 3));

    final user = FirebaseAuth.instance.currentUser;
    final prefs = await SharedPreferences.getInstance();
    bool rememberMe = prefs.getBool('remember_me') ?? false;

    if (mounted) {
      if (user != null) {
        
        if (rememberMe) {
         
          
          
          await Future.wait([
            DataController().loadUserData(),
            _saveUserToken(user),
          ]);
          
          if (mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) =>  MainNavigation()),
            );
          }
        } else {
         
          await FirebaseAuth.instance.signOut();
          DataController().clearSession();
          
          if (mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const AuthScreen()),
            );
          }
        }
      } else {
        
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const AuthScreen()),
        );
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, 
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: AppTheme.primaryGradient,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              
              SlideTransition(
                position: _logoSlideAnimation,
                child: Image.asset(
                  'assets/images/Login.png',
                  width: 180,
                ),
              ),
              
              const SizedBox(height: 40),

              
              FadeTransition(
                opacity: _textFadeAnimation,
                child: SlideTransition(
                  position: _textSlideAnimation,
                  child: Column(
                    children: [
                      
                      ShaderMask(
                        blendMode: BlendMode.srcIn,
                        shaderCallback: (bounds) => AppTheme.accentGradient.createShader(
                          Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                        ),
                        child: const Text(
                          "Ederi Ne?",
                          style: TextStyle(
                            fontSize: 42,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                            shadows: [
                                Shadow(
                                  blurRadius: 10.0,
                                  color: Colors.black26,
                                  offset: Offset(2.0, 2.0),
                                ),
                              ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      
                      ShaderMask(
                        blendMode: BlendMode.srcIn,
                        shaderCallback: (bounds) => AppTheme.accentGradient.createShader(
                          Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                        ),
                        child: const Text(
                          "Fiyatları Keşfet, Kararını Ver!",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 1.2,
                             shadows: [
                                Shadow(
                                  blurRadius: 8.0,
                                  color: Colors.black26,
                                  offset: Offset(1.0, 1.0),
                                ),
                              ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}