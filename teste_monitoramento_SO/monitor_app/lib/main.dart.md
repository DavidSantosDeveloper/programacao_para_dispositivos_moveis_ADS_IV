import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path/path.dart' as path;

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
   String? _imageDescription;

  Future<void> _openGallery() async {
    try {
      final String? imagePath =
          await MyApp.platform.invokeMethod('openGallery');
      setState(() {
        _imagePath = imagePath;
         _imageDescription = null;
      });
      if (_imagePath != null) {
        await _getImageDescription();
      }
    } on PlatformException catch (e) {
      print("Failed to open gallery: '${e.message}'.");
    }
  }

 Future<void> _getImageDescription() async {
    final apiKey = 'AIzaSyD_VbN3miCOIDOr0r2wDvWbzUufg9eBzjc';
    final model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: apiKey);

    try {
      final imageBytes = await File(_imagePath!).readAsBytes();
      final fileType = path.extension(_imagePath!).toLowerCase();

      String mimeType;
      switch (fileType) {
        case '.png':
          mimeType = 'image/png';
          break;
        case '.webp':
          mimeType = 'image/webp';
          break;
        case '.gif':
          mimeType = 'image/gif';
          break;
        case '.bmp':
          mimeType = 'image/bmp';
          break;
        case '.jpeg':
        case '.jpg':
        default:
          mimeType = 'image/jpeg';
      }

      final prompt = TextPart(
          "Descreva o conteúdo desta imagem.A descricão deve ser em lingua portuguesa.");
      final imagePart = DataPart(mimeType, imageBytes);

      final response = await model.generateContent([
        Content.multi([prompt, imagePart])
      ]);

      setState(() {
        _imageDescription = response.text;
      });
      print(response.text);

      // Reproduz o texto da descrição em áudio
      
    } catch (e) {
      print('Erro ao descrever imagem: $e');
      setState(() {
        _imageDescription = 'Erro ao descrever imagem.';
      });
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