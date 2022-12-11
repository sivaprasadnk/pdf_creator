import 'package:flutter/material.dart';
import 'package:pdf_creator/provider/filter.provider.dart';
import 'package:pdf_creator/utils/counter.widget.dart';
import 'package:pdf_creator/utils/water.mark.image.dart';
import 'package:provider/provider.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({super.key});

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
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
          Consumer<FilterProvider>(builder: (_, provider, __) {
            return ListTile(
              title: const Text("Bullets"),
              trailing: Switch(
                value: provider.enableBullets,
                onChanged: (val) {
                  provider.updateBullets(val);
                },
              ),
            );
          }),
          const SizedBox(height: 20),
          Consumer<FilterProvider>(builder: (_, provider, __) {
            return ListTile(
              title: const Text("Alignment"),
              trailing: DropdownButton(
                onChanged: (value) {
                  provider.updateAlignment(value!);
                },
                items: TextAlign.values.map(
                  (e) {
                    return DropdownMenuItem(
                      value: e.name.toString(),
                      child: Text(
                        e.name.toString(),
                      ),
                    );
                  },
                ).toList(),
                value: provider.alignment,
              ),
            );
          }),
          const SizedBox(height: 20),
          const ListTile(
            title: Text("Font Size"),
            trailing: CounterWidget(),
          ),
          const SizedBox(height: 20),
          const ListTile(
            title: Text("Watermark image"),
            trailing: WatermarkImage(),
          ),
          const SizedBox(height: 20),
          Consumer<FilterProvider>(builder: (_, provider, __) {
            return provider.imagePath.isNotEmpty
                ? ElevatedButton.icon(
                    onPressed: () {
                      provider.updateImagePath('');
                    },
                    label: const Text("Delete Image"),
                    icon: const Icon(Icons.delete),
                  )
                : const SizedBox.shrink();
          })
        ],
      ),
    );
  }
}
