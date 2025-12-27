# 🚀 Ederi Ne? - Akıllı Fiyat Takip & Doğrulama Platformu (v2.0.0 Stable)

[![Flutter Version](https://img.shields.io/badge/Flutter-3.x-blue.svg)](https://flutter.dev)
[![Platform](https://img.shields.io/badge/Platform-Android-green.svg)](https://android.com)
[![Version](https://img.shields.io/badge/Version-v2.0.0--Stable-orange.svg)](https://github.com/AhmedakV2/Ederi-Ne-V2/releases)
[![License](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

**Ederi Ne?**, enflasyonist ortamda tüketicinin en güçlü silahı olan "şeffaf bilgi paylaşımı" üzerine kurulu, topluluk odaklı bir fiyat takip ekosistemidir. Mahalle bakkalından zincir marketlere kadar her noktadaki güncel fiyatı, gerçek kullanıcı verileriyle cebinize getirir.

---

## 📝 Proje Vizyonu: Neden "Ederi Ne?"

Geleneksel fiyat karşılaştırma platformları genellikle sadece büyük e-ticaret sitelerine odaklanır. **Ederi Ne?** ise odağını sokağa, mahalle marketine ve yerel manava çevirir. 

### 💡 Nasıl Değer Yaratır?
* **Kolektif Veri:** Kullanıcılar gördükleri fiyatları saniyeler içinde yükler, böylece "en ucuz" reklamla değil, gerçekle belirlenir.
* **Topluluk Denetimi:** Paylaşılan fiyatlar diğer kullanıcılar tarafından "Doğru" veya "Hatalı" olarak oylanır.
* **Güven Endeksi:** 5 ve üzeri şikayet alan ürünler otomatik olarak **"ŞÜPHELİ"** etiketiyle işaretlenerek yanıltıcı bilginin önüne geçilir.

---

## 📸 Uygulama Ekran Görüntüleri

| Ana Liste (v2) | Ürün Detay & Yorum | Fiyat Ekleme | Profil & İstatistik |
|:---:|:---:|:---:|:---:|
| <img src="screenshots/home.png" width="200"> | <img src="screenshots/comments.png" width="200"> | <img src="screenshots/add.png" width="200"> | <img src="screenshots/profile.png" width="200"> |

> *Not: Ekran görüntülerini aktif etmek için `screenshots/` klasörüne ilgili dosyaları yüklemeyi unutmayın.*

---

## 📥 Hemen Deneyin (v2.0.0 APK)

Uygulamanın en güncel ve kararlı sürümünü aşağıdaki butona tıklayarak doğrudan indirebilirsiniz:

[![Download APK](https://img.shields.io/badge/İndir-Ederi_Ne_v2.0.0_APK-brightgreen?style=for-the-badge&logo=android)](app-release.apk)

---

## 💎 v2.0.0 Sürümüyle Gelen Büyük Yenilikler

Bu güncelleme, uygulamanın beta aşamasından tam kapasite kararlı sürümü geçişini temsil eder.

### 📍 Gelişmiş Konum Hassasiyeti
* **Lokasyon Bazlı Kartlar:** Her ürün kartına entegre edilen **İl ve İlçe** bilgisi sayesinde, fiyatın nerede geçerli olduğu artık net bir şekilde görülmektedir.
* **Modern UX:** Konum göstergeleri ve market ikonları ile arayüz hiyerarşisi yeniden tasarlandı.

### 🔄 Akıllı Navigasyon & Senkronizasyon
* **Profil-Liste Entegrasyonu:** Kullanıcı profilindeki paylaşımlardan ana listedeki ilgili ürüne "akıllı odaklanma" ile geçiş özelliği eklendi.
* **Hata Giderimi:** Açılıştaki `SplashScreen` donmaları ve `MainNavigation` üzerindeki `GlobalKey` çakışmaları tamamen çözüldü.

### 🏗️ Teknik Mimari İyileştirmeleri
* **Merkezi Veri Yönetimi:** `DataController` üzerinden yönetilen `allProductsList` yapısı ile veri yükleme hızı optimize edildi.
* **Güvenlik:** Hassas Firebase anahtarları (`service-account.json`) koruma altına alındı ve `.gitignore` yapılandırması modernize edildi.
* **Modern Dart Standartları:** Flutter 3.x uyumlu `withValues` renk yönetimi ve `const` constructor optimizasyonları yapıldı.

---

## 🛠️ Teknoloji Yığını
* **Framework:** Flutter (Dart)
* **Backend:** Firebase (Firestore, Authentication)
* **State Management:** DataController & GlobalKey Patterns
* **Güvenlik:** GitHub Push Protection & Secret Scanning

---

## ⚙️ Geliştiriciler İçin Kurulum Rehberi

1.  **Repoyu Klonlayın:**
    ```bash
    git clone [https://github.com/AhmedakV2/Ederi-Ne-V2.git](https://github.com/AhmedakV2/Ederi-Ne-V2.git)
    ```
2.  **Bağımlılıkları Yükleyin:**
    ```bash
    flutter pub get
    ```
3.  **Firebase Yapılandırması:**
    Kendi `google-services.json` dosyanızı `android/app/` dizinine ekleyin.
4.  **Uygulamayı Çalıştırın:**
    ```bash
    flutter run
    ```

---

## 🤝 Katkıda Bulunma
Bu proje açık kaynaklı bir topluluk projesidir. Hata bildirimleri veya yeni özellik önerileri için bir "Issue" açabilir veya "Pull Request" gönderebilirsiniz.

**Geliştirici:** [AhmedakV2](https://github.com/AhmedakV2) 🚀
