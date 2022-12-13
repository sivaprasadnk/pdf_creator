import 'package:flutter/material.dart';

class GenerateButton extends StatelessWidget {
  const GenerateButton({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ElevatedButton(
        onPressed: onTap,
        child: const Text(
          "Generate PDF",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
