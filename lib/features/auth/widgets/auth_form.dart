import 'package:flutter/material.dart';
import 'theme_textfield.dart';
import 'role_button.dart';
import '../../../data/city_data.dart';
import '../../price/widgets_add/price_form_fields.dart';
import '../../../core/utils/auth_validator.dart';
import '../../../core/theme/app_theme.dart'; // AppTheme import'u eklendi

class AuthForm extends StatelessWidget {
  final bool isLogin;
  final int selectedRole;
  final Function(int) onRoleChange;
  final TextEditingController nameController;
  final TextEditingController storeController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final String? selectedCity;
  final String? selectedDistrict;
  final Function(String?) onCityChanged;
  final Function(String?) onDistrictChanged;

  // YENİ PARAMETRELER: Beni Hatırla Seçeneği İçin
  final bool rememberMe;
  final Function(bool?) onRememberMeChanged;

  const AuthForm({
    super.key,
    required this.isLogin,
    required this.selectedRole,
    required this.onRoleChange,
    required this.nameController,
    required this.storeController,
    required this.emailController,
    required this.passwordController,
    this.selectedCity,
    this.selectedDistrict,
    required this.onCityChanged,
    required this.onDistrictChanged,
    required this.rememberMe,          // Yeni
    required this.onRememberMeChanged, // Yeni
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 1. AD SOYAD (Sadece Kayıt Olurken)
        if (!isLogin) ...[
          ThemeTextField(
            controller: nameController,
            hint: "Ad Soyad",
            icon: Icons.person_outline,
            validator: AuthValidator.validateName,
          ),
          const SizedBox(height: 15),
        ],

        // 2. E-POSTA ALANI
        ThemeTextField(
          controller: emailController,
          hint: "E-posta",
          icon: Icons.email_outlined,
          isPassword: false,
          keyboardType: TextInputType.emailAddress,
          validator: AuthValidator.validateEmail,
        ),
        const SizedBox(height: 15),

        // 3. ŞİFRE ALANI
        ThemeTextField(
          controller: passwordController,
          hint: "Şifre",
          icon: Icons.lock_outline,
          isPassword: true,
          validator: AuthValidator.validatePassword,
        ),

        // --- YENİ EKLENEN KISIM: BENİ HATIRLA KUTUCUĞU ---
        // Şifre alanının hemen altında gösterilir
        Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Row(
            children: [
              Theme(
                data: ThemeData(unselectedWidgetColor: Colors.grey),
                child: Checkbox(
                  value: rememberMe,
                  activeColor: AppTheme.accentGold,
                  checkColor: AppTheme.navyDark,
                  onChanged: onRememberMeChanged,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)), // Estetik için
                ),
              ),
              const Text(
                "Beni Hatırla",
                style: TextStyle(
                  color: AppTheme.navyDark, // Arka plan beyaz olduğu için KOYU renk
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),

        // 4. ROL VE KONUM ALANLARI (Sadece Kayıt Olurken)
        if (!isLogin) ...[
          const SizedBox(height: 20),
          
          Row(
            children: [
              Expanded(
                child: RoleButton(
                  text: "Müşteri",
                  selected: selectedRole == 0,
                  onTap: () => onRoleChange(0),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: RoleButton(
                  text: "Satıcı",
                  selected: selectedRole == 1,
                  onTap: () => onRoleChange(1),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // --- MAĞAZA ADI ---
          if (selectedRole == 1) ...[
            ThemeTextField(
              controller: storeController,
              hint: "Mağaza Adı",
              icon: Icons.store,
              validator: (v) => (v == null || v.isEmpty) ? "Mağaza adı zorunludur" : null,
            ),
            const SizedBox(height: 15),
          ],

          // --- İL SEÇİMİ ---
          PriceDropdown(
            value: selectedCity,
            hint: "İl Seçin",
            icon: Icons.location_city,
            items: CityData.cities,
            onChanged: onCityChanged,
          ),

          const SizedBox(height: 15),

          // --- İLÇE SEÇİMİ ---
          PriceDropdown(
            value: selectedDistrict,
            hint: selectedCity == null ? "Önce İl Seçin" : "İlçe Seçin",
            icon: Icons.map,
            items: selectedCity != null ? CityData.citiesAndDistricts[selectedCity]! : [],
            onChanged: selectedCity == null ? null : onDistrictChanged,
          ),
        ],
      ],
    );
  }
}