import 'package:flutter/material.dart';
import 'package:health_care/components/clientes_component.dart';
import 'package:health_care/models/usuario.dart';
import 'package:health_care/services/database_service.dart';
import 'package:health_care/shared/constants.dart';

class ArquivosPage extends StatefulWidget {
  const ArquivosPage({Key? key}) : super(key: key);

  @override
  State<ArquivosPage> createState() => _ArquivosPageState();
}

class _ArquivosPageState extends State<ArquivosPage> {
  final TextEditingController pesquisaController = TextEditingController();
  late List<Usuario> usuarios = [];
  late List<Usuario> usuariosFiltered = [];
  bool isFilter = false;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    usuarios = await DatabaseService().listarUsuarios();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        surfaceTintColor: const Color.fromARGB(0, 0, 0, 0),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            FocusScope.of(context).unfocus();
            Navigator.pushReplacementNamed(context, '/home');
          },
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.only(left: 30.0, right: 30.0, bottom: 12.0),
            child: TextField(
              controller: pesquisaController,
              decoration: inputDec(
                Icons.search,
                'Digite o nome do cliente',
                'Pesquisar',
              ),
              onChanged: (text) {
                // Implemente a lógica de filtro aqui
              },
            ),
          ),
          Expanded(
            child: usuarios.isEmpty
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: usuarios.length,
                    itemBuilder: (context, index) {
                      final usuario = usuarios[index];
                      return ClientesComponent(
                        usuario: usuario,
                        onPress: () {
                          Navigator.pushReplacementNamed(
                            context,
                            '/detalhe-arquivo',
                            arguments: usuario,
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
