import 'package:flutter/material.dart';

class TextFieldInput extends StatelessWidget {
  final TextEditingController textEditingController;
  final String hintText;
  final TextInputType textInputType;
  final bool isPass;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String title;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged; 

  const TextFieldInput({
    super.key,
    required this.textEditingController,
    required this.hintText,
    required this.textInputType,
    required this.title,
    this.isPass = false,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    this.onChanged, 
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          TextFormField(
            controller: textEditingController,
            keyboardType: textInputType,
            obscureText: isPass,
            decoration: InputDecoration(
              prefixIcon: prefixIcon,
              suffixIcon: suffixIcon,
              hintText: hintText,
              border: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.grey,
                ),
              ),
            ),
            validator: validator,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
