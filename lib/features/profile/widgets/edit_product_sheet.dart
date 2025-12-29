import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class EditProductSheet extends StatefulWidget { //Ürün düzenleme alt sayfası
  final Map<String, dynamic> currentItem; //Düzenlenecek ürün bilgileri
  final Function(String name, double price, String market) onSave; //Kaydetme işlevi

  const EditProductSheet({ //Ürün düzenleme alt sayfası
    super.key,
    required this.currentItem,
    required this.onSave,
  });

  @override
  State<EditProductSheet> createState() => _EditProductSheetState(); //Durum oluşturma
}

class _EditProductSheetState extends State<EditProductSheet> { //Ürün düzenleme alt sayfası durumu
  late TextEditingController _nameController; //Ürün adı denetleyicisi
  late TextEditingController _priceController; //Ürün fiyat denetleyicisi
  late TextEditingController _marketController; //Ürün market denetleyicisi

  @override
  void initState() { //Başlatma işlemleri
    super.initState(); //Üst sınıf başlatma
    
    _nameController = TextEditingController(text: widget.currentItem['name']); //Mevcut ürün adını ayarla
    _priceController = TextEditingController(text: widget.currentItem['price'].toString()); //Mevcut ürün fiyatını ayarla
    _marketController = TextEditingController(text: widget.currentItem['market']); //Mevcut ürün marketini ayarla
  }

  @override
  void dispose() { //Kaynakları serbest bırakma
    _nameController.dispose(); 
    _priceController.dispose();
    _marketController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) { 
    
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom; //Klavye yüksekliğini al

    return Container(
      padding: EdgeInsets.only(top: 20, left: 20, right: 20, bottom: bottomPadding + 20), //Klavye yüksekliğine göre alt boşluk ekle
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, 
        children: [
          
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          
          const Text(
            "Ürünü Düzenle",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppTheme.navyDark,
            ),
          ),
          const SizedBox(height: 20),

          
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: "Ürün Adı",
              prefixIcon: const Icon(Icons.shopping_basket_outlined, color: AppTheme.accentGold),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
            ),
          ),
          const SizedBox(height: 15),

          
          TextField(
            controller: _priceController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              labelText: "Fiyat (₺)",
              prefixIcon: const Icon(Icons.currency_lira, color: AppTheme.accentGold),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
            ),
          ),
          const SizedBox(height: 15),

          
          TextField(
            controller: _marketController,
            decoration: InputDecoration(
              labelText: "Market / Mağaza",
              prefixIcon: const Icon(Icons.storefront, color: AppTheme.accentGold),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
            ),
          ),
          const SizedBox(height: 25),

          
          SizedBox( 
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                final double? price = double.tryParse(_priceController.text.replaceAll(',', '.'));
                if (_nameController.text.isNotEmpty && price != null) {
                  widget.onSave(
                    _nameController.text.trim(),
                    price,
                    _marketController.text.trim(),
                  );
                  Navigator.pop(context); 
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.navyDark,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),
              child: const Text("Değişiklikleri Kaydet", style: TextStyle(color: Colors.white, fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }
}