import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:in_app_update/in_app_update.dart';
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
  showToast(String text) {
    Fluttertoast.showToast(msg: text);
  }

  confirmUpdate(BuildContext contxt) async {
    try {
      await InAppUpdate.checkForUpdate().then((update) {
        if (update.updateAvailability == UpdateAvailability.updateAvailable) {
          var version = update.availableVersionCode;
          
          showDialog(
              context: contxt,
              useRootNavigator: false,
              builder: (ctx) {
                return WillPopScope(
                  onWillPop: () async {
                    Navigator.of(context).pop(false);
                    return true;
                  },
                  child: AlertDialog(
                    title: const Text("Update Available ! "),
                    content: Text("version :$version"),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(ctx);
                        },
                        child: const Text('Update later!'),
                      ),
                      TextButton(
                        onPressed: () {
                          try {
                            Navigator.pop(ctx);
                            Navigator.pop(contxt);

                            performUpdate(version.toString(), ctx);
                          } catch (err) {
                            Fluttertoast.showToast(msg: err.toString());
                          }
                        },
                        child: const Text('Update now!'),
                      ),
                    ],
                  ),
                );
              });
        } else {
          showToast('No Updates available !! Please try later! ');
        }
      }).catchError((e) {
        showToast(e.toString());
      });
    } catch (er) {
      showToast(er.toString());
    }
  }

  performUpdate(String version, BuildContext contxt) async {
    showDialog(
        context: contxt,
        useRootNavigator: false,
        builder: (ctx) {
          return WillPopScope(
            onWillPop: () async {
              Navigator.pop(context);
              return true;
            },
            child: AlertDialog(
              title: const Text("Select update type "),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    Navigator.pop(contxt);
                    startFlexibleUpdate(ctx);
                  },
                  child: const Text('Background update!'),
                ),
                TextButton(
                  onPressed: () {
                    // Navigator.pop(ctx);
                    // Navigator.pop(contxt);
                    try {
                      InAppUpdate.performImmediateUpdate().then((result) {
                        if (result == AppUpdateResult.success) {
                          Fluttertoast.showToast(msg: 'Update Success !');
                        } else if (result ==
                            AppUpdateResult.inAppUpdateFailed) {
                          Fluttertoast.showToast(msg: 'Update Failed !');
                        } else if (result == AppUpdateResult.userDeniedUpdate) {
                          Navigator.pop(context);
                          Fluttertoast.showToast(msg: 'Update Denied !');
                        }
                      }).catchError((e) => showToast(e.toString()));
                    } catch (err) {
                      Fluttertoast.showToast(msg: err.toString());
                    }
                  },
                  child: const Text('Immediate update!'),
                ),
              ],
            ),
          );
        });
  }

  startFlexibleUpdate(BuildContext ctx) async {
    try {
      InAppUpdate.startFlexibleUpdate().then((result) {
        if (result == AppUpdateResult.success) {
          Fluttertoast.showToast(msg: 'Update Success !');
          final snackBar = SnackBar(
            content: const Text('Update completed!'),
            action: SnackBarAction(
              label: 'Refresh',
              onPressed: () {
                InAppUpdate.completeFlexibleUpdate();
              },
            ),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        } else if (result == AppUpdateResult.inAppUpdateFailed) {
          Fluttertoast.showToast(msg: 'Update Failed !');
        } else if (result == AppUpdateResult.userDeniedUpdate) {
          Navigator.pop(ctx);
          Fluttertoast.showToast(msg: 'Update Denied !');
        }
      });
    } catch (err) {
      Fluttertoast.showToast(msg: err.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          actions: [
            GestureDetector(
              onTap: () {
                showModalBottomSheet(
                    isDismissible: true,
                    context: context,
                    builder: (ctx) {
                      return WillPopScope(
                        onWillPop: () async => true,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          child: Container(
                            height: 310,
                            width: double.infinity,
                            margin: const EdgeInsets.only(top: 0),
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                              ),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 25),
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
                                        child:
                                            const Icon(Icons.forward_to_inbox),
                                      )
                                    ],
                                  ),
                                  const SizedBox(height: 28),
                                  Consumer<AppProvider>(
                                      builder: (_, provider, __) {
                                    return Row(
                                      children: [
                                        const Text("Version "),
                                        const Spacer(),
                                        Text(provider.version),
                                      ],
                                    );
                                  }),
                                  const SizedBox(height: 28),
                                  Row(
                                    children: [
                                      const Text("Check for update! "),
                                      const Spacer(),
                                      GestureDetector(
                                        onTap: () {
                                          confirmUpdate(ctx);
                                        },
                                        child: const Icon(Icons.update),
                                      )
                                    ],
                                  ),
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
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
      ),
    );
  }
}
