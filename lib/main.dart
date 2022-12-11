import 'package:flutter/material.dart';
// import "package:text2pdf/text2pdf.dart";
import 'package:pdf_creator/provider/filter.provider.dart';
import 'package:pdf_creator/utils/data.dart';
import 'package:pdf_creator/views/create/create.screen.dart';
import 'package:pdf_creator/views/saved/saved.lists.dart';
import 'package:provider/provider.dart';

void main() {
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
            primarySwatch: Colors.blue,
          ),
          home: const HomeScreen(),
        ),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 250),
            const Text(
              'Pdf Creator',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            ),
            GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                mainAxisExtent: 150,
              ),
              itemCount: homeScreenTiles.length,
              itemBuilder: (context, index) {
                var item = homeScreenTiles[index];
                return GestureDetector(
                  onTap: () {
                    if (index == 0) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: ((context) => const SavedListScreen())),
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: ((context) => const CreateScreen())),
                      );
                    }
                  },
                  child: Container(
                    height: 100,
                    width: 75,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black,
                      ),
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: Center(
                      child: Text(item),
                    ),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
