import 'package:flutter/material.dart';
import 'package:pdf_creator/provider/filter.provider.dart';
import 'package:pdf_creator/views/common/counter.widget.dart';
import 'package:pdf_creator/views/common/water.mark.image.dart';
import 'package:provider/provider.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({super.key});

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  //
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 80),
          const Padding(
            padding: EdgeInsets.only(left: 20, bottom: 20),
            child: Text(
              "PDF Settings",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20,
              ),
            ),
          ),
          const Divider(
            indent: 20,
            thickness: 1,
            color: Colors.black,
            endIndent: 20,
          ),
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
