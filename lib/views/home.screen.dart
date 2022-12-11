import 'package:flutter/material.dart';
import 'package:pdf_creator/utils/data.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
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
            SizedBox(height: height * 0.4),
            ListView.builder(
              itemCount: homeMenuList.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                var menu = homeMenuList[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, menu.routeName);
                  },
                  child: Container(
                    height: 50,
                    margin: const EdgeInsets.all(15),
                    width: width * 0.8,
                    decoration: BoxDecoration(
                      color: Colors.cyan,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        menu.title,
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
