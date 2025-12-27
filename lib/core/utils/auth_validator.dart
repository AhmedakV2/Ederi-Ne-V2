

class AuthValidator {
 
  static String? validateEmail(String? value) {
    
    final email = value?.trim();

    if (email == null || email.isEmpty) {
      return 'E-posta alanı boş bırakılamaz';
    }
    
    
    final emailRegex = RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
    );
    
    if (!emailRegex.hasMatch(email)) {
      return 'Lütfen geçerli bir e-posta adresi giriniz (örn: isim@gmail.com)';
    }
    return null;
  }

  
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Şifre alanı boş bırakılamaz';
    }
    
    
    if (value.length < 8) {
      return 'Şifre en az 8 karakter uzunluğunda olmalıdır';
    }
    
    
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Şifre en az bir büyük harf (A-Z) içermelidir';
    }

    
    if (!value.contains(RegExp(r'[a-z]'))) {
      return 'Şifre en az bir küçük harf (a-z) içermelidir';
    }
    
    
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Şifre en az bir rakam (0-9) içermelidir';
    }
    
    
    if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return 'Şifre en az bir özel karakter (!, @, #, vb.) içermelidir';
    }
    
    return null;
  }

  
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