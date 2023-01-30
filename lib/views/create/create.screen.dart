import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pdf_creator/provider/app.provider.dart';
import 'package:pdf_creator/utils/constants.dart';
import 'package:pdf_creator/views/common/create.list.item.dart';
import 'package:pdf_creator/views/create/image/image.list.screen.dart';
import 'package:pdf_creator/views/create/text/single.text.screen.dart';
import 'package:pdf_creator/views/create/text/text.list.screen.dart';
import 'package:pdf_creator/views/saved/saved.lists.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import "package:url_launcher/url_launcher.dart";

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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        actions: [
          GestureDetector(
            onTap: () {
              showModalBottomSheet(
                  isDismissible: false,
                  context: context,
                  builder: (context) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Container(
                        height: 260,
                        width: double.infinity,
                        margin: const EdgeInsets.only(top: 0),
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          child: Column(
                            children: [
                              const SizedBox(height: 15),
                              Container(
                                height: 2,
                                width: 75,
                                color: Colors.black,
                              ),
                              const Spacer(),
                              const SizedBox(height: 28),
                              Row(
                                children: [
                                  const Text("Share "),
                                  const Spacer(),
                                  GestureDetector(
                                    onTap: () async {
                                      await Share.share(appUrl);
                                    },
                                    child: const Icon(Icons.share),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 28),
                              Row(
                                children: [
                                  const Text('Feedback'),
                                  const Spacer(),
                                  GestureDetector(
                                    onTap: () async {
                                      if (await canLaunchUrl(
                                          Uri.parse(mailUrl))) {
                                        await launchUrl(Uri.parse(mailUrl));
                                      } else {
                                        throw "Error occured sending an email";
                                      }
                                    },
                                    child: const Icon(Icons.forward_to_inbox),
                                  )
                                ],
                              ),
                              const SizedBox(height: 28),
                              Consumer<AppProvider>(builder: (_, provider, __) {
                                return Row(
                                  children: [
                                    const Text("Version "),
                                    const Spacer(),
                                    Text(provider.version),
                                  ],
                                );
                              }),
                              const SizedBox(height: 28),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  height: 40,
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 30, vertical: 10),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Text(
                                        'Close',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  });
            },
            child: const Icon(
              Icons.settings,
            ),
          ),
          const SizedBox(width: 15)
        ],
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                'View Saved',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(width: 15),
              Icon(
                Icons.arrow_forward_rounded,
                color: Colors.white,
              )
            ],
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Create PDF",
                  style: TextStyle(
                    fontSize: 28,
                    fontFamily: "Arvo",
                    color: Colors.red,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  "from ...",
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: "Arvo",
                    color: Colors.red,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

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
                      // CreateListItem(
                      //   routeName: RteScreen.routeName,
                      //   title: "Rich Text",
                      // ),
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
          // const SizedBox(height: 30),
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
