import 'package:flutter/material.dart';
import 'package:pdf_creator/views/create/image/image.list.screen.dart';
import 'package:pdf_creator/views/create/text/single.text.screen.dart';
import 'package:pdf_creator/views/create/text/text.list.screen.dart';

class CreateScreen extends StatefulWidget {
  const CreateScreen({super.key});

  @override
  State<CreateScreen> createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 75),
          const Center(child: Text("From Text")),
          Center(
            child: Container(
              width: 200,
              decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.cyan,
                  ),
                  borderRadius: BorderRadius.circular(5)),
              child: Column(
                children: [
                  ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: ((context) => const TextListScreen())),
                        );
                      },
                      child: const Text("List")),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: ((context) => const SingleTextScreen())),
                      );
                    },
                    child: const Text("Single Plain Text"),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 75),
          const Center(child: Text("From Image")),
          Center(
            child: Container(
              width: 200,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.cyan,
                ),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: ((context) => const ImageListScreen())),
                      );
                    },
                    child: const Text("List"),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: ((context) => const EditImageScreen())));
                    },
                    child: const Text("Single Image"),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
