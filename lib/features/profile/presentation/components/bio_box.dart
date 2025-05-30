import 'package:flutter/material.dart';

class BioBox extends StatelessWidget {
  final String text;
  const BioBox({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.tertiary),
      child: Text(text.isNotEmpty ? text : "Empty bio..."),
    );
  }
}
