import 'package:flutter/material.dart';
import 'package:health_care/components/clientes_component.dart';
import 'package:health_care/models/usuario.dart';
import 'package:health_care/shared/constants.dart';
import 'package:health_care/services/database_service.dart';

class ClientesPage extends StatefulWidget {
  const ClientesPage({Key? key}) : super(key: key);

  @override
  State<ClientesPage> createState() => _ClientesPageState();
}

class _ClientesPageState extends State<ClientesPage> {
  final TextEditingController pesquisaController = TextEditingController();
  late List<Usuario> usuarios = [];
  late List<Usuario> filteredUsuarios = [];
  bool isFilter = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _buscarUsuarios();
  }

  void _buscarUsuarios() async {
    try {
      usuarios = await DatabaseService().listarUsuarios();
      filteredUsuarios = usuarios;
    } catch (e) {
      print('Erro ao buscar usuários: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final usuario = ModalRoute.of(context)!.settings.arguments as Usuario;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            FocusScope.of(context).unfocus();
            Navigator.pushReplacementNamed(context, '/home');
          },
        ),
      ),
      body: isLoading
          ? const Center(
              child:
                  CircularProgressIndicator()) // Exibir indicador de carregamento enquanto os usuários estão sendo buscados
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 30.0, right: 30.0, bottom: 12.0),
                    child: TextField(
                      controller: pesquisaController,
                      decoration: inputDec(
                        Icons.search,
                        'Digite o nome do cliente',
                        'Pesquisar',
                      ),
                      onChanged: (text) {
                        filterSearchResults(text);
                      },
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height - 200,
                    child: ListView.builder(
                      itemCount: filteredUsuarios.length,
                      itemBuilder: (context, index) {
                        return ClientesComponent(
                          usuario: filteredUsuarios[index],
                          onPress: () {
                            Navigator.pushReplacementNamed(
                                context, '/detalhe-clientes',
                                arguments: filteredUsuarios[index]);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  void filterSearchResults(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredUsuarios = List.from(usuarios);
        isFilter = false;
      } else {
        filteredUsuarios = usuarios
            .where((usuario) =>
                usuario.nome!.toLowerCase().contains(query.toLowerCase()))
            .toList();
        isFilter = true;
      }
    });
  }
}
