import 'dart:io';

import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf_creator/utils/data.dart';
import 'package:pdf_creator/utils/file.extensions.dart';

class SavedListScreen extends StatefulWidget {
  const SavedListScreen({super.key});
  static const routeName = '/SavedScreen';

  @override
  State<SavedListScreen> createState() => _SavedListScreenState();
}

class _SavedListScreenState extends State<SavedListScreen> {
  String directory = "";
  List<FileSystemEntity> fileList = [];
  List thumbnailList = [];

  SavedView view = SavedView.grid;
  SavedSort sort = SavedSort.asc;

  @override
  void initState() {
    _listofFiles();
    super.initState();
  }

  void _listofFiles() async {
    directory = (await getExternalStorageDirectory())!.path;
    fileList = Directory("$directory/").listSync();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    const IconData sort_amount_down =
        IconData(0xf160, fontFamily: 'sort', fontPackage: null);
    const IconData sort_amount_up =
        IconData(0xf161, fontFamily: 'sort', fontPackage: null);

    const IconData filePdf =
        IconData(0xf1c1, fontFamily: 'pdf', fontPackage: null);
    return Scaffold(
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
        title: const Text("Saved"),
        actions: [
          sort == SavedSort.asc
              ? GestureDetector(
                  onTap: () {
                    fileList.sort(
                        (a, b) => b.path.dateTime.compareTo(a.path.dateTime));
                    sort = SavedSort.desc;
                    setState(() {});
                  },
                  child: const Icon(
                    sort_amount_up,
                    size: 15,
                  ),
                )
              : GestureDetector(
                  onTap: () {
                    fileList.sort(
                        (a, b) => a.path.dateTime.compareTo(b.path.dateTime));
                    sort = SavedSort.asc;

                    setState(() {});
                  },
                  child: const Icon(
                    sort_amount_down,
                    size: 15,
                  ),
                ),
          const SizedBox(width: 20),
          if (view == SavedView.list)
            GestureDetector(
              onTap: () {
                view = SavedView.grid;
                setState(() {});
              },
              child: const Icon(Icons.grid_view_outlined),
            )
          else
            GestureDetector(
              onTap: () {
                view = SavedView.list;
                setState(() {});
              },
              child: const Icon(Icons.list_rounded),
            ),
          const SizedBox(width: 20)
        ],
      ),
      body: fileList.isNotEmpty
          ? view == SavedView.grid
              ? GridView.builder(
                  padding: const EdgeInsets.all(20),
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisExtent: 150,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: fileList.length,
                  itemBuilder: (context, index) {
                    var fileItem = fileList[index];

                    var date = fileItem.path.dateTime;
                    return GestureDetector(
                      onTap: () {
                        OpenFilex.open(fileItem.path);
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
                            child: const Center(
                              child: Icon(
                                filePdf,
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
                                  fileItem.delete();
                                  fileList.removeWhere(
                                      (element) =>
                                      element.path == fileItem.path);
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
              : ListView.separated(
                  itemCount: fileList.length,
                  shrinkWrap: true,
                  padding: const EdgeInsets.only(left: 20, top: 50, right: 15),
                  separatorBuilder: (context, index) {
                    return const Divider(
                      color: Colors.black,
                      indent: 5,
                      endIndent: 15,
                    );
                  },
                  itemBuilder: (context, index) {
                    var fileItem = fileList[index];

                    var date = fileItem.path.dateTime;
                    return SizedBox(
                      height: 55,
                      child: ListTile(
                        title: Text("Doc_${fileItem.path.file}"),
                        subtitle: Text(date.toString().split('.').first),
                        dense: false,
                        leading: const Icon(
                          filePdf,
                          size: 30,
                          color: Colors.red,
                        ),
                        trailing: GestureDetector(
                          onTap: () {
                            fileItem.delete();
                            fileList.removeWhere(
                                (element) => element.path == fileItem.path);
                            setState(() {});
                          },
                          child: const Icon(Icons.delete_forever),
                        ),
                      ),
                    );
                  },
                )
          : const SizedBox.expand(
              child: Center(
                child: Text("No item"),
              ),
            ),
    );
  }
}
