// lib/core/utils/auth_validator.dart

class AuthValidator {
  /// E-posta Doğrulaması
  static String? validateEmail(String? value) {
    // Boşlukları temizleyerek kontrol edelim
    final email = value?.trim();

    if (email == null || email.isEmpty) {
      return 'E-posta alanı boş bırakılamaz';
    }
    
    // Gelişmiş e-posta formatı Regex
    final emailRegex = RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
    );
    
    if (!emailRegex.hasMatch(email)) {
      return 'Lütfen geçerli bir e-posta adresi giriniz (örn: isim@mail.com)';
    }
    return null;
  }

  /// Şifre Güvenlik Doğrulaması
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Şifre alanı boş bırakılamaz';
    }
    
    // 1. Uzunluk Kontrolü
    if (value.length < 8) {
      return 'Şifre en az 8 karakter uzunluğunda olmalıdır';
    }
    
    // 2. Büyük Harf Kontrolü
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Şifre en az bir büyük harf (A-Z) içermelidir';
    }

    // 3. Küçük Harf Kontrolü (Güvenlik için eklendi)
    if (!value.contains(RegExp(r'[a-z]'))) {
      return 'Şifre en az bir küçük harf (a-z) içermelidir';
    }
    
    // 4. Rakam Kontrolü
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Şifre en az bir rakam (0-9) içermelidir';
    }
    
    // 5. Özel Karakter Kontrolü
    if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return 'Şifre en az bir özel karakter (!, @, #, vb.) içermelidir';
    }
    
    return null;
  }

  /// Ad Soyad Doğrulaması (Opsiyonel ama önerilir)
  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'İsim alanı boş bırakılamaz';
    }
    if (value.trim().length < 3) {
      return 'Lütfen geçerli bir isim giriniz';
    }
    return null;
  }
}