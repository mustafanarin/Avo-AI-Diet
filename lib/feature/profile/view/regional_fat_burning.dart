import 'package:avo_ai_diet/feature/onboarding/cubit/user_info_cache_cubit.dart';
import 'package:avo_ai_diet/feature/profile/cubit/regional_fat_burning_cubit.dart';
import 'package:avo_ai_diet/feature/profile/state/regional_fat_burning_state.dart';
import 'package:avo_ai_diet/product/constants/project_colors.dart';
import 'package:avo_ai_diet/product/widgets/project_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:xml/xml.dart' as xml;

class RegionalFatBurning extends StatefulWidget {
  const RegionalFatBurning({super.key});

  @override
  State<RegionalFatBurning> createState() => _RegionalFatBurningState();
}

class _RegionalFatBurningState extends State<RegionalFatBurning> {
  // ScrollController ekliyoruz
  final ScrollController _scrollController = ScrollController();
  
  // Kullanıcı cinsiyeti
  late String _userGender;

  // Cinsiyet bazlı SVG dosyaları
  late String _assetName;

  final Set<String> _selectedParts = {};

  // Eşleşen bölgeler (kollar ve bacaklar birlikte çalışması için)
  final Map<String, List<String>> _pairedRegions = {
    'arm_left': ['arm_right'],
    'arm_right': ['arm_left'],
    'leg_left': ['leg_right'],
    'leg_right': ['leg_left'],
  };

  // Bölge ID'lerinin görünen isimleri
  final Map<String, String> _regionNames = {
    'face': 'Yüz',
    'chest': 'Göğüs',
    'belly': 'Karın',
    'hip': 'Kalça',
    'arm_left': 'Kollar',
    'arm_right': 'Kollar',
    'leg_left': 'Bacaklar',
    'leg_right': 'Bacaklar',
  };

  // SVG verisi
  String? _modifiedSvgString;
  String? _originalSvgString;

  // Beklenen ID'ler
  final List<String> _expectedIds = [
    'arm_left',
    'arm_right',
    'chest',
    'belly',
    'hip',
    'leg_right',
    'leg_left',
    'face',
  ];

  // İşlenmiş mi?
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // Varsayılan değer
    _userGender = 'Erkek';
    _assetName = 'assets/svg/manDiagram.svg';
    
    // Cinsiyet bazlı SVG dosyasını belirle
    _loadUserData();
  }
  
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    try {
      // Cinsiyet bilgisini asenkron olarak yükle
      final gender = await context.read<UserInfoCacheCubit>().getUserGender();

      // State'i güncelle
      setState(() {
        _userGender = gender;
        _assetName = _userGender == 'Erkek' ? 'assets/svg/manDiagram.svg' : 'assets/svg/womanDiagram.svg';
      });

      // SVG'yi yükle
      await _loadSvgAsset();
    } catch (e) {
      setState(() {
        _userGender = 'Erkek';
        _assetName = 'assets/svg/manDiagram.svg';
      });
      await _loadSvgAsset();
    }
  }

  Future<void> _loadSvgAsset() async {
    try {
      final svgString = await DefaultAssetBundle.of(context).loadString(_assetName);
      final processedSvg = _processSvg(svgString);

      setState(() {
        _originalSvgString = processedSvg;
        _modifiedSvgString = processedSvg;
        _isLoading = false;
      });
    } catch (e) {
      // Hata durumunda yedek SVG kullan
      final fallbackSvg = _createFallbackSvg();

      setState(() {
        _originalSvgString = fallbackSvg;
        _modifiedSvgString = fallbackSvg;
        _isLoading = false;
      });
    }
  }

  String _processSvg(String svgString) {
    final document = xml.XmlDocument.parse(svgString);
    _setDefaultPathStyles(document);
    _checkAndFixMissingElements(document);
    return document.toXmlString();
  }

  void _setDefaultPathStyles(xml.XmlDocument document) {
    for (final id in _expectedIds) {
      final elements = document.findAllElements('*').where((element) => element.getAttribute('id') == id);

      for (final element in elements) {
        element.setAttribute('fill', 'transparent');
        element.setAttribute('stroke', 'black');
        element.setAttribute('stroke-width', '0.8');
        element.setAttribute('stroke-dasharray', '3,2'); // Kesikli çizgi ekle
      }
    }
  }

  void _checkAndFixMissingElements(xml.XmlDocument document) {
    final foundIds = document
        .findAllElements('*')
        .where((element) => element.getAttribute('id') != null)
        .map((element) => element.getAttribute('id'))
        .toSet();

    final missingIds = _expectedIds.where((id) => !foundIds.contains(id));

    for (final missingId in missingIds) {
      final pathData = _getDefaultPathForId(missingId);
      if (pathData.isNotEmpty) {
        final element = xml.XmlElement(
          xml.XmlName('path'),
          [
            xml.XmlAttribute(xml.XmlName('id'), missingId),
            xml.XmlAttribute(xml.XmlName('d'), pathData),
            xml.XmlAttribute(xml.XmlName('fill'), 'transparent'),
            xml.XmlAttribute(xml.XmlName('stroke'), 'white'),
            xml.XmlAttribute(xml.XmlName('stroke-width'), '0.5'),
          ],
          [],
        );
        document.rootElement.children.add(element);
      }
    }
  }

  String _getDefaultPathForId(String id) {
    switch (id) {
      case 'arm_left':
        return 'M50,100 L30,200 L40,200 L60,100 Z';
      case 'arm_right':
        return 'M150,100 L170,200 L160,200 L140,100 Z';
      case 'chest':
        return 'M70,100 L130,100 L130,140 L70,140 Z';
      case 'belly':
        return 'M70,150 L130,150 L130,200 L70,200 Z';
      case 'hip':
        return 'M70,210 L130,210 L130,250 L70,250 Z';
      case 'leg_left':
        return 'M70,260 L100,260 L100,350 L70,350 Z';
      case 'leg_right':
        return 'M100,260 L130,260 L130,350 L100,350 Z';
      case 'face':
        return 'M85,30 L115,30 Q130,50 115,70 Q100,80 85,70 Q70,50 85,30 Z';
      default:
        return '';
    }
  }

  String _createFallbackSvg() {
    return _userGender == 'Erkek'
        ? '''
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 200 500">
  <path id="face" d="M85,30 L115,30 Q130,50 115,70 Q100,80 85,70 Q70,50 85,30 Z" fill="transparent" stroke="black" stroke-width="1.5" stroke-dasharray="3,2" />
  <path id="chest" d="M80,80 L120,80 L120,130 L80,130 Z" fill="transparent" stroke="black" stroke-width="1.5" stroke-dasharray="3,2" />
  <path id="belly" d="M80,140 L120,140 L120,200 L80,200 Z" fill="transparent" stroke="black" stroke-width="1.5" stroke-dasharray="3,2" />
  <path id="hip" d="M80,210 L120,210 L120,250 L80,250 Z" fill="transparent" stroke="black" stroke-width="1.5" stroke-dasharray="3,2" />
  <path id="arm_left" d="M50,90 L70,90 L70,180 L50,180 Z" fill="transparent" stroke="black" stroke-width="1.5" stroke-dasharray="3,2" />
  <path id="arm_right" d="M130,90 L150,90 L150,180 L130,180 Z" fill="transparent" stroke="black" stroke-width="1.5" stroke-dasharray="3,2" />
  <path id="leg_left" d="M80,260 L100,260 L100,400 L80,400 Z" fill="transparent" stroke="black" stroke-width="1.5" stroke-dasharray="3,2" />
  <path id="leg_right" d="M100,260 L120,260 L120,400 L100,400 Z" fill="transparent" stroke="black" stroke-width="1.5" stroke-dasharray="3,2" />
</svg>
      '''
        : '''
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 200 500">
  <path id="face" d="M85,30 L115,30 Q130,50 115,70 Q100,80 85,70 Q70,50 85,30 Z" fill="transparent" stroke="black" stroke-width="1.5" stroke-dasharray="3,2" />
  <path id="chest" d="M75,85 L125,85 L125,130 L75,130 Z" fill="transparent" stroke="black" stroke-width="1.5" stroke-dasharray="3,2" />
  <path id="belly" d="M80,140 L120,140 L120,200 L80,200 Z" fill="transparent" stroke="black" stroke-width="1.5" stroke-dasharray="3,2" />
  <path id="hip" d="M75,210 L125,210 L125,260 L75,260 Z" fill="transparent" stroke="black" stroke-width="1.5" stroke-dasharray="3,2" />
  <path id="arm_left" d="M50,90 L70,90 L70,180 L50,180 Z" fill="transparent" stroke="black" stroke-width="1.5" stroke-dasharray="3,2" />
  <path id="arm_right" d="M130,90 L150,90 L150,180 L130,180 Z" fill="transparent" stroke="black" stroke-width="1.5" stroke-dasharray="3,2" />
  <path id="leg_left" d="M80,270 L100,270 L100,400 L80,400 Z" fill="transparent" stroke="black" stroke-width="1.5" stroke-dasharray="3,2" />
  <path id="leg_right" d="M100,270 L120,270 L120,400 L100,400 Z" fill="transparent" stroke="black" stroke-width="1.5" stroke-dasharray="3,2" />
</svg>
      ''';
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

      for (final partId in _expectedIds) {
        final elements = document.findAllElements('*').where(
              (element) => element.getAttribute('id') == partId,
            );

        for (final element in elements) {
          final isSelected = _selectedParts.contains(partId);
          _applyStyleToElement(element, isSelected);
        }
      }

      // Güncellenmiş SVG stringini kaydet
      _modifiedSvgString = document.toXmlString();
    } catch (e) {
      // Hata durumunda orijinal SVG'yi koruyalım
      _modifiedSvgString = _originalSvgString;
    }
  }

  void _applyStyleToElement(xml.XmlElement element, bool isSelected) {
    if (isSelected) {
      element.setAttribute('fill', '#557C55'); // ProjectColors.primary
      element.setAttribute('fill-opacity', '0.3'); // Yarı saydam ama biraz daha belirgin
      element.setAttribute('stroke', '#2E5522'); // ProjectColors.darkAvocado
      element.setAttribute('stroke-width', '1.2'); // Biraz daha kalın kontur
      element.setAttribute('stroke-dasharray', ''); // Kesikli çizgiyi kaldır
    } else {
      element.setAttribute('fill', 'transparent');
      element.setAttribute('stroke', 'black');
      element.setAttribute('stroke-width', '0.8');
      element.setAttribute('fill-opacity', '0');
      element.setAttribute('stroke-dasharray', '3,2'); // Kesikli çizgi ekle
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
    // Seçili bölgelerin isimlerini al
    final selectedRegions = _getSelectedRegionNames();
    
    if (selectedRegions.isNotEmpty) {
      // Cubit üzerinden tavsiye al
      context.read<RegionalFatBurningCubit>().getAdvice(selectedRegions);
    }
  }

  // Tavsiye geldiğinde sayfayı aşağıya kaydır
  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
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
      body: BlocConsumer<RegionalFatBurningCubit, RegionalFatBurningState>(
        listener: (context, state) {
          // Tavsiye başarıyla alındığında sayfayı aşağı kaydır
          if (state.advice.isNotEmpty && !state.isLoading) {
            // UI güncellemesi bittikten sonra kaydırma işlemi yap
            WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                // Vücut şeması - sabit boyutta kalacak
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.5,
                  child: !_isLoading && _modifiedSvgString != null
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: InteractiveSvgBody(
                              svgString: _modifiedSvgString!,
                              onTapRegion: _toggleBodyPart,
                              gender: _userGender,
                            ),
                          ),
                        )
                      : const Center(child: CircularProgressIndicator()),
                ),
                
                // Seçilen bölgeler ve Tavsiye Al butonu
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Seçilen bölgeler yazısı
                      _buildSelectedRegionsBox(selectedRegionNames),

                      // Tavsiye Al butonu
                      ProjectButton(
                        text: state.isLoading 
                            ? 'Tavsiye Alınıyor...' 
                            : state.adviceReceived 
                                ? 'Tavsiye Alındı' 
                                : 'Tavsiye Al',
                        onPressed: state.isLoading || state.adviceReceived ? null : _getAdvice,
                        isEnabled: selectedRegionNames.isNotEmpty && !state.isLoading && !state.adviceReceived,
                      ),
                      
                      // Hata mesajı varsa göster
                      if (state.error.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: Text(
                            state.error,
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                      
                      // Tavsiye içeriği
                      if (state.advice.isNotEmpty)
                        Container(
                          margin: const EdgeInsets.only(top: 16),
                          padding: const EdgeInsets.all(16),
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
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: ProjectColors.primary,
                                    radius: 16.r,
                                    child: Icon(
                                      Icons.fitness_center,
                                      color: Colors.white,
                                      size: 18.w,
                                    ),
                                  ),
                                  SizedBox(width: 8.w),
                                  Text(
                                    'Avo\'nun Tavsiyeleri',
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.bold,
                                      color: ProjectColors.darkAvocado,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 12.h),
                              Text(
                                state.advice,
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: Colors.black87,
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
                
                // Ekranın altında biraz boşluk bırakalım
                SizedBox(height: 20.h),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSelectedRegionsBox(List<String> selectedRegionNames) {
    return Container(
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
              text: selectedRegionNames.isEmpty ? 'Henüz bölge seçilmedi' : selectedRegionNames.join(', '),
            ),
          ],
        ),
      ),
    );
  }
}

class InteractiveSvgBody extends StatelessWidget {
  const InteractiveSvgBody({
    required this.svgString,
    required this.onTapRegion,
    required this.gender,
    super.key,
  });

  final String svgString;
  final Function(String) onTapRegion;
  final String gender;

  // Erkek ve kadınlar için merkez noktaları
  Map<String, Offset> get _regionCenters => gender == 'Erkek'
      ? {
          // Erkek vücut şeması için merkez noktaları
          'face': const Offset(0.5, 0.075),
          'chest': const Offset(0.5, 0.23),
          'belly': const Offset(0.5, 0.36),
          'hip': const Offset(0.5, 0.45),
          'arm_left': const Offset(0.34, 0.35),
          'arm_right': const Offset(0.66, 0.35),
          'leg_left': const Offset(0.44, 0.71),
          'leg_right': const Offset(0.56, 0.71),
        }
      : {
          // Kadın vücut şeması için merkez noktaları
          'face': const Offset(0.5, 0.075),
          'chest': const Offset(0.5, 0.22),
          'belly': const Offset(0.5, 0.32),
          'hip': const Offset(0.5, 0.42),
          'arm_left': const Offset(0.37, 0.35),
          'arm_right': const Offset(0.63, 0.35),
          'leg_left': const Offset(0.44, 0.72),
          'leg_right': const Offset(0.56, 0.72),
        };

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth * 0.95;
        final maxHeight = constraints.maxHeight * 0.95;

        return Stack(
          alignment: Alignment.center,
          children: [
            // SVG görseli
            SizedBox(
              width: maxWidth,
              height: maxHeight,
              child: SvgPicture.string(svgString),
            ),

            // Tıklanabilir hedef noktalar
            ..._regionCenters.entries.map((entry) {
              return _buildTargetPoint(entry.key, entry.value, maxWidth, maxHeight);
            }),
          ],
        );
      },
    );
  }

  Widget _buildTargetPoint(String regionId, Offset center, double width, double height) {
    final pointSize = 28.w;
    final innerPointSize = 6.w;
    final borderWidth = 1.5.w;
    final blurRadius = 6.w;
    final spreadRadius = 1.w;

    return Positioned(
      left: center.dx * width - (pointSize / 2),
      top: center.dy * height - (pointSize / 2),
      child: GestureDetector(
        onTap: () => onTapRegion(regionId),
        behavior: HitTestBehavior.translucent,
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
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
      ),
    );
  }
}