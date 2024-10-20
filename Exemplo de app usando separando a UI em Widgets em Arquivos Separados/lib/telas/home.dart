import 'package:flutter/material.dart';
import 'package:flutter_application_3/widgets/ContainerDeTextos.dart';

class HomePage extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: new Text('App menu'),
      ),
      body: new ContainerDeTextos(),
      backgroundColor: Colors.lightBlue,
    );
  }
}
