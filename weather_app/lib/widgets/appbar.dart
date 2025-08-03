import 'dart:ui';
import 'package:flutter/material.dart';
import "package:google_fonts/google_fonts.dart";

class Appbar extends StatelessWidget implements PreferredSizeWidget {
  final String heading;
  const Appbar({Key? key, required this.heading}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      // Optional: to prevent blur bleed
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10), // Blur strength
        child: AppBar(
          backgroundColor: Colors.white.withOpacity(0), // Frosted look
          elevation: 0,
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
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56);
}
