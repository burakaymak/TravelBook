# 🗺️ Travel Book

📱 **Travel Book**, kullanıcıların harita üzerinde seçtikleri konumları işaretleyip kaydedebildiği bir iOS uygulamasıdır.  
Kaydedilen konumlar **Core Data** ile saklanır ve uygulamanın ilk ekranında listelenir.  
Liste üzerinden seçilen kayıt detay sayfasında harita üzerinde görüntülenebilir.  

---

## ✨ Özellikler
- 📋 Kayıtlı tüm yerleri **TableView** üzerinden listeleme  
- ➕ Navigation bar’daki **Add** butonu ile yeni konum ekleme  
- 🗑 Kaydı sola kaydırarak **silme** (Core Data’dan da silinir)  
- 🗺 Uzun basarak haritada istediğiniz yere **pin ekleme**  
- 💾 Pin’e isim ve yorum ekleyerek **Core Data** ile kalıcı olarak kaydetme  
- 🔄 `NotificationCenter` kullanılarak yeni eklenen yerlerin listeye otomatik yansıması  
- 📍 Seçilen konuma tıklayınca **Apple Maps üzerinden yol tarifi açma**  

---

## 📖 Uygulama Akışı
1. **ListViewController**
   - TableView içinde kayıtlı yerlerin isimleri listelenir.  
   - ➕ butonuna tıklanarak yeni yer ekleme ekranına gidilir.  
   - Silme işlemleri **Core Data** üzerinden yapılır.  
   - Bir yer seçildiğinde detay ekranına (`ViewController`) segue ile gidilir.  

2. **ViewController**
   - Harita üzerinde uzun basarak konum işaretlenir.  
   - İsim ve yorum girildikten sonra **Save** butonu ile kayıt eklenir.  
   - Var olan kayıt açıldığında:
     - Haritada pin gösterilir.  
     - İsim ve yorum alanları doldurulur.  
     - Sağ üstteki **kaydetme butonu gizlenir**.  
   - Pin detayına tıklandığında Apple Maps açılarak yol tarifi alınabilir.  

---

## 🛠 Kullanılan Yapılar
- **UIKit** → UI bileşenleri (TableView, Navigation Bar, TextField)  
- **MapKit** → Harita üzerinde pin ekleme ve konum görüntüleme  
- **CoreLocation** → Kullanıcının mevcut konumunu almak  
- **Core Data** → Konum bilgilerini (isim, yorum, enlem, boylam, id) saklamak  
- **NotificationCenter** → Yeni kayıt sonrası listeyi güncellemek için bildirim kullanımı  
- **Segue** → Liste ekranından detay ekranına geçiş  

---

## 📂 Veri Modeli (Core Data - `Places`)
- `title` → String (Yer ismi)  
- `subtitle` → String (Yorum / açıklama)  
- `latitude` → Double (Enlem)  
- `longitude` → Double (Boylam)  
- `id` → UUID (Benzersiz kayıt anahtarı)  

---

## 🚀 Çalışma Mantığı
- Uygulama açıldığında `ListViewController`, Core Data’dan verileri çeker ve TableView’de listeler.  
- Yeni bir yer eklemek için ➕ butonuna tıklanır, haritada uzun basarak pin bırakılır.  
- Kaydedilen veriler `NotificationCenter` sayesinde listeye otomatik olarak yansır.  
- Listeden seçilen kayıt detay ekranında harita üzerinde gösterilir ve yol tarifi alınabilir.  

---

## 🔧 Uygulamada Kullanılanlar
- **Core Data** ile verileri kalıcı olarak saklandı 
- **MapKit** ve **CoreLocation** kullanarak konum tabanlı özellikler geliştirildi
- **NotificationCenter** ile ekranlar arası veri senkronizasyonu sağlandı
- **Segue** kullanarak ViewController’lar arası veri geçişini uygulandı
- **TableView** üzerinde CRUD işlemlerini (Create, Read, Delete) gerçekleştirildi

