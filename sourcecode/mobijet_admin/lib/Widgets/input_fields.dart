import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:thinkcreative_technologies/Configs/my_colors.dart';
import 'package:thinkcreative_technologies/Widgets/PhoneField/intl_phone_field.dart';
import 'package:thinkcreative_technologies/Widgets/PhoneField/phone_number.dart';

class MobileInputWithOutline extends StatefulWidget {
  final String? initialCountryCode;
  final String? hintText;
  final double? height;
  final double? width;
  final TextEditingController? controller;
  final Color? borderColor;
  final Color? buttonTextColor;
  final Color? buttonhintTextColor;
  final TextStyle? hintStyle;
  final String? buttonText;
  final Function(PhoneNumber? phone)? onSaved;

  MobileInputWithOutline(
      {this.height,
      this.width,
      this.borderColor,
      this.buttonhintTextColor,
      this.hintStyle,
      this.buttonTextColor,
      this.onSaved,
      this.hintText,
      this.controller,
      this.initialCountryCode,
      this.buttonText});
  @override
  _MobileInputWithOutlineState createState() => _MobileInputWithOutlineState();
}

class _MobileInputWithOutlineState extends State<MobileInputWithOutline> {
  BoxDecoration boxDecoration(
      {double radius = 5,
      Color bgColor = Colors.white,
      var showShadow = false}) {
    return BoxDecoration(
        color: bgColor,
        boxShadow: showShadow
            ? [
                BoxShadow(
                    color: Mycolors.primary, blurRadius: 10, spreadRadius: 2)
              ]
            : [BoxShadow(color: Colors.transparent)],
        border:
            Border.all(color: widget.borderColor ?? Mycolors.grey, width: 1.5),
        borderRadius: BorderRadius.all(Radius.circular(radius)));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: EdgeInsetsDirectional.only(bottom: 7, top: 5),
          height: widget.height ?? 50,
          width: widget.width ?? MediaQuery.of(this.context).size.width,
          decoration: boxDecoration(bgColor: Mycolors.greylightcolor),
          child: IntlPhoneField(
              textAlign: TextAlign.left,
              initialCountryCode: widget.initialCountryCode,
              controller: widget.controller,
              style: TextStyle(
                  height: 1.35,
                  letterSpacing: 1,
                  fontSize: 16.0,
                  color: widget.buttonTextColor ?? Colors.black87,
                  fontWeight: FontWeight.bold),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(3, 15, 8, 0),
                  hintText: widget.hintText ?? "Mobile Number",
                  hintStyle: widget.hintStyle ??
                      TextStyle(
                          letterSpacing: 1,
                          height: 0.0,
                          fontSize: 15.5,
                          fontWeight: FontWeight.w400,
                          color: Mycolors.greylightcolor),
                  fillColor: Mycolors.grey,
                  filled: true,
                  border: new OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                    borderSide: BorderSide.none,
                  )),
              onChanged: (phone) {
                widget.onSaved!(phone);
              },
              validator: (v) {
                return null;
              },
              onSaved: widget.onSaved),
        ),
        // Positioned(
        //     left: 110,
        //     child: Container(
        //       width: 1.5,
        //       height: widget.height ?? 48,
        //       color: widget.borderColor ??Mycolors.grey,
        //     ))
      ],
    );
  }
}
