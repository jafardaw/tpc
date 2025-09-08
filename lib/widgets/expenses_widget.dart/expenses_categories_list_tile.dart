import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tcp212/constants/my_app_colors.dart';

class ExpensesCategoriesListTile extends StatelessWidget {
  final String name;
  final String description;
  final void Function()? onPressed;
  final void Function()? onPressed2;
  const ExpensesCategoriesListTile({
    super.key,
    required this.name,
    required this.description,
    this.onPressed,
    this.onPressed2,
  });

  IconData _getCategoryIcon(String categoryName) {
    String lowerName = categoryName.toLowerCase();

    if (lowerName.contains('food') ||
        lowerName.contains('restaurant') ||
        lowerName.contains('meal')) {
      return Icons.restaurant;
    } else if (lowerName.contains('transport') ||
        lowerName.contains('car') ||
        lowerName.contains('gas')) {
      return Icons.directions_car;
    } else if (lowerName.contains('shopping') ||
        lowerName.contains('clothes') ||
        lowerName.contains('store')) {
      return Icons.shopping_bag;
    } else if (lowerName.contains('entertainment') ||
        lowerName.contains('movie') ||
        lowerName.contains('game')) {
      return Icons.movie;
    } else if (lowerName.contains('health') ||
        lowerName.contains('medical') ||
        lowerName.contains('doctor')) {
      return Icons.medical_services;
    } else if (lowerName.contains('education') ||
        lowerName.contains('book') ||
        lowerName.contains('study')) {
      return Icons.school;
    } else if (lowerName.contains('home') ||
        lowerName.contains('house') ||
        lowerName.contains('rent')) {
      return Icons.home;
    } else if (lowerName.contains('bills') ||
        lowerName.contains('electricity') ||
        lowerName.contains('water')) {
      return Icons.receipt;
    } else if (lowerName.contains('travel') ||
        lowerName.contains('vacation') ||
        lowerName.contains('trip')) {
      return Icons.flight;
    } else if (lowerName.contains('gym') ||
        lowerName.contains('fitness') ||
        lowerName.contains('sport')) {
      return Icons.fitness_center;
    } else if (lowerName.contains('coffee') || lowerName.contains('drink')) {
      return Icons.local_cafe;
    } else if (lowerName.contains('gift') || lowerName.contains('present')) {
      return Icons.card_giftcard;
    } else if (lowerName.contains('pet') || lowerName.contains('animal')) {
      return Icons.pets;
    } else if (lowerName.contains('beauty') ||
        lowerName.contains('salon') ||
        lowerName.contains('hair')) {
      return Icons.face;
    } else if (lowerName.contains('phone') ||
        lowerName.contains('mobile') ||
        lowerName.contains('communication')) {
      return Icons.phone;
    } else if (lowerName.contains('internet') ||
        lowerName.contains('wifi') ||
        lowerName.contains('online')) {
      return Icons.wifi;
    } else {
      return Icons.category;
    }
  }

  Color _getCategoryColor(String categoryName) {
    String lowerName = categoryName.toLowerCase();

    if (lowerName.contains('food') ||
        lowerName.contains('restaurant') ||
        lowerName.contains('meal')) {
      return Colors.orange;
    } else if (lowerName.contains('transport') ||
        lowerName.contains('car') ||
        lowerName.contains('gas')) {
      return Colors.blue;
    } else if (lowerName.contains('shopping') ||
        lowerName.contains('clothes') ||
        lowerName.contains('store')) {
      return Colors.pink;
    } else if (lowerName.contains('entertainment') ||
        lowerName.contains('movie') ||
        lowerName.contains('game')) {
      return Colors.purple;
    } else if (lowerName.contains('health') ||
        lowerName.contains('medical') ||
        lowerName.contains('doctor')) {
      return Colors.red;
    } else if (lowerName.contains('education') ||
        lowerName.contains('book') ||
        lowerName.contains('study')) {
      return Colors.indigo;
    } else if (lowerName.contains('home') ||
        lowerName.contains('house') ||
        lowerName.contains('rent')) {
      return Colors.brown;
    } else if (lowerName.contains('bills') ||
        lowerName.contains('electricity') ||
        lowerName.contains('water')) {
      return Colors.cyan;
    } else if (lowerName.contains('travel') ||
        lowerName.contains('vacation') ||
        lowerName.contains('trip')) {
      return Colors.teal;
    } else if (lowerName.contains('gym') ||
        lowerName.contains('fitness') ||
        lowerName.contains('sport')) {
      return Colors.green;
    } else if (lowerName.contains('coffee') || lowerName.contains('drink')) {
      return Colors.amber;
    } else if (lowerName.contains('gift') || lowerName.contains('present')) {
      return Colors.deepPurple;
    } else if (lowerName.contains('pet') || lowerName.contains('animal')) {
      return Colors.deepOrange;
    } else if (lowerName.contains('beauty') ||
        lowerName.contains('salon') ||
        lowerName.contains('hair')) {
      return Colors.pinkAccent;
    } else if (lowerName.contains('phone') ||
        lowerName.contains('mobile') ||
        lowerName.contains('communication')) {
      return Colors.lightBlue;
    } else if (lowerName.contains('internet') ||
        lowerName.contains('wifi') ||
        lowerName.contains('online')) {
      return Colors.lightGreen;
    } else {
      return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: ListTile(
            leading: CircleAvatar(
              radius: 30.r,
              backgroundColor: _getCategoryColor(name),
              child: Icon(
                _getCategoryIcon(name),
                color: Colors.white,
                size: 30.sp,
              ),
            ),
            title: Text(
              name,
              style: TextStyle(
                fontSize: 18.sp,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              description,
              style: TextStyle(fontSize: 15.sp, color: Colors.grey[600]!),
            ),
            trailing: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: onPressed2,
                  icon: Icon(
                    Icons.info,
                    size: 25.sp,
                    color: MyAppColors.kPrimary,
                  ),
                ),
                IconButton(
                  onPressed: onPressed,
                  icon: Icon(
                    Icons.arrow_forward_ios,
                    size: 25.sp,
                    color: MyAppColors.kPrimary,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 10.h),
      ],
    );
  }
}
