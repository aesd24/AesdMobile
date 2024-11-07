import "package:flutter/material.dart";

Widget customTextField({
  required String label,
  String? placeholder,
  FocusNode? focusNode,
  TextEditingController? controller,
  FormFieldValidator? validator,
  TextInputType? type,
  bool obscureText = false,
  Widget? prefixIcon,
  Widget? suffix,
  void Function(String)? onChanged
}){
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 10),
    child: TextFormField(
      focusNode: focusNode,
      textAlignVertical: TextAlignVertical.center,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade200, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7),
          borderSide: const BorderSide(color: Colors.green, width: 2)
        ),
        label: Text(label),
        prefixIcon: prefixIcon,
        suffixIcon: suffix,
        fillColor: Colors.grey.shade600,
        hintText: placeholder,
      ),
      onChanged: onChanged,
      validator: validator,
      obscureText: obscureText, 
      keyboardType: type ?? TextInputType.text,
      controller: controller,
    ),
  );
}

Widget customMultilineField({
  required String label,
  TextEditingController? controller,
  int? maxLength,
  int? maxLines,
  FormFieldValidator? validator,
  void Function(String)? onChanged
}){
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 10),
    child: TextFormField(
      textAlignVertical: TextAlignVertical.center,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade200, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7),
          borderSide: const BorderSide(color: Colors.green, width: 2)
        ),
        fillColor: Colors.grey.shade600,
        hintText: label,
      ),
      onChanged: onChanged,
      validator: validator,
      keyboardType: TextInputType.multiline,
      maxLines: maxLines ?? 6,
      maxLength: maxLength,
      controller: controller,
    ),
  );
}
