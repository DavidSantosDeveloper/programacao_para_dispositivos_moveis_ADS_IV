import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path/path.dart' as path;
import 'package:flutter_tts/flutter_tts.dart';

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
  FlutterTts flutterTts = FlutterTts();

  // Método para abrir a galeria e obter o caminho da imagem
  Future<void> _openGallery() async {
    if (Platform.isAndroid) {
      var storagePermission = await Permission.storage.status;

      if (Platform.version.contains('11') ||
          Platform.version.contains('12') ||
          Platform.version.contains('13')) {
        storagePermission = await Permission.manageExternalStorage.status;
      }

      if (!storagePermission.isGranted) {
        if (Platform.version.contains('11') ||
            Platform.version.contains('12') ||
            Platform.version.contains('13')) {
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

  // Método para obter a descrição da imagem usando a API Gemini e reproduzir em áudio
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

      // Reproduz o texto da descrição em áudio
      if (_imageDescription != null) {
        await _speakText(_imageDescription!);
      }
    } catch (e) {
      print('Erro ao descrever imagem: $e');
      setState(() {
        _imageDescription = 'Erro ao descrever imagem.';
      });
    }
  }

  // Função para sintetizar e reproduzir o texto em áudio
  Future<void> _speakText(String text) async {
    await flutterTts.setLanguage("pt-BR");
    await flutterTts.setSpeechRate(0.5); // Configura a velocidade
    await flutterTts.speak(text); // Reproduz o texto em áudio
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
