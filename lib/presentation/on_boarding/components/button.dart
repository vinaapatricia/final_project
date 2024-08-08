import 'package:flutter/material.dart';
import 'package:final_project/core/configs/theme/app_colors.dart';
import 'package:final_project/presentation/auth/pages/register/register.dart';

class OnBoardingButton extends StatelessWidget {
  final PageController controller;
  final int currentIndex;
  final int totalContents;

  const OnBoardingButton({
    required this.controller,
    required this.currentIndex,
    required this.totalContents,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      margin: const EdgeInsets.all(40),
      width: 334,
      child: ElevatedButton(
        onPressed: () {
          if (currentIndex == totalContents - 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => const RegisterPage(),
              ),
            );
          } else {
            controller.nextPage(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              currentIndex == totalContents - 1 ? "Continue" : 'Next',
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(width: 8),
            Icon(
              currentIndex == totalContents - 1
                  ? Icons.arrow_forward
                  : Icons.navigate_next,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
