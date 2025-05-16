import 'package:avo_ai_diet/feature/search/model/food_model.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

extension IconDataExtension on FoodModel {
  IconData getIconData() {
    if (icon.startsWith('FontAwesomeIcons.')) {
      final iconName = icon.replaceFirst('FontAwesomeIcons.', '');
      switch (iconName) {
        // Fruits
        case 'apple': return FontAwesomeIcons.apple;
        case 'appleWhole': return FontAwesomeIcons.appleWhole;
        case 'banana': return FontAwesomeIcons.utensils;
        case 'lemon': return FontAwesomeIcons.lemon;
        
        // Vegetables
        case 'carrot': return FontAwesomeIcons.carrot;
        case 'leaf': return FontAwesomeIcons.leaf;
        case 'seedling': return FontAwesomeIcons.seedling;
        case 'tree': return FontAwesomeIcons.seedling;
        case 'pepperHot': return FontAwesomeIcons.pepperHot;
        case 'fireFlameSimple': return FontAwesomeIcons.fireFlameSimple;
        case 'beansThriving': return FontAwesomeIcons.seedling; 
        
        // Shapes and simple forms
        case 'solidCircle': return FontAwesomeIcons.solidCircle;
        case 'solidSquare': return FontAwesomeIcons.solidSquare;
        case 'cloud': return FontAwesomeIcons.cloud;
        case 'cube': return FontAwesomeIcons.cube;
        case 'circleHalfStroke': return FontAwesomeIcons.circleHalfStroke;
        case 'ring': return FontAwesomeIcons.ring;
        case 'ringCircle': return FontAwesomeIcons.ring; 
        case 'diamondTurnRight': return FontAwesomeIcons.diamondTurnRight;
        case 'c': return FontAwesomeIcons.c;
        case 'gem': return FontAwesomeIcons.gem;
        case 'shapes': return FontAwesomeIcons.shapes;
        case 'bolt': return FontAwesomeIcons.bolt;
        
        // Protein
        case 'drumstickBite': return FontAwesomeIcons.drumstickBite;
        case 'egg': return FontAwesomeIcons.egg;
        case 'fish': return FontAwesomeIcons.fish;
        case 'shrimp': return FontAwesomeIcons.shrimp;
        case 'burger': return FontAwesomeIcons.burger;
        case 'bone': return FontAwesomeIcons.bone;
        case 'steak': return FontAwesomeIcons.drumstickBite;
        case 'spider': return FontAwesomeIcons.spider;
        case 'hotdog': return FontAwesomeIcons.hotdog;
        case 'pizzaSlice': return FontAwesomeIcons.pizzaSlice;
        case 'handsBound': return FontAwesomeIcons.utensils; 
        
        // Grains and carbohydrates
        case 'bowlRice': return FontAwesomeIcons.bowlRice;
        case 'bowlFood': return FontAwesomeIcons.bowlFood;
        case 'breadSlice': return FontAwesomeIcons.breadSlice;
        case 'wheatAwn': return FontAwesomeIcons.wheatAwn;
        
        // Milk productions
        case 'cheese': return FontAwesomeIcons.cheese;
        case 'horse': return FontAwesomeIcons.horse;
        
        // Beverages and liquids
        case 'bottleDroplet': return FontAwesomeIcons.bottleDroplet;
        case 'bottleWater': return FontAwesomeIcons.bottleWater;
        case 'mugSaucer': return FontAwesomeIcons.mugSaucer;
        case 'wineGlass': return FontAwesomeIcons.wineGlass;
        case 'wineGlassAlt': return FontAwesomeIcons.wineGlass; 
        case 'glassWater': return FontAwesomeIcons.glassWater;
        case 'glassCheers': return FontAwesomeIcons.glassWater; 
        case 'droplet': return FontAwesomeIcons.droplet;
        case 'jar': return FontAwesomeIcons.jar;
        case 'beerMugEmpty': return FontAwesomeIcons.beerMugEmpty;
        case 'oilCan': return FontAwesomeIcons.oilCan;
        case 'oilWell': return FontAwesomeIcons.bottleDroplet; 
        
        // Sweets
        case 'iceCream': return FontAwesomeIcons.iceCream;
        case 'candyCane': return FontAwesomeIcons.candyCane;
        case 'cakeCandles': return FontAwesomeIcons.cakeCandles;
        
        // Food and kitchenware
        case 'utensils': return FontAwesomeIcons.utensils;
        
        // Default
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