import 'dart:io';

import 'package:flutter/material.dart';

class ImageViewScreen extends StatelessWidget {
  const ImageViewScreen({super.key});

  static const routeName = "/ImageView";

  @override
  Widget build(BuildContext context) {
    var imageFile = ModalRoute.of(context)!.settings.arguments as File;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.keyboard_backspace_rounded,
            color: Colors.white,
          ),
        ),
      ),
      body: Center(
        child: InteractiveViewer(
          child: Image(
            image: FileImage(imageFile),
          ),
        ),
      ),
    );
  }
}
