import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:chat_api_app/components/app_theme.dart';

class CustomAddField extends StatelessWidget {
  const CustomAddField({
    required this.hintText,
    this.icon = Icons.space_bar,
    this.obscureText = false,
    required this.maxLines,
    required this.keyboardType,
    required this.onChanged,
    required this.onSaved,
    required this.validator,
    Key? key,
  }) : super(key: key);

  final String hintText;
  final IconData icon;
  final bool obscureText;
  final int maxLines;
  final TextInputType keyboardType;
  final Function(String) onChanged;
  final FormFieldSetter<String> onSaved;
  final FormFieldValidator<String> validator;

  @override
  Widget build(BuildContext context) {
    return Padding(
      // padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 12.0),
      padding:
          const EdgeInsets.only(left: 8.0, right: 8.0, top: 8, bottom: 15.0),
      child: TextFormField(
        inputFormatters: (hintText == '₩ 가격')
            ? [
                CurrencyTextInputFormatter(
                  locale: 'ko',
                  decimalDigits: 0,
                  symbol: '￦',
                )
              ]
            : null,
        cursorColor: AppTheme.kDarkGreenColor,
        obscureText: obscureText,
        // textInputAction: TextInputAction.newline,
        keyboardType: keyboardType,
        minLines: (maxLines == 0) ? 5 : maxLines,
        // maxLines: (maxLines == 0) ? 100 : maxLines,
        maxLines: (maxLines == 0) ? 100 : 3,
        // expands: true,
        // maxLength: 100,
        // maxLengthEnforcement: MaxLengthEnforcement.enforced,
        // expands: true,
        style: AppTheme.signForm,
        // textInputAction: TextInputAction.done,
        // onFieldSubmitted: (value) {
        //   // 입력이 완료될 때 호출되는 콜백
        // },
        decoration: InputDecoration(
          labelText: hintText,
          // hintText: hintText,
          errorStyle: AppTheme.signError,
          // contentPadding: const EdgeInsets.all(10.0),
          contentPadding: const EdgeInsets.only(left: 8, bottom: 8),
          // filled: true,
          // fillColor: AppTheme.kGinColor,
          labelStyle: AppTheme.signForm,
          hintStyle: AppTheme.signForm,
          alignLabelWithHint: true,
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(
              color: AppTheme.kGinColor,
            ),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(
              color: AppTheme.kDarkGreenColor,
            ),
          ),
          focusedErrorBorder: const UnderlineInputBorder(
            borderSide: BorderSide(
              color: AppTheme.kDarkGreenColor,
            ),
          ),
          errorBorder: const UnderlineInputBorder(
            borderSide: BorderSide(
              color: AppTheme.kDarkGreenColor,
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
