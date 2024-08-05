import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:health_care/components/reunioes_component.dart';
import 'package:health_care/models/usuario_reuniao.dart';
import 'package:health_care/models/reuniao.dart';
import 'package:health_care/models/usuario.dart';
import 'package:health_care/services/database_service.dart';
import 'package:health_care/shared/constants.dart';

class ReunioesPage extends StatefulWidget {
  const ReunioesPage({Key? key}) : super(key: key);

  @override
  State<ReunioesPage> createState() => _ReunioesPageState();
}

class _ReunioesPageState extends State<ReunioesPage> {
  late List<Reuniao> reunioes = [];
  late List<UsuarioReuniao> userReunioes = [];
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
        userReunioes = await databaseService.listarTodasReunioes();
      } else {
        reunioes = await databaseService.listarReunioesDoUsuario(usuario!);
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
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushReplacementNamed('/home');
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text('Reuniões'),
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
              padding: const EdgeInsets.only(left: 30.0, right: 30.0, bottom: 12.0),
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
                    ? userReunioes.length
                    : reunioes.length,
                itemBuilder: (context, index) {
                  final reuniao =
                      usuario?.tipoUsuario == TipoUsuario.Administrador
                          ? userReunioes[index].reuniao
                          : reunioes[index];

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ReuniaoComponent(
                        reuniao: reuniao,
                        usuario: usuario?.tipoUsuario == TipoUsuario.Administrador
                            ? userReunioes[index].usuario
                            : usuario!,
                        usuarioAuth: usuario!,
                        onPress: () {
                          Navigator.pushReplacementNamed(
                            context,
                            '/edit-reuniao',
                            arguments: {
                              'reuniao': reuniao,
                              'usuario': userReunioes.isNotEmpty
                                  ? userReunioes[index].usuario
                                  : usuario,
                              'novaReuniao': false,
                            },
                          );
                        },
                        onCardPress: () {
                          Navigator.pushReplacementNamed(
                            context,
                            '/detalhe-reuniao',
                            arguments: {
                              'reuniao': reuniao,
                              'usuario': usuario?.tipoUsuario ==
                                      TipoUsuario.Administrador
                                  ? userReunioes[index].usuario
                                  : usuario,
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
                      Navigator.pushReplacementNamed(
                        context,
                        '/edit-reuniao',
                        arguments: {
                          'novaReuniao': true,
                        },
                      );
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
