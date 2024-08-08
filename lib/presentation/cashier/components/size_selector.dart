import 'package:flutter/material.dart';

class SizeSelector extends StatelessWidget {
  final int selectedSizeIndex;
  final ValueChanged<int> onSizeSelected;

  const SizeSelector({
    required this.selectedSizeIndex,
    required this.onSizeSelected,
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
              onSizeSelected(0);
            },
            child: CategoryChip(
              size: 'S',
              isSelected: selectedSizeIndex == 0,
            ),
          ),
          const SizedBox(width: 16),
          GestureDetector(
            onTap: () {
              onSizeSelected(1);
            },
            child: CategoryChip(
              size: 'M',
              isSelected: selectedSizeIndex == 1,
            ),
          ),
          const SizedBox(width: 16),
          GestureDetector(
            onTap: () {
              onSizeSelected(2);
            },
            child: CategoryChip(
              size: 'L',
              isSelected: selectedSizeIndex == 2,
            ),
          ),
        ],
      ),
    );
  }
}

class CategoryChip extends StatelessWidget {
  final String size;
  final bool isSelected;

  const CategoryChip({
    required this.size,
    required this.isSelected,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 41,
      height: 40,
      decoration: ShapeDecoration(
        color: isSelected ? const Color(0xFFF0F0FF) : const Color(0xFFFAFAFA),
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 1,
            color:
                isSelected ? const Color(0xFF7874FF) : const Color(0xFFFAFAFA),
          ),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            size,
            style: const TextStyle(
              color: Color(0xFF232B39),
              fontSize: 16,
              fontWeight: FontWeight.w700,
              height: 0.07,
            ),
          ),
        ],
      ),
    );
  }
}
