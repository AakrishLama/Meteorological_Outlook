import 'dart:ui';
import 'package:flutter/material.dart';
import "package:google_fonts/google_fonts.dart";

class Appbar extends StatelessWidget implements PreferredSizeWidget {
  final String heading;
  const Appbar({Key? key, required this.heading}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      duration: Duration(milliseconds: 500),
      tween: Tween<double>(begin: 0.0, end: 1.0),
      builder: (BuildContext context, double? value, Widget? child) { 
        return Opacity(
          opacity: value!,
          child: Padding(
            padding: EdgeInsets.only( top: value*18), 
            child: child,),
        );
       },
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10), // Blur strength
          child: AppBar(
            backgroundColor: Colors.white.withOpacity(0), 
            elevation: 1,
            centerTitle: true,
            title: Text(
              heading,
              style: GoogleFonts.vollkorn(
                fontSize: 40,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              )
            ),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56);
}
