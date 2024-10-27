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
      home: GalleryPicker(),
    );
  }
}

class GalleryPicker extends StatefulWidget {
  @override
  _GalleryPickerState createState() => _GalleryPickerState();
}

class _GalleryPickerState extends State<GalleryPicker> {
  String? _imagePath;

  Future<void> _openGallery() async {
    try {
      final String? imagePath =
          await MyApp.platform.invokeMethod('openGallery');
      setState(() {
        _imagePath = imagePath;
      });
    } on PlatformException catch (e) {
      print("Failed to open gallery: '${e.message}'.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gallery Picker'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _openGallery,
              child: Text('Open Gallery'),
            ),
            SizedBox(height: 20),
            if (_imagePath != null) ...[
              Text('Image Path:'),
              SizedBox(height: 10),
              Text(
                _imagePath!,
                style: TextStyle(fontSize: 14, color: Colors.black),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
