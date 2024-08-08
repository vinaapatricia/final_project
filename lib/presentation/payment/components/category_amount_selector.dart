import 'package:final_project/core/configs/theme/app_colors.dart';
import 'package:flutter/material.dart';

class CategoryAmountSelector extends StatelessWidget {
  final int selectedAmountIndex;
  final ValueChanged<int> onAmountSelected;

  const CategoryAmountSelector({
    required this.selectedAmountIndex,
    required this.onAmountSelected,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              onAmountSelected(0);
            },
            child: CategoryChip(
              text: '100',
              isAmountSelected: selectedAmountIndex == 1,
            ),
          ),
          const SizedBox(width: 16),
          GestureDetector(
            onTap: () {
              onAmountSelected(1);
            },
            child: CategoryChip(
              text: 'Debit',
              isAmountSelected: selectedAmountIndex == 2,
            ),
          ),
          const SizedBox(width: 16),
          GestureDetector(
            onTap: () {
              onAmountSelected(2);
            },
            child: CategoryChip(
              text: 'QRIS',
              isAmountSelected: selectedAmountIndex == 3,
            ),
          ),
          const SizedBox(width: 16),
          GestureDetector(
            onTap: () {
              onAmountSelected(2);
            },
            child: CategoryChip(
              text: 'QRIS',
              isAmountSelected: selectedAmountIndex == 4,
            ),
          ),
          const SizedBox(width: 16),
          GestureDetector(
            onTap: () {
              onAmountSelected(2);
            },
            child: CategoryChip(
              text: 'QRIS',
              isAmountSelected: selectedAmountIndex == 5,
            ),
          ),
        ],
      ),
    );
  }
}

class CategoryChip extends StatelessWidget {
  final String text;
  final bool isAmountSelected;

  const CategoryChip({
    required this.text,
    required this.isAmountSelected,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 114,
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: ShapeDecoration(
        color: isAmountSelected ? AppColors.lightBackground : Colors.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 1,
            color: isAmountSelected ? AppColors.primary : Colors.white,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: AppColors.neutral,
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
