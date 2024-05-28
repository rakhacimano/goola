import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.label,
    required this.amount,
    required this.onChangeAmount,
    this.hint,
    this.prefixIcon,
    this.suffixIcon,
    this.isPassword = false,
  });

  final String amount;
  final ValueChanged<String> onChangeAmount;

  final String label;
  final String? hint;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final bool isPassword;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        buildGlucoseField(),
      ],
    );
  }

  TextFormField buildGlucoseField() {
    return TextFormField(
      maxLength: 3,
      onChanged: onChangeAmount,
      initialValue: amount,
      validator: (amount) {
        return amount != null && amount.isEmpty ? 'Amount cannot be empty!' : null;
      },
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      style: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
      textAlign: TextAlign.center,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 24),
        hintText: hint,
        hintStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        counterText: '', // Add this line to hide the counter text
      ),
    );
  }
}
