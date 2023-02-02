
import 'package:flutter/material.dart';
// import 'package:in_app_update/in_app_update.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pdf_creator/provider/app.provider.dart';
import 'package:pdf_creator/views/create/create.screen.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String version = "";


  asyncInitState() async {
    await PackageInfo.fromPlatform().then((packageInfo) async {
      version = packageInfo.version;
      setState(() {});
      Provider.of<AppProvider>(context, listen: false).updateVersion(version);
    });
  }

  @override
  Widget build(BuildContext context) {
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
            if (version.isNotEmpty)
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
