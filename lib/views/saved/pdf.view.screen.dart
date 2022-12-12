// import 'dart:async';

// import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_pdfview/flutter_pdfview.dart';
// // import 'package:pdf_render/pdf_render_widgets.dart';

// class PdfViewScreen extends StatefulWidget {
//   const PdfViewScreen({super.key, required this.path, required this.doc});

//   final String path;
//   final PDFDocument doc;

//   @override
//   State<PdfViewScreen> createState() => _PdfViewScreenState();
// }

// class _PdfViewScreenState extends State<PdfViewScreen> {
//   final Completer<PDFViewController> _controller =
//       Completer<PDFViewController>();
//   int? pages = 0;
//   int? currentPage = 0;
//   bool isReady = false;
//   String errorMessage = '';

//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
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
//         title: const Text("Doc"),
//       ),
//       // body: SfPdfViewer.file(
//       //   File(widget.path),
//       // ),
//       // body: PDFView(
//       //   filePath: widget.path,
//       //   enableSwipe: true,
//       //   swipeHorizontal: false,
//       //   autoSpacing: false,
//       //   pageFling: false,
//       //   onRender: (pages) {
//       //     setState(() {
//       //       pages = pages;
//       //       isReady = true;
//       //     });
//       //   },
//       //   onError: (error) {
//       //     debugPrint(error.toString());
//       //   },
//       //   onPageError: (page, error) {
//       //     debugPrint('$page: ${error.toString()}');
//       //   },
//       //   onViewCreated: (PDFViewController pdfViewController) {
//       //     _controller.complete(pdfViewController);
//       //   },
//       //   onPageChanged: (int? page, int? total) {
//       //     debugPrint('page change: $page/$total');
//       //   },
//       // ),
//       body: PDFViewer(
//         document: widget.doc,
//       ),
//     );
//   }
// }
