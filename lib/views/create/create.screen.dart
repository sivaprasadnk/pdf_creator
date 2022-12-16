import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pdf_creator/views/common/create.list.item.dart';
import 'package:pdf_creator/views/create/image/image.list.screen.dart';
import 'package:pdf_creator/views/create/text/rte.screen.dart';
import 'package:pdf_creator/views/create/text/single.text.screen.dart';
import 'package:pdf_creator/views/create/text/text.list.screen.dart';
import 'package:pdf_creator/views/saved/saved.lists.dart';

class CreateScreen extends StatefulWidget {
  const CreateScreen({super.key});
  static const routeName = '/CreateScreen';

  @override
  State<CreateScreen> createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        // leadingWidth: 70,
        // leading: GestureDetector(
        //   onTap: () {
        //     Navigator.pop(context);
        //   },
        //   child: Container(
        //     decoration: const BoxDecoration(
        //       color: Colors.cyan,
        //       borderRadius: BorderRadius.only(
        //         bottomRight: Radius.circular(50),
        //         topRight: Radius.circular(50),
        //       ),
        //     ),
        //     child: const Icon(
        //       Icons.keyboard_backspace_rounded,
        //       color: Colors.white,
        //     ),
        //   ),
        // ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      bottomNavigationBar: GestureDetector(
        onTap: () {
          Navigator.pushNamed(
            context,
            SavedListScreen.routeName,
          );
        },
        child: Container(
          height: 50,
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Center(
            child: Text(
              'View Saved',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 0),
          Padding(
            padding: EdgeInsets.only(left: width * 0.13),
            child: const Text(
              "Create",
              style: TextStyle(
                fontSize: 28,
                fontFamily: "Arvo",
                color: Colors.red,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 15),
          Center(
            child: Stack(
              children: [
                Container(
                  width: 300,
                  height: 220,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.cyan,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: const [
                      CreateListItem(
                        routeName: TextListScreen.routeName,
                        title: "List",
                      ),
                      CreateListItem(
                        routeName: SingleTextScreen.routeName,
                        title: "Single Plain Text",
                      ),
                      CreateListItem(
                        routeName: RteScreen.routeName,
                        title: "Rich Text",
                      ),

                    ],
                  ),
                ),
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      height: 25,
                      width: 60,
                      decoration: const BoxDecoration(
                        color: Colors.deepPurpleAccent,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          "Text",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 30),
          Center(
            child: Stack(
              children: [
                Container(
                  width: 300,
                  height: 180,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.cyan,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: const [
                      CreateListItem(
                        routeName: ImageListScreen.routeName,
                        arguments: ImageSource.gallery,
                        title: "Gallery",
                      ),
                      CreateListItem(
                        routeName: ImageListScreen.routeName,
                        arguments: ImageSource.camera,
                        title: "Camera",
                      ),
                    ],
                  ),
                ),
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      height: 25,
                      width: 60,
                      decoration: const BoxDecoration(
                        color: Colors.deepPurpleAccent,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          "Image",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          // const SizedBox(height: 30),
          // Center(
          //   child: Stack(
          //     children: [
          //       Container(
          //         width: 300,
          //         height: 75,
          //         decoration: BoxDecoration(
          //           border: Border.all(
          //             color: Colors.cyan,
          //           ),
          //           borderRadius: BorderRadius.circular(10),
          //         ),
          //         child: Column(
          //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //           children: const [
          //             CreateListItem(
          //               routeName: DocFileListScreen.routeName,
          //               arguments: ["doc", "docx"],
          //               title: "Word Docs",
          //             ),
          //             // CreateListItem(
          //             //   routeName: ImageListScreen.routeName,
          //             //   arguments: ImageSource.camera,
          //             //   title: "Camera",
          //             // ),
          //           ],
          //         ),
          //       ),
          //       Positioned.fill(
          //         child: Align(
          //           alignment: Alignment.topLeft,
          //           child: Container(
          //             height: 25,
          //             width: 60,
          //             decoration: const BoxDecoration(
          //               color: Colors.deepPurpleAccent,
          //               borderRadius: BorderRadius.only(
          //                 topLeft: Radius.circular(10),
          //                 bottomRight: Radius.circular(10),
          //               ),
          //             ),
          //             child: const Center(
          //               child: Text(
          //                 "File",
          //                 style: TextStyle(
          //                   color: Colors.white,
          //                 ),
          //               ),
          //             ),
          //           ),
          //         ),
          //       )
          //     ],
          //   ),
          // ),

        ],
      ),
    );
  }
}
