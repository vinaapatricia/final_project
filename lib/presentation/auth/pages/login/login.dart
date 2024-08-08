import 'package:final_project/presentation/auth/pages/register/register.dart';
import 'package:flutter/material.dart';
import 'package:final_project/main.dart';
import '../../../../core/configs/theme/app_colors.dart';
import '../../../cashier/pages/cashier_page.dart';
import '../../components/button.dart';
import '../../components/text_field.dart';
import '../auto_login/google_auth.dart';
import 'continue_login.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isObscured = true;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneOrEmailController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    super.dispose();
    passwordController.dispose();
    phoneOrEmailController.dispose();
  }

  bool get _isFormValid {
    final formState = _formKey.currentState;
    if (formState != null) {
      formState.save();
      return formState.validate();
    }
    return false;
  }

  bool get isPhone {
    final text = phoneOrEmailController.text;
    return RegExp(r'^\d+$').hasMatch(text);
  }

  void loginUser() async {
    if (!_isFormValid) return;

    setState(() {
      isLoading = true;
    });

    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      isLoading = false;
    });

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const ContinueLoginPage(),
      ),
    );
  }
  // void loginUser() async {
  //   if (!_isFormValid) return;

  //   setState(() {
  //     isLoading = true;
  //   });

  //   try {
  //     String res = await AuthMethod().loginUser(
  //       email: phoneOrEmailController.text,
  //       password: passwordController.text,
  //     );

  //     if (res == "success") {
  //       setState(() {
  //         isLoading = false;
  //       });

  //       Navigator.of(context).pushReplacement(
  //         MaterialPageRoute(
  //           builder: (context) => const ContinueRegisterPage(),
  //         ),
  //       );
  //     } else {
  //       setState(() {
  //         isLoading = false;
  //       });
  //       showSnackBar(context, res);
  //     }
  //   } catch (e) {
  //     setState(() {
  //       isLoading = false;
  //     });

  //     showSnackBar(context, 'Login failed. Please try again.');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: SizedBox(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Login POS account',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const Text(
                        'Welcome back! Let`s login to your account.',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFieldInput(
                        prefixIcon: isPhone
                            ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6.0),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        '+62',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      Icon(
                                        Icons.keyboard_arrow_down_rounded,
                                        color: Colors.black,
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : const Icon(Icons.email_outlined),
                        textEditingController: phoneOrEmailController,
                        hintText: isPhone
                            ? 'ex. 9889-9870-9865'
                            : 'ex. yourname@gmail.com',
                        textInputType: isPhone
                            ? TextInputType.phone
                            : TextInputType.emailAddress,
                        title: isPhone ? 'Phone Number' : 'Email',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your ${isPhone ? 'phone number' : 'email'}';
                          }
                          if (!isPhone &&
                              !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                            return 'Please enter a valid email address';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(
                              () {}); // Rebuild the widget to update the input type
                        },
                      ),
                      TextFieldInput(
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Image.asset('assets/images/key_icon.png'),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isObscured
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              _isObscured = !_isObscured;
                            });
                          },
                        ),
                        textEditingController: passwordController,
                        hintText: 'Type your password here',
                        textInputType: TextInputType.text,
                        isPass: _isObscured,
                        title: 'Password',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16.0),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AuthButton(
                        onTap: _isFormValid ? loginUser : null,
                        text: "Login",
                        color: _isFormValid ? null : Colors.grey,
                      ),
                      const SizedBox(height: 16),
                      const Text('or'),
                      const SizedBox(height: 16),
                      AuthButton(
                        onTap: () async {
                          await FirebaseServices().signInWithGoogle();
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CashierPage()));
                        },
                        text: "Sign Up with Google",
                        isOutlined: true,
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: Image.asset('assets/images/Google.png'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don`t have an account?"),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const RegisterPage(),
                            ),
                          );
                        },
                        child: TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const RegisterPage(),
                              ),
                            );
                          },
                          child: const Text(
                            'Register',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
