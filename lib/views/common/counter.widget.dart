import 'package:flutter/material.dart';
import 'package:pdf_creator/provider/filter.provider.dart';
import 'package:provider/provider.dart';

class CounterWidget extends StatefulWidget {
  const CounterWidget({super.key});

  @override
  State<CounterWidget> createState() => _CounterWidgetState();
}

class _CounterWidgetState extends State<CounterWidget> {
  @override
  Widget build(BuildContext context) {
    return Consumer<FilterProvider>(builder: (_, provider, __) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () {
              provider.reduceFontSize();
            },
            child: const Icon(Icons.remove),
          ),
          const SizedBox(width: 5),
          Text(provider.fontSize.toString()),
          const SizedBox(width: 5),
          GestureDetector(
            onTap: () {
              provider.increaseFontSize();
            },
            child: const Icon(Icons.add),
          ),
        ],
      );
    });
  }
}
