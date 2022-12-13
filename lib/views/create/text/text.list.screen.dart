import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
// import "package:text2pdf/text2pdf.dart";
import 'package:pdf_creator/drawer.dart';
import 'package:pdf_creator/provider/filter.provider.dart';
import 'package:pdf_creator/views/common/generate.button.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';

class TextListScreen extends StatefulWidget {
  const TextListScreen({super.key});
  static const routeName = '/TextListScreen';

  @override
  State<TextListScreen> createState() => _TextListScreenState();
}

class _TextListScreenState extends State<TextListScreen> {
  final _formKey = GlobalKey<FormState>();
  final List<TextEditingController> _controllerList =
      List.generate(1, (index) => TextEditingController());
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        key: _scaffoldKey,
        endDrawer: Drawer(
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
              _scaffoldKey.currentState!.openEndDrawer();
            },
            child: const DrawerWidget(),
          ),
        ),
        backgroundColor: Colors.white,
        appBar: AppBar(
          leadingWidth: 70,
          leading: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
              Future.delayed(const Duration(milliseconds: 400)).then((value) {
                Navigator.pop(context);
              });
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
          title: const Text("Add Text"),
          actions: [
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
              ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                separatorBuilder: (context, index) => const SizedBox(
                  height: 15,
                ),
                itemCount: _controllerList.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: _controllerList[index],
                      decoration: InputDecoration(
                        hintText: "Type here",
                        suffixIcon: index != 0
                            ? GestureDetector(
                                onTap: () {
                                  _controllerList.removeAt(index);
                                  setState(() {});
                                },
                                child: const Icon(Icons.delete),
                              )
                            : const SizedBox.shrink(),
                        border: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.cyan,
                          ),
                        ),
                      ),
                      scrollPadding: const EdgeInsets.all(20.0),
                      maxLines: null,
                      autofocus: false,
                    ),
                  );
                },
              ),
              TextButton(
                onPressed: () {
                  FocusScope.of(context).unfocus();
                  _controllerList.add(TextEditingController());
                  setState(() {});
                },
                child: const Text("Add more ..."),
              )
            ],
          ),
        ),
        bottomNavigationBar: GenerateButton(onTap: generatePdf),
      ),
    );
  }

  generatePdf() async {
    _formKey.currentState!.save();
    FocusScope.of(context).unfocus();

    List<String> textList = [];
    for (var i in _controllerList) {
      if (i.text.trim().isNotEmpty) {
        textList.add(i.text.trim());
      }
    }

    var provider = Provider.of<FilterProvider>(context, listen: false);
    Uint8List? imagebytes = provider.imagePath.isNotEmpty
        ? File(provider.imagePath).readAsBytesSync()
        : null;
    var align = provider.alignment;
    final pdf = pw.Document();
    final font = await PdfGoogleFonts.openSansRegular();
    var myTheme = pw.ThemeData.withFont(
      base: font,
    );
    pdf.addPage(
      pw.MultiPage(
        // textDirection: TextD,
        theme: myTheme,
        margin: const pw.EdgeInsets.all(20),
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return [
            provider.enableBorder
                ? pw.Stack(
                    alignment: pw.Alignment.center,
                    children: [
                      if (imagebytes != null)
                        pw.Image(
                          pw.MemoryImage(
                            imagebytes,
                          ),
                        ),
                      pw.SizedBox.expand(
                        child: pw.Container(
                          alignment: align == "Left"
                              ? pw.Alignment.centerLeft
                              : align == "Right"
                                  ? pw.Alignment.centerRight
                                  : pw.Alignment.center,
                          constraints: const pw.BoxConstraints(),
                          decoration: pw.BoxDecoration(
                            border: pw.Border.all(
                              color: PdfColors.black,
                            ),
                          ),
                          child: pw.Padding(
                            padding: const pw.EdgeInsets.all(8),
                            child: pw.Column(
                              crossAxisAlignment: align == "Right"
                                  ? pw.CrossAxisAlignment.end
                                  : align == "Left"
                                      ? pw.CrossAxisAlignment.start
                                      : pw.CrossAxisAlignment.center,
                              children: textList
                                  .map(
                                    (e) => pw.Row(
                                      crossAxisAlignment:
                                          pw.CrossAxisAlignment.center,
                                      children: [
                                        pw.SizedBox(
                                          width: 10,
                                        ),
                                        if (provider.enableBullets)
                                          pw.Container(
                                            height: 5,
                                            width: 5,
                                            margin: const pw.EdgeInsets.only(
                                                top: 3),
                                            decoration: const pw.BoxDecoration(
                                              color: PdfColors.black,
                                              shape: pw.BoxShape.circle,
                                            ),
                                          ),
                                        pw.SizedBox(
                                          width: 10,
                                        ),
                                        pw.Text(
                                          e,
                                          style: pw.TextStyle(
                                            fontSize: provider.fontSize,
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                        ),
                      )
                    ],
                  )
                : pw.Stack(
                    alignment: pw.Alignment.center,
                    children: [
                      if (imagebytes != null)
                        pw.Image(
                          pw.MemoryImage(
                            imagebytes,
                          ),
                        ),
                      pw.Column(
                        crossAxisAlignment: align == "Right"
                            ? pw.CrossAxisAlignment.end
                            : align == "Left"
                                ? pw.CrossAxisAlignment.start
                                : pw.CrossAxisAlignment.center,
                        children: textList
                            .map(
                              (e) => pw.Row(
                                crossAxisAlignment:
                                    pw.CrossAxisAlignment.center,
                                children: [
                                  pw.SizedBox(
                                    width: 10,
                                  ),
                                  if (provider.enableBullets)
                                    pw.Container(
                                      height: 5,
                                      width: 5,
                                      margin: const pw.EdgeInsets.only(top: 3),
                                      decoration: const pw.BoxDecoration(
                                        color: PdfColors.black,
                                        shape: pw.BoxShape.circle,
                                      ),
                                    ),
                                  pw.SizedBox(
                                    width: 10,
                                  ),
                                  pw.Text(
                                    e,
                                    style: pw.TextStyle(
                                      fontSize: provider.fontSize,
                                    ),
                                  )
                                ],
                              ),
                            )
                            .toList(),
                      )
                    ],
                  ),
          ];
        },
      ),
    ); //
    final output = await getExternalStorageDirectory();
    var now = DateTime.now().millisecondsSinceEpoch;
    final file = File("${output!.path}/Doc_$now.pdf");
    await file.writeAsBytes(await pdf.save()).then((value) {
      OpenFilex.open(value.path);
    });
  }
}
