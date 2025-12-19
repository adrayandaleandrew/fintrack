import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Custom text field widget with consistent styling and validation
///
/// Provides a reusable text input component with built-in validation,
/// error handling, and various input types.
class CustomTextField extends StatefulWidget {
  /// Text editing controller
  final TextEditingController controller;

  /// Field label
  final String label;

  /// Hint text
  final String? hint;

  /// Validation function
  final String? Function(String?)? validator;

  /// Keyboard type
  final TextInputType keyboardType;

  /// Obscure text (for passwords)
  final bool obscureText;

  /// Enable/disable field
  final bool enabled;

  /// Read-only field
  final bool readOnly;

  /// Max lines
  final int maxLines;

  /// Max length
  final int? maxLength;

  /// Prefix icon
  final IconData? prefixIcon;

  /// Suffix icon
  final IconData? suffixIcon;

  /// Suffix icon pressed callback
  final VoidCallback? onSuffixIconPressed;

  /// Text changed callback
  final ValueChanged<String>? onChanged;

  /// Input formatters
  final List<TextInputFormatter>? inputFormatters;

  /// Auto-validate mode
  final AutovalidateMode autovalidateMode;

  /// Text capitalization
  final TextCapitalization textCapitalization;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.label,
    this.hint,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.enabled = true,
    this.readOnly = false,
    this.maxLines = 1,
    this.maxLength,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixIconPressed,
    this.onChanged,
    this.inputFormatters,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
    this.textCapitalization = TextCapitalization.none,
  });

  /// Email text field
  factory CustomTextField.email({
    Key? key,
    required TextEditingController controller,
    String label = 'Email',
    String? hint,
    String? Function(String?)? validator,
    bool enabled = true,
    ValueChanged<String>? onChanged,
  }) {
    return CustomTextField(
      key: key,
      controller: controller,
      label: label,
      hint: hint,
      validator: validator,
      keyboardType: TextInputType.emailAddress,
      prefixIcon: Icons.email_outlined,
      enabled: enabled,
      onChanged: onChanged,
    );
  }

  /// Password text field with show/hide toggle
  static Widget password({
    Key? key,
    required TextEditingController controller,
    String label = 'Password',
    String? hint,
    String? Function(String?)? validator,
    bool enabled = true,
    ValueChanged<String>? onChanged,
  }) {
    return _PasswordTextField(
      key: key,
      controller: controller,
      label: label,
      hint: hint,
      validator: validator,
      enabled: enabled,
      onChanged: onChanged,
    );
  }

  /// Number text field
  factory CustomTextField.number({
    Key? key,
    required TextEditingController controller,
    required String label,
    String? hint,
    String? Function(String?)? validator,
    bool enabled = true,
    int? maxLength,
    ValueChanged<String>? onChanged,
  }) {
    return CustomTextField(
      key: key,
      controller: controller,
      label: label,
      hint: hint,
      validator: validator,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      enabled: enabled,
      maxLength: maxLength,
      onChanged: onChanged,
    );
  }

  /// Decimal text field
  factory CustomTextField.decimal({
    Key? key,
    required TextEditingController controller,
    required String label,
    String? hint,
    String? Function(String?)? validator,
    bool enabled = true,
    ValueChanged<String>? onChanged,
  }) {
    return CustomTextField(
      key: key,
      controller: controller,
      label: label,
      hint: hint,
      validator: validator,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
      ],
      enabled: enabled,
      onChanged: onChanged,
    );
  }

  /// Multiline text field
  factory CustomTextField.multiline({
    Key? key,
    required TextEditingController controller,
    required String label,
    String? hint,
    String? Function(String?)? validator,
    bool enabled = true,
    int maxLines = 3,
    int? maxLength,
    ValueChanged<String>? onChanged,
  }) {
    return CustomTextField(
      key: key,
      controller: controller,
      label: label,
      hint: hint,
      validator: validator,
      keyboardType: TextInputType.multiline,
      maxLines: maxLines,
      maxLength: maxLength,
      enabled: enabled,
      onChanged: onChanged,
    );
  }

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return Semantics(
      textField: true,
      enabled: widget.enabled,
      readOnly: widget.readOnly,
      label: widget.label,
      hint: widget.hint ?? 'Enter ${widget.label.toLowerCase()}',
      child: TextFormField(
        controller: widget.controller,
        decoration: InputDecoration(
          labelText: widget.label,
          hintText: widget.hint,
          prefixIcon: widget.prefixIcon != null
              ? Icon(widget.prefixIcon)
              : null,
          suffixIcon: widget.suffixIcon != null
              ? IconButton(
                  icon: Icon(widget.suffixIcon),
                  onPressed: widget.onSuffixIconPressed,
                )
              : null,
          counterText: widget.maxLength != null ? null : '',
        ),
        validator: widget.validator,
        keyboardType: widget.keyboardType,
        obscureText: widget.obscureText,
        enabled: widget.enabled,
        readOnly: widget.readOnly,
        maxLines: widget.maxLines,
        maxLength: widget.maxLength,
        inputFormatters: widget.inputFormatters,
        onChanged: widget.onChanged,
        autovalidateMode: widget.autovalidateMode,
        textCapitalization: widget.textCapitalization,
      ),
    );
  }
}

/// Password text field with show/hide toggle
class _PasswordTextField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String? hint;
  final String? Function(String?)? validator;
  final bool enabled;
  final ValueChanged<String>? onChanged;

  const _PasswordTextField({
    super.key,
    required this.controller,
    required this.label,
    this.hint,
    this.validator,
    this.enabled = true,
    this.onChanged,
  });

  @override
  State<_PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<_PasswordTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      child: CustomTextField(
        controller: widget.controller,
        label: widget.label,
        hint: widget.hint,
        validator: widget.validator,
        obscureText: _obscureText,
        prefixIcon: Icons.lock_outlined,
        suffixIcon: _obscureText ? Icons.visibility : Icons.visibility_off,
        onSuffixIconPressed: () {
          setState(() {
            _obscureText = !_obscureText;
          });
        },
        enabled: widget.enabled,
        onChanged: widget.onChanged,
      ),
    );
  }
}
