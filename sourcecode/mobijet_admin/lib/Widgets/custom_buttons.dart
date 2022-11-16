import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:thinkcreative_technologies/Configs/my_colors.dart';
import 'package:thinkcreative_technologies/Widgets/custom_text.dart';

class MySimpleButton extends StatefulWidget {
  final Color? buttoncolor;
  final Color? buttontextcolor;
  final Color? shadowcolor;
  final String? buttontext;
  final double? width;
  final double? height;
  final double? spacing;
  final double? borderradius;
  final Function? onpressed;
  final Widget? icon;

  MySimpleButton(
      {this.buttontext,
      this.buttoncolor,
      this.height,
      this.spacing,
      this.borderradius,
      this.width,
      this.buttontextcolor,
      this.icon,
      this.onpressed,
      // this.forcewidget,
      this.shadowcolor});
  @override
  _MySimpleButtonState createState() => _MySimpleButtonState();
}

class _MySimpleButtonState extends State<MySimpleButton> {
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return GestureDetector(
        onTap: widget.onpressed as void Function()?,
        child: Container(
          alignment: Alignment.center,
          width: widget.width ?? w - 40,
          height: widget.height ?? 50,
          padding: EdgeInsets.fromLTRB(16, 10, 16, 10),
          child: widget.icon != null
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MtCustomfontMedium(
                      spacing: widget.spacing ?? 2,
                      fontsize: 15,
                      color: widget.buttontextcolor ?? Colors.white,
                      text: widget.buttontext ?? 'SUBMIT',
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    widget.icon!
                  ],
                )
              : MtCustomfontMedium(
                  spacing: widget.spacing ?? 2,
                  fontsize: 15,
                  color: widget.buttontextcolor ?? Colors.white,
                  text: widget.buttontext ?? 'SUBMIT',
                ),
          decoration: BoxDecoration(
              color: widget.buttoncolor ?? Mycolors.primary,
              //gradient: LinearGradient(colors: [bgColor, whiteColor]),
              boxShadow: [
                BoxShadow(
                    color: widget.shadowcolor ?? Colors.transparent,
                    blurRadius: 10,
                    spreadRadius: 2)
              ],
              border: Border.all(
                color: widget.buttoncolor ?? Mycolors.primary,
              ),
              borderRadius:
                  BorderRadius.all(Radius.circular(widget.borderradius ?? 5))),
        ));
  }
}

class MySimpleButtonWithIcon extends StatefulWidget {
  final Color? buttoncolor;
  final Color? buttontextcolor;
  final Color? shadowcolor;
  final String? buttontext;
  final double? width;
  final double? height;
  final IconData? iconData;
  final double? spacing;
  final double? borderradius;
  final Function? onpressed;

  MySimpleButtonWithIcon(
      {this.buttontext,
      this.buttoncolor,
      this.height,
      this.spacing,
      this.iconData,
      this.borderradius,
      this.width,
      this.buttontextcolor,
      // this.icon,
      this.onpressed,
      // this.forcewidget,
      this.shadowcolor});
  @override
  _MySimpleButtonWithIconState createState() => _MySimpleButtonWithIconState();
}

class _MySimpleButtonWithIconState extends State<MySimpleButtonWithIcon> {
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(this.context).size.width;
    return GestureDetector(
        onTap: widget.onpressed as void Function()?,
        child: Container(
          alignment: Alignment.center,
          width: widget.width ?? w,
          height: widget.height ?? 50,
          padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
          child: Stack(
            children: [
              Container(
                alignment: Alignment.center,
                child: Text(
                  widget.buttontext ?? "Submit",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    // letterSpacing: widget.spacing ?? 0,
                    fontSize: 16,
                    fontFamily: 'Proxima-Nova-SemiBold',
                    color: widget.buttontextcolor ?? Colors.white,
                  ),
                ),
              ),
              Positioned(
                  right: 5,
                  top: 3,
                  child: Center(
                    child: Icon(
                      widget.iconData ?? LineAwesomeIcons.arrow_right,
                      color: Colors.white,
                      size: 22,
                    ),
                  ))
            ],
          ),
          decoration: BoxDecoration(
              color: widget.buttoncolor ?? Colors.primaries as Color?,
              //gradient: LinearGradient(colors: [bgColor, whiteColor]),
              boxShadow: [
                BoxShadow(
                    color: widget.shadowcolor ?? Colors.transparent,
                    blurRadius: 10,
                    spreadRadius: 2)
              ],
              border: Border.all(
                color: widget.buttoncolor ?? Colors.green,
              ),
              borderRadius:
                  BorderRadius.all(Radius.circular(widget.borderradius ?? 5))),
        ));
  }
}
