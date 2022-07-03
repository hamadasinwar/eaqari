import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final String hint;
  final String? text;
  final TextEditingController? controller;
  final int maxLines;
  final bool mini;
  final bool? enabled;
  final Widget? leading;
  final ValueChanged<String>? onChanged;

  const MyTextField({
    Key? key,
    required this.hint,
    this.controller,
    this.mini = false,
    this.maxLines = 1,
    this.text,
    this.onChanged,
    this.leading, this.enabled,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.16),
            blurRadius: 6,
            spreadRadius: 1,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        enabled: enabled,
        onChanged: (String value) {
          if (onChanged != null) {
            onChanged!(value);
          }
        },
        initialValue: text,
        obscureText: hint.contains("مرور"),
        maxLines: maxLines,
        minLines: maxLines != 1 ? 3 : 1,
        keyboardType: getInputType(),
        style: TextStyle(height: mini ? 0.5 : null),
        decoration: InputDecoration(
          prefixIcon: leading,
          labelText: hint,
          fillColor: Colors.white,
          filled: true,
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).primaryColor,
              width: 0.5,
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Color(-9408400),
              width: 0.5,
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey[400]!,
              width: 0.5,
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Colors.red,
              width: 0.5,
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Colors.red,
              width: 0.5,
            ),
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'الرجاء ملء الحقول';
          } else {
            if (hint == 'كلمة المرور' && value.length < 8) {
              return 'كلمة المرور يجب أن تكون 8 حروف واكثر';
            } else if (hint == 'رقم الموبايل' && value.length < 10) {
              return 'رقم موبايل خاطئ';
            }
          }
          return null;
        },
      ),
    );
  }

  TextInputType? getInputType() {
    TextInputType? type;
    switch (hint) {
      case "رقم الموبايل":
        type = TextInputType.phone;
        break;
      case "مساحة العقار م²":
        type = TextInputType.number;
        break;
      case "المبلغ شهرياً NIS":
        type = TextInputType.number;
        break;
      default :
        type = TextInputType.name;
        break;
    }
    return type;
  }
}
