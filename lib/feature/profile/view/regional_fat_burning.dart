import 'package:avo_ai_diet/feature/onboarding/cubit/user_info_cache_cubit.dart';
import 'package:avo_ai_diet/feature/profile/cubit/regional_fat_burning_cubit.dart';
import 'package:avo_ai_diet/feature/profile/state/regional_fat_burning_state.dart';
import 'package:avo_ai_diet/product/constants/body_regions.dart';
import 'package:avo_ai_diet/product/constants/enum/general/json_name.dart';
import 'package:avo_ai_diet/product/constants/enum/general/svg_name.dart';
import 'package:avo_ai_diet/product/constants/project_colors.dart';
import 'package:avo_ai_diet/product/constants/project_strings.dart';
import 'package:avo_ai_diet/product/utility/extensions/json_extension.dart';
import 'package:avo_ai_diet/product/utility/extensions/svg_extension.dart';
import 'package:avo_ai_diet/product/utility/extensions/text_theme_extension.dart';
import 'package:avo_ai_diet/product/widgets/project_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:xml/xml.dart' as xml;

final class RegionalFatBurning extends StatefulWidget {
  const RegionalFatBurning({super.key});

  @override
  State<RegionalFatBurning> createState() => _RegionalFatBurningState();
}

class _RegionalFatBurningState extends State<RegionalFatBurning> {
  final ScrollController _scrollController = ScrollController();

  late String _userGender;
  late String _assetName;
  final Set<String> _selectedParts = {};

  // SVG data
  String? _modifiedSvgString;
  String? _originalSvgString;

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // Default value
    _userGender = ProjectStrings.male;
    _assetName = SvgName.manDiagram.path;

    // Determine gender-based SVG file
    _loadUserData();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    try {
      final gender = await context.read<UserInfoCacheCubit>().getUserGender();

      setState(() {
        _userGender = gender;
        _assetName = _userGender == ProjectStrings.male ? SvgName.manDiagram.path : SvgName.womanDiagram.path;
      });

      await _loadSvgAsset();
    } catch (e) {
      setState(() {
        _userGender = ProjectStrings.male;
        _assetName = SvgName.manDiagram.path;
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
      // Use fallback SVG in case of error
      final fallbackSvg = BodyRegions.getFallbackSvg(_userGender);

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
    for (final id in BodyRegions.expectedIds) {
      final elements = document.findAllElements('*').where((element) => element.getAttribute('id') == id);

      for (final element in elements) {
        element.setAttribute('fill', 'transparent');
        element.setAttribute('stroke', 'black');
        element.setAttribute('stroke-width', '0.8');
        element.setAttribute('stroke-dasharray', '3,2');
      }
    }
  }

  void _checkAndFixMissingElements(xml.XmlDocument document) {
    final foundIds = document
        .findAllElements('*')
        .where((element) => element.getAttribute('id') != null)
        .map((element) => element.getAttribute('id'))
        .toSet();

    final missingIds = BodyRegions.expectedIds.where((id) => !foundIds.contains(id));

    for (final missingId in missingIds) {
      final pathData = BodyRegions.getDefaultPathForId(missingId);
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

  void _toggleBodyPart(String partId) {
    setState(() {
      // If it's arms or legs, process both of them
      final partsToToggle = <String>[partId];

      // Let's add the matching regions
      if (BodyRegions.pairedRegions.containsKey(partId)) {
        partsToToggle.addAll(BodyRegions.pairedRegions[partId]!);
      }

      // Process all relevant parts
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

      for (final partId in BodyRegions.expectedIds) {
        final elements = document.findAllElements('*').where(
              (element) => element.getAttribute('id') == partId,
            );

        for (final element in elements) {
          final isSelected = _selectedParts.contains(partId);
          _applyStyleToElement(element, isSelected);
        }
      }

      // Save the updated SVG string
      _modifiedSvgString = document.toXmlString();
    } catch (e) {
      // Let's preserve the original SVG in case of error
      _modifiedSvgString = _originalSvgString;
    }
  }

  void _applyStyleToElement(xml.XmlElement element, bool isSelected) {
    if (isSelected) {
      element.setAttribute('fill', '#557C55'); // ProjectColors.primary
      element.setAttribute('fill-opacity', '0.3');
      element.setAttribute('stroke', '#2E5522'); // ProjectColors.darkAvocado
      element.setAttribute('stroke-width', '1.2');
      element.setAttribute('stroke-dasharray', '');
    } else {
      element.setAttribute('fill', 'transparent');
      element.setAttribute('stroke', 'black');
      element.setAttribute('stroke-width', '0.8');
      element.setAttribute('fill-opacity', '0');
      element.setAttribute('stroke-dasharray', '3,2');
    }
  }

  // Get the names of selected regions as a list
  List<String> _getSelectedRegionNames() {
    final regionNames = <String>{};

    for (final partId in _selectedParts) {
      final name = BodyRegions.regionNames[partId];
      if (name != null) {
        regionNames.add(name);
      }
    }

    return regionNames.toList();
  }

  void _getAdvice() {
    final selectedRegions = _getSelectedRegionNames();

    if (selectedRegions.isNotEmpty) {
      context.read<RegionalFatBurningCubit>().getAdvice(selectedRegions);
    }
  }

  // Scroll the page down when advice is received
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
    final selectedRegionNames = _getSelectedRegionNames();

    return Scaffold(
      appBar: AppBar(
        title: const Text(ProjectStrings.regionalFatBurning),
        backgroundColor: ProjectColors.backgroundCream,
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(
            Icons.arrow_back,
            color: ProjectColors.earthBrown,
          ),
        ),
      ),
      body: BlocConsumer<RegionalFatBurningCubit, RegionalFatBurningState>(
        listener: (context, state) {
          if (state.advice.isNotEmpty && !state.isLoading) {
            // Perform scrolling after UI update is complete
            WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.65,
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
                Padding(
                  padding: EdgeInsets.all(20.r),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Selected regions text
                      _buildSelectedRegionsBox(selectedRegionNames),

                      // Get advice button
                      ProjectButton(
                        text: state.isLoading
                            ? ProjectStrings.adviceGetting
                            : state.adviceReceived
                                ? ProjectStrings.adviceGot
                                : ProjectStrings.adviceGet,
                        onPressed: state.isLoading || state.adviceReceived ? null : _getAdvice,
                        isEnabled: selectedRegionNames.isNotEmpty && !state.isLoading && !state.adviceReceived,
                      ),

                      // Show error message if exists
                      if (state.error.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: Text(
                            state.error,
                            style: context.textTheme().bodySmall?.copyWith(
                                  color: ProjectColors.red,
                                ),
                          ),
                        ),

                      if (state.isLoading)
                        Center(
                          child: SizedBox(
                            height: 70.h,
                            width: 70.h,
                            child: Lottie.asset(
                              JsonName.avoWalk.path,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),

                      // Advice content
                      if (state.advice.isNotEmpty)
                        Container(
                          margin: const EdgeInsets.only(top: 16),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: ProjectColors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: ProjectColors.black.withOpacity(0.05),
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
                                      Icons.local_fire_department_outlined,
                                      color: ProjectColors.white,
                                      size: 18.w,
                                    ),
                                  ),
                                  SizedBox(width: 8.w),
                                  Text(
                                    ProjectStrings.advicesOfAvo,
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.bold,
                                      color: ProjectColors.darkAvocado,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 12.h),
                              MarkdownBody(
                                data: state.advice,
                                styleSheet: MarkdownStyleSheet(
                                  p: const TextStyle(
                                    color: ProjectColors.black,
                                  ),
                                  strong: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: ProjectColors.black,
                                  ),
                                  em: const TextStyle(
                                    fontStyle: FontStyle.italic,
                                    color: ProjectColors.black,
                                  ),
                                  listBullet: const TextStyle(
                                    color: ProjectColors.black,
                                  ),
                                ),
                                selectable: true,
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
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
        color: ProjectColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: ProjectColors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: RichText(
        text: TextSpan(
          style: TextStyle(
            fontSize: 16.sp,
            color: ProjectColors.earthBrown,
          ),
          children: [
            const TextSpan(
              text: ProjectStrings.selectedRegion,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(
              text: selectedRegionNames.isEmpty ? ProjectStrings.noRegionSelected : selectedRegionNames.join(', '),
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
  final void Function(String) onTapRegion;
  final String gender;

  Map<String, Offset> get _regionCenters => gender == ProjectStrings.male
      ? {
          // Center points for male body diagram
          BodyRegions.face: const Offset(0.5, 0.075),
          BodyRegions.chest: const Offset(0.5, 0.23),
          BodyRegions.belly: const Offset(0.5, 0.36),
          BodyRegions.hip: const Offset(0.5, 0.45),
          BodyRegions.armLeft: const Offset(0.34, 0.35),
          BodyRegions.armRight: const Offset(0.66, 0.35),
          BodyRegions.legLeft: const Offset(0.44, 0.71),
          BodyRegions.legRight: const Offset(0.56, 0.71),
        }
      : {
          // Center points for female body diagram
          BodyRegions.face: const Offset(0.5, 0.075),
          BodyRegions.chest: const Offset(0.5, 0.22),
          BodyRegions.belly: const Offset(0.5, 0.32),
          BodyRegions.hip: const Offset(0.5, 0.42),
          BodyRegions.armLeft: const Offset(0.37, 0.35),
          BodyRegions.armRight: const Offset(0.63, 0.35),
          BodyRegions.legLeft: const Offset(0.44, 0.72),
          BodyRegions.legRight: const Offset(0.56, 0.72),
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
            // SVG image
            SizedBox(
              width: maxWidth,
              height: maxHeight,
              child: SvgPicture.string(svgString),
            ),

            // Clickable target points
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
            color: ProjectColors.green.withOpacity(0.3),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.green.shade600, width: borderWidth),
            boxShadow: [
              BoxShadow(
                color: ProjectColors.green.withOpacity(0.4),
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
                color: ProjectColors.earthBrown,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
