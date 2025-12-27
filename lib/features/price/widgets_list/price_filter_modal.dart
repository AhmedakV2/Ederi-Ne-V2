import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../data/city_data.dart';

class PriceFilterModal extends StatefulWidget {
  final String? initialCategory;
  final String? initialCity; // Yeni
  final String? initialDistrict; // Yeni (Eski neighborhood)
  final RangeValues initialPriceRange;
  final Function(String? category, String? city, String? district, RangeValues priceRange) onApply;

  const PriceFilterModal({
    super.key,
    this.initialCategory,
    this.initialCity,
    this.initialDistrict,
    required this.initialPriceRange,
    required this.onApply,
  });

  @override
  State<PriceFilterModal> createState() => _PriceFilterModalState();
}

class _PriceFilterModalState extends State<PriceFilterModal> {
  String? filterCategory;
  String? filterCity; // Yeni
  String? filterDistrict; // Yeni
  late RangeValues filterPriceRange;

  @override
  void initState() {
    super.initState();
    filterCategory = widget.initialCategory;
    filterCity = widget.initialCity;
    filterDistrict = widget.initialDistrict;
    filterPriceRange = widget.initialPriceRange;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.80, // İl eklendiği için yüksekliği biraz artırdık
      decoration: const BoxDecoration(
        gradient: AppTheme.primaryGradient,
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 0, left: 0, right: 0,
            child: Container(
              height: 3,
              decoration: const BoxDecoration(
                gradient: AppTheme.accentGradient,
                borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(25, 10, 25, 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 50, height: 5,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Filtrele", style: TextStyle(color: AppTheme.textWhite, fontSize: 22, fontWeight: FontWeight.bold)),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          filterCategory = null;
                          filterCity = null;
                          filterDistrict = null;
                          filterPriceRange = const RangeValues(0, 5000);
                        });
                      },
                      child: const Text("Temizle", style: TextStyle(color: AppTheme.accentGold)),
                    )
                  ],
                ),
                Divider(color: Colors.white.withOpacity(0.1)),
                const SizedBox(height: 15),

                Expanded(
                  child: ListView(
                    children: [
                      _buildFilterLabel("Kategori"),
                      _buildDropdown(filterCategory, CityData.categories, (val) {
                        setState(() => filterCategory = val);
                      }, "Kategori Seçin"),
                      
                      const SizedBox(height: 20),
                      
                      // İL SEÇİMİ
                      _buildFilterLabel("İl"),
                      _buildDropdown(filterCity, CityData.cities, (val) {
                        setState(() {
                          filterCity = val;
                          filterDistrict = null; // İl değişince ilçeyi sıfırla
                        });
                      }, "İl Seçin"),
                      
                      const SizedBox(height: 20),

                      // İLÇE SEÇİMİ (İl seçilmeden kilitli)
                      _buildFilterLabel("İlçe"),
                      _buildDropdown(
                        filterDistrict, 
                        filterCity != null ? CityData.citiesAndDistricts[filterCity]! : [], 
                        filterCity == null ? null : (val) {
                          setState(() => filterDistrict = val);
                        },
                        filterCity == null ? "Önce İl Seçin" : "İlçe Seçin"
                      ),
                      
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildFilterLabel("Fiyat Aralığı"),
                          GradientText(
                            "₺${filterPriceRange.start.round()} - ₺${filterPriceRange.end.round()}",
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            gradient: AppTheme.accentGradient,
                          ),
                        ],
                      ),
                      RangeSlider(
                        values: filterPriceRange,
                        min: 0, max: 5000, divisions: 50,
                        activeColor: AppTheme.accentGold,
                        inactiveColor: AppTheme.accentGold.withOpacity(0.2),
                        labels: RangeLabels("₺${filterPriceRange.start.round()}", "₺${filterPriceRange.end.round()}"),
                        onChanged: (val) {
                          setState(() => filterPriceRange = val);
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: AppTheme.accentGradient,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        widget.onApply(filterCategory, filterCity, filterDistrict, filterPriceRange);
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        foregroundColor: AppTheme.navyDark,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
                      ),
                      child: const Text("Sonuçları Göster", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(text, style: const TextStyle(color: AppTheme.textGrey, fontSize: 14, fontWeight: FontWeight.w600)),
    );
  }

  Widget _buildDropdown(String? value, List<String> items, Function(String?)? onChanged, String hint) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          dropdownColor: AppTheme.navyDark,
          hint: Text(hint, style: const TextStyle(color: Colors.grey, fontSize: 14)),
          icon: const Icon(Icons.keyboard_arrow_down, color: AppTheme.accentGold),
          style: const TextStyle(color: AppTheme.textWhite),
          items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: onChanged, // onChanged null ise dropdown otomatik kilitlenir
        ),
      ),
    );
  }
}