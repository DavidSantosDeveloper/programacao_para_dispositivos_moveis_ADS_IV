import 'package:flutter/material.dart';
import 'package:flutter_application_3/widgets/ItemContainerDeTextos.dart';

class ContainerDeTextos extends StatelessWidget {
  Widget build(BuildContext context) {
    return new Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ItemContainerDeTextos(
            text1: "Filho 1", text2: "Filho 2", text3: "Filho 3"),
        ItemContainerDeTextos(
            text1: "Filho 4", text2: "Filho 5", text3: "Filho 6"),
        ItemContainerDeTextos(
            text1: "Filho 7", text2: "Filho 8", text3: "Filho 9"),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.yellow, width: 4),
            borderRadius: BorderRadius.circular(8),
          ),
          child: new Row(
            children: [Text("Davi")],
          ),
        )
      ],
    );
  }
}
