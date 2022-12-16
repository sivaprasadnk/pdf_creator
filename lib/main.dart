import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import "package:text2pdf/text2pdf.dart";
import 'package:pdf_creator/provider/filter.provider.dart';
import 'package:pdf_creator/utils/routes.dart';
import 'package:pdf_creator/views/splash.screen.dart';
import 'package:provider/provider.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.white,

      statusBarIconBrightness: Brightness.dark, // status bar color
    ),
  );
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<FilterProvider>(
          create: ((context) => FilterProvider()),
        )
      ],
      child: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Pdf Creator',
          theme: ThemeData(
            primarySwatch: Colors.cyan,
          ),
          home: const SplashScreen(),
          routes: routes,
        ),
      ),
    );
  }
}
