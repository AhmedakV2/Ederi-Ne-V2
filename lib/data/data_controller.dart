import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// 1. ADIM: ChangeNotifier ekledik
class DataController with ChangeNotifier {
  
  // --- KAYDIRMA KONTROLÜ ---
  final ScrollController mainScrollController = ScrollController();

  // PriceListScreen'den gelen ürün listesi hafızası
  List<Map<String, dynamic>> allProductsList = []; 

  // --- KULLANICI BİLGİLERİ ---
  String? uid;
  String userName = "Misafir";
  String userBio = "";
  String userRole = "Müşteri"; 
  String userAvatar = "assets/images/avatar_1.png";
  String? storeName;
  
  String? userCity;
  String? userDistrict;

  List<String> followingIds = [];

  // --- VERİLERİ YÜKLE ---
  Future<void> loadUserData() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      uid = user.uid;
      try {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .get();

        if (userDoc.exists) {
          final data = userDoc.data() as Map<String, dynamic>?;
          if (data == null) return;
          
          userName = data['name'] ?? "İsimsiz";
          userBio = data['bio'] ?? "";
          userRole = data['role'] ?? "Müşteri";
          userAvatar = data['avatar'] ?? "assets/images/avatar_1.png";
          storeName = data['storeName'];
          userCity = data['city'];
          userDistrict = data['district'];
          
          if (data['following'] != null) {
              followingIds = List<String>.from(data['following']);
          }
          
          // 2. ADIM: Veri çekilince ekranı haberdar ediyoruz
          notifyListeners(); 
        }
      } catch (e) {
        debugPrint("Veri çekme hatası: $e");
      }
    }
  }

  // --- YÖNLENDİRME VE KAYDIRMA FONKSİYONU ---
  void scrollToProduct(String productId, List<Map<String, dynamic>> products) {
    int index = products.indexWhere((item) => item['id'] == productId);
    
    if (index != -1 && mainScrollController.hasClients) {
      double targetOffset = index * 130.0; 
      
      mainScrollController.animateTo(
        targetOffset,
        duration: const Duration(milliseconds: 700),
        curve: Curves.easeInOutQuart,
      );
    }
  }

  // --- BASİT KONTROLLER ---
  bool get isSeller => userRole == "Satıcı";

  bool isFollowing(String targetUserId) {
    return followingIds.contains(targetUserId);
  }

  // --- LOGOUT (Çıkış Yapınca Temizle) ---
  void clearSession() {
    uid = null;
    userName = "Misafir";
    userBio = "";
    userRole = "Müşteri";
    userAvatar = "assets/images/avatar_1.png";
    storeName = null;
    userCity = null;
    userDistrict = null;
    followingIds.clear();
    allProductsList.clear(); 
    
    // 3. ADIM: Çıkış yapıldığını tüm sayfalara bildiriyoruz
    notifyListeners();
  }
}