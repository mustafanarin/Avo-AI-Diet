import 'package:avo_ai_diet/feature/search/model/food_model.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

extension IconDataExtension on FoodModel {
  IconData getIconData() {
    if (icon.startsWith('FontAwesomeIcons.')) {
      final iconName = icon.replaceFirst('FontAwesomeIcons.', '');
            switch (iconName) {
        case 'apple': return FontAwesomeIcons.apple;
        case 'banana': return FontAwesomeIcons.utensils;
        case 'solidCircle': return FontAwesomeIcons.solidCircle;
        case 'seedling': return FontAwesomeIcons.seedling;
        case 'carrot': return FontAwesomeIcons.carrot;
        case 'tree': return FontAwesomeIcons.seedling;
        case 'leaf': return FontAwesomeIcons.leaf;
        case 'drumstickBite': return FontAwesomeIcons.drumstickBite;
        case 'egg': return FontAwesomeIcons.egg;
        case 'fish': return FontAwesomeIcons.fish;
        case 'burger': return FontAwesomeIcons.burger;
        case 'bowlRice': return FontAwesomeIcons.bowlRice;
        case 'bowlFood': return FontAwesomeIcons.bowlFood;
        case 'breadSlice': return FontAwesomeIcons.breadSlice;
        case 'wheatAwn': return FontAwesomeIcons.wheatAwn;
        case 'bottleDroplet': return FontAwesomeIcons.bottleDroplet;
        case 'appleWhole': return FontAwesomeIcons.appleWhole;
        case 'cheese': return FontAwesomeIcons.cheese;
        case 'mugSaucer': return FontAwesomeIcons.mugSaucer;
        case 'wineGlass': return FontAwesomeIcons.wineGlass;
        case 'cloud': return FontAwesomeIcons.cloud;
        case 'lemon': return FontAwesomeIcons.lemon;
        case 'bone': return FontAwesomeIcons.bone;
        case 'droplet': return FontAwesomeIcons.droplet;
        default: return FontAwesomeIcons.utensils;
      }
    } else if (icon.startsWith('Icons.')) {
      final iconName = icon.replaceFirst('Icons.', '');
      
      switch (iconName) {
        case 'circle': return Icons.circle;
        case 'circle_outlined': return Icons.circle_outlined;
        case 'grain': return Icons.grain;
        case 'grass': return Icons.grass;
        case 'egg_alt': return Icons.egg_alt;
        default: return Icons.restaurant_menu;
      }
    }
    
    return Icons.restaurant_menu;
  }
}