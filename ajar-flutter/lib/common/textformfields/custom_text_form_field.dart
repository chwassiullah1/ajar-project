import 'package:flutter/material.dart';
import 'package:ajar/utils/theme_colors_constants.dart';
import 'package:flutter/services.dart';

class CustomTextFormField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool obscureText;
  final bool isPasswordField;
  final VoidCallback? toggleVisibility;
  final String? Function(String?)? validator;
  final FocusNode? focusNode;
  final bool? isEditable;
  final bool? showIcon; // New field to determine if icon should be shown
  final IconData? iconData; // New field for custom icon
  final VoidCallback? onIconPress; // New field for icon press action
  final int? maxLength; // New field for maximum text length
  final int? maxLines; // New field for maximum lines
  final List<TextInputFormatter>?
      inputFormatters; // New field for inputFormatters

  const CustomTextFormField({
    super.key,
    required this.label,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.isPasswordField = false,
    this.toggleVisibility,
    this.validator,
    this.focusNode,
    this.isEditable,
    this.showIcon, // New argument for showing optional icon
    this.iconData, // New argument for custom icon
    this.onIconPress, // New argument for icon press action
    this.maxLength, // Optional maximum text length
    this.maxLines, // Optional maximum lines of text
    this.inputFormatters, // Optional inputFormatters
  });

  @override
  Widget build(BuildContext context) {
    // Determine the current theme mode (light or dark)
    Brightness brightness = Theme.of(context).brightness;
    bool isDarkMode = brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        maxLines: maxLines ?? 1,
        maxLength: maxLength,
        controller: controller,
        keyboardType: keyboardType,
        focusNode: focusNode,
        obscureText: obscureText,
        validator: validator,
        inputFormatters: inputFormatters,
        style: TextStyle(
          color: isDarkMode ? Colors.white : Colors.grey.shade900,
        ),
        enabled: isEditable,
        decoration: InputDecoration(
          errorStyle: const TextStyle(height: 0),
          labelText: label,
          labelStyle: TextStyle(
              fontSize: 14,
              color: isDarkMode ? Colors.white : Colors.grey.shade500),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          filled: true,
          fillColor: isDarkMode ? fdarkBlue : Colors.grey[200],
          hintStyle: TextStyle(
            fontSize: 12,
            color: isDarkMode ? Colors.white : Colors.grey.shade500,
          ),
          // Add icon based on password field or custom logic
          suffixIcon: isPasswordField
              ? IconButton(
                  icon: Icon(
                    obscureText ? Icons.visibility_off : Icons.visibility,
                    size: 18,
                    color: isDarkMode ? Colors.white : fMainColor,
                  ),
                  onPressed: toggleVisibility, // Toggle visibility action
                )
              : (showIcon == true
                  ? IconButton(
                      icon: Icon(
                        iconData ?? Icons.info, // Default to info icon
                        size: 18,
                        color: isDarkMode ? Colors.white : fMainColor,
                      ),
                      onPressed: onIconPress, // Custom action on icon press
                    )
                  : null),
        ),
      ),
    );
  }
}
