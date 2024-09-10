import 'package:flutter/material.dart';

Widget customDropDownField({
  required String label,
  required List<Map<String, dynamic>> items,
  FormFieldValidator? validator,
  void Function(dynamic)? onChange,
  String? value,
  String? selectedValue,
  String? placeholder,
  Icon? prefixIcon
}){
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 10),
    child: DropdownButtonFormField(
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.green, width: 2)
        ),
        prefixIcon: prefixIcon,
        labelText: label,
        hintText: placeholder
      ),
      validator: validator,
      value: value,
      dropdownColor: Colors.green.shade50,
      items: List.generate(items.length, (i){
        var item = items[i];
        return DropdownMenuItem(
          value: item["code"],
          child: Text(item["name"]!)
        );
      }),
      icon: const Icon(Icons.keyboard_arrow_down),
      onChanged: onChange
    ),
  );
}