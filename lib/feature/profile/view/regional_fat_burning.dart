import 'package:avo_ai_diet/product/constants/project_colors.dart';
import 'package:avo_ai_diet/product/widgets/project_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:xml/xml.dart' as xml;

class BodySvgInteractivePage extends StatefulWidget {
  const BodySvgInteractivePage({super.key});

  @override
  State<BodySvgInteractivePage> createState() => _BodySvgInteractivePageState();
}

class _BodySvgInteractivePageState extends State<BodySvgInteractivePage> {
  final String _assetName = 'assets/semaadvance.svg';
  final Set<String> _selectedParts = {};

  // Eşleşen bölgeler (kollar ve bacaklar birlikte çalışması için)
  final Map<String, List<String>> _pairedRegions = {
    'kol_sol': ['kol_sag'],
    'kol_sag': ['kol_sol'],
    'bacak_sol': ['bacak_sag'],
    'bacak_sag': ['bacak_sol'],
  };

  // Bölge ID'lerinin görünen isimleri
  final Map<String, String> _regionNames = {
    'yuz': 'Yüz',
    'gogus': 'Göğüs',
    'karin': 'Karın',
    'kalca': 'Kalça',
    'kol_sol': 'Kollar',
    'kol_sag': 'Kollar',
    'bacak_sol': 'Bacaklar',
    'bacak_sag': 'Bacaklar',
  };

  // Renk eşlemesi
  final Map<String, Color> _originalColors = {};

  // SVG verisi
  String? _modifiedSvgString;
  String? _originalSvgString;

  // İşlenmiş mi?
  bool _isProcessed = false;

  @override
  void initState() {
    super.initState();
    _loadSvgAsset();
  }

  Future<void> _loadSvgAsset() async {
    try {
      final svgString = await DefaultAssetBundle.of(context).loadString(_assetName);
      print('SVG dosyası başarıyla yüklendi. Boyut: ${svgString.length}');

      // SVG içeriğini kontrol edelim
      final document = xml.XmlDocument.parse(svgString);

      // Tüm elementlerin dolgu rengini ayarlayalım
      final paths = document.findAllElements('path');
      for (final path in paths) {
        // ID'si var mı kontrol et
        final id = path.getAttribute('id');
        if (id == null) continue;

        // Ekran görüntüsündeki gibi varsayılan renkleri ayarla
        if (['kol_sol', 'kol_sag', 'gogus', 'karin', 'kalca', 'bacak_sag', 'bacak_sol', 'yuz', 'vucut'].contains(id)) {
          path.setAttribute('fill', 'black');
          path.setAttribute('stroke', 'white');
          path.setAttribute('stroke-width', '0.5');
        }
      }

      final elements = document
          .findAllElements('*')
          .where(
            (element) => element.getAttribute('id') != null,
          )
          .toList();

      print("SVG'de ${elements.length} id'li element bulundu:");
      for (final element in elements) {
        final id = element.getAttribute('id');
        print('ID: $id, Etiket: ${element.name.local}');
      }

      // Bulunmayan ID'leri belirleyelim
      final expectedIds = [
        'vucut',
        'kol_sol',
        'kol_sag',
        'gogus',
        'karin',
        'kalca',
        'bacak_sag',
        'bacak_sol',
        'yuz',
      ];

      final foundIds = elements.map((e) => e.getAttribute('id')).toSet();
      final missingIds = expectedIds.where((id) => !foundIds.contains(id)).toList();

      if (missingIds.isNotEmpty) {
        print("DİKKAT: Beklenen ancak bulunamayan ID'ler: ${missingIds.join(', ')}");

        // Eksik ID'leri SVG'ye ekleyelim
        if (missingIds.contains('vucut')) {
          final root = document.rootElement;
          final body = xml.XmlElement(
            xml.XmlName('path'),
            [
              xml.XmlAttribute(xml.XmlName('id'), 'vucut'),
              xml.XmlAttribute(xml.XmlName('d'), 'M50,50 L150,50 L150,350 L50,350 Z'),
              xml.XmlAttribute(xml.XmlName('fill'), 'black'),
              xml.XmlAttribute(xml.XmlName('stroke'), 'white'),
              xml.XmlAttribute(xml.XmlName('stroke-width'), '0.5'),
              xml.XmlAttribute(xml.XmlName('style'), 'opacity:0.1'),
            ],
            [],
          );
          root.children.insert(0, body); // En alta ekle
          print("Eksik vucut ID'si eklendi");
        }

        // Diğer eksik ID'ler için de benzer işlemler yapılabilir
        for (final missingId in missingIds) {
          if (missingId == 'vucut') continue; // Zaten ekledik

          // Eksik bölge için varsayılan path oluştur
          var pathData = '';
          switch (missingId) {
            case 'kol_sol':
              pathData = 'M50,100 L30,200 L40,200 L60,100 Z';
            case 'kol_sag':
              pathData = 'M150,100 L170,200 L160,200 L140,100 Z';
            case 'gogus':
              pathData = 'M70,100 L130,100 L130,140 L70,140 Z';
            case 'karin':
              pathData = 'M70,150 L130,150 L130,200 L70,200 Z';
            case 'kalca':
              pathData = 'M70,210 L130,210 L130,250 L70,250 Z';
            case 'bacak_sol':
              pathData = 'M70,260 L100,260 L100,350 L70,350 Z';
            case 'bacak_sag':
              pathData = 'M100,260 L130,260 L130,350 L100,350 Z';
            case 'yuz':
              pathData = 'M85,30 L115,30 Q130,50 115,70 Q100,80 85,70 Q70,50 85,30 Z';
            default:
              break;
          }

          if (pathData.isNotEmpty) {
            final element = xml.XmlElement(
              xml.XmlName('path'),
              [
                xml.XmlAttribute(xml.XmlName('id'), missingId),
                xml.XmlAttribute(xml.XmlName('d'), pathData),
                xml.XmlAttribute(xml.XmlName('fill'), 'black'),
                xml.XmlAttribute(xml.XmlName('stroke'), 'white'),
                xml.XmlAttribute(xml.XmlName('stroke-width'), '0.5'),
              ],
              [],
            );
            document.rootElement.children.add(element);
            print("Eksik $missingId ID'si eklendi");
          }
        }
      }

      setState(() {
        _originalSvgString = document.toXmlString(); // Güncellenmiş SVG
        _modifiedSvgString = _originalSvgString;
        _processOriginalSvg(_originalSvgString!);
        _isProcessed = true;
      });
    } catch (e) {
      print('SVG yüklenirken hata: $e');
      print('Hata detayı: $e');

      // Hata durumunda basit bir SVG oluşturalım - ekran görüntüsüne benzer
      const simpleSvg = '''
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 200 500">
  <path id="vucut" d="M70,50 L130,50 L130,400 L70,400 Z" fill="black" stroke="white" stroke-width="0.5" />
  <path id="yuz" d="M85,30 L115,30 Q130,50 115,70 Q100,80 85,70 Q70,50 85,30 Z" fill="black" stroke="white" stroke-width="0.5" />
  <path id="gogus" d="M80,80 L120,80 L120,130 L80,130 Z" fill="black" stroke="white" stroke-width="0.5" />
  <path id="karin" d="M80,140 L120,140 L120,200 L80,200 Z" fill="black" stroke="white" stroke-width="0.5" />
  <path id="kalca" d="M80,210 L120,210 L120,250 L80,250 Z" fill="black" stroke="white" stroke-width="0.5" />
  <path id="kol_sol" d="M50,90 L70,90 L70,180 L50,180 Z" fill="black" stroke="white" stroke-width="0.5" />
  <path id="kol_sag" d="M130,90 L150,90 L150,180 L130,180 Z" fill="black" stroke="white" stroke-width="0.5" />
  <path id="bacak_sol" d="M80,260 L100,260 L100,400 L80,400 Z" fill="black" stroke="white" stroke-width="0.5" />
  <path id="bacak_sag" d="M100,260 L120,260 L120,400 L100,400 Z" fill="black" stroke="white" stroke-width="0.5" />
</svg>
      ''';

      setState(() {
        _originalSvgString = simpleSvg;
        _modifiedSvgString = simpleSvg;
        _processOriginalSvg(simpleSvg);
        _isProcessed = true;
      });

      print('SVG yüklenemedi, basit yedek SVG kullanılıyor');
    }
  }

  void _processOriginalSvg(String svgString) {
    try {
      final document = xml.XmlDocument.parse(svgString);

      // Tüm ID'leri olan elementleri bul ve orijinal renklerini kaydet
      final idElements = document.findAllElements('*').where(
            (element) =>
                element.getAttribute('id') != null &&
                [
                  'vucut',
                  'kol_sol',
                  'kol_sag',
                  'gogus',
                  'karin',
                  'kalca',
                  'bacak_sag',
                  'bacak_sol',
                  'yuz',
                ].contains(element.getAttribute('id')),
          );

      for (final element in idElements) {
        final id = element.getAttribute('id');
        if (id != null) {
          // SVG'de fill özelliği olup olmadığını kontrol et
          final fill = element.getAttribute('fill');
          if (fill != null) {
            _originalColors[id] = _parseColor(fill);
          } else {
            // Varsayılan dolgu rengi (stroke rengine bak veya varsayılan siyah kullan)
            final stroke = element.getAttribute('stroke');
            _originalColors[id] = stroke != null ? _parseColor(stroke) : Colors.black;
          }
        }
      }
    } catch (e) {
      print('SVG işlenirken hata: $e');
    }
  }

  Color _parseColor(String colorStr) {
    // HEX renk kodlarını işle
    if (colorStr.startsWith('#')) {
      final hex = colorStr.replaceFirst('#', '');
      if (hex.length == 6) {
        return Color(int.parse('0xFF$hex'));
      } else if (hex.length == 3) {
        // Kısa HEX formatı (örn: #FFF)
        final r = hex.substring(0, 1);
        final g = hex.substring(1, 2);
        final b = hex.substring(2, 3);
        return Color(int.parse('0xFF$r$r$g$g$b$b'));
      }
    }

    // İsimlendirilmiş renkler
    switch (colorStr.toLowerCase()) {
      case 'black':
        return Colors.black;
      case 'white':
        return Colors.white;
      case 'red':
        return Colors.red;
      case 'green':
        return Colors.green;
      case 'blue':
        return Colors.blue;
      // Diğer renkleri buraya ekleyebilirsiniz
      default:
        return Colors.black;
    }
  }

  void _toggleBodyPart(String partId) {
    setState(() {
      // Eğer kollar veya bacaklarsa, her ikisini birden işle
      final partsToToggle = <String>[partId];

      // Eşleşen bölgeleri ekleyelim
      if (_pairedRegions.containsKey(partId)) {
        partsToToggle.addAll(_pairedRegions[partId]!);
      }

      // Tüm ilgili parçaları işleyelim
      for (final part in partsToToggle) {
        if (_selectedParts.contains(part)) {
          _selectedParts.remove(part);
        } else {
          _selectedParts.add(part);
        }
      }

      _updateSvgColors();
    });
  }

  void _updateSvgColors() {
    if (_originalSvgString == null) return;

    try {
      final document = xml.XmlDocument.parse(_originalSvgString!);

      // Debug bilgisi
      print('Seçili bölgeler: $_selectedParts');

      // Tüm bölgeleri döngüye al
      for (final partId in [
        'vucut',
        'kol_sol',
        'kol_sag',
        'gogus',
        'karin',
        'kalca',
        'bacak_sag',
        'bacak_sol',
        'yuz',
      ]) {
        // İlgili ID'ye sahip elementleri bul
        final elements = document.findAllElements('*').where(
              (element) => element.getAttribute('id') == partId,
            );

        // Kaç element bulundu debug bilgisi
        print('$partId için ${elements.length} element bulundu');

        for (final element in elements) {
          // Seçiliyse yeşil, değilse orijinal rengine geri döndür
          if (_selectedParts.contains(partId)) {
            // SVG path'ın fill özelliğini güncelleyelim
            element.setAttribute('fill', '#00FF00'); // Yeşil
            element.setAttribute('fill-opacity', '0.5'); // Yarı saydam
            element.setAttribute('stroke', '#008800'); // Koyu yeşil kontur
            element.setAttribute('stroke-width', '1'); // Kontur kalınlığı

            print('$partId yeşile boyandı');
          } else {
            // Eğer orijinal renk yoksa, varsayılan olarak 'none' veya siyah kullan
            final originalColor = _originalColors[partId];
            if (originalColor != null) {
              final hexColor = '#${originalColor.value.toRadixString(16).substring(2)}';
              element.setAttribute('fill', hexColor);
            } else {
              // Siyah dolgu, ekran görüntüsündeki gibi
              element.setAttribute('fill', 'black');
              element.setAttribute('stroke', 'white');
              element.setAttribute('stroke-width', '0.5');
            }
            element.removeAttribute('fill-opacity');

            print('$partId orijinal renge döndürüldü');
          }
        }
      }

      // Güncellenmiş SVG stringini kaydet
      _modifiedSvgString = document.toXmlString();
    } catch (e) {
      print('SVG güncellenirken hata: $e');
    }
  }

  // Seçili bölgelerin isimlerini liste olarak getir
  List<String> _getSelectedRegionNames() {
    final regionNames = <String>{};

    for (final partId in _selectedParts) {
      final name = _regionNames[partId];
      if (name != null) {
        regionNames.add(name);
      }
    }

    return regionNames.toList();
  }

  // Tavsiye Al butonuna basıldığında çağrılacak fonksiyon
  void _getAdvice() {
    // Burada Gemini API'ye yönlendirme yapılacak
    print('Tavsiye alınacak bölgeler: ${_getSelectedRegionNames().join(", ")}');

    // Backend bağlantısı burada yapılacak
    // Bu kısmı sen backend'i bağlarken tamamlayacaksın
  }

  @override
  Widget build(BuildContext context) {
    // Seçili bölgelerin isimlerini al
    final selectedRegionNames = _getSelectedRegionNames();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bölgesel Yağ Yakımı'),
        backgroundColor: ProjectColors.backgroundCream,
      ),
      backgroundColor: ProjectColors.backgroundCream,
      body: Column(
        children: [
          Expanded(
            flex: 5,
            child: _isProcessed && _modifiedSvgString != null
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: InteractiveSvgBody(
                        svgString: _modifiedSvgString!,
                        onTapRegion: _toggleBodyPart,
                      ),
                    ),
                  )
                : const Center(child: CircularProgressIndicator()),
          ),
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: ProjectColors.backgroundCream,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Seçilen bölgeler yazısı
                  Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: const Color(0xFF806040),
                        ),
                        children: [
                          const TextSpan(
                            text: 'Seçilen bölge: ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text:
                                selectedRegionNames.isEmpty ? 'Henüz bölge seçilmedi' : selectedRegionNames.join(', '),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Tavsiye Al butonu
                  ProjectButton(
                    text: 'Tavsiye Al',
                    onPressed: _getAdvice,
                    isEnabled: selectedRegionNames.isNotEmpty,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class InteractiveSvgBody extends StatelessWidget {
  InteractiveSvgBody({
    required this.svgString,
    required this.onTapRegion,
    super.key,
  });
  final String svgString;
  final Function(String) onTapRegion;

  // Bölgelerin merkez noktaları (göreceli koordinatlar, 0-1 arası)
  final Map<String, Offset> _regionCenters = {
    'yuz': const Offset(0.5, 0.075),
    'gogus': const Offset(0.5, 0.23),
    'karin': const Offset(0.5, 0.36),
    'kalca': const Offset(0.5, 0.48),
    'kol_sol': const Offset(0.33, 0.35),
    'kol_sag': const Offset(0.67, 0.35),
    'bacak_sol': const Offset(0.4, 0.75),
    'bacak_sag': const Offset(0.6, 0.75),
  };

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // SVG boyutunu artırmak için genişlik ve yüksekliği belirliyoruz
        final maxWidth = constraints.maxWidth * 0.95;
        final maxHeight = constraints.maxHeight * 0.95;

        return Stack(
          alignment: Alignment.center,
          children: [
            // SVG görseli - Boyutu büyütülmüş
            SizedBox(
              width: maxWidth,
              height: maxHeight,
              child: SvgPicture.string(
                svgString,
              ),
            ),

            // Tıklanabilir hedef noktalar
            ...buildTargetPoints(maxWidth, maxHeight),
          ],
        );
      },
    );
  }

  List<Widget> buildTargetPoints(double width, double height) {
    return _regionCenters.entries.map((entry) {
      return buildTargetPoint(entry.key, entry.value, width, height);
    }).toList();
  }

  Widget buildTargetPoint(String regionId, Offset center, double width, double height) {
    // ScreenUtil ile çalışacak şekilde boyutları ayarlayalım
    final pointSize = 28.w; // ScreenUtil ile genişlik bazlı responsive
    final innerPointSize = 6.w;
    final borderWidth = 1.5.w;
    final blurRadius = 6.w;
    final spreadRadius = 1.w;

    return Positioned(
      left: center.dx * width - (pointSize / 2),
      top: center.dy * height - (pointSize / 2),
      child: GestureDetector(
        onTap: () => onTapRegion(regionId),
        behavior: HitTestBehavior.translucent, // Tıklama alanını arttırır
        child: Container(
          width: pointSize,
          height: pointSize,
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.3),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.green.shade600, width: borderWidth),
            boxShadow: [
              BoxShadow(
                color: Colors.green.withOpacity(0.4),
                blurRadius: blurRadius,
                spreadRadius: spreadRadius,
              ),
            ],
          ),
          child: Center(
            child: Container(
              width: innerPointSize,
              height: innerPointSize,
              decoration: const BoxDecoration(
                color: Colors.blue, // Mavi nokta daha görünür
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
