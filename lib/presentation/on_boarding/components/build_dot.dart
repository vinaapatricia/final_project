import 'package:flutter/material.dart';
import 'package:final_project/core/configs/theme/app_colors.dart';

Widget buildDot(int index, int currentIndex, BuildContext context) {
  return Container(
    height: 10,
    width: currentIndex == index ? 25 : 10,
    margin: const EdgeInsets.only(right: 5),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      color: currentIndex == index ? AppColors.neutral : Colors.black12,
    ),
  );
}
