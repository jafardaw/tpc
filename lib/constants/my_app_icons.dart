import 'package:flutter/material.dart';

class MyAppIcons {
  static IconData getCategoryIcon(String categoryName) {
    String lowerName = categoryName.toLowerCase();

    if (lowerName.contains('food') || lowerName.contains('restaurant') || lowerName.contains('meal')) {
      return Icons.restaurant;
    } else if (lowerName.contains('transport') || lowerName.contains('car') || lowerName.contains('gas')) {
      return Icons.directions_car;
    } else if (lowerName.contains('shopping') || lowerName.contains('clothes') || lowerName.contains('store')) {
      return Icons.shopping_bag;
    } else if (lowerName.contains('entertainment') || lowerName.contains('movie') || lowerName.contains('game')) {
      return Icons.movie;
    } else if (lowerName.contains('health') || lowerName.contains('medical') || lowerName.contains('doctor')) {
      return Icons.medical_services;
    } else if (lowerName.contains('education') || lowerName.contains('book') || lowerName.contains('study')) {
      return Icons.school;
    } else if (lowerName.contains('home') || lowerName.contains('house') || lowerName.contains('rent')) {
      return Icons.home;
    } else if (lowerName.contains('bills') || lowerName.contains('electricity') || lowerName.contains('water')) {
      return Icons.receipt;
    } else if (lowerName.contains('travel') || lowerName.contains('vacation') || lowerName.contains('trip')) {
      return Icons.flight;
    } else if (lowerName.contains('gym') || lowerName.contains('fitness') || lowerName.contains('sport')) {
      return Icons.fitness_center;
    } else if (lowerName.contains('coffee') || lowerName.contains('drink')) {
      return Icons.local_cafe;
    } else if (lowerName.contains('gift') || lowerName.contains('present')) {
      return Icons.card_giftcard;
    } else if (lowerName.contains('pet') || lowerName.contains('animal')) {
      return Icons.pets;
    } else if (lowerName.contains('beauty') || lowerName.contains('salon') || lowerName.contains('hair')) {
      return Icons.face;
    } else if (lowerName.contains('phone') || lowerName.contains('mobile') || lowerName.contains('communication')) {
      return Icons.phone;
    } else if (lowerName.contains('internet') || lowerName.contains('wifi') || lowerName.contains('online')) {
      return Icons.wifi;
    } else {
      return Icons.category;
    }
  }
}