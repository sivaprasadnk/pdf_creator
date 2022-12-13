import 'package:flutter/material.dart';
// import "package:text2pdf/text2pdf.dart";
import 'package:flutter_html_to_pdf/flutter_html_to_pdf.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf_creator/drawer.dart';
import 'package:pdf_creator/views/common/generate.button.dart';

class RteScreen extends StatefulWidget {
  const RteScreen({super.key});

  static const routeName = "/rteScreen";

  @override
  State<RteScreen> createState() => _RteScreenState();
}

class _RteScreenState extends State<RteScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  HtmlEditorController controller = HtmlEditorController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        controller.clearFocus();
        return true;
      },
      child: Scaffold(
        key: _scaffoldKey,
        endDrawer: Drawer(
          child: GestureDetector(
            onTap: () {
              controller.clearFocus();

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
              controller.clearFocus();

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
        body: HtmlEditor(
          hint: "Type here",
          controller: controller,
          toolbar: const [
            // Toolbar()
          ],
          options: const HtmlEditorOptions(),
        ),
        bottomNavigationBar: GenerateButton(onTap: generatePdf),
      ),
    );
  }

  generatePdf() async {
    FocusScope.of(context).unfocus();
    controller.clearFocus();
    await controller.getText().then((data1) async {
      if (data1!.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Nothing to convert !')));
        }
      } else {
        final output = await getExternalStorageDirectory();
        var now = DateTime.now().millisecondsSinceEpoch;
        var targetPath = output!.path;
        var targetFileName = "$now";

        await FlutterHtmlToPdf.convertFromHtmlContent(
                data1, targetPath, targetFileName)
            .then((generatedPdfFile) {
          debugPrint("..@ path:${generatedPdfFile.path}");
          OpenFilex.open(generatedPdfFile.path);
        });
      }
    });
  }
}
