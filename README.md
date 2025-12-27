# 🚀 Ederi Ne? - Akıllı Fiyat Takip Platformu (v2.0.0 Stable)

[![Flutter Version](https://img.shields.io/badge/Flutter-3.x-blue.svg)](https://flutter.dev)
[![Platform](https://img.shields.io/badge/Platform-Android-green.svg)](https://android.com)
[![Version](https://img.shields.io/badge/Version-v2.0.0--Stable-orange.svg)](https://github.com/AhmedakV2/Ederi-Ne-V2/releases)

**Ederi Ne?**, güncel market fiyatlarını topluluk gücüyle takip etmenizi sağlayan modern bir mobil platformdur. Enflasyonla mücadelede şeffaf fiyat bilgisini cebinize getirir.

---

## 📸 Uygulama Ekran Görüntüleri

| Ana Liste (v2) | Ürün Detay & Yorum | Fiyat Ekleme | Profil & İstatistik |
|:---:|:---:|:---:|:---:|
| <img src="screenshots/home.png" width="200"> | <img src="screenshots/comments.png" width="200"> | <img src="screenshots/add.png" width="200"> | <img src="screenshots/profile.png" width="200"> |

> *Not: Ekran görüntülerini görmek için `screenshots/` klasörüne ilgili dosyaları yüklemeyi unutmayın.*

---

## 📥 Uygulamayı Deneyin (APK)

Uygulamanın en güncel ve kararlı sürümünü (v2.0.0) aşağıdaki butona tıklayarak hemen indirebilirsiniz:

[![Download APK](https://img.shields.io/badge/İndir-Ederi_Ne_v2.0.0_APK-brightgreen?style=for-the-badge&logo=android)](app-release.apk)

---

## 💎 v2.0.0 Sürümüyle Gelen Büyük Yenilikler

Bu sürüm, uygulamanın beta sürecinden tam kapasite kararlı sürüme geçişini temsil eder.

### 📍 Gelişmiş Konum ve Detaylandırma
* **Lokasyon Odaklı Kartlar:** Her ürün kartına entegre edilen **İl ve İlçe** bilgisi sayesinde, fiyatın tam olarak nerede geçerli olduğunu saniyeler içinde anlayabilirsiniz.
* **Gelişmiş Kart Tasarımı:** Market ikonları ve konum göstergeleriyle daha modern bir UX yapısı kuruldu.

### 🔄 Akıllı Navigasyon ve Senkronizasyon
* **Profil-Liste Köprüsü:** Profil sayfanızdaki paylaşımlarınıza dokunduğunuzda, uygulama sizi ana listedeki ilgili ürüne otomatik olarak yönlendirir.
* **Hata Giderimi:** `SplashScreen` ve `MainNavigation` geçişlerinde yaşanan derleme hataları (const constructor sorunları) tamamen giderildi.

### 🏗️ Teknik Altyapı Fixleri
* **DataController:** `allProductsList` yapısı ile veri yükleme ve liste yenileme sorunları çözüldü.
* **Kod Modernizasyonu:** Flutter'ın en güncel `withValues` renk yönetimi ve `const` yapıları projeye uygulandı.

---

## 🛠️ Teknik Özellikler
* **Backend:** Firebase Firestore (Veri) & Firebase Auth (Giriş)
* **Mimari:** MVC (Model-View-Controller)
* **Güvenlik:** GitHub Push Protection & `.gitignore` ile korunan hassas anahtarlar.

---

## ⚙️ Geliştiriciler İçin Kurulum
1. Repoyu klonlayın: `git clone https://github.com/AhmedakV2/Ederi-Ne-V2.git`
2. Bağımlılıkları çekin: `flutter pub get`
3. Firebase dosyanızı ekleyin: `android/app/google-services.json`
4. Uygulamayı başlatın: `flutter run`

---

**Geliştirici:** [AhmedakV2](https://github.com/AhmedakV2) 🚀
