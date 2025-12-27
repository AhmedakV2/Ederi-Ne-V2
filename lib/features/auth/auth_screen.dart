import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; 
import 'package:shared_preferences/shared_preferences.dart'; // YENİ: Tercihi kaydetmek için
import 'auth_service.dart';
import '../navigation/main_navigation.dart';
import '../../core/theme/app_theme.dart';
import '../../data/data_controller.dart'; // YENİ: Verileri yüklemek için

// Widget Importları
import 'widgets/auth_header.dart';
import 'widgets/avatar_selector.dart';
import 'widgets/auth_form.dart';
import 'widgets/auth_submit_button.dart';
import 'widgets/auth_footer.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final AuthService _authService = AuthService();
  bool _isLoading = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool isLogin = true;
  bool rememberMe = false; // YENİ: Beni Hatırla Durumu (Varsayılan kapalı)

  int selectedRole = 0; // 0: Müşteri, 1: Satıcı
  int selectedAvatarIndex = 0;

  String? _selectedCity;
  String? _selectedDistrict;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController storeController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final List<String> avatars = [
    'assets/images/avatar_1.png',
    'assets/images/avatar_2.png',
  ];

  // --- FORM GÖNDERME FONKSİYONU ---
  void _submit() async {
    // 1. Form Doğrulaması
    if (!_formKey.currentState!.validate()) return;

    // 2. Konum Zorunluluğu (Kayıt olurken)
    if (!isLogin && (_selectedCity == null || _selectedDistrict == null)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Lütfen il ve ilçe seçimi yapın!"),
          backgroundColor: Colors.orangeAccent,
        ),
      );
      return;
    }

    FocusScope.of(context).unfocus();

    setState(() {
      _isLoading = true;
    });

    User? user;

    // 4. Firebase İşlemleri
    if (isLogin) {
      // --- GİRİŞ YAP ---
      user = await _authService.signIn(
        emailController.text.trim(),
        passwordController.text.trim(),
      );
    } else {
      // --- KAYIT OL ---
      user = await _authService.signUp(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
        name: nameController.text.trim(),
      );

      // 5. Ekstra Bilgileri Kaydet
      if (user != null) {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
          'role': (selectedRole == 1) ? "Satıcı" : "Müşteri",
          'city': _selectedCity,
          'district': _selectedDistrict,
          'storeName': (selectedRole == 1) ? storeController.text.trim() : null,
          'avatar': avatars[selectedAvatarIndex],
          // 'following': [] // İstersen boş takip listesi de oluşturabilirsin
        });
      }
    }

    // 6. BAŞARILI İSE İŞLEMLER
    if (user != null) {
      
      // --- YENİ EKLENEN KISIM: BENİ HATIRLA & VERİ YÜKLEME ---
      
      // A) Tercihi Telefona Kaydet
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('remember_me', rememberMe);

      // B) Kullanıcı Verilerini Hafızaya Çek (DataController)
      // Bunu yapıyoruz ki ana sayfaya geçtiğinde "db.userCity" gibi veriler hazır olsun.
      await DataController().loadUserData();

      // -------------------------------------------------------

      if (mounted) {
        setState(() => _isLoading = false);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) =>  MainNavigation()),
        );
        
        ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(
            content: Text(isLogin ? "Tekrar Hoş Geldin!" : "Kayıt Başarılı!"),
            backgroundColor: AppTheme.navyDark,
          ),
        );
      }
    } else {
      // HATA
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("İşlem başarısız! E-posta veya şifreyi kontrol edin."),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    storeController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              AuthHeader(isLogin: isLogin),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  children: [
                    const SizedBox(height: 20),

                    if (!isLogin) ...[
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Profil Resmi Seç",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppTheme.navyDark,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      AvatarSelector(
                        avatars: avatars,
                        selectedIndex: selectedAvatarIndex,
                        onSelect: (index) {
                          setState(() => selectedAvatarIndex = index);
                        },
                      ),
                      const SizedBox(height: 25),
                    ],

                    AuthForm(
                      isLogin: isLogin,
                      selectedRole: selectedRole,
                      onRoleChange: (role) => setState(() => selectedRole = role),
                      nameController: nameController,
                      storeController: storeController,
                      emailController: emailController,
                      passwordController: passwordController,
                      selectedCity: _selectedCity,
                      selectedDistrict: _selectedDistrict,
                      onCityChanged: (city) {
                        setState(() {
                          _selectedCity = city;
                          _selectedDistrict = null;
                        });
                      },
                      onDistrictChanged: (district) {
                        setState(() {
                          _selectedDistrict = district;
                        });
                      },
                      
                      // --- YENİ PARAMETRELERİ BAĞLADIK ---
                      rememberMe: rememberMe,
                      onRememberMeChanged: (val) {
                        setState(() {
                          rememberMe = val ?? false;
                        });
                      },
                      // -----------------------------------
                    ),

                    const SizedBox(height: 20),

                    _isLoading
                        ? const CircularProgressIndicator(color: AppTheme.accentGold)
                        : AuthSubmitButton(
                            isLogin: isLogin,
                            onPressed: _submit,
                          ),

                    const SizedBox(height: 10),

                    AuthFooter(
                      isLogin: isLogin,
                      onToggle: () {
                        setState(() {
                          isLogin = !isLogin;
                          _formKey.currentState?.reset();
                          // Mod değişince form temizlenir ama rememberMe kalabilir veya sıfırlayabilirsin
                          // rememberMe = false; 
                        });
                      },
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}