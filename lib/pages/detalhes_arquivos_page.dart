import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:health_care/models/usuario.dart';
import 'package:health_care/services/database_service.dart';
import 'package:health_care/services/storage_service.dart';
import 'package:open_app_file/open_app_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class DetalhesArquivoPage extends StatefulWidget {
  const DetalhesArquivoPage({
    Key? key,
  }) : super(key: key);

  @override
  State<DetalhesArquivoPage> createState() => _DetalhesArquivoPageState();
}

class _DetalhesArquivoPageState extends State<DetalhesArquivoPage> {
  bool loading = true;
  late ListResult refs;
  late Usuario usuario;
  String emailAddress = '';
  String _fileExtension = '';
  List<String> arquivos = [];
  String retorno = '/arquivos';
  late ListResult arquivosCompletos;
  final storageRef = FirebaseStorage.instance.ref();
  DatabaseService databaseService = DatabaseService();
  final StorageService storageService = StorageService();
  final FirebaseStorage storage = FirebaseStorage.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  Usuario? usuarioAuth;

  @override
  void initState() {
    super.initState();
    _firebaseAuth.authStateChanges().listen(
      (User? user) {
        if (user != null) {
          _defineRetorno(user);
          _carregarUsuario(user);
        }
      },
    );
  }

  void _defineRetorno(User? user) async {
    if (user != null) {
      usuarioAuth = await databaseService.obterUsuario(user.uid);
      if (usuarioAuth?.tipoUsuario == TipoUsuario.Administrador) {
        setState(() {
          retorno = '/arquivos';
        });
      } else {
        setState(() {
          retorno = '/home';
        });
      }
    }
  }

  // Método para carregar o usuário
  void _carregarUsuario(User user) async {
    usuarioAuth = await databaseService.obterUsuario(user.uid);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    usuario = ModalRoute.of(context)!.settings.arguments as Usuario;
    _listarArquivos(usuario.email!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back_ios_new),
              onPressed: () {
                FocusScope.of(context).unfocus();
                Navigator.pushReplacementNamed(
                  context,
                  retorno,
                  arguments: usuario,
                );
              },
            ),
            const Text('Arquivos'),
          ],
        ),
        actions: [
          if (usuarioAuth?.tipoUsuario == TipoUsuario.Administrador)
            IconButton(
              icon: const Icon(Icons.upload),
              onPressed: () {
                pickAndUploadFile();
              },
            ),
        ],
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(24.0),
              child: arquivos.isEmpty
                  ? const Center(child: Text('Você não tem nenhum arquivo.'))
                  : ListView.builder(
                      itemBuilder: (BuildContext context, index) {
                        return ListTile(
                          leading: const SizedBox(
                            width: 60,
                            height: 40,
                            child: Icon(Icons.file_copy_outlined),
                          ),
                          title: Text(arquivos[index]),
                          trailing: IconButton(
                            icon: const Icon(Icons.download),
                            onPressed: () {
                              _downloadFile(arquivosCompletos.items[index]);
                            },
                          ),
                        );
                      },
                      itemCount: arquivos.length,
                    ),
            ),
    );
  }

  pickAndUploadFile() async {
    String filePath = '';

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'pdf', 'doc'],
    );

    if (result == null) {
      _exibirMensagem("Nenhum arquivo selecionado");
    } else {
      filePath = result.files.single.path!;
      _fileExtension = p.extension(result.files.single.path!);

      storageService.uploadFile(filePath, usuario.email!, _fileExtension);
    }
  }

  _downloadFile(Reference arquivoDownload) async {
    final islandRef = storageRef.child(arquivoDownload.fullPath);

    final appDocDir = await getApplicationDocumentsDirectory();

    final String appDocPath = appDocDir.path;
    final File tempFile = File(appDocPath + '/' + arquivoDownload.name);

    islandRef.writeToFile(tempFile);

    await tempFile.create();
    await OpenAppFile.open(tempFile.path);
  }

  void _exibirMensagem(String mensagem) {
    final snackbar = SnackBar(content: Text(mensagem));
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  _listarArquivos(String email) async {
    refs = (await storageService.listFiles(email));
    arquivosCompletos = refs;
    List<String> arquivosList = [];
    for (var ref in refs.items) {
      final arquivo = ref.name;
      arquivosList.add(arquivo);
    }

    if (mounted) {
      setState(() {
        arquivos = arquivosList;
        loading = false;
      });
    }
  }
}
