import 'package:flutter/material.dart';

class TextFieldWidget extends StatelessWidget {
  const TextFieldWidget({
    super.key,
    required this.label,
    this.controller,
    this.textInputType = TextInputType.text,
    this.validator,
  });

  final String label;
  final TextEditingController? controller;
  final TextInputType? textInputType;
  final FormFieldValidator<String>? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      controller: controller,
      maxLines: 1,
      keyboardType: textInputType,
      decoration: InputDecoration(
        label: Text(label),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            width: 1,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
