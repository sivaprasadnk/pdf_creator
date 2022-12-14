import 'dart:io';

// import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf_creator/model/file.item.model.dart';
import 'package:pdf_creator/utils/data.dart';
import 'package:pdf_creator/utils/file.extensions.dart';
import 'package:pdf_creator/views/create/create.screen.dart';
import 'package:share_plus/share_plus.dart';

class SavedListScreen extends StatefulWidget {
  const SavedListScreen({super.key});
  static const routeName = '/SavedScreen';

  @override
  State<SavedListScreen> createState() => _SavedListScreenState();
}

class _SavedListScreenState extends State<SavedListScreen> {
  String directory = "";
  List<FileItemModel> fileList = [];
  List<XFile> selectedFileList = [];
  List thumbnailList = [];

  bool shareEnabled = false;
  bool deleteEnabled = false;
  bool selectAllEnabled = false;

  SavedView view = SavedView.grid;
  SavedSort sort = SavedSort.asc;

  @override
  void initState() {
    _listofFiles();
    super.initState();
  }

  void _listofFiles() async {
    directory = (await getExternalStorageDirectory())!.path;
    var tempFileList = Directory("$directory/").listSync();
    for (var item in tempFileList) {
      fileList.add(
        FileItemModel(
            name: item.path.file,
            path: item.path,
            createdDateTime: item.path.dateTime,
            isSelected: false),
      );
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    const IconData sortDown =
        IconData(0xf160, fontFamily: 'sort', fontPackage: null);
    const IconData sortUp =
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
          if (selectedFileList.isNotEmpty)
            GestureDetector(
              onTap: () async {
                var shareList = <XFile>[];
                for (var i in selectedFileList) {
                  shareList.add(XFile(i.path));
                }
                await Share.shareXFiles(selectedFileList);
              },
              child: const Icon(Icons.share),
            ),
          const SizedBox(width: 20),
          if (selectedFileList.isNotEmpty)
            GestureDetector(
              onTap: () {
                confirmDelete();
              },
              child: const Icon(Icons.delete),
            ),
          const SizedBox(width: 20),
          if (fileList.isNotEmpty)
            sort == SavedSort.asc
                ? GestureDetector(
                    onTap: () {
                      fileList.sort((a, b) =>
                          b.createdDateTime.compareTo(a.createdDateTime));
                      sort = SavedSort.desc;
                      setState(() {});
                    },
                    child: const Icon(
                      sortUp,
                      size: 15,
                    ),
                  )
                : GestureDetector(
                    onTap: () {
                      fileList.sort((a, b) =>
                          a.createdDateTime.compareTo(b.createdDateTime));
                      sort = SavedSort.asc;

                      setState(() {});
                    },
                    child: const Icon(
                      sortDown,
                      size: 15,
                    ),
                  ),
          const SizedBox(width: 20),
          if (fileList.isNotEmpty)
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
      // bottomNavigationBar: GestureDetector(
      //   onTap: () {
      //     Navigator.pushReplacementNamed(
      //       context,
      //       CreateScreen.routeName,
      //     );
      //   },
      //   child: Container(
      //     height: 50,
      //     margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      //     decoration: BoxDecoration(
      //       color: Theme.of(context).primaryColor,
      //       borderRadius: BorderRadius.circular(8),
      //     ),
      //     child: const Center(
      //       child: Text(
      //         'Create New',
      //         style: TextStyle(
      //           color: Colors.white,
      //           fontWeight: FontWeight.w500,
      //         ),
      //       ),
      //     ),
      //   ),
      // ),
      body: SizedBox.expand(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 50,
              width: width,
              child: fileList.isNotEmpty
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Text('Select all'),
                        const SizedBox(
                          width: 15,
                        ),
                        Checkbox(
                            value: selectAllEnabled,
                            onChanged: (val) {
                              selectAllEnabled = val!;
                              if (val) {
                                for (var i in fileList) {
                                  i.isSelected = val;
                                  selectedFileList.add(XFile(i.path));
                                }
                              } else {
                                for (var i in fileList) {
                                  i.isSelected = val;
                                }
                                selectedFileList.clear();
                              }
                              setState(() {});
                            }),
                        const SizedBox(
                          width: 15,
                        )
                      ],
                    )
                  : const SizedBox.shrink(),
            ),
            fileList.isNotEmpty
                ? view == SavedView.grid
                    ? SizedBox(
                        height: height * 0.8,
                        child: GridView.builder(
                          padding: const EdgeInsets.all(20),
                          shrinkWrap: true,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisExtent: 150,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                          ),
                          itemCount: fileList.length,
                          itemBuilder: (context, index) {
                            var fileItem = fileList[index];

                            var date = fileItem.createdDateTime;
                            return GestureDetector(
                              onTap: () async {
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
                                    top: 5,
                                    right: 5,
                                    child: Align(
                                      alignment: Alignment.topRight,
                                      child: Checkbox(
                                        value: fileItem.isSelected,
                                        onChanged: (value) {
                                          fileItem.isSelected = value!;
                                          if (value) {
                                            selectedFileList
                                                .add(XFile(fileItem.path));
                                          } else {
                                            selectedFileList.removeWhere(
                                                (element) =>
                                                    element.path ==
                                                    fileItem.path);
                                          }
                                          setState(() {});
                                        },
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            );
                          },
                        ),
                      )
                    : SizedBox(
                        height: height * 0.8,
                        child: ListView.separated(
                          itemCount: fileList.length,
                          shrinkWrap: true,
                          padding: const EdgeInsets.only(
                              left: 10, top: 20, right: 15),
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
                                title: Text("${fileItem.path.fileName}.pdf"),
                                subtitle:
                                    Text(date.toString().split('.').first),
                                dense: false,
                                leading: const Icon(
                                  filePdf,
                                  size: 30,
                                  color: Colors.red,
                                ),
                                trailing: Checkbox(
                                  value: fileItem.isSelected,
                                  onChanged: (value) {
                                    fileItem.isSelected = value!;

                                    if (value) {
                                      selectedFileList
                                          .add(XFile(fileItem.path));
                                    } else {
                                      selectedFileList.removeWhere((element) =>
                                          element.path == fileItem.path);
                                    }
                                    setState(() {});
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                      )
                : const SizedBox(
                    height: 500,
                    child: Center(
                      child: Text("No item"),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  confirmDelete() async {
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Confirm delete"),
            content: Text(
                "Are you sure to delete these ${selectedFileList.length} files ?"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("No"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  for (var i in selectedFileList) {
                    File(i.path).delete();
                    fileList.removeWhere((element) => element.path == i.path);
                  }
                  selectedFileList.clear();
                  setState(() {});
                },
                child: const Text("Yes"),
              )
            ],
          );
        });
  }
}
