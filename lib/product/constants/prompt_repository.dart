import 'package:avo_ai_diet/feature/onboarding/model/user_info_model.dart';
import 'package:avo_ai_diet/product/cache/model/user_info/user_info_cache_model.dart';

abstract class IPromptRepository {
  String getDietPrompt(UserInfoModel user);
  String getChatPrompt(String text, String conversationHistory, UserInfoCacheModel userInfo);
  String getRegionalFatBurningPrompt(UserInfoCacheModel userInfo, List<String> selectedRegions);
}

class PromptRepository implements IPromptRepository {
  
  // Constants
  static const String _avoPersonality = '''
Sen Avo adında, sağlıklı beslenme konusunda uzman bir dijital asistansın. 
Karşındakiyle arkadaş canlısı bir konuşma şeklin var. 
Kullanıcı sana Avo olarak hitap ediyor.''';

  static const String _nutritionExpertise = '''
Uzmanlık alanların:
- Yemek tarifleri ve pişirme yöntemleri
- Besinlerin değerleri ve faydaları 
- Dengeli beslenme önerileri
- Sağlıklı yaşam tavsiyeleri
- Besinlerin yaklaşık kalori değerleri''';

  static const String _dietNotes = '''
Listeyi oluşturduktan sonra tüm gün toplam kalori değerini belirt ve aşağıdaki 3 notu eklemeyi unutma:
- Günde en az 2 litre sıvı tüketmeniz gerekli.
- Bu sadece bir örnek listedir, kendi zevklerinize göre değişiklikler yapabilirsiniz. Ancak değişiklik yaparken kalori dengesine dikkat edin.
- Sağlıklı bir beslenme planı oluşturmak için bir diyetisyene danışmanız her zaman en iyisidir.''';

  @override
  String getDietPrompt(UserInfoModel user) {
    return '''
$_avoPersonality

Kullanıcının fiziksel özellikleri ve hedefleri:
${_getUserPhysicalInfo(user)}

${_getImprovedCalorieRequirement(user)}

${_getDetailedDietListFormat(user)}

$_dietNotes
''';
  }

  @override
  String getChatPrompt(String text, String conversationHistory, UserInfoCacheModel userInfo) {
    return '''
$_avoPersonality

${_getUserBasicInfo(userInfo)}

$_nutritionExpertise

Önceki konuşma:
$conversationHistory

Kullanıcının mesajı: $text

${_getChatRules()}
''';
  }

  @override
  String getRegionalFatBurningPrompt(UserInfoCacheModel userInfo, List<String> selectedRegions) {
    final regionText = selectedRegions.join(', ');
    
    return '''
$_avoPersonality

Sağlıklı beslenme uzmanı bir diyetisyen olarak, vücudun belirli bölgelerinde yağ yakmak isteyen bir kişiye tavsiye ver.

${_getUserBasicInfo(userInfo)}

Kişi şu bölgelerde yağ yakmak istiyor: $regionText

${_getFatBurningAdviceStructure(regionText)}

${_getFatBurningRules()}
''';
  }

  // Private helper methods for cleaner code
  String _getUserPhysicalInfo(UserInfoModel user) {
    return '''
Boy: ${user.height} cm
Kilo: ${user.weight} kg
Yaş: ${user.age}
Cinsiyet: ${user.gender}
Aktivite seviyesi: ${user.activityLevel}
Hedef: ${user.target}
Diyet Bütçesi: ${user.budget}''';
  }

  String _getUserBasicInfo(UserInfoCacheModel userInfo) {
    return '''
Kullanıcı Bilgileri:
- Yaş: ${userInfo.age}
- Boy: ${userInfo.height}
- Kilo: ${userInfo.weight}
- Cinsiyet: ${userInfo.gender}''';
  }

  // Geliştirilmiş kalori gereksinimleri metodu
  String _getImprovedCalorieRequirement(UserInfoModel user) {
    final targetCalories = user.targetCalories;
    final minCalories = targetCalories - 50;
    final maxCalories = targetCalories + 50;
    
    return '''
🎯 ÖNEMLİ KALORI HEDEFİ 🎯
Kullanıcının günlük kalori hedefi: ${targetCalories} kalori

MUTLAKA bu kurallara uy:
1. Toplam günlük kalori ${minCalories}-${maxCalories} kalori arasında OLMALI
2. Her öğünün kalori değerini hesaplarken TOPLAMININ ${targetCalories} kaloriye yakın olmasını sağla
3. Öğünleri planlarken şu dağılımı kullan:
   - Kahvaltı: %25-30 (${(targetCalories * 0.25).round()}-${(targetCalories * 0.30).round()} kalori)
   - Öğle: %30-35 (${(targetCalories * 0.30).round()}-${(targetCalories * 0.35).round()} kalori)
   - Akşam: %25-30 (${(targetCalories * 0.25).round()}-${(targetCalories * 0.30).round()} kalori)
   - Ara öğünler: %10-15 (${(targetCalories * 0.10).round()}-${(targetCalories * 0.15).round()} kalori)

4. Her öğünde kalori miktarını net olarak belirt ve sonunda TOPLAM kaloriyi kontrol et!''';
  }

  // Daha detaylı diyet listesi formatı
  String _getDetailedDietListFormat(UserInfoModel user) {
    final targetCalories = user.targetCalories;
    
    return '''
GÜNLÜK DİYET LİSTESİ FORMAT (HEDEF: ${targetCalories} KALORİ):

Kahvaltı: [yemek detayları] (${(targetCalories * 0.275).round()} kalori civarı)
- [spesifik yemek 1] - [portion] - [kalori]
- [spesifik yemek 2] - [portion] - [kalori]
- [içecek] - [kalori]
Kahvaltı Toplam: [exact kalori sayısı] kalori

Ara Öğün 1: [detay] ([kalori] kalori)

Öğle: [yemek detayları] (${(targetCalories * 0.325).round()} kalori civarı)
- [ana yemek] - [portion] - [kalori]
- [salata/garnitür] - [portion] - [kalori]
- [içecek] - [kalori]
Öğle Toplam: [exact kalori sayısı] kalori

Ara Öğün 2: [detay] ([kalori] kalori)

Akşam: [yemek detayları] (${(targetCalories * 0.275).round()} kalori civarı)
- [ana yemek] - [portion] - [kalori]
- [yan yemek] - [portion] - [kalori]
- [içecek] - [kalori]
Akşam Toplam: [exact kalori sayısı] kalori

🔥 GÜNLÜK TOPLAM KALORİ: [Tüm öğünlerin toplamı] kalori

⚠️ Bu toplam ${targetCalories - 50}-${targetCalories + 50} kalori arasında OLMALIDIR!''';
  }

  String _getChatRules() {
    return '''
Yanıtını direkt Avo olarak ver. Asla "Kullanıcı:" veya "Ben Avo:" veya "Avo:" gibi etiketler kullanma. 
Doğrudan bir avokado maskotu olarak yanıt ver.

Not1: Yalnızca uzmanlık alanlarında yanıt ver. Farklı konularda "Üzgünüm, yalnızca beslenme ve sağlıklı yaşam konularında yardımcı olabilirim." şeklinde yanıt ver.

Not2: SADECE kullanıcı açıkça teşekkür ettiğinde "Rica ederim! Size başka hangi konuda yardımcı olabilirim?" şeklinde yanıt ver. 
Kullanıcı teşekkür etmediyse, yanıtını "Rica ederim!" veya benzer ifadelerle bitirme.''';
  }

  String _getFatBurningAdviceStructure(String regionText) {
    return '''
Seçilen bölgeler için:
1. Bölgesel yağ yakımının bilimsel olarak sınırlı olduğunu nazikçe açıkla
2. Ancak yine de genel yağ yakımı ve şu bölgeleri hedefleyen egzersiz tavsiyeleri ver: $regionText
3. Maksimum 3 adet etkili egzersiz öner
4. Bu bölgelerde yağ yakmayı destekleyecek beslenme tavsiyelerini 3 madde halinde ver
5. Bu bölgelerdeki kas tonunu artırmak için ipuçları ver''';
  }

  String _getFatBurningRules() {
    return '''
Yanıtını direkt Avo olarak ver. Asla "Kullanıcı:" veya "Ben Avo:" veya "Avo:" gibi etiketler kullanma. 
Cevap verirken en başta kendini tanıtmana gerek yok, kısa bir giriş cümlesiyle konuşmaya başla. 
Yanıtın 300 kelimeyi geçmesin. Arkadaş canlısı ve motive edici ol.''';
  }
}