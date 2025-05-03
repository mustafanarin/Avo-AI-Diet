import 'package:flutter/foundation.dart' show immutable;

@immutable
abstract final class ProjectStrings {
  // Welcome Page
  static const String welcomeTitle = 'Sağlıklı Yaşama Merhaba!';
  static const String welcomeDescription =
      'Ben Avo! Yapay zeka destekli beslenme koçun olarak, seni daha sağlıklı ve enerjik bir yaşama ulaştırmak için buradayım.';
  static const String welcomeButton = 'Hadi Başlayalım';

  // Name Input Page
  static const String nameInputTitle = 'Seni Tanıyalım!';
  static const String nameInputDescription = 'Sana daha iyi hizmet verebilmem için\nadını öğrenebilir miyim?';
  static const String nameInputButton = 'Devam Et';
  static const String nameInputHintText = 'Adını yazar mısın?';

  // User Info Page
  static const String userInfoAppbar = 'Kalori Hesaplayıcı';
  static const String continueButton = 'Devam et';
  static const String calculatButton = 'Hesapla';
  static const String personelInfoTitle = 'Kişisel Bilgiler';
  static const String activityLevel = 'Aktivite Seviyesi';
  static const String target = 'Hedef';
  static const String budget = 'Bütçe';
  static const String male = 'Erkek';
  static const String female = 'Kadın';
  static const String age = 'Yaş';
  static const String size = 'Boy (cm)';
  static const String weight = 'Kilo (kg)';
  static const String avoDietLoadingMessage = 'Senin için en uygun diyet planını hazırlıyorum :)';

  // Home Page
  static const String dietListTitle = 'Günlük Beslenme Planı';
  static const String hello = 'Merhaba';
  static const String myDietList = 'Diyet Listelerim';

  // Chat Page
  static const String askToAvo = "Avo'ya sor";
  static const String avoHowCanIHelpText =
      'Merhaba ben yapay zeka diyet asistanın Avo. Sana nasıl yardımcı olabilirim?';
  static const String writeMessage = 'Mesajınızı yazın';

  // Favorite Page
  static const String details = 'Detaylar';
  static const String close = 'Kapat';
  static const String myFavorites = 'Favorilerim';
  static const String noFavorite = 'Henüz favori mesajlarınız bulunmuyor';

  // Search Page
  static const String searchFood = 'Besin Ara';
  static const String enterFoodName = 'Besin adı girin...';
  static const String noResults = 'Sonuç bulunamadı';
  static const String noFood = 'Besin bulunamadı';
  static const String oneHundredGram = '100 gram';

  // Food Detail Page
  static const String foodDetail = 'Besin Detayı';
  static const String allCalori = 'Toplam Kalori';
  static const String foodValues = 'Besin Değerleri';
  static const String protein = 'Protein';
  static const String carbohydrate = 'Karbonhidrat';
  static const String oil = 'Yağ';

  // BottomNavBar
  static const String home = 'Ana Sayfa';
  static const String search = 'Arama';
  static const String favorites = 'Favoriler';
  static const String profile = 'Profil';

  // Profile Page
  static const String myProfile = 'Profilim';
  static const String helloProfile = 'Merhaba,';
  static const String profileSupTitle = 'Avo seninle beslenme yolculuğunda!';
  static const String waterReminder = 'Su Hatırlatıcı';
  static const String reminderSupTitle = 'Her gün 12:00 - 21:00 arasında su içme hatırlatmaları alın';
  static const String changeName = 'Adınızı Değiştirin';
  static const String changeNameSupTitle = 'Uygulama içindeki adınızı güncelleyin';
  static const String bodyInformation = 'Fiziksel Bilgileriniz';
  static const String bodyInformationSupTitle = 'Boy, kilo ve hedeflerinizi güncelleyin';
  static const String regionalFatBurning = 'Bölgesel Yağ Yakımı';
  static const String fatBurningSupTitle = 'Yapay zeka ile kişiselleştirilmiş tavsiyeler';

  // Name Edit Page
  static const String inputNewName = 'Yeni adını gir';
  static const String updateName = 'Adını Güncelle!';
  static const String updateNameDesc =
      'Uygulamada görünen adını değiştirmek ister misin? Yeni adını aşağıya yazabilirsin.';
  static const String saving = 'Kaydediliyor...';
  static const String save = 'Kaydet';
  static const String nameSuccessful = 'İsminiz başarıyla güncellendi!';

  // User Info Edit Page
  static const String succesUpdateDiet = 'Diyetin başarıyla güncellendi!';

  // Regional fat burning
  static const String adviceGetting = 'Tavsiye Alınıyor...';
  static const String adviceGot = 'Tavsiye Alındı';
  static const String adviceGet = 'Tavsiye Al';
  static const String advicesOfAvo = "Avo'nun Tavsiyeleri";
  static const String selectedRegion = 'Seçilen bölge: ';
  static const String noRegionSelected = 'Henüz bölge seçilmedi';
}
