import 'package:flutter/material.dart';

class ItemContainerDeTextos extends StatelessWidget {
  final String text1;
  final String text2;
  final String text3;

  const ItemContainerDeTextos({
    Key? key,
    required this.text1,
    required this.text2,
    required this.text3,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [Text(text1), Text(text2), Text(text3)],
    );
  }
}
