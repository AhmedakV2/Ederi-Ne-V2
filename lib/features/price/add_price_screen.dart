import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../data/city_data.dart';
import '../../core/theme/app_theme.dart';
import '../../data/data_controller.dart'; 
import '../navigation/main_navigation.dart';


import 'widgets_add/add_price_header.dart';
import 'widgets_add/price_form_fields.dart';
import 'widgets_add/save_price_button.dart';

class AddPriceScreen extends StatefulWidget {
  const AddPriceScreen({super.key});

  @override
  State<AddPriceScreen> createState() => _AddPriceScreenState();
}

class _AddPriceScreenState extends State<AddPriceScreen> {
  
  final db = DataController();

  
  final _nameC = TextEditingController();
  final _priceC = TextEditingController();
  final _marketC = TextEditingController();
  
 
  String? _selectedCategory;
  String? _selectedCity;
  String? _selectedDistrict;

  
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _prepareInitialData();
  }

 
  void _prepareInitialData() {
    
    setState(() {
      if (db.isSeller) {
        _marketC.text = db.storeName ?? "";
        _selectedCity = db.userCity;
        _selectedDistrict = db.userDistrict;
      }
    });
  }

  @override
  void dispose() {
    _nameC.dispose();
    _priceC.dispose();
    _marketC.dispose();
    super.dispose();
  }

  
  void _handleSave() async {
    
    if (_nameC.text.trim().isEmpty ||
        _priceC.text.trim().isEmpty ||
        _selectedCategory == null ||
        _selectedCity == null ||
        _selectedDistrict == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Lütfen tüm zorunlu alanları doldurun!"),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception("Kullanıcı oturumu bulunamadı.");

      
      String addedByName = (db.isSeller && db.storeName != null) ? db.storeName! : db.userName;

      
      await FirebaseFirestore.instance.collection('products').add({
        'name': _nameC.text.trim(),
        'price': double.tryParse(_priceC.text.replaceAll(',', '.')) ?? 0.0,
        'market': _marketC.text.trim().isEmpty ? "Bilinmeyen Market" : _marketC.text.trim(),
        'category': _selectedCategory,
        'city': _selectedCity,
        'district': _selectedDistrict, 
        'neighborhood': _selectedDistrict, 
        'rating': 0.0,
        
        
        'ownerId': user.uid,
        'addedBy': addedByName,
        'userRole': db.userRole,
        'userAvatar': db.userAvatar,
        'createdAt': FieldValue.serverTimestamp(),
        
        
        'confirmationCount': 0, 
        'reportCount': 0,       
        'trusted': db.isSeller, 
      });

      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Ürün başarıyla paylaşıldı!"),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
        
        
        Navigator.pop(context);
        
        
        mainNavKey.currentState?.changeTab(0);
      }

    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Hata oluştu: $e"), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const AddPriceHeader(),
            Transform.translate(
              offset: const Offset(0, -40),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    )
                  ],
                ),
                child: Column(
                  children: [
                    
                    PriceTextField(
                      controller: _nameC,
                      label: "Ürün Adı",
                      icon: Icons.shopping_basket_outlined,
                    ),
                    const SizedBox(height: 15),

                    
                    PriceTextField(
                      controller: _priceC,
                      label: "Fiyat (₺)",
                      icon: Icons.currency_lira,
                      isNumber: true,
                    ),
                    const SizedBox(height: 15),
                    
                    
                    PriceTextField(
                      controller: _marketC,
                      label: "Market/Mağaza Adı",
                      icon: Icons.storefront_outlined,
                      readOnly: db.isSeller, 
                    ),
                    if (db.isSeller)
                       Padding(
                        padding: const EdgeInsets.only(top: 4, bottom: 10),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Satıcı hesabında mağaza adı sabittir.",
                            style: TextStyle(fontSize: 11, color: Colors.orange[800]),
                          ),
                        ),
                      ),
                    const SizedBox(height: 15),

                    
                    PriceDropdown(
                      value: _selectedCategory,
                      hint: "Kategori Seçin",
                      icon: Icons.category_outlined,
                      items: CityData.categories,
                      onChanged: (String? v) => setState(() => _selectedCategory = v),
                    ),
                    const SizedBox(height: 15),

                    
                    PriceDropdown(
                      value: _selectedCity,
                      hint: "İl Seçin",
                      icon: Icons.location_city,
                      items: CityData.cities,
                      onChanged: db.isSeller ? null : (String? v) {
                        setState(() {
                          _selectedCity = v;
                          _selectedDistrict = null; 
                        });
                      },
                    ),
                    const SizedBox(height: 15),

                    
                    Stack(
                      children: [
                        PriceDropdown(
                          value: _selectedDistrict,
                          hint: _selectedCity == null ? "Önce İl Seçin" : "İlçe Seçin",
                          icon: Icons.location_on_outlined,
                          items: _selectedCity != null ? CityData.citiesAndDistricts[_selectedCity]! : [],
                          onChanged: (db.isSeller || _selectedCity == null) 
                              ? null 
                              : (String? v) => setState(() => _selectedDistrict = v),
                        ),
                        if (db.isSeller)
                          Positioned.fill(
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Padding(
                                padding: const EdgeInsets.only(right: 40),
                                child: Icon(Icons.lock_outline, size: 16, color: Colors.grey.withOpacity(0.5)),
                              ),
                            ),
                          ),
                      ],
                    ),

                    if (db.isSeller)
                      Padding(
                        padding: const EdgeInsets.only(top: 8, left: 4),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "* Konum bilgileriniz profilinizden alınmaktadır.",
                            style: TextStyle(fontSize: 11, color: Colors.grey[600], fontStyle: FontStyle.italic),
                          ),
                        ),
                      ),
                    const SizedBox(height: 30),

                    
                    _isLoading 
                        ? const CircularProgressIndicator(color: AppTheme.accentGold)
                        : SavePriceButton(onPressed: _handleSave),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}