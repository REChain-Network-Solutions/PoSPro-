import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class TabButton extends StatelessWidget {
  TabButton({
    required this.title,
    required this.text,
    required this.background,
    required this.press,
    Key? key,
  }) : super(key: key);
  final Color background;
  final Color text;
  final String title;
  // ignore: prefer_typing_uninitialized_variables
  var press;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40.0,
      width: 100.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        color: background,
      ),
      child: Center(
        child: TextButton(
          onPressed: press,
          child: Text(
            title,
            style: GoogleFonts.poppins(
              color: text,
            ),
          ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class TabButtonSmall extends StatelessWidget {
  TabButtonSmall({
    required this.title,
    required this.text,
    required this.background,
    required this.press,
    Key? key,
  }) : super(key: key);
  final Color background;
  final Color text;
  final String title;
  // ignore: prefer_typing_uninitialized_variables
  var press;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40.0,
      width: 90.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        color: background,
      ),
      child: Center(
        child: TextButton(
          onPressed: press,
          child: Text(
            title,
            style: GoogleFonts.poppins(
              color: text,
            ),
          ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class TabButtonBig extends StatelessWidget {
  TabButtonBig({
    required this.title,
    required this.text,
    required this.background,
    required this.press,
    Key? key,
  }) : super(key: key);
  final Color background;
  final Color text;
  final String title;
  // ignore: prefer_typing_uninitialized_variables
  var press;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        color: background,
      ),
      child: Center(
        child: TextButton(
          onPressed: press,
          child: Text(
            title,
            style: GoogleFonts.poppins(
              color: text,
            ),
          ),
        ),
      ),
    );
  }
}
