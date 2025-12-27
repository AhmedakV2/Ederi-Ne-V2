import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../data/data_controller.dart';
import '../../../../data/city_data.dart';

class EditProfileSheet extends StatefulWidget {
  final String currentName;
  final String currentBio;
  final String currentAvatar;
  final String? currentStoreName;
  final String currentCity;
  final String currentDistrict;
  final List<String> avatars;
  final Function(String name, String bio, String avatar, String? storeName, String city, String district) onSave;

  const EditProfileSheet({
    super.key,
    required this.currentName,
    required this.currentBio,
    required this.currentAvatar,
    this.currentStoreName,
    required this.currentCity,
    required this.currentDistrict,
    required this.avatars,
    required this.onSave,
  });

  @override
  State<EditProfileSheet> createState() => _EditProfileSheetState();
}

class _EditProfileSheetState extends State<EditProfileSheet> {
  late TextEditingController nameController;
  late TextEditingController bioController;
  late TextEditingController storeController;
  late String selectedAvatar;
  late String selectedCity;
  late String selectedDistrict;
  
  final db = DataController();

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.currentName);
    bioController = TextEditingController(text: widget.currentBio);
    storeController = TextEditingController(text: widget.currentStoreName ?? "");
    selectedAvatar = widget.currentAvatar;
    selectedCity = widget.currentCity;
    selectedDistrict = widget.currentDistrict;
  }

  @override
  void dispose() {
    nameController.dispose();
    bioController.dispose();
    storeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        left: 25,
        right: 25,
        top: 25,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle Bar
            Container(
                width: 50,
                height: 5,
                decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10))),
            const SizedBox(height: 25),
            const Text("Profili Düzenle",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.navyDark)),
            const SizedBox(height: 30),
            
            // --- AVATAR SEÇİMİ ---
            const Align(
                alignment: Alignment.centerLeft,
                child: Text("Avatar Seçin",
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textGrey))),
            const SizedBox(height: 15),
            SizedBox(
              height: 85,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: widget.avatars.length,
                itemBuilder: (context, index) {
                  bool isSelected = selectedAvatar == widget.avatars[index];
                  return GestureDetector(
                    onTap: () {
                      setState(() => selectedAvatar = widget.avatars[index]);
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      margin: const EdgeInsets.only(right: 15),
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: isSelected ? AppTheme.accentGold : Colors.transparent, 
                            width: 3),
                        boxShadow: isSelected ? [
                          BoxShadow(color: AppTheme.accentGold.withOpacity(0.3), blurRadius: 8)
                        ] : null,
                      ),
                      child: CircleAvatar(
                        radius: 35,
                        backgroundColor: AppTheme.background,
                        backgroundImage: AssetImage(widget.avatars[index]),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 30),

            // --- INPUT ALANLARI ---
            _buildModalTextField(
                nameController, "Ad Soyad / Kullanıcı Adı", Icons.person_outline),
            
            if (db.userRole == "Satıcı") ...[
              const SizedBox(height: 15),
              _buildModalTextField(
                  storeController, "Mağaza Adı", Icons.store_outlined),
              
              const SizedBox(height: 15),
              // İL SEÇİMİ (Hiyerarşik)
              _buildDropdownField(
                label: "Şehir",
                value: selectedCity,
                items: CityData.cities,
                icon: Icons.location_city_outlined,
                onChanged: (val) {
                  setState(() {
                    selectedCity = val!;
                    // İlçe listesini yeni ile göre güncelle ve ilk ilçeyi seç veya null yap
                    selectedDistrict = CityData.citiesAndDistricts[val]!.first;
                  });
                },
              ),

              const SizedBox(height: 15),
              // İLÇE SEÇİMİ (Seçili ile bağlı)
              _buildDropdownField(
                label: "İlçe",
                value: selectedDistrict,
                // Sadece seçili şehrin ilçelerini gösterir
                items: CityData.citiesAndDistricts[selectedCity] ?? [],
                icon: Icons.map_outlined,
                onChanged: (val) => setState(() => selectedDistrict = val!),
              ),
            ],

            const SizedBox(height: 15),
            _buildModalTextField(
                bioController, "Hakkında Yazısı", Icons.info_outline,
                maxLines: 3),
            
            const SizedBox(height: 35),

            // --- KAYDET BUTONU ---
            Container(
              width: double.infinity,
              height: 55,
              decoration: BoxDecoration(
                gradient: AppTheme.primaryGradient,
                borderRadius: BorderRadius.circular(15),
              ),
              child: ElevatedButton(
                onPressed: () {
                  widget.onSave(
                    nameController.text, 
                    bioController.text, 
                    selectedAvatar,
                    storeController.text.isEmpty ? null : storeController.text,
                    selectedCity,
                    selectedDistrict,
                  );
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  elevation: 0,
                ),
                child: const Text("Değişiklikleri Kaydet",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String value,
    required List<String> items,
    required IconData icon,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AppTheme.background,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppTheme.accentGold.withOpacity(0.2)),
      ),
      child: DropdownButtonFormField<String>(
        value: items.contains(value) ? value : items.first, // Güvenlik kontrolü
        items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.grey, fontSize: 14),
          prefixIcon: Icon(icon, color: AppTheme.navyLight, size: 22),
          border: InputBorder.none,
        ),
        style: const TextStyle(fontSize: 15, color: AppTheme.navyDark),
        dropdownColor: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
    );
  }

  Widget _buildModalTextField(
      TextEditingController controller, String label, IconData icon,
      {int maxLines = 1}) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.background,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppTheme.accentGold.withOpacity(0.2)),
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        style: const TextStyle(fontSize: 15, color: AppTheme.navyDark),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.grey[600], fontSize: 14),
          prefixIcon: Icon(icon, color: AppTheme.navyLight, size: 22),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
      ),
    );
  }
}