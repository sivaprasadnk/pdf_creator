import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
// import "package:text2pdf/text2pdf.dart";
import 'package:pdf_creator/drawer.dart';
import 'package:pdf_creator/provider/filter.provider.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';

class SingleTextScreen extends StatefulWidget {
  const SingleTextScreen({super.key});

  @override
  State<SingleTextScreen> createState() => _SingleTextScreenState();
}

class _SingleTextScreenState extends State<SingleTextScreen> {
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final TextEditingController _controller = TextEditingController();

  String content = "";

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
            },
            child: const DrawerWidget(),
          ),
        ),
        appBar: AppBar(
          title: const Text('Text2pdf'),
          actions: [
            GestureDetector(
              onTap: () async {
                ClipboardData? cdata =
                    await Clipboard.getData(Clipboard.kTextPlain);
                String? copiedtext = cdata!.text;
                _controller.text = copiedtext!;
                setState(() {});
              },
              child: const Icon(Icons.paste),
            ),
            const SizedBox(
              width: 10,
            ),
            GestureDetector(
              onTap: () {
                _scaffoldKey.currentState!.openEndDrawer();
              },
              child: const Icon(Icons.menu),
            ),
            const SizedBox(
              width: 10,
            )
          ],
        ),
        body: GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus!.unfocus();
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    onSaved: (newValue) {
                      content = newValue!;
                    },
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: "Type here",
                      border: InputBorder.none,
                    ),
                    scrollPadding: const EdgeInsets.all(20.0),
                    keyboardType: TextInputType.multiline,
                    maxLines: 999,
                    // minLines: 5,
                    autofocus: false,
                  ),
                ),
              ),
            ],
          ),
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
      ),
    );
  }

  generatePdf() async {
    _formKey.currentState!.save();
    FocusScope.of(context).unfocus();
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
                        style: pw.TextStyle(
                          fontSize: provider.fontSize,
                        ),
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
                    style: pw.TextStyle(
                      fontSize: provider.fontSize,
                    ),
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
