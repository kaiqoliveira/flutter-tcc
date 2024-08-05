import 'package:flutter/material.dart';
import 'package:health_care/services/auth_service.dart';

class ConfiguracoesPage extends StatefulWidget {
  const ConfiguracoesPage({super.key});

  @override
  State<ConfiguracoesPage> createState() => _ConfiguracoesPageState();
}

class _ConfiguracoesPageState extends State<ConfiguracoesPage> {
  AuthService authService = AuthService();

  void _showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Atenção'),
          content: const Text('Tem certeza que deseja deletar sua conta?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Não'),
            ),
            TextButton(
              onPressed: () {
                authService.deletarUsuario();
                Navigator.pushReplacementNamed(context, '/login');
              },
              child: const Text('Sim'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
            const ListTile(
              title: Center(child: Text('Conta')),
              subtitle: Center(child: Text('Gerencie sua conta e informações pessoais')),
            ),
          const Divider(),
          ListTile(
            title: const Text('Senha'),
            subtitle: const Text('Alterar senha'),
            onTap: () =>
                Navigator.pushReplacementNamed(context, '/alterar-senha'),
          ),
          const Divider(),
          ListTile(
            title: const Text('Email'),
            subtitle: const Text('Confirmar E-mail'),
            onTap: () {},
          ),
          const Divider(),
          ListTile(
            title: const Text('Desconectar'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/login');
              authService.logout();
            },
          ),
          const Divider(),
          // Manter comentado botão de deletar conta
          // ListTile(
          //   title: const Text(
          //     'Deletar Conta',
          //     style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
          //   ),
          //   onTap: () => _showAlertDialog(context),
          // ),
        ],
      ),
    );
  }
}
