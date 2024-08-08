import 'package:flutter/material.dart';

class CategorySelector extends StatelessWidget {
  final int selectedCategoryIndex;
  final ValueChanged<int> onCategorySelected;

  const CategorySelector({
    required this.selectedCategoryIndex,
    required this.onCategorySelected,
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
              onCategorySelected(0);
            },
            child: CategoryChip(
              title: 'All',
              productCount: 4357,
              isSelected: selectedCategoryIndex == 0,
            ),
          ),
          const SizedBox(width: 16),
          GestureDetector(
            onTap: () {
              onCategorySelected(1);
            },
            child: CategoryChip(
              title: 'Man',
              productCount: 1276,
              isSelected: selectedCategoryIndex == 1,
            ),
          ),
          const SizedBox(width: 16),
          GestureDetector(
            onTap: () {
              onCategorySelected(2);
            },
            child: CategoryChip(
              title: 'Woman',
              productCount: 1287,
              isSelected: selectedCategoryIndex == 2,
            ),
          ),
        ],
      ),
    );
  }
}

class CategoryChip extends StatelessWidget {
  final String title;
  final int productCount;
  final bool isSelected;

  const CategoryChip({
    required this.title,
    required this.productCount,
    required this.isSelected,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 139,
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      decoration: ShapeDecoration(
        color: isSelected ? const Color(0xFFF0F0FF) : const Color(0xFFFAFAFA),
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 1,
            color: isSelected ? const Color(0xFF7874FF) : const Color(0xFFFAFAFA),
          ),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF232B39),
              fontSize: 18,
              fontWeight: FontWeight.w700,
              height: 0.07,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            '$productCount Product',
            style: const TextStyle(
              color: Color(0xFF707784),
              fontSize: 14,
              fontWeight: FontWeight.w400,
              height: 0.10,
            ),
          ),
        ],
      ),
    );
  }
}
