import 'package:flutter/material.dart';
import 'package:pdf_creator/provider/filter.provider.dart';
import 'package:provider/provider.dart';

class ImageDrawer extends StatefulWidget {
  const ImageDrawer({super.key});

  @override
  State<ImageDrawer> createState() => _ImageDrawerState();
}

class _ImageDrawerState extends State<ImageDrawer> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        children: [
          const SizedBox(height: 100),
          Consumer<FilterProvider>(builder: (_, provider, __) {
            return ListTile(
              title: const Text("Border"),
              trailing: Switch(
                value: provider.enableBorder,
                onChanged: (val) {
                  provider.updateBorder(val);
                },
              ),
            );
          }),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
