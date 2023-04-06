import 'package:flutter/material.dart';
import 'package:chat_api_app/components/app_theme.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    required this.hintText,
    this.icon = Icons.space_bar,
    this.obscureText = false,
    required this.keyboardType,
    required this.onChanged,
    required this.onSaved,
    required this.validator,
    Key? key,
  }) : super(key: key);

  final String hintText;
  final IconData icon;
  final bool obscureText;
  final TextInputType keyboardType;
  final Function(String) onChanged;
  final FormFieldSetter<String> onSaved;
  final FormFieldValidator<String> validator;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 15.0),
      child: TextFormField(
        cursorColor: AppTheme.kDarkGreenColor,
        obscureText: obscureText,
        keyboardType: keyboardType,
        // style: GoogleFonts.notoSansNKo(
        //   color: AppTheme.kDarkGreenColor,
        //   fontWeight: FontWeight.w600,
        //   fontSize: 15.0,
        // ),
        style: AppTheme.signForm,
        decoration: InputDecoration(
          suffixIcon: (icon == Icons.space_bar)
              ? null
              : Icon(
                  icon,
                  color: AppTheme.kDarkGreenColor,
                ),
          labelText: hintText,
          // hintText: hintText,
          errorStyle: AppTheme.signError,
          contentPadding: const EdgeInsets.all(18.0),
          filled: true,
          fillColor: AppTheme.kGinColor,
          labelStyle: AppTheme.signForm,
          hintStyle: AppTheme.signForm,
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
            borderSide: BorderSide(
              color: AppTheme.kGinColor,
            ),
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
            borderSide: BorderSide(
              color: AppTheme.kDarkGreenColor,
            ),
          ),
          focusedErrorBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
            borderSide: BorderSide(
              color: AppTheme.kDarkGreenColor,
            ),
          ),
          errorBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
            borderSide: BorderSide(
              color: AppTheme.kGinColor,
            ),
          ),
        ),
        onChanged: onChanged,
        onSaved: onSaved,
        validator: validator,
      ),
    );
  }
}
