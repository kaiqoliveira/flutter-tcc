import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:health_care/components/vistorias_component.dart';
import 'package:health_care/models/usuario_vistoria.dart';
import 'package:health_care/models/vistoria.dart';
import 'package:health_care/models/usuario.dart'; // Importe o modelo de usuário
import 'package:health_care/services/database_service.dart';
import 'package:health_care/shared/constants.dart';

class VistoriasPage extends StatefulWidget {
  const VistoriasPage({Key? key}) : super(key: key);

  @override
  State<VistoriasPage> createState() => _VistoriasPageState();
}

class _VistoriasPageState extends State<VistoriasPage> {
  late List<Vistoria> vistorias = [];
  late List<UsuarioVistoria> userVistorias = [];
  DatabaseService databaseService = DatabaseService();
  final pesquisaController = TextEditingController();
  Usuario? usuario;
  double tamanho = 60;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      usuario = await databaseService.obterUsuario(user.uid);

      if (usuario!.tipoUsuario == TipoUsuario.Administrador) {
        userVistorias = await databaseService.listarTodasVistorias();
      } else {
        vistorias = await databaseService.listarVistoriasDoUsuario(usuario!);
      }

      setState(() {});
    } else {
      print('Nenhum usuário autenticado encontrado.');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).size.width >= 600) {
      tamanho = 100;
    }
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (!didPop) {
          Navigator.of(context).pushReplacementNamed('/home');
        }
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text('Vistorias'),
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
                  //_followingBloc.findPlayerName(text);
                },
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: usuario?.tipoUsuario == TipoUsuario.Administrador
                    ? userVistorias.length
                    : vistorias.length,
                itemBuilder: (context, index) {
                  final vistoria =
                      usuario?.tipoUsuario == TipoUsuario.Administrador
                          ? userVistorias[index].vistoria
                          : vistorias[index];
    
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      VistoriaComponent(
                        data: vistoria.data!,
                        usuario:
                            usuario?.tipoUsuario == TipoUsuario.Administrador
                                ? userVistorias[index].usuario
                                : usuario!,
                        usuarioAuth: usuario!,
                        onPress: () {
                          Navigator.pushReplacementNamed(
                            context,
                            '/edit-vistoria',
                            arguments: {
                              'vistoria': vistoria,
                              'usuario': userVistorias.isNotEmpty
                                  ? userVistorias[index].usuario
                                  : usuario,
                              'novaVistoria': false,
                            },
                          );
                        },
                        onCardPress: () {
                          Navigator.pushReplacementNamed(
                            context,
                            '/detalhe-vistoria',
                            arguments: {
                              'vistoria': vistoria,
                              'usuario': usuario?.tipoUsuario ==
                                      TipoUsuario.Administrador
                                  ? userVistorias[index].usuario
                                  : usuario,
                              'novaVistoria': false,
                            },
                          );
                        },
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
        floatingActionButton: usuario != null &&
                usuario!.tipoUsuario == TipoUsuario.Administrador
            ? SizedBox(
                width: tamanho,
                height: tamanho,
                child: FittedBox(
                  child: FloatingActionButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/edit-vistoria', arguments: {
                        'novaVistoria': true,
                      },);
                    },
                    backgroundColor: const Color.fromARGB(255, 175, 164, 160),
                    foregroundColor: Colors.white,
                    child: const Icon(Icons.add),
                  ),
                ),
              )
            : null,
      ),
    );
  }
}
