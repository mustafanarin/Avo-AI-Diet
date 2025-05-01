import 'package:flutter/material.dart' show immutable;

@immutable
abstract final class BodyRegions {
  // body ID
  static const armLeft = 'arm_left';
  static const armRight = 'arm_right';
  static const chest = 'chest';
  static const belly = 'belly';
  static const hip = 'hip';
  static const legRight = 'leg_right';
  static const legLeft = 'leg_left';
  static const face = 'face';

  static const expectedIds = [
    armLeft,
    armRight,
    chest,
    belly,
    hip,
    legRight,
    legLeft,
    face,
  ];

  /// Paired areas (such as arms and legs)
  static const pairedRegions = {
    armLeft: [armRight],
    armRight: [armLeft],
    legLeft: [legRight],
    legRight: [legLeft],
  };

  /// Display names of their IDs
  static const regionNames = {
    face: 'Yüz',
    chest: 'Göğüs',
    belly: 'Karın',
    hip: 'Kalça',
    armLeft: 'Kollar',
    armRight: 'Kollar',
    legLeft: 'Bacaklar',
    legRight: 'Bacaklar',
  };

  /// fallback SVG for male
  static const maleFallbackSvg = '''
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
''';

  ///  fallback SVG for female
  static const femaleFallbackSvg = '''
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

  // Returns the default SVG path by ID
  static String getDefaultPathForId(String id) {
    switch (id) {
      case armLeft:
        return 'M50,100 L30,200 L40,200 L60,100 Z';
      case armRight:
        return 'M150,100 L170,200 L160,200 L140,100 Z';
      case chest:
        return 'M70,100 L130,100 L130,140 L70,140 Z';
      case belly:
        return 'M70,150 L130,150 L130,200 L70,200 Z';
      case hip:
        return 'M70,210 L130,210 L130,250 L70,250 Z';
      case legLeft:
        return 'M70,260 L100,260 L100,350 L70,350 Z';
      case legRight:
        return 'M100,260 L130,260 L130,350 L100,350 Z';
      case face:
        return 'M85,30 L115,30 Q130,50 115,70 Q100,80 85,70 Q70,50 85,30 Z';
      default:
        return '';
    }
  }

  // Returns fallback SVG by gender
  static String getFallbackSvg(String gender) {
    return gender == 'Erkek' ? maleFallbackSvg : femaleFallbackSvg;
  }
}
