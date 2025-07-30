import 'package:flutter/material.dart';
import "package:google_fonts/google_fonts.dart";

class Input extends StatelessWidget {
  // controller for the text field
  final TextEditingController inputController;
  // callback function to be called when the user submits the input
  final VoidCallback? onSubmit;

  const Input({super.key, required this.inputController, this.onSubmit});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 400,
      height: 70, // Slightly taller for better visual impact
      child: TextField(
        controller: inputController,
        autofocus: true,
        style: GoogleFonts.poppins(
          fontSize: 18,
          color: Colors.deepPurple[800],
          fontWeight: FontWeight.w500,
        ),
        cursorWidth: 3,
        cursorHeight: 24,
        decoration: InputDecoration(
          labelText: 'Enter city name.',
          labelStyle: GoogleFonts.poppins(
            color: Colors.deepPurple[300],
            fontSize: 16,
          ),
          filled: true,
          fillColor: const Color.fromARGB(255, 254, 252, 252),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(
              color: Colors.deepPurple[100]!,
              width: 2.5,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(
              color: Colors.deepPurple[400]!,
              width: 3,
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 25,
            vertical: 20,
          ),
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 15, right: 10),
            child: Icon(
              Icons.map_rounded,
              color: Colors.deepPurple[300],
              size: 24,
            ),
          ),
          suffixIcon: Padding(
            padding: const EdgeInsets.only(right: 15),
            child: IconButton(
              icon: Icon(
                Icons.send_rounded,
                color: Colors.deepPurple[400],
                size: 28,
              ),
              onPressed: onSubmit,
            ),
          ),
        ),
        onSubmitted: (_) => onSubmit!(),
      ),
    );
  }
}