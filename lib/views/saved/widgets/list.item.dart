// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:pdf_creator/utils/file.extensions.dart';

// class SavedListItem extends StatelessWidget {
//   const SavedListItem({super.key, required this.fileItem});

//   final FileSystemEntity fileItem;

//   @override
//   Widget build(BuildContext context) {
//     var date = fileItem.path.dateTime;
//     const IconData filePdf =
//         IconData(0xf1c1, fontFamily: 'pdf', fontPackage: null);
//     return SizedBox(
//       height: 55,
//       child: ListTile(
//         title: Text("Doc_${fileItem.path.file}"),
//         subtitle: Text(date.toString().split('.').first),
//         dense: false,
//         leading: const Icon(
//           filePdf,
//           size: 30,
//           color: Colors.red,
//         ),
//         trailing: GestureDetector(
//           onTap: () {
//             fileItem.delete();
//             fileList.removeWhere((element) => element.path == fileItem.path);
//             setState(() {});
//           },
//           child: const Icon(Icons.delete_forever),
//         ),
//       ),
//     );
//   }
// }
