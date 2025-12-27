# 🚀 Ederi Ne? - Akıllı Fiyat Takip & Doğrulama Platformu (v2.0.0 Stable)

[![Flutter Version](https://img.shields.io/badge/Flutter-3.x-blue.svg)](https://flutter.dev)
[![Platform](https://img.shields.io/badge/Platform-Android-green.svg)](https://android.com)
[![Version](https://img.shields.io/badge/Version-v2.0.0--Stable-orange.svg)](https://github.com/AhmedakV2/Ederi-Ne-V2/releases)
[![License](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

**Ederi Ne?**, enflasyonist ortamda tüketicinin en güçlü silahı olan "şeffaf bilgi paylaşımı" üzerine kurulu, topluluk odaklı bir fiyat takip ekosistemidir. Mahalle bakkalından zincir marketlere kadar her noktadaki güncel fiyatı, gerçek kullanıcı verileriyle cebinize getirir.

---

## 📝 Proje Vizyonu & Hakkında

Günümüzün dinamik ekonomik koşullarında tüketicinin en büyük ihtiyacı güncel ve şeffaf bilgiye ulaşmaktır. **Ederi Ne?**, geleneksel fiyat karşılaştırma sitelerinin aksine odağını sokağa, mahalle marketine ve yerel satıcılara çevirir. 

### 💡 Nasıl Değer Yaratır?
* **Kolektif Veri:** Kullanıcılar gördükleri fiyatları saniyeler içinde yükler, böylece "en ucuz" reklamla değil, gerçek saha verisiyle belirlenir.
* **Topluluk Denetimi:** Paylaşılan fiyatlar diğer kullanıcılar tarafından "Doğru" veya "Hatalı" olarak oylanır.
* **Güven Endeksi:** 5 ve üzeri şikayet alan ürünler otomatik olarak **"ŞÜPHELİ"** etiketiyle işaretlenerek yanıltıcı bilginin önüne geçilir.

---

## 📸 Uygulama Ekran Görüntüleri & Akışı

Uygulamanın v2.0.0 sürümüyle yenilenen modern arayüzü ve kullanıcı deneyimi (UX) akışı:

| Giriş Ekranı | Kayıt Ekranı | Ana Liste (v2) | Fiyat Ekleme | Profil & İstatistik |
|:---:|:---:|:---:|:---:|:---:|
| ![Griş](https://github.com/user-attachments/assets/e3054649-5f7c-46a5-b67d-83dfabeaf6e8)| ![Kayıt](https://github.com/user-attachments/assets/833ee792-55ad-471e-8e7d-fd30606162fe)
 | ![Fiyat_listesi](https://github.com/user-attachments/assets/e9cefe57-3a35-4caf-85bb-724b2cee9529)
 |![Fİyat_ekle](https://github.com/user-attachments/assets/5ed8866a-7725-46d8-8682-5a8312198eb0)
 | ![Profil](https://github.com/user-attachments/assets/f7234faf-38af-4392-89ec-a357bd638382) |

> *Not: Ekran görüntülerini aktif etmek için `screenshots/` klasörüne ilgili dosyaları (`login.png`, `register.png`, `home.png`, `add.png`, `profile.png`) yüklemeyi unutmayın.*

---

## 📥 Hemen Deneyin (v2.0.0 APK)

Uygulamanın en güncel ve kararlı sürümünü aşağıdaki butona tıklayarak doğrudan Android cihazınıza indirebilirsiniz:

[![Download APK](https://img.shields.io/badge/İndir-Ederi_Ne_v2.0.0_APK-brightgreen?style=for-the-badge&logo=android)](app-release.apk)

---

## 💎 v2.0.0 Sürümüyle Gelen Büyük Yenilikler

Bu güncelleme, projenin beta aşamasından tam kararlı sürüme geçişini temsil eder.

### 🔐 Gelişmiş Kimlik Doğrulama & Giriş
* **Ayrıcalıklı Auth Deneyimi:** Giriş ve Kayıt süreçleri, kullanıcı dostu doğrulamalar ve modern bir tasarımla birbirinden ayrıldı.
* **Avatar & Rol Sistemi:** Kayıt sırasında kullanıcıların kendilerini ifade edebileceği modern avatar seçimleri ve "Tüketici/Satıcı" rolleri eklendi.

### 📍 Gelişmiş Konum Hassasiyeti
* **Lokasyon Bazlı Kartlar:** Her ürün kartına entegre edilen **İl ve İlçe** bilgisi sayesinde, fiyatın nerede geçerli olduğu net bir şekilde görülmektedir.
* **Gelişmiş UX:** Konum göstergeleri ve market ikonları ile arayüz hiyerarşisi optimize edildi.

### 🔄 Akıllı Navigasyon & Senkronizasyon
* **Profil-Liste Entegrasyonu:** Kullanıcı profilindeki paylaşımlardan ana listedeki ilgili ürüne "akıllı odaklanma" ile geçiş özelliği sağlandı.
* **Hata Giderimi:** Açılıştaki `SplashScreen` donmaları ve `MainNavigation` üzerindeki `GlobalKey` çakışmaları tamamen çözüldü.

### 🏗️ Teknik Mimari İyileştirmeleri
* **Merkezi Veri Yönetimi:** `DataController` üzerinden yönetilen `allProductsList` yapısı ile veri yükleme hızı artırıldı.
* **Güvenlik:** Hassas Firebase anahtarları (`service-account.json`) koruma altına alındı ve `.gitignore` yapılandırması güncellendi.
* **Modern Dart:** Flutter 3.x uyumlu `withValues` renk yönetimi ve `const` constructor optimizasyonları yapıldı.

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
