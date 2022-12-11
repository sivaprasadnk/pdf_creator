import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pdf_creator/provider/filter.provider.dart';
import 'package:provider/provider.dart';

class WatermarkImage extends StatefulWidget {
  const WatermarkImage({super.key});

  @override
  State<WatermarkImage> createState() => _WatermarkImageState();
}

class _WatermarkImageState extends State<WatermarkImage> {
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Consumer<FilterProvider>(builder: (_, provider, __) {
      return provider.imagePath.isEmpty
          ? ElevatedButton(
              onPressed: () async {
                final XFile? image =
                    await _picker.pickImage(source: ImageSource.gallery);
                if (image != null) {
                  provider.updateImagePath(image.path);
                }
              },
              child: const Text("Select"),
            )
          : Container(
              height: 70,
              width: 70,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: FileImage(
                  File(provider.imagePath),
                )),
                borderRadius: BorderRadius.circular(8),
              ),
            );
    });
  }
}
