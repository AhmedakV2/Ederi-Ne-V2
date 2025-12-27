import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/theme/app_theme.dart';
import '../../data/data_controller.dart'; // DataController eklendi
import 'widgets_list/price_header.dart';
import 'widgets_list/price_item_card.dart';
import 'widgets_list/price_filter_modal.dart';

class PriceListScreen extends StatefulWidget {
  const PriceListScreen({super.key});

  @override
  State<PriceListScreen> createState() => _PriceListScreenState();
}

class _PriceListScreenState extends State<PriceListScreen> {
  final db = DataController(); // DataController örneği çekildi

  // Filtre State'leri
  String? filterCategory;
  String? filterCity;
  String? filterDistrict;
  RangeValues filterPriceRange = const RangeValues(0, 5000);
  String searchQuery = "";

  void _openFilterMenu() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return PriceFilterModal(
          initialCategory: filterCategory,
          initialCity: filterCity,
          initialDistrict: filterDistrict,
          initialPriceRange: filterPriceRange,
          onApply: (category, city, district, priceRange) {
            setState(() {
              filterCategory = category;
              filterCity = city;
              filterDistrict = district;
              filterPriceRange = priceRange;
            });
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Column(
        children: [
          PriceHeader(
            onSearchChanged: (val) => setState(() => searchQuery = val),
            onFilterTap: _openFilterMenu,
          ),

          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('products')
                  .orderBy('createdAt', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: AppTheme.accentGold),
                  );
                }

                if (snapshot.hasError) {
                  return Center(child: Text("Hata: ${snapshot.error}"));
                }

                final allDocs = snapshot.data?.docs ?? [];
                
                final List<Map<String, dynamic>> allProducts = allDocs.map((doc) {
                   final data = doc.data() as Map<String, dynamic>;
                   data['id'] = doc.id; 
                   return data;
                }).toList();

                // --- FİLTRELEME MANTIĞI ---
                final filteredList = allProducts.where((p) {
                  final name = p['name']?.toString().toLowerCase() ?? "";
                  final matchesSearch = name.contains(searchQuery.toLowerCase());
                  final matchesCat = filterCategory == null || p['category'] == filterCategory;
                  final matchesCity = filterCity == null || p['city'] == filterCity;
                  final matchesLoc = filterDistrict == null || 
                                     (p['neighborhood'] == filterDistrict || p['district'] == filterDistrict);
                  
                  final price = (p['price'] is int) 
                      ? (p['price'] as int).toDouble() 
                      : (p['price'] as double? ?? 0.0);
                  
                  final matchesPrice = price >= filterPriceRange.start && price <= filterPriceRange.end;
                  
                  return matchesSearch && matchesCat && matchesCity && matchesLoc && matchesPrice;
                }).toList();

                // ÖNEMLİ: DataController'daki listeyi güncelle ki scroll fonksiyonu doğru indeksleri bulabilsin
                db.allProductsList = filteredList;

                if (filteredList.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off_rounded, size: 80, color: Colors.grey[300]),
                        const SizedBox(height: 15),
                        Text("Sonuç bulunamadı", style: TextStyle(color: Colors.grey[500])),
                        if (filterCity != null || filterCategory != null || searchQuery.isNotEmpty)
                          TextButton(
                            onPressed: () => setState(() {
                              filterCity = null;
                              filterDistrict = null;
                              filterCategory = null;
                              searchQuery = "";
                              filterPriceRange = const RangeValues(0, 5000);
                            }),
                            child: const Text("Filtreleri Sıfırla"),
                          )
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  // YENİ: Kaydırma kontrolcüsü bağlandı
                  controller: db.mainScrollController, 
                  padding: const EdgeInsets.only(top: 20, bottom: 80),
                  itemCount: filteredList.length,
                  itemBuilder: (context, index) {
                    final item = filteredList[index];
                    return PriceItemCard(item: item);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}