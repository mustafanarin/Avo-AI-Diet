import 'dart:async';
import 'package:avo_ai_diet/feature/onboarding/cubit/user_info_cache_cubit.dart';
import 'package:avo_ai_diet/product/constants/body_regions.dart';
import 'package:avo_ai_diet/product/constants/enum/general/svg_name.dart';
import 'package:avo_ai_diet/product/constants/project_strings.dart';
import 'package:avo_ai_diet/product/utility/extensions/svg_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xml/xml.dart';

mixin RegionalFatBurningMixin<T extends StatefulWidget> on State<T> {
  final ScrollController scrollController = ScrollController();

  late String userGender;
  late String assetName;
  final Set<String> selectedParts = {};

  String? modifiedSvgString;
  String? originalSvgString;

  bool isLoading = true;

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @mustCallSuper
  void initRegionalFatBurning() {
    userGender = ProjectStrings.male;
    assetName = SvgName.manDiagram.path;

    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final gender = await context.read<UserInfoCacheCubit>().getUserGender();

      setState(() {
        userGender = gender;
        assetName = userGender == ProjectStrings.male ? SvgName.manDiagram.path : SvgName.womanDiagram.path;
      });

      await _loadSvgAsset();
    } catch (e) {
      setState(() {
        userGender = ProjectStrings.male;
        assetName = SvgName.manDiagram.path;
      });
      await _loadSvgAsset();
    }
  }

  Future<void> _loadSvgAsset() async {
    try {
      final svgString = await DefaultAssetBundle.of(context).loadString(assetName);
      final processedSvg = _processSvg(svgString);

      setState(() {
        originalSvgString = processedSvg;
        modifiedSvgString = processedSvg;
        isLoading = false;
      });
    } catch (e) {
      // Use fallback SVG in case of error
      final fallbackSvg = BodyRegions.getFallbackSvg(userGender);

      setState(() {
        originalSvgString = fallbackSvg;
        modifiedSvgString = fallbackSvg;
        isLoading = false;
      });
    }
  }

  String _processSvg(String svgString) {
    final document = XmlDocument.parse(svgString);
    _setDefaultPathStyles(document);
    _checkAndFixMissingElements(document);
    return document.toXmlString();
  }

  void _setDefaultPathStyles(XmlDocument document) {
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

  void _checkAndFixMissingElements(XmlDocument document) {
    final foundIds = document
        .findAllElements('*')
        .where((element) => element.getAttribute('id') != null)
        .map((element) => element.getAttribute('id'))
        .toSet();

    final missingIds = BodyRegions.expectedIds.where((id) => !foundIds.contains(id));

    for (final missingId in missingIds) {
      final pathData = BodyRegions.getDefaultPathForId(missingId);
      if (pathData.isNotEmpty) {
        final element = XmlElement(
          XmlName('path'),
          [
            XmlAttribute(XmlName('id'), missingId),
            XmlAttribute(XmlName('d'), pathData),
            XmlAttribute(XmlName('fill'), 'transparent'),
            XmlAttribute(XmlName('stroke'), 'white'),
            XmlAttribute(XmlName('stroke-width'), '0.5'),
          ],
          [],
        );
        document.rootElement.children.add(element);
      }
    }
  }

  void toggleBodyPart(String partId) {
    setState(() {
      // If it's arms or legs, process both of them
      final partsToToggle = <String>[partId];

      // Let's add the matching regions
      if (BodyRegions.pairedRegions.containsKey(partId)) {
        partsToToggle.addAll(BodyRegions.pairedRegions[partId]!);
      }

      // Process all relevant parts
      for (final part in partsToToggle) {
        if (selectedParts.contains(part)) {
          selectedParts.remove(part);
        } else {
          selectedParts.add(part);
        }
      }

      _updateSvgColors();
    });
  }

  void _updateSvgColors() {
    if (originalSvgString == null) return;

    try {
      final document = XmlDocument.parse(originalSvgString!);

      for (final partId in BodyRegions.expectedIds) {
        final elements = document.findAllElements('*').where(
              (element) => element.getAttribute('id') == partId,
            );

        for (final element in elements) {
          final isSelected = selectedParts.contains(partId);
          _applyStyleToElement(element, isSelected);
        }
      }

      // Save the updated SVG string
      modifiedSvgString = document.toXmlString();
    } catch (e) {
      // Let's preserve the original SVG in case of error
      modifiedSvgString = originalSvgString;
    }
  }

  void _applyStyleToElement(XmlElement element, bool isSelected) {
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
  List<String> getSelectedRegionNames() {
    final regionNames = <String>{};

    for (final partId in selectedParts) {
      final name = BodyRegions.regionNames[partId];
      if (name != null) {
        regionNames.add(name);
      }
    }

    return regionNames.toList();
  }

  // Scroll the page down when advice is received
  void scrollToBottom() {
    if (scrollController.hasClients) {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }
}
