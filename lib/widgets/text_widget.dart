import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextWidget extends StatelessWidget {
  TextWidget({
    Key? key,
    required this.text,
    required this.color,
    this.textSize = 16,
    this.maxLines = 10,
    this.isTitle = false,
  }) : super(key: key);
  final String text;
  final Color color;
  final double textSize;
  bool isTitle;
  int maxLines = 10;
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      overflow: TextOverflow.ellipsis,
      maxLines: maxLines,
      style:isTitle ? GoogleFonts.montserrat(
            fontSize: textSize,
            color: color,
            // overflow: TextOverflow.ellipsis,
            fontWeight: FontWeight.bold
      ):GoogleFonts.montserrat(
          fontSize: textSize,
          color: color,
          // overflow: TextOverflow.ellipsis,
          fontWeight: FontWeight.normal
      )
      );
  }
}