import 'dart:async';

import 'package:flutter/material.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pdf_creator/views/create/create.screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String version = "";

  AppUpdateInfo? _updateInfo;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  // final bool _flexibleUpdateAvailable = false;

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> checkForUpdate() async {
    InAppUpdate.checkForUpdate().then((info) {
      // _updateInfo = info;
      if (_updateInfo?.updateAvailability ==
          UpdateAvailability.updateAvailable) {
        InAppUpdate.performImmediateUpdate()
            .catchError((e) => showSnack(e.toString()));
      }
    }).catchError((e) {
      showSnack(e.toString());
    });
  }

  showSnack(String text) {
    if (_scaffoldKey.currentContext != null) {
      ScaffoldMessenger.of(_scaffoldKey.currentContext!)
          .showSnackBar(SnackBar(content: Text(text)));
    }
  }

  @override
  void initState() {
    asyncInitState();
    super.initState();
  }

  asyncInitState() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    version = packageInfo.version;
    setState(() {});
    await checkForUpdate();
  }

  @override
  Widget build(BuildContext context) {
    // var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      bottomNavigationBar: GestureDetector(
        onTap: () {
          Navigator.pushNamedAndRemoveUntil(
              context, CreateScreen.routeName, (route) => false);
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
              'Continue',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: height * 0.3),
            const Center(
              child: Text(
                'PDF \nCreator',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: "Arvo",
                  color: Colors.red,
                  fontSize: 50,
                ),
              ),
            ),
            const SizedBox(height: 50),
            Center(
              child: Text("v$version"),
            ),
            SizedBox(height: height * 0.18),
          ],
        ),
      ),
    );
  }
}
