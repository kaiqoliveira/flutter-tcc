import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:health_care/models/usuario.dart';
import 'package:health_care/models/vistoria.dart';
import 'package:health_care/pages/detalhes_imagens_page.dart';
import 'package:intl/intl.dart';
import 'package:health_care/services/database_service.dart';
import 'package:health_care/services/storage_service.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:http/http.dart' as http;

class DetalhesVistoriaPage extends StatelessWidget {
  const DetalhesVistoriaPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (!didPop) {
          Navigator.of(context).pushReplacementNamed('/vistorias');
        }
      },
      child: const DetalhesVistoriaContent(),
    );
  }
}

class DetalhesVistoriaContent extends StatefulWidget {
  const DetalhesVistoriaContent({Key? key}) : super(key: key);

  @override
  _DetalhesVistoriaContentState createState() =>
      _DetalhesVistoriaContentState();
}

class _DetalhesVistoriaContentState extends State<DetalhesVistoriaContent> {
  final int _currentImageIndex = 0; // Índice da imagem atual
  late bool _isLoading;
  List<String> _imgList = []; // Lista de URLs das imagens
  late Vistoria vistoria;
  late Usuario usuario;
  final StorageService storageService = StorageService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  DatabaseService databaseService = DatabaseService();
  Usuario? usuarioAuth;
  double tamanhoFonteTitulo = 35;
  double tamanhoFonteTexto = 25;

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    _carregarImagens();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final Map<String, dynamic>? args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    vistoria = (args?['vistoria'] as Vistoria?)!;
    usuario = args?['usuario'] as Usuario;
    if (vistoria != null) {
      _carregarImagens();
    }
  }

  void _carregarImagens() async {
    try {
      ListResult result =
          await storageService.listImages(usuario.email!, vistoria.id!);
      List<String> imageUrls = [];
      for (Reference ref in result.items) {
        String url = await ref.getDownloadURL();
        imageUrls.add(url);
      }
      setState(() {
        _imgList = imageUrls;
        _isLoading =
            false; // Define como falso quando o carregamento é concluído
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final DateFormat formatter = DateFormat('dd/MM/yyyy');

    double screenWidth = MediaQuery.of(context).size.width;
    final String dataVistoria = formatter.format(vistoria.data!);
    final String obsVistoria = vistoria.observacoes!;
    double tamanhoTela = MediaQuery.of(context).size.width;
    if (tamanhoTela < 1000) {
      tamanhoFonteTitulo = 28;
      tamanhoFonteTexto = 18;
    } else if (tamanhoTela < 1600) {
      tamanhoFonteTitulo = 30;
      tamanhoFonteTexto = 20;
    } else {
      tamanhoFonteTitulo = 35;
      tamanhoFonteTexto = 25;
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            FocusScope.of(context).unfocus();
            Navigator.pushReplacementNamed(context, '/vistorias');
          },
        ),
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      GestureDetector(
                        onLongPress: () {
                          _showImageOptions(
                              context, _imgList[_currentImageIndex]);
                        },
                        child: DetalhesImagemPage(
                            imgList: _imgList,
                            currentImageIndex: _currentImageIndex),
                      )
                    ],
                  ),
                  const SizedBox(height: 20), // Espaçamento responsivo
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Vistoria Realizada',
                          style: TextStyle(
                            fontSize:
                                tamanhoFonteTitulo, // Tamanho do titulo responsivo
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20), // Espaçamento responsivo
                        Text(
                          'Data: $dataVistoria',
                          style: TextStyle(
                            fontSize:
                                tamanhoFonteTexto, // Tamanho do texto responsivo
                          ),
                        ),
                        const SizedBox(height: 20), // Espaçamento responsivo
                        Text(
                          'Obs: $obsVistoria',
                          style: TextStyle(
                            fontSize:
                                tamanhoFonteTexto, // Tamanho do texto responsivo
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  void _showImageOptions(BuildContext context, String imageUrl) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.content_copy),
              title: const Text('Copiar'),
              onTap: () {
                Clipboard.setData(ClipboardData(text: imageUrl));
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.file_download),
              title: const Text('Download'),
              onTap: () async {
                await _downloadImage(imageUrl);
                // ignore: use_build_context_synchronously
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _downloadImage(String imageUrl) async {
    final externalDir = await getExternalStorageDirectory();
    final savedDir = Directory('${externalDir?.path}/Imagens');
    bool hasExisted = await savedDir.exists();
    if (!hasExisted) {
      savedDir.create();
    }

    final fileName = imageUrl.split('/').last;
    final response = await http.get(Uri.parse(imageUrl));
    if (response.statusCode == 200) {
      final Uint8List bytes = response.bodyBytes;
      final File imageFile = File('${savedDir.path}/$fileName');
      await imageFile.writeAsBytes(bytes);

      //   final taskId = await FlutterDownloader.enqueue(
      //     url: imageUrl
      //     url: imageUrl,
      //     savedDir: savedDir.path,
      //     showNotification: true,
      //     openFileFromNotification: true,
      //   );
      // } else {
      //   throw Exception('Falha ao baixar a imagem');
      // }
    }
  }
}
