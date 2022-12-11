import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf_creator/image.drawer.dart';
import 'package:pdf_creator/provider/filter.provider.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';

class ImageListScreen extends StatefulWidget {
  const ImageListScreen({super.key});

  @override
  State<ImageListScreen> createState() => _ImageListScreenState();
}

class _ImageListScreenState extends State<ImageListScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final ImagePicker _picker = ImagePicker();

  List<XFile> imageList = [];
  List<Uint8List> imageBytesList = [];

  @override
  Widget build(BuildContext context) {
    debugPrint("..@ list :$imageList");
    debugPrint("..@ list :${imageList.length}");
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: Drawer(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: const ImageDrawer(),
        ),
      ),
      appBar: AppBar(
        title: const Text('Add images'),
        actions: [
          GestureDetector(
            onTap: () async {
              addImage();
            },
            child: const Icon(Icons.add),
          ),
          const SizedBox(
            width: 10,
          ),
          GestureDetector(
            onTap: () {
              _scaffoldKey.currentState!.openEndDrawer();
            },
            child: const Icon(Icons.settings),
          ),
          const SizedBox(
            width: 10,
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisExtent: 100,
              ),
              itemCount: imageList.length,
              itemBuilder: (context, index) {
                var image = imageList[index];
                debugPrint("..@ image :${image.path}");

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Stack(
                    children: [
                      Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image(
                            height: 30,
                            width: 30,
                            fit: BoxFit.contain,
                            image: FileImage(
                              File(image.path),
                            ),
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.error_rounded);
                            },
                          ),
                        ),
                      ),
                      Positioned.fill(
                        top: 5,
                        right: 5,
                        child: Align(
                          alignment: Alignment.topRight,
                          child: GestureDetector(
                            onTap: () {
                              imageList.removeAt(index);
                              imageBytesList.removeAt(index);
                              setState(() {});
                            },
                            child: const Icon(
                              Icons.delete_forever,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
            TextButton(
              onPressed: () {
                addImage();
              },
              child: const Text("Add more ..."),
            )
          ],
        ),
      ),
      bottomNavigationBar: imageBytesList.isNotEmpty
          ? SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: generatePdf,
                child: const Text(
                  "Generate PDF",
                ),
              ),
            )
          : const SizedBox.shrink(),
    );
  }

  addImage() async {
    FocusScope.of(context).unfocus();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    imageList.add(image!);
    var bytes = await image.readAsBytes();
    imageBytesList.add(bytes);
    setState(() {});
  }

  generatePdf() async {
    FocusScope.of(context).unfocus();

    var provider = Provider.of<FilterProvider>(context, listen: false);
    final pdf = pw.Document();
    final font = await PdfGoogleFonts.openSansRegular();
    var myTheme = pw.ThemeData.withFont(
      base: font,
    );
    for (var e in imageBytesList) {
      pdf.addPage(pw.Page(
        theme: myTheme,
        margin: const pw.EdgeInsets.all(20),
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.SizedBox.expand(
            child: pw.Container(
              decoration: pw.BoxDecoration(
                border: provider.enableBorder
                    ? pw.Border.all(color: PdfColors.black)
                    : pw.Border.all(
                        color: PdfColors.white,
                      ),
              ),
              child: pw.Center(
                child: pw.Image(
                  pw.MemoryImage(e),
                  // height: 500,
                  fit: pw.BoxFit.contain,
                  alignment: pw.Alignment.center,
                ),
              ),
            ),
          );
        },
      ));
    }

    // imageBytesList.map((e) {
    //   return pdf.addPage(pw.MultiPage(
    //     theme: myTheme,
    //     margin: const pw.EdgeInsets.all(20),
    //     pageFormat: PdfPageFormat.a4,
    //     build: (pw.Context context) {
    //       return pw.Container(
    //         decoration: pw.BoxDecoration(
    //           border: provider.enableBorder
    //               ? pw.Border.all(color: PdfColors.black)
    //               : pw.Border.all(),
    //         ),
    //         child: pw.Center(
    //           child: pw.Image(
    //             pw.MemoryImage(e),
    //           ),
    //         ),
    //       );
    //     },
    //   ));
    // });
    final output = await getExternalStorageDirectory();
    var now = DateTime.now().millisecondsSinceEpoch;
    final file = File("${output!.path}/$now.pdf");
    await file.writeAsBytes(await pdf.save()).then((value) {
      OpenFilex.open(value.path);
    });
  }
}
