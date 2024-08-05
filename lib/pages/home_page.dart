import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:health_care/components/box_home_page.dart';
import 'package:health_care/models/usuario.dart';
import 'package:health_care/pages/configuracoes_page.dart';
import 'package:health_care/services/auth_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int page = 0;
  AuthService authService = AuthService();

  late Usuario usuario;
  bool admin = false;
  bool isLoading = true;
  bool isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    Usuario? user = await authService.validaUsuarioLogado();
    if (user == null) {
      Navigator.of(context).pushReplacementNamed('/login');
    } else {
      setState(() {
        usuario = user;
        admin = user.tipoUsuario == TipoUsuario.Administrador;
        isLoading = false;
        isLoggedIn = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else if (!isLoggedIn) {
      // This case should not be reached since Navigator.pushReplacementNamed('/login') will redirect the user
      return Container();
    } else {
      return Scaffold(
        body: getBody(usuario),
        bottomNavigationBar: getBottomNavigationBar(),
      );
    }
  }

  Widget getBody(Usuario usuario) {
    return IndexedStack(
      index: page,
      children: [
        getHomeBody(usuario),
        const ConfiguracoesPage(),
      ],
    );
  }

  Widget getHomeBody(Usuario usuario) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(height: 50),
          const Padding(
            padding: EdgeInsets.only(left: 30.0, top: 50.0),
            child: Text(
              'Olá,',
              style: TextStyle(fontSize: 30),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 30.0, bottom: 50.0),
            child: Text(
              usuario.nome!,
              style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 30.0, bottom: 20.0),
            child: Text(
              admin ? 'Administração' : 'Bem vindo(a)',
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 83, 76, 76)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10.0, left: 10.0),
            child: Center(
              child: BoxHomeWidget(
                usuario: usuario,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget getBottomNavigationBar() {
    return BottomNavigationBar(
      selectedItemColor: const Color.fromARGB(255, 83, 76, 76),
      currentIndex: page,
      onTap: (index) {
        setState(() {
          page = index;
        });
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Ionicons.home_outline),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Ionicons.settings_outline),
          label: "",
        ),
      ],
      type: BottomNavigationBarType.fixed,
    );
  }
}
