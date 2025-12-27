import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../data/data_controller.dart';


import '../../features/price/price_list_screen.dart';
import '../../features/price/add_price_screen.dart';
import '../../features/profile/profile_screen.dart';


final GlobalKey<MainNavigationState> mainNavKey = GlobalKey<MainNavigationState>();

class MainNavigation extends StatefulWidget {
  
  MainNavigation({super.key}); 

  @override
  State<MainNavigation> createState() => MainNavigationState();
}

class MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;
  final db = DataController();

  void changeTab(int index) {
    if (mounted) {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _setupInteractedMessage();
  }

  Future<void> _setupInteractedMessage() async {
    RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  void _handleMessage(RemoteMessage message) {
    if (message.data.containsKey('productId')) {
      changeTab(0);
    }
  }

  final List<Widget> _pages = [
    const PriceListScreen(),
    const Center(child: Text("Yükleniyor...")), 
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          IndexedStack(
            index: _currentIndex,
            children: _pages,
          ),

          
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              margin: const EdgeInsets.all(20),
              height: 70,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(35),
                boxShadow: [
                  BoxShadow(
                    
                    color: Colors.black.withValues(alpha: 0.1), 
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    onPressed: () => changeTab(0),
                    icon: Icon(
                      _currentIndex == 0 ? Icons.home_rounded : Icons.home_outlined,
                      color: _currentIndex == 0 ? AppTheme.accentGold : Colors.grey,
                      size: 30,
                    ),
                  ),

                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const AddPriceScreen()),
                      );
                    },
                    child: Container(
                      width: 55,
                      height: 55,
                      decoration: const BoxDecoration(
                        gradient: AppTheme.accentGradient,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.accentGold,
                            blurRadius: 15,
                            offset: Offset(0, 5),
                          )
                        ],
                      ),
                      child: const Icon(Icons.add, color: AppTheme.navyDark, size: 30),
                    ),
                  ),

                  GestureDetector(
                    onTap: () => changeTab(2),
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: _currentIndex == 2 ? AppTheme.accentGold : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: CircleAvatar(
                        radius: 14,
                        backgroundColor: Colors.grey[200],
                        backgroundImage: AssetImage(db.userAvatar),
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