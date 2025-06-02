import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? label;
  final bool obscureText;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final Color? fillColor;
  final Color? borderColor;
  final bool filled;
  final String? hint;
  final int? maxLines;
  final TextInputAction? textInputAction;
  final void Function(String)? onSubmitted;
  final void Function(String)? onChanged;

  // Dropdown-specific fields
  final bool isDropdown;
  final List<String>? items;
  final String? selectedValue;
  final void Function(String?)? onDropdownChanged;

  const CustomTextField({
    super.key,
    this.controller,
    this.label,
    this.obscureText = false,
    this.suffixIcon,
    this.keyboardType,
    this.validator,
    this.fillColor,
    this.borderColor,
    this.filled = true,
    this.hint,
    this.maxLines = 1,
    this.textInputAction,
    this.onSubmitted,
    this.onChanged,
    this.isDropdown = false,
    this.items,
    this.selectedValue,
    this.onDropdownChanged,
  });

  @override
  Widget build(BuildContext context) {
    final Color actualFillColor = fillColor ?? AppColors.cultured;
    final Color actualBorderColor = borderColor ?? AppColors.gunmetal;

    final inputDecoration = InputDecoration(
      hintText: hint,
      hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
        color: AppColors.onBackground.withOpacity(0.5),
      ),
      filled: filled,
      fillColor: actualFillColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: actualBorderColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: actualBorderColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.blue, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.error, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.error, width: 2),
      ),
      errorStyle: TextStyle(color: AppColors.error),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      suffixIcon: suffixIcon,
    );

    // Use DropdownButtonFormField if isDropdown is true
    if (isDropdown) {
      return DropdownButtonFormField<String>(
        value: selectedValue,
        items: items
            ?.map((item) => DropdownMenuItem(
          value: item,
          child: Text(item),
        ))
            .toList(),
        onChanged: onDropdownChanged,
        validator: validator,
        decoration: inputDecoration,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
          color: AppColors.onBackground,
        ),
      );
    }

    // Default to TextFormField
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      maxLines: maxLines,
      textInputAction: textInputAction,
      onFieldSubmitted: onSubmitted,
      onChanged: onChanged,
      style: Theme.of(context)
          .textTheme
          .bodyLarge
          ?.copyWith(color: AppColors.onBackground),
      decoration: inputDecoration.copyWith(labelText: label),
      validator: validator,
    );
  }
}
