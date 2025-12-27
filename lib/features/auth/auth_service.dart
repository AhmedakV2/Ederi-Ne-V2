import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Şu anki kullanıcıyı getir
  User? get currentUser => _auth.currentUser;

  // --- KAYIT OL (Hem Auth hem Database) ---
  Future<User?> signUp({
    required String email, 
    required String password,
    required String name, // Kullanıcıdan isim de alacağız
  }) async {
    try {
      // 1. Firebase Auth ile kullanıcı oluştur
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // 2. Firestore'a Kullanıcı Detaylarını Kaydet
      if (userCredential.user != null) {
        await _firestore.collection('users').doc(userCredential.user!.uid).set({
          'uid': userCredential.user!.uid,
          'email': email,
          'name': name,
          'profilePhoto': '', // Başlangıçta boş
          'score': 0, // Puan
          'followers': [], // Takipçiler
          'following': [], // Takip edilenler
          'createdAt': FieldValue.serverTimestamp(),
          'bio': 'Ederine uygulamasını kullanıyor.', // Varsayılan söz
        });
      }
      return userCredential.user;
    } catch (e) {
      print("Kayıt Hatası: $e");
      return null;
    }
  }

  // --- GİRİŞ YAP ---
  Future<User?> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print("Giriş Hatası: $e");
      return null;
    }
  }

  // --- ÇIKIŞ YAP ---
  Future<void> signOut() async {
    await _auth.signOut();
  }
}