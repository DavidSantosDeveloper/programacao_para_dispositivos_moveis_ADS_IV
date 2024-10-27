import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static const platform = MethodChannel('com.example.gallery/channel');

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Gallery Opener'),
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: () async {
              try {
                final String? imagePath =
                    await platform.invokeMethod('openGallery');
                print('Image Path: $imagePath');
              } on PlatformException catch (e) {
                print("Failed to open gallery: '${e.message}'.");
              }
            },
            child: Text('Open Gallery'),
          ),
        ),
      ),
    );
  }
}
