import 'dart:io';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:path/path.dart' as path;
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'dart:typed_data';

 import 'package:image/image.dart' as img;  

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
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
  List<AssetPathEntity> _albums = [];
  List<AssetEntity> _images = [];
  String? _imageDescription;
  FlutterTts flutterTts = FlutterTts();

  @override
  void initState() {
    super.initState();
    _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.photos,
      Permission.videos,
      Permission.audio,
    ].request();

    bool allGranted = statuses.values.every((status) => status.isGranted);

    if (allGranted) {
      _loadAlbums();
    } else {
      _showPermissionDialog();
    }
  }

  void _showPermissionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Permissão necessária'),
        content: Text(
            'O aplicativo precisa de permissão para acessar suas fotos. Por favor, permita o acesso nas configurações.'),
        actions: [
          TextButton(
            onPressed: () {
              openAppSettings();
            },
            child: Text('Abrir configurações'),
          ),
        ],
      ),
    );
  }

  Future<void> _loadAlbums() async {
    List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(
      onlyAll: false,
      filterOption: FilterOptionGroup(
        imageOption: FilterOption(
          sizeConstraint: SizeConstraint(minWidth: 100, minHeight: 100),
        ),
        orders: [OrderOption(type: OrderOptionType.createDate)],
      ),
    );
    setState(() {
      _albums = albums;
    });
  }

  Future<void> _loadImages(AssetPathEntity album) async {
    List<AssetEntity> images = await album.getAssetListPaged(page: 0, size: 100);
    setState(() {
      _images = images;
    });
  }



Future<void> _getImageDescription(String filePath) async {
  final apiKey = 'AIzaSyD_VbN3miCOIDOr0r2wDvWbzUufg9eBzjc';
  final model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: apiKey);

  try {
    // Carregar a imagem
    final imageFile = File(filePath);
    final imageBytes = await imageFile.readAsBytes();
    final image = img.decodeImage(imageBytes); // Decodifica os bytes da imagem

    if (image == null) {
      print('Erro ao decodificar imagem.');
      setState(() {
        _imageDescription = 'Erro ao processar a imagem.';
      });
      return;
    }

    // Redimensionar a imagem
    final resizedImage = img.copyResize(image, width: 800); // Reduz a largura para 800px, mantendo a proporção
    final resizedBytes = img.encodeJpg(resizedImage);  // Codifica novamente para o formato JPEG

    final fileType = path.extension(filePath).toLowerCase();
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

    final prompt = TextPart("Descreva o conteúdo desta imagem em português.");
    final imagePart = DataPart(mimeType, resizedBytes);  // Envia a imagem redimensionada

    final response = await model.generateContent([Content.multi([prompt, imagePart])]);

    setState(() {
      _imageDescription = response.text ?? 'Descrição não disponível.';
    });

    if (_imageDescription != null) {
      await flutterTts.speak(_imageDescription!);
    }
  } catch (e) {
    print('Erro ao descrever imagem: $e');
    setState(() {
      _imageDescription = 'Erro ao descrever imagem: $e';
    });
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gallery Picker'),
      ),
      body: _albums.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                DropdownButton<AssetPathEntity>(
                  hint: Text("Selecione uma categoria"),
                  items: _albums.map((album) {
                    return DropdownMenuItem(
                      value: album,
                      child: Text(album.name),
                    );
                  }).toList(),
                  onChanged: (album) {
                    if (album != null) {
                      _loadImages(album);
                    }
                  },
                ),
                Expanded(
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 4,
                      mainAxisSpacing: 4,
                    ),
                    itemCount: _images.length,
                    itemBuilder: (context, index) {
                      return FutureBuilder<Uint8List?>(
                        future: _images[index].thumbnailDataWithSize(ThumbnailSize(200, 200)),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.done) {
                            return GestureDetector(
                              onTap: () async {
                                File? file = await _images[index].file;
                                if (file != null) {
                                  _getImageDescription(file.path);
                                }
                              },
                              child: Image.memory(
                                snapshot.data!,
                                fit: BoxFit.cover,
                              ),
                            );
                          }
                          return Container(
                            color: Colors.grey[300],
                          );
                        },
                      );
                    },
                  ),
                ),
                if (_imageDescription != null)
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      'Descrição da imagem: $_imageDescription',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
              ],
            ),
    );
  }
}
