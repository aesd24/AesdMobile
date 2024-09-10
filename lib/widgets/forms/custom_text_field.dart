import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String? hintText;
  final IconData? icon;
  final ValueChanged<String>? onChanged;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final FormFieldValidator<String>? validator;
  final GlobalKey<FormFieldState>? formFieldKey;
  final String? errorText;
  final bool obscureText;
  final Icon? prefixedIcon;

  const CustomTextField({
    super.key,
    this.icon,
    this.hintText,
    this.onChanged,
    this.controller,
    this.keyboardType,
    this.validator,
    this.formFieldKey,
    this.errorText,
    required this.obscureText,
    this.prefixedIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      elevation: 2,
      child: TextFormField(
        cursorColor: Colors.black54,
        cursorWidth: 2,
        obscureText: obscureText,
        validator: validator,
        controller: controller,
        onChanged: onChanged,
        keyboardType: keyboardType ?? TextInputType.text,
        style: const TextStyle(color: Colors.black54),
        decoration: InputDecoration(
          border: InputBorder.none,
          filled: true,
          fillColor: Colors.white,
          prefixIcon: prefixedIcon,
          hintText: hintText,
          hintStyle: const TextStyle(
            color: Colors.black54,
            fontWeight: FontWeight.bold,
            fontFamily: 'PTSans',
          ),
        ),
      ),
    );
  }
}

/*
return Container(
      width: size.width * 0.8,
      child: TextFormField(
        onChanged: onChanged,
        cursorColor: kPrimaryColor,
        controller: controller,
        keyboardType: this.keyboardType ?? TextInputType.text,
        validator: this.validator,
        style: TextStyle(
          color: kGrayColor,
          fontWeight: FontWeight.w500
        ),
        decoration: InputDecoration(
          hintText: hintText,
          fillColor: inputBgColor,
          focusColor: kPrimaryColor,
          prefixIcon: Icon(
            icon,
            color: kPrimaryColor,
            size: 18.0
          ),
          hintStyle: TextStyle(color: kGrayColor),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(29.0),
            borderSide: BorderSide(width: 0.0, style: BorderStyle.none)
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 1.0, color: kPrimaryColor),
            borderRadius: BorderRadius.circular(29.0)
          ),
          filled: true,
          contentPadding: const EdgeInsets.all(12.0),
        ),
      ),
    );
    */
