import 'package:final_project/core/configs/theme/app_colors.dart';
import 'package:flutter/material.dart';

class CategoryPaymentSelector extends StatelessWidget {
  final int selectedPaymentIndex;
  final ValueChanged<int> onPaymentSelected;

  const CategoryPaymentSelector({
    required this.selectedPaymentIndex,
    required this.onPaymentSelected,
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
              onPaymentSelected(0);
            },
            child: CategoryChip(
              text: 'Cash',
              isSelected: selectedPaymentIndex == 0,
            ),
          ),
          const SizedBox(width: 16),
          GestureDetector(
            onTap: () {
              onPaymentSelected(1);
            },
            child: CategoryChip(
              text: 'Debit',
              isSelected: selectedPaymentIndex == 1,
            ),
          ),
          const SizedBox(width: 16),
          GestureDetector(
            onTap: () {
              onPaymentSelected(2);
            },
            child: CategoryChip(
              text: 'QRIS',
              isSelected: selectedPaymentIndex == 2,
            ),
          ),
        ],
      ),
    );
  }
}

class CategoryChip extends StatelessWidget {
  final String text;
  final bool isSelected;

  const CategoryChip({
    required this.text,
    required this.isSelected,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 114,
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: ShapeDecoration(
        color: isSelected ? AppColors.lightBackground : Colors.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 1,
            color: isSelected ? AppColors.primary : Colors.white,
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
