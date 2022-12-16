// import 'dart:io';

// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:open_filex/open_filex.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:flutter_full_pdf_viewer/full_pdf_viewer_scaffold.dart';
// // import 'package:pdf/pdf.dart';
// // import 'package:pdf/widgets.dart' as pw;
// import 'package:pdf_creator/image.drawer.dart';
// import 'package:pdf_creator/views/common/generate.button.dart';

// class DocFileListScreen extends StatefulWidget {
//   const DocFileListScreen({super.key});
//   static const routeName = '/DocFileListScreen';

//   @override
//   State<DocFileListScreen> createState() => _DocFileListScreenState();
// }

// class _DocFileListScreenState extends State<DocFileListScreen> {
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

//   List<File> docFileList = [];
//   List<Uint8List?> imageBytesList = [];

//   @override
//   Widget build(BuildContext context) {
//     var height = MediaQuery.of(context).size.height;

//     return Scaffold(
//       key: _scaffoldKey,
//       endDrawer: Drawer(
//         child: GestureDetector(
//           onTap: () {
//             FocusScope.of(context).unfocus();
//           },
//           child: const ImageDrawer(),
//         ),
//       ),
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         leadingWidth: 70,
//         leading: GestureDetector(
//           onTap: () {
//             Navigator.pop(context);
//           },
//           child: Container(
//             decoration: const BoxDecoration(
//               color: Colors.cyan,
//               borderRadius: BorderRadius.only(
//                 bottomRight: Radius.circular(50),
//                 topRight: Radius.circular(50),
//               ),
//             ),
//             child: const Icon(
//               Icons.keyboard_backspace_rounded,
//               color: Colors.white,
//             ),
//           ),
//         ),
//         backgroundColor: Colors.white,
//         elevation: 0,
//         title: const Text("Add Doc"),
//         actions: [
//           GestureDetector(
//             onTap: () async {
//               addDoc();
//             },
//             child: const Icon(Icons.add),
//           ),
//           const SizedBox(
//             width: 10,
//           ),
//           GestureDetector(
//             onTap: () {
//               FocusScope.of(context).unfocus();
//               _scaffoldKey.currentState!.openEndDrawer();
//             },
//             child: const Icon(Icons.settings),
//           ),
//           const SizedBox(
//             width: 10,
//           )
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             if (imageBytesList.isNotEmpty)
//               GridView.builder(
//                 physics: const NeverScrollableScrollPhysics(),
//                 shrinkWrap: true,
//                 padding: const EdgeInsets.only(left: 15, top: 50, right: 15),
//                 gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 3,
//                   childAspectRatio: 1,
//                   crossAxisSpacing: 10,
//                   // mainAxisExtent: 150,
//                 ),
//                 itemCount: docFileList.length,
//                 itemBuilder: (context, index) {
//                   var doc = docFileList[index];

//                   return Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Stack(
//                       children: [
//                         GestureDetector(
//                           onTap: () {
//                             // Navigator.pushNamed(
//                             //   context,
//                             //   ImageViewScreen.routeName,
//                             //   arguments: File(doc.path!),
//                             // );
//                             OpenFilex.open(doc.path);
//                           },
//                           child: Container(
//                             height: 200,
//                             width: 200,
//                             decoration: BoxDecoration(
//                               border: Border.all(
//                                 color: Colors.black,
//                               ),
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                             child: const Center(
//                               child: Icon(Icons.insert_drive_file),
//                             ),
//                             // child: ClipRRect(
//                             //   borderRadius: BorderRadius.circular(8),
//                             //   child: Image(
//                             //     height: 100,
//                             //     width: 100,
//                             //     fit: BoxFit.contain,
//                             //     image: FileImage(
//                             //       File(image.path),
//                             //     ),
//                             //     errorBuilder: (context, error, stackTrace) {
//                             //       return const Icon(Icons.error_rounded);
//                             //     },
//                             //   ),
//                             // ),
//                           ),
//                         ),
//                         Positioned.fill(
//                           top: 5,
//                           right: 5,
//                           child: Align(
//                             alignment: Alignment.topRight,
//                             child: GestureDetector(
//                               onTap: () {
//                                 docFileList.removeAt(index);
//                                 imageBytesList.removeAt(index);
//                                 setState(() {});
//                               },
//                               child: const Icon(
//                                 Icons.delete_forever,
//                               ),
//                             ),
//                           ),
//                         )
//                       ],
//                     ),
//                   );
//                 },
//               )
//             else
//               Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   SizedBox(height: height * 0.4),
//                   const Center(
//                     child: Text(
//                       "Click '+' at top to add images!",
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             if (imageBytesList.isNotEmpty)
//               Center(
//                 child: TextButton(
//                   onPressed: () {
//                     addDoc();
//                   },
//                   child: const Text("Add more ..."),
//                 ),
//               )
//           ],
//         ),
//       ),
//       bottomNavigationBar: imageBytesList.isNotEmpty
//           ? GenerateButton(onTap: generatePdf)
//           : const SizedBox.shrink(),
//     );
//   }

//   addDoc() async {
//     var typeList = ModalRoute.of(context)!.settings.arguments as List<String>;
//     // FocusScope.of(context).unfocus();
//     // final XFile? image = await _picker.pickImage(source: source);
//     // if (image != null) {
//     //   docFileList.add(image);
//     //   var bytes = await image.readAsBytes();
//     //   imageBytesList.add(bytes);
//     // }

//     FilePickerResult? result = await FilePicker.platform.pickFiles(
//       type: FileType.custom,
//       allowedExtensions: typeList,
//     );
//     if (result != null) {
//       File file = File(result.files.first.path!);
//       docFileList.add(file);
//       var imageBytes = file.readAsBytesSync();
//       imageBytesList.add(imageBytes);

//       // debugPrint(file.name);
//       // debugPrint(file.extension);
//       // debugPrint(file.path);
//     } else {
//       // User canceled the picker
//     }
//     setState(() {});
//   }

//   generatePdf() async {
//     // final PdfDocument document =
//     //     PdfDocument(inputBytes: File(docFileList[0].path).readAsBytesSync());
//     // List<int> docxBytes = File(docFileList[0].path).readAsBytesSync();
//     // final output = await getExternalStorageDirectory();
//     // var now = DateTime.now().millisecondsSinceEpoch;
//     // final pdfFile = File("${output!.path}/Doc_$now.pdf");
//     // // File pdfFile = new File('my_document.pdf');
//     // pdfFile.writeAsBytes(docxBytes).then((value) {
//     //   OpenFilex.open(pdfFile.path);
//     // });
//     // file.writeAsBytes(await document.save()).then((value) {
//     //   OpenFilex.open(value.path).then((value) {
//     //     document.dispose();
//     //   });
//     // });

//     // var provider = Provider.of<FilterProvider>(context, listen: false);
//     // final pdf = pw.Document();
//     // final font = await PdfGoogleFonts.openSansRegular();
//     // var myTheme = pw.ThemeData.withFont(
//     //   base: font,
//     // );
//     // for (var e in imageBytesList) {
//     //   pdf.addPage(pw.Page(
//     //     theme: myTheme,
//     //     margin: const pw.EdgeInsets.all(20),
//     //     pageFormat: PdfPageFormat.a4,
//     //     build: (pw.Context context) {
//     //       return pw.SizedBox.expand(
//     //         child: pw.Container(
//     //           decoration: pw.BoxDecoration(
//     //             border: provider.enableBorder
//     //                 ? pw.Border.all(color: PdfColors.black)
//     //                 : pw.Border.all(
//     //                     color: PdfColors.white,
//     //                   ),
//     //           ),
//     //           child: pw.Center(
//     //             child: pw.Image(
//     //               pw.MemoryImage(e),
//     //               // height: 500,
//     //               fit: pw.BoxFit.contain,
//     //               alignment: pw.Alignment.center,
//     //             ),
//     //           ),
//     //         ),
//     //       );
//     //     },
//     //   ));
//     // }

//     // final output = await getExternalStorageDirectory();
//     // var now = DateTime.now().millisecondsSinceEpoch;
//     // final file = File("${output!.path}/Doc_$now.pdf");
//     // await file.writeAsBytes(await pdf.save()).then((value) {
//     //   OpenFilex.open(value.path);
//     // });
//   }
// }
