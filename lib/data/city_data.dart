class CityData {
  // En kalabalık 5 İl ve Tüm İlçeleri (Hiyerarşik Yapı)
  static const Map<String, List<String>> citiesAndDistricts = {
    'İstanbul': [
      'Adalar', 'Arnavutköy', 'Ataşehir', 'Avcılar', 'Bağcılar', 'Bahçelievler', 'Bakırköy', 
      'Başakşehir', 'Bayrampaşa', 'Beşiktaş', 'Beykoz', 'Beylikdüzü', 'Beyoğlu', 'Büyükçekmece', 
      'Çatalca', 'Çekmeköy', 'Esenler', 'Esenyurt', 'Eyüpsultan', 'Fatih', 'Gaziosmanpaşa', 
      'Güngören', 'Kadıköy', 'Kağıthane', 'Kartal', 'Küçükçekmece', 'Maltepe', 'Pendik', 
      'Sancaktepe', 'Sarıyer', 'Silivri', 'Sultanbeyli', 'Sultangazi', 'Şile', 'Şişli', 
      'Tuzla', 'Ümraniye', 'Üsküdar', 'Zeytinburnu'
    ],
    'Ankara': [
      'Akyurt', 'Altındağ', 'Ayaş', 'Bala', 'Beypazarı', 'Çamlıdere', 'Çankaya', 'Çubuk', 
      'Elmadağ', 'Etimesgut', 'Evren', 'Gölbaşı', 'Güdül', 'Haymana', 'Kahramankazan', 
      'Kalecik', 'Keçiören', 'Kızılcahamam', 'Mamak', 'Nallıhan', 'Polatlı', 'Pursaklar', 
      'Sincan', 'Şereflikoçhisar', 'Yenimahalle'
    ],
    'İzmir': [
      'Aliağa', 'Balçova', 'Bayındır', 'Bayraklı', 'Bergama', 'Beydağ', 'Bornova', 'Buca', 
      'Çeşme', 'Çiğli', 'Dikili', 'Foça', 'Gaziemir', 'Güzelbahçe', 'Karabağlar', 'Karaburun', 
      'Karşıyaka', 'Kemalpaşa', 'Kınık', 'Kiraz', 'Konak', 'Menderes', 'Menemen', 'Narlıdere', 
      'Ödemiş', 'Seferihisar', 'Selçuk', 'Tire', 'Torbalı', 'Urla'
    ],
    'Bursa': [
      'Büyükorhan', 'Gemlik', 'Gürsu', 'Harmancık', 'İnegöl', 'İznik', 'Karacabey', 
      'Keles', 'Kestel', 'Mudanya', 'Mustafakemalpaşa', 'Nilüfer', 'Orhaneli', 
      'Orhangazi', 'Osmangazi', 'Yenişehir', 'Yıldırım'
    ],
    'Antalya': [
      'Akseki', 'Aksu', 'Alanya', 'Demre', 'Döşemealtı', 'Elmalı', 'Finike', 'Gazipaşa', 
      'Gündoğmuş', 'İbradi', 'Kaş', 'Kemer', 'Kepez', 'Konyaaltı', 'Korkuteli', 'Kumluca', 
      'Manavgat', 'Muratpaşa', 'Serik'
    ],
  };

  // İl listesini çeker (Dropdown için)
  static List<String> get cities => citiesAndDistricts.keys.toList();

  // --- HATA DÜZELTME: neighborhood getter'ı ---
  // Diğer ekranlarda hata almamak için tüm ilçeleri düz bir liste olarak da sunuyoruz
  static List<String> get neighborhoods {
    return citiesAndDistricts.values.expand((element) => element).toList();
  }

  // Sabit Kategoriler
  static const List<String> categories = [
    'Süt & Kahvaltılık', 'Meyve & Sebze', 'Temizlik', 'Atıştırmalık', 
    'Et & Tavuk', 'Bakliyat', 'İçecekler', 'Kişisel Bakım', 'Teknoloji'
  ];
}