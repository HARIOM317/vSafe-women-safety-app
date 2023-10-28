import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget{
  final String? hintText;
  final TextEditingController? controller;
  final String? Function(String?)? validate;
  final Function(String?)? onSave;
  final int? maxLines;
  final bool isPassword;
  final bool isEnable;
  final bool? check;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;
  final Widget? prefix;
  final Widget? suffix;

  const CustomTextField(
      {
        super.key,
        this.hintText,
        this.focusNode,
        this.textInputAction,
        this.controller,
        this.isEnable = true,
        this.isPassword = false,
        this.check,
        this.keyboardType,
        this.maxLines,
        this.onSave,
        this.prefix,
        this.suffix,
        this.validate
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: const TextStyle(
        fontFamily: 'PTSans-Regular',
      ),
      enabled: isEnable == true ? true : isEnable,
      maxLines: maxLines ?? 1,
      onSaved: onSave,
      focusNode: focusNode,
      textInputAction: textInputAction,
      keyboardType: keyboardType ?? TextInputType.name,
      controller: controller,
      validator: validate,
      obscureText: isPassword == false ? false : isPassword,

      decoration: InputDecoration(
        prefixIcon: prefix,
        suffixIcon: suffix,
        labelText: hintText ?? "Hint text...",

        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            style: BorderStyle.solid,
            color: Color(0xff5720c6),
            width: 1.5
            )
          ),

          enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(
                  style: BorderStyle.solid,
                  color: Color(0xFF909A9E),
              ),
          ),

          focusedErrorBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                  style: BorderStyle.solid,
                  color: Theme.of(context).primaryColor
              )
          ),

        errorBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            style: BorderStyle.solid,
            color: Colors.deepOrange
          )
        )
        ),
      );
  }
}

class LoginTextField extends StatelessWidget{
  final String? hintText;
  final TextEditingController? controller;
  final String? Function(String?)? validate;
  final Function(String?)? onSave;
  final int? maxLines;
  final bool isPassword;
  final bool isEnable;
  final bool? check;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;
  final Widget? prefix;
  final Widget? suffix;

  const LoginTextField(
      {
        super.key,
        this.hintText,
        this.focusNode,
        this.textInputAction,
        this.controller,
        this.isEnable = true,
        this.isPassword = false,
        this.check,
        this.keyboardType,
        this.maxLines,
        this.onSave,
        this.prefix,
        this.suffix,
        this.validate
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: const TextStyle(
        fontFamily: 'PTSans-Regular',
      ),
      enabled: isEnable == true ? true : isEnable,
      maxLines: maxLines ?? 1,
      onSaved: onSave,
      focusNode: focusNode,
      textInputAction: textInputAction,
      keyboardType: keyboardType ?? TextInputType.name,
      controller: controller,
      validator: validate,
      obscureText: isPassword == false ? false : isPassword,

      decoration: InputDecoration(
          prefixIcon: prefix,
          suffixIcon: suffix,
          labelText: hintText ?? "Hint text...",

          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: const BorderSide(
                  style: BorderStyle.solid,
                  color: Color(0xff5720c6),
                  width: 1.5
              )
          ),

          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(
              style: BorderStyle.solid,
              color: Color(0xFF909A9E),
            ),
          ),

          focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(
                  style: BorderStyle.solid,
                  color: Theme.of(context).primaryColor
              )
          ),

          errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: const BorderSide(
                  style: BorderStyle.solid,
                  color: Colors.deepOrange
              )
          )
      ),
    );
  }
}