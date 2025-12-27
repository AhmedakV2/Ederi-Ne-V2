import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  
  User? get currentUser => _auth.currentUser;

  
  Future<User?> signUp({
    required String email, 
    required String password,
    required String name, 
  }) async {
    try {
      
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      
      if (userCredential.user != null) {
        await _firestore.collection('users').doc(userCredential.user!.uid).set({
          'uid': userCredential.user!.uid,
          'email': email,
          'name': name,
          'profilePhoto': '', 
          'score': 0, 
          'followers': [], 
          'following': [], 
          'createdAt': FieldValue.serverTimestamp(),
          'bio': 'Ederine uygulamasını kullanıyor.', 
        });
      }
      return userCredential.user;
    } catch (e) {
      print("Kayıt Hatası: $e");
      return null;
    }
  }

  
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

  
  Future<void> signOut() async {
    await _auth.signOut();
  }
}