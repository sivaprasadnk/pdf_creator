import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf_creator/drawer.dart';
// import "package:text2pdf/text2pdf.dart";
import 'package:pdf_creator/provider/filter.provider.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';

class RteScreen extends StatefulWidget {
  const RteScreen({super.key});

  static const routeName = "/rteScreen";

  @override
  State<RteScreen> createState() => _RteScreenState();
}

class _RteScreenState extends State<RteScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final quill.QuillController _controller = quill.QuillController.basic();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: Drawer(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
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
            Future.delayed(const Duration(seconds: 1)).then((value) {
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
      body: Column(
        children: [
          quill.QuillToolbar.basic(controller: _controller),
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  border: Border.all(
                color: Colors.cyan,
              )),
              child: quill.QuillEditor.basic(
                controller: _controller,
                readOnly: false, // true for view only mode
              ),
            ),
          )
        ],
      ),
      bottomNavigationBar: SizedBox(
        height: 50,
        child: ElevatedButton(
          onPressed: generatePdf,
          child: const Text(
            "Generate PDF",
          ),
        ),
      ),
    );
  }

  generatePdf() async {
    FocusScope.of(context).unfocus();
    var content = _controller.document.toPlainText();
    var data = _controller.getPlainText();
    // _controller.document.
    // _controller.document.
    debugPrint(" content :$data");
    if (content.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Nothing to convert !')));
    } else {
      var provider = Provider.of<FilterProvider>(context, listen: false);
      var align = provider.alignment;
      final pdf = pw.Document();
      final font = await PdfGoogleFonts.openSansRegular();
      var myTheme = pw.ThemeData.withFont(
        base: font,
      );
      pdf.addPage(
        pw.Page(
          theme: myTheme,
          margin: const pw.EdgeInsets.all(20),
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return provider.enableBorder
                ? pw.SizedBox.expand(
                    child: pw.Container(
                    constraints: const pw.BoxConstraints(),
                    decoration: pw.BoxDecoration(
                      border: pw.Border.all(
                        color: PdfColors.black,
                      ),
                    ),
                    child: pw.Padding(
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Text(
                        content,
                        // style: pw.TextStyle(
                        //   fontSize: provider.fontSize,
                        // ),
                        textAlign: align == "Left"
                            ? pw.TextAlign.left
                            : align == "Right"
                                ? pw.TextAlign.right
                                : align == "Justify"
                                    ? pw.TextAlign.justify
                                    : pw.TextAlign.center,
                      ),
                    ),
                  ))
                : pw.Text(
                    content,
                    // style: pw.TextStyle(
                    //   fontSize: provider.fontSize,
                    // ),
                    textAlign: align == "Left"
                        ? pw.TextAlign.left
                        : align == "Right"
                            ? pw.TextAlign.right
                            : align == "Justify"
                                ? pw.TextAlign.justify
                                : pw.TextAlign.center,
                  );
          },
        ),
      ); //
      final output = await getApplicationDocumentsDirectory();
      var now = DateTime.now().millisecondsSinceEpoch;
      final file = File("${output.path}/$now.pdf");
      await file.writeAsBytes(await pdf.save()).then((value) {
        OpenFilex.open(value.path);
      });
    }
  }
}
