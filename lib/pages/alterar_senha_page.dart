// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:health_care/services/auth_service.dart';

class AlterarSenhaPage extends StatefulWidget {
  const AlterarSenhaPage({Key? key}) : super(key: key);

  @override
  _AlterarSenhaPageState createState() => _AlterarSenhaPageState();
}

class _AlterarSenhaPageState extends State<AlterarSenhaPage> {
  final _formKey = GlobalKey<FormState>();
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmNewPasswordController = TextEditingController();
  AuthService authService = AuthService();
  bool _obscureOldPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmNewPassword = true;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (!didPop) {
          Navigator.of(context).pushReplacementNamed('/configuracoes');
        }
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new),
            onPressed: () {
              FocusScope.of(context).unfocus();
              Navigator.pushReplacementNamed(context, '/configuracoes');
            },
          ),
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _oldPasswordController,
                  obscureText: _obscureOldPassword,
                  decoration: InputDecoration(
                    labelText: 'Senha anterior',
                    suffixIcon: IconButton(
                      icon: Icon(_obscureOldPassword
                          ? Icons.visibility
                          : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          _obscureOldPassword = !_obscureOldPassword;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, digite sua senha anterior.';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _newPasswordController,
                  obscureText: _obscureNewPassword,
                  decoration: InputDecoration(
                    labelText: 'Nova senha',
                    suffixIcon: IconButton(
                      icon: Icon(_obscureNewPassword
                          ? Icons.visibility
                          : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          _obscureNewPassword = !_obscureNewPassword;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, digite sua nova senha.';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _confirmNewPasswordController,
                  obscureText: _obscureConfirmNewPassword,
                  decoration: InputDecoration(
                    labelText: 'Confirmar nova senha',
                    suffixIcon: IconButton(
                      icon: Icon(_obscureConfirmNewPassword
                          ? Icons.visibility
                          : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          _obscureConfirmNewPassword =
                              !_obscureConfirmNewPassword;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, confirme sua nova senha.';
                    }
                    if (value != _newPasswordController.text) {
                      return 'As senhas não coincidem.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Processar a alteração de senha aqui
                      _changePassword();
                    }
                  },
                  child: const Text('Alterar Senha'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _changePassword() async {
    String oldPassword = _oldPasswordController.text;
    String newPassword = _newPasswordController.text;

    try {
      // Chamar o método de alteração de senha do AuthService
      await authService.alterarSenha(oldPassword, newPassword);

      // Limpar os campos do formulário após a alteração da senha
      _oldPasswordController.clear();
      _newPasswordController.clear();
      _confirmNewPasswordController.clear();

      // Exibir uma mensagem de sucesso
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Senha alterada com sucesso.'),
      ));
    } catch (error) {
      // Exibir uma mensagem de erro
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text('Erro ao alterar a senha: a senha anterior está incorreta.'),
        ),
      );
    }
  }
}
