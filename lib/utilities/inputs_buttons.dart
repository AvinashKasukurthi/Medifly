import 'package:flutter/material.dart';
import 'constants.dart';

class TextInputField extends StatelessWidget {
  TextInputField({@required this.hintText, this.isOtp});
  final String hintText;
  final bool isOtp;
  String phoneNum;
  @override
  Widget build(BuildContext context) {
//    otpState = true;
    return TextField(
      onChanged: (val) {
        this.phoneNum = val;
      },
      textAlign: TextAlign.center,
      decoration: InputDecoration(
        filled: true,
        fillColor: kCardsColor,
        hintText: hintText,
        border: OutlineInputBorder(
          // borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide.none,
        ),
      ),
      keyboardType: TextInputType.number,
    );
  }
}
