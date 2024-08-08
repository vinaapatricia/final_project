import 'package:flutter/material.dart';

import '../../../../core/configs/theme/app_colors.dart';
import '../login/login.dart';

class ContinueLoginPage extends StatelessWidget {
  const ContinueLoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/Change Data Success.png'),
            const Text(
              'Business information has been saved successfully ',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 12,
            ),
            const Text(
              'You have successfully completed your business information. Please continue to the main page',
              style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 72),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const LoginPage(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.0),
                  child: Text(
                    'Continue',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
