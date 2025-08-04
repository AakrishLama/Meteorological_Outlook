import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Input extends StatefulWidget {
  final TextEditingController inputController;
  final VoidCallback? onSubmit;

  const Input({super.key, required this.inputController, this.onSubmit});

  @override
  State<Input> createState() => _InputState();
}

class _InputState extends State<Input> {
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    widget.inputController.addListener(() {
      setState(() {
        _isTyping = widget.inputController.text.isNotEmpty;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 400,
      height: 70,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.black.withOpacity(0.3),
                width: 1.5,
              ),
            ),
            child: TextField(
              controller: widget.inputController,
              autofocus: true,
              style: GoogleFonts.poppins(
                fontSize: 18,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
              cursorWidth: 3,
              cursorHeight: 24,
              decoration: InputDecoration(
                hintText: _isTyping ? '' : 'Enter city name',
                hintStyle: GoogleFonts.poppins(
                  color: Colors.black.withOpacity(0.7),
                  fontSize: 21,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 25,
                  vertical: 20,
                ),
                prefixIcon: Padding(
                  padding: const EdgeInsets.only(left: 15, right: 10),
                  child: Icon(
                    Icons.map_rounded,
                    color: Colors.black.withOpacity(0.7),
                    size: 28,
                  ),
                ),
                suffixIcon: Padding(
                  padding: const EdgeInsets.only(right: 15),
                  child: IconButton(
                    icon: Icon(
                      Icons.send_rounded,
                      color: Colors.black.withOpacity(0.9),
                      size: 28,
                    ),
                    onPressed: widget.onSubmit,
                  ),
                ),
              ),
              onSubmitted: (_) => widget.onSubmit?.call(),
            ),
          ),
        ),
      ),
    );
  }
}
