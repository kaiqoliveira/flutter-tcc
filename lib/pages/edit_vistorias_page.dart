// ignore_for_file: depend_on_referenced_packages

import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:health_care/components/botao_component.dart';
import 'package:health_care/models/usuario.dart';
import 'package:health_care/models/vistoria.dart';
import 'package:health_care/pages/detalhes_imagens_page.dart';
import 'package:health_care/services/database_service.dart';
import 'package:health_care/services/messaging_service.dart';
import 'package:health_care/services/storage_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:http/http.dart' as http;

class EditVistoriaPage extends StatelessWidget {
  const EditVistoriaPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Navigator.of(context).pushReplacementNamed('/vistorias');
          },
        ),
      ),
      body: const EditVistoriaContent(),
    );
  }
}

class EditVistoriaContent extends StatefulWidget {
  const EditVistoriaContent({Key? key}) : super(key: key);

  @override
  _EditVistoriaContentState createState() => _EditVistoriaContentState();
}

class _EditVistoriaContentState extends State<EditVistoriaContent> {
  final TextEditingController _dataController = TextEditingController();
  final TextEditingController _obsController = TextEditingController();
  final StorageService storageService = StorageService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  DatabaseService databaseService = DatabaseService();
  List<String> _imgList = [];
  List<File> _localImgList = [];
  int _currentImageIndex = 0;
  String _fileExtension = '';
  bool novaVistoria = false;
  late Usuario usuario;
  Vistoria? vistoria;
  DateTime? _selectedDate;
  bool _isLoading = true;
  Usuario? _selectedCliente;
  List<Usuario> _clientes = [];
  double largura = 0;
  double larguraObservacao = 0;

  @override
  void initState() {
    super.initState();
    _carregarClientes().then((_) {
      Future.delayed(Duration.zero, () {
        final Map<String, dynamic>? args =
            ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
        novaVistoria = args?['novaVistoria'] as bool;
        if (novaVistoria == true) {
          _isLoading = false;
          vistoria = Vistoria(data: DateTime.now(), observacoes: '');
          _dataController.text = '';
          _obsController.text = '';
          _imgList = [];
        } else {
          vistoria = (args?['vistoria'] as Vistoria?)!;
          usuario = args?['usuario'] as Usuario;
          _selectedCliente = _clientes.firstWhere(
              (cliente) => cliente.id == usuario.id,
              orElse: () => usuario);
          if (vistoria != null) {
            _carregarImagens();
          }
        }
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final Map<String, dynamic>? args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    if (!novaVistoria) {
      novaVistoria = args?['novaVistoria'] as bool;
    }
    if (novaVistoria == false) {
      vistoria = (args?['vistoria'] as Vistoria?)!;
      usuario = args?['usuario'] as Usuario;

      if (vistoria != null) {
        _carregarImagens();
      }
    }
  }

  Future<void> _carregarClientes() async {
    List<Usuario> clientes = await databaseService.listarUsuarios();
    setState(() {
      _clientes = clientes;
    });
  }

  @override
  void dispose() {
    _dataController.dispose();
    _obsController.dispose();
    super.dispose();
  }

  void _carregarImagens() async {
    if (novaVistoria == true) {
      return;
    }
    setState(() {
      _isLoading = true;
    });
    try {
      ListResult result =
          await storageService.listImages(usuario.email!, vistoria!.id!);
      List<String> imageUrls = [];
      for (Reference ref in result.items) {
        String url = await ref.getDownloadURL();
        imageUrls.add(url);
      }
      if (mounted) {
        setState(() {
          _imgList = imageUrls;
        });
      }
    } catch (e) {
      print('Erro ao carregar imagens: $e');
    } finally {
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
    double tamanhoTela = MediaQuery.of(context).size.width;
    String dataVistoria = '';
    String obsVistoria = '';

    if (vistoria != null) {
      dataVistoria = formatter.format(vistoria!.data!);
      obsVistoria = vistoria!.observacoes!;
    }

    _dataController.text = dataVistoria;
    _obsController.text = obsVistoria;

    if (tamanhoTela < 1000) {
      largura = tamanhoTela;
      larguraObservacao = tamanhoTela;
    } else if (tamanhoTela < 1600) {
      largura = tamanhoTela;
    } else {
      largura = tamanhoTela / 4;
    }

    return Scaffold(
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
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
                                currentImageIndex: _currentImageIndex,
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 50),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.add),
                                onPressed: () {
                                  _pickAndUploadFile();
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  _deleteImage(_imgList[_currentImageIndex]);
                                },
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: tamanhoTela * 0.05,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: tamanhoTela * 0.05),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: tamanhoTela * 0.05),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Text(
                                      'Vistoria Realizada',
                                      style: TextStyle(
                                        fontSize: 40,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: tamanhoTela * 0.02),
                                    SizedBox(
                                      width: largura,
                                      child: DropdownButtonFormField<Usuario>(
                                        isExpanded: true,
                                        hint:
                                            const Text('Selecione um cliente'),
                                        value: _selectedCliente,
                                        items: _clientes
                                            .map((Usuario cliente) =>
                                                DropdownMenuItem<Usuario>(
                                                  value: cliente,
                                                  child: Text(cliente.nome!),
                                                ))
                                            .toList(),
                                        onChanged: (Usuario? newValue) {
                                          setState(() {
                                            _selectedCliente = newValue;
                                          });
                                        },
                                        decoration: const InputDecoration(
                                          labelText: 'Cliente',
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: tamanhoTela * 0.02),
                                    GestureDetector(
                                      onTap: () {
                                        _selectDate(context);
                                      },
                                      child: AbsorbPointer(
                                        child: SizedBox(
                                          width: largura,
                                          child: TextFormField(
                                            controller: _dataController,
                                            keyboardType:
                                                TextInputType.datetime,
                                            decoration: const InputDecoration(
                                              labelText: 'Data',
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: tamanhoTela * 0.02),
                                    SizedBox(
                                      width: largura,
                                      child: TextFormField(
                                        controller: _obsController,
                                        keyboardType: TextInputType.multiline,
                                        maxLines: null,
                                        decoration: const InputDecoration(
                                          labelText: 'Observações',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: BotaoWidget(
                    onPress: () {
                      _salvarVistoria();
                    },
                    text: 'Salvar',
                  ),
                ),
              ],
            ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dataController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
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
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _deleteImage(String imageUrl) async {
    try {
      if (_isLocalFile(imageUrl)) {
        File file = File(imageUrl);
        if (await file.exists()) {
          await file.delete();
          setState(() {
            _imgList.remove(imageUrl);
            if (_imgList.isEmpty) {
              _currentImageIndex = 0;
            } else if (_currentImageIndex >= _imgList.length) {
              _currentImageIndex = _imgList.length - 1;
            }
          });
        }
      } else {
        await storageService.deleteImage(imageUrl);
        setState(() {
          _imgList.remove(imageUrl);
          if (_imgList.isEmpty) {
            _currentImageIndex = 0;
          } else if (_currentImageIndex >= _imgList.length) {
            _currentImageIndex = _imgList.length - 1;
          }
        });
      }
    } catch (e) {
      print('Erro ao excluir imagem: $e');
    }
  }

  bool _isLocalFile(String imageUrl) {
    return imageUrl.startsWith('file://');
  }

  _pickAndUploadFile() async {
    String filePath = '';

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.image,
    );

    if (result == null) {
      _exibirMensagem("Nenhuma imagem selecionada");
    } else {
      filePath = result.files.single.path!;
      _fileExtension = p.extension(filePath).toLowerCase();
      if (_isImageExtension(filePath)) {
        if (novaVistoria) {
          setState(() {
            _localImgList.add(File(filePath));
            _imgList.add(filePath);
          });
        } else {
          await storageService.uploadImage(
              filePath, usuario.email!, _fileExtension, vistoria!.id!);
          _exibirMensagem("Upload da imagem concluído com sucesso");
          _carregarImagens();
        }
      } else {
        _exibirMensagem("O arquivo selecionado não é uma imagem");
      }
    }
  }

  bool _isImageExtension(String path) {
    String extension = p.extension(path).toLowerCase();
    return extension == '.jpg' ||
        extension == '.jpeg' ||
        extension == '.png' ||
        extension == '.gif' ||
        extension == '.bmp';
  }

  void _exibirMensagem(String mensagem) {
    final snackbar = SnackBar(content: Text(mensagem));
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
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
    }
  }

  Future<void> _salvarVistoria() async {
    if (novaVistoria) {
      // Obtenha o próximo ID de vistoria como string
      String novoId = await _obterProximoIdVistoria();

      // Crie um novo documento de vistoria com o ID sequencial
      Vistoria novaVistoria = Vistoria(
        id: novoId,
        data: _selectedDate ?? DateTime.now(),
        observacoes: _obsController.text,
      );

      // Adicione o documento com um ID automático e o ID sequencial dentro do documento
      await databaseService.adicionarVistoria(
          _selectedCliente!.id!, novaVistoria);

      // Faça o upload das imagens para o Storage
      for (File imageFile in _localImgList) {
        await storageService.uploadImage(
            imageFile.path, _selectedCliente!.email!, _fileExtension, novoId);
      }

      _exibirMensagem("Vistoria e imagens salvas com sucesso");
      _enviarNotificacao(_selectedCliente);
    } else {
      // Atualize a vistoria existente no banco de dados aqui
      vistoria!.data = _selectedDate ?? vistoria!.data!;
      vistoria!.observacoes = _obsController.text;

      await databaseService.atualizarVistoria(_selectedCliente!.id!, vistoria!);

      _exibirMensagem("Vistoria atualizada com sucesso");
    }

    Navigator.of(context).pushReplacementNamed('/vistorias');
  }

  Future<String> _obterProximoIdVistoria() async {
    List<Vistoria> vistorias =
        await databaseService.listarVistorias(_selectedCliente!.id!);
    if (vistorias.isEmpty) {
      return '1';
    }
    // Converte os IDs para inteiros
    List<int> ids =
        vistorias.map((vistoria) => int.tryParse(vistoria.id!) ?? 0).toList();
    // Encontra o maior ID
    int ultimoId = ids.reduce((a, b) => a > b ? a : b);
    // Adiciona 1 e converte de volta para string
    return (ultimoId + 1).toString();
  }

  void _enviarNotificacao(Usuario? selectedCliente) {
    FirebaseApi().sendNotification(selectedCliente!.messageToken!);
  }
}
