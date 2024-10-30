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

  // Método para abrir a galeria e obter o caminho da imagem
  Future<void> _openGallery() async {
    if (Platform.isAndroid) {
      var storagePermission = await Permission.storage.status;

      // Verifique a versão do Android
      if (Platform.operatingSystemVersion.contains('Android 11') ||
          Platform.operatingSystemVersion.contains('Android 12') ||
          Platform.operatingSystemVersion.contains('Android 13')) {
        storagePermission = await Permission.manageExternalStorage.status;
      }

      // Solicita a permissão correta
      if (!storagePermission.isGranted) {
        if (Platform.operatingSystemVersion.contains('Android 11') ||
            Platform.operatingSystemVersion.contains('Android 12') ||
            Platform.operatingSystemVersion.contains('Android 13')) {
          storagePermission = await Permission.manageExternalStorage.request();
        } else {
          storagePermission = await Permission.storage.request();
        }
      }

      if (storagePermission.isGranted) {
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
          print("Falha ao abrir a galeria: '${e.message}'.");
        }
      } else {
        print("Permissão de armazenamento negada.");
      }
    }
  }

  // Método para obter a descrição da imagem usando a API Gemini
  Future<void> _getImageDescription() async {
    final apiKey = 'YOUR_API_KEY';
    final model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: apiKey);

    try {
      final imageBytes = await File(_imagePath!).readAsBytes();
      final fileType = path.extension(_imagePath!).toLowerCase();

      // Ajusta o tipo de conteúdo da imagem conforme o formato detectado
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

      final prompt = TextPart("Descreva o conteúdo desta imagem.");
      final imagePart = DataPart(mimeType, imageBytes);

      final response = await model.generateContent([
        Content.multi([prompt, imagePart])
      ]);

      setState(() {
        _imageDescription = response.text;
      });
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
        title: Text('Selecionador de Galeria com Descrição de Imagem'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _openGallery,
              child: Text('Abrir Galeria'),
            ),
            SizedBox(height: 20),
            if (_imagePath != null) ...[
              Text('Caminho da Imagem:'),
              SizedBox(height: 10),
              Text(
                _imagePath!,
                style: TextStyle(fontSize: 14, color: Colors.black),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              _imageDescription != null
                  ? Text(
                      'Descrição da Imagem:',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    )
                  : CircularProgressIndicator(),
              SizedBox(height: 10),
              Text(
                _imageDescription ?? 'Carregando descrição...',
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
