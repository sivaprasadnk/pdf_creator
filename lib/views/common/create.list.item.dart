import 'package:flutter/material.dart';

class CreateListItem extends StatelessWidget {
  const CreateListItem(
      {super.key,
      required this.routeName,
      this.arguments,
      required this.title});

  final String routeName;
  final Object? arguments;
  final String title;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, routeName, arguments: arguments);
      },
      child: Container(
        width: 150,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.cyan,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}
