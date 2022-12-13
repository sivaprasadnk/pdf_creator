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
import 'package:pdf_creator/views/common/generate.button.dart';
import 'package:pdf_creator/views/create/image/image.view.screen.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';

class ImageListScreen extends StatefulWidget {
  const ImageListScreen({super.key});
  static const routeName = '/ImageListScreen';

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
    var height = MediaQuery.of(context).size.height;

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
      backgroundColor: Colors.white,
      appBar: AppBar(
        leadingWidth: 70,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.cyan,
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(50),
                topRight: Radius.circular(50),
              ),
            ),
            child: const Icon(
              Icons.keyboard_backspace_rounded,
              color: Colors.white,
            ),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text("Add Image"),
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
              FocusScope.of(context).unfocus();
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
            if (imageBytesList.isNotEmpty)
              GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                padding: const EdgeInsets.only(left: 15, top: 50, right: 15),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 1,
                  crossAxisSpacing: 10,
                  // mainAxisExtent: 150,
                ),
                itemCount: imageList.length,
                itemBuilder: (context, index) {
                  var image = imageList[index];

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Stack(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              ImageViewScreen.routeName,
                              arguments: File(image.path),
                            );
                          },
                          child: Container(
                            height: 200,
                            width: 200,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.black,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image(
                                height: 100,
                                width: 100,
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
              )
            else
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: height * 0.4),
                  const Center(
                    child: Text(
                      "Click '+' at top to add images!",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            if (imageBytesList.isNotEmpty)
              Center(
                child: TextButton(
                  onPressed: () {
                    addImage();
                  },
                  child: const Text("Add more ..."),
                ),
              )
          ],
        ),
      ),
      bottomNavigationBar: imageBytesList.isNotEmpty
          ? GenerateButton(onTap: generatePdf)
          : const SizedBox.shrink(),
    );
  }

  addImage() async {
    var source = ModalRoute.of(context)!.settings.arguments as ImageSource;
    FocusScope.of(context).unfocus();
    final XFile? image = await _picker.pickImage(source: source);
    if (image != null) {
      imageList.add(image);
      var bytes = await image.readAsBytes();
      imageBytesList.add(bytes);
    }
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

    final output = await getExternalStorageDirectory();
    var now = DateTime.now().millisecondsSinceEpoch;
    final file = File("${output!.path}/Doc_$now.pdf");
    await file.writeAsBytes(await pdf.save()).then((value) {
      OpenFilex.open(value.path);
    });
  }
}
