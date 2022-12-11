import 'dart:io';

import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

class SavedListScreen extends StatefulWidget {
  const SavedListScreen({super.key});

  @override
  State<SavedListScreen> createState() => _SavedListScreenState();
}

class _SavedListScreenState extends State<SavedListScreen> {
  String directory = "";
  List<FileSystemEntity> fileList = [];
  List thumbnailList = [];
  @override
  void initState() {
    _listofFiles();
    super.initState();
  }

  void _listofFiles() async {
    directory = (await getExternalStorageDirectory())!.path;
    fileList = Directory("$directory/").listSync();
//     for(var file in fileList){
//       final pageImage = await file.render();
// final image = await pageImage.createImageDetached();
// final pngData = await image.toByteData(ImageByteFormat.png);
//     }
//     Future.delayed(const Duration(seconds: 2)).then((value) {
//     });
      setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    const kFontFam = 'pdf';
    const String? kFontPkg = null;

    const IconData file_pdf =
        IconData(0xf1c1, fontFamily: kFontFam, fontPackage: kFontPkg);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Saved"),
      ),
      body: fileList.isNotEmpty
          ? GridView.builder(
              padding: const EdgeInsets.all(10),
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisExtent: 150,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: fileList.length,
              itemBuilder: (context, index) {
                var file = fileList[index];
                debugPrint("..path:${file.path}");
                var name = file.path.split('/').last;
                var date = DateTime.fromMillisecondsSinceEpoch(
                    int.parse(name.split('.').first));
                return GestureDetector(
                  onTap: () {
                    OpenFilex.open(file.path);
                  },
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: Colors.cyan,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        // child: PdfViewer.openFile(
                        //   file.path,
                        //   params: const PdfViewerParams(pageNumber: 1),
                        // ),
                        // child: PdfThumbnail.fromFile(file.path, currentPage: 1,height: 100,),
                        child: const Center(
                          child: Icon(
                            file_pdf,
                            size: 55,
                            color: Colors.red,
                          ),
                        ),
                      ),
                      Positioned.fill(
                        bottom: 10,
                        left: 10,
                        child: Align(
                          alignment: Alignment.bottomLeft,
                          child: Text(
                            date.toString().split('.').first,
                          ),
                        ),
                      ),
                      Positioned.fill(
                        top: 10,
                        right: 10,
                        child: Align(
                          alignment: Alignment.topRight,
                          child: GestureDetector(
                            onTap: () {
                              file.delete();
                              fileList.removeWhere(
                                  (element) => element.path == file.path);
                              setState(() {});
                            },
                            child: const Icon(Icons.delete_forever),
                          ),
                        ),
                      )
                    ],
                  ),
                );
              },
            )
          : const SizedBox.expand(
              child: Center(
                child: Text('No item !'),
              ),
            ),
    );
  }
}
