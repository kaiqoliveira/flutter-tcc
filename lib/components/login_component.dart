import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:health_care/components/botao_component.dart';
import 'package:health_care/services/auth_service.dart';
import 'package:health_care/shared/constants.dart';

class LoginComponent extends StatefulWidget {
  const LoginComponent({super.key});
  

  @override
  State<LoginComponent> createState() => _LoginComponentState();

}

class _LoginComponentState extends State<LoginComponent> {
  final _key = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final senhaController = TextEditingController();
  bool obscureText = true;
  double largura = 400;
  double tamanhoFonte = 30;
  double marginTitulo = 0;
  AuthService authService = AuthService(); 

  @override
  Widget build(BuildContext context) {
    double tamanhoTela = MediaQuery.of(context).size.width;
    if (tamanhoTela < 1000) {
      marginTitulo = 0;
      largura = 400;
      tamanhoFonte = 30;
    }else if (tamanhoTela < 1600) {
      largura = tamanhoTela / 2;
      marginTitulo = 200;
      tamanhoFonte = 35;
    } else {
      largura = tamanhoTela / 4;
      marginTitulo = 690;
      tamanhoFonte = 40;
    }
    return Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Olá,',
                        style: TextStyle(fontSize: tamanhoFonte),
                      ),
                      Text(
                        'Bem Vindo',
                        style: TextStyle(
                            fontSize: tamanhoFonte,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Form(
                  key: _key,
                  child: Column(
                    children: [
                      _buildEmail(),
                      const SizedBox(height: 20),
                      _buildSenha(),
                      const SizedBox(height: 20),
                      _buildEsqueceuSenha(),
                      const SizedBox(height: 20),
                      _buildButton(),
                      const SizedBox(height: 50),
                      const Text(
                        'Ou',
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 50),
                      _buildRegistrar(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
  }
    SizedBox _buildEmail() {
    return SizedBox(
      width: largura,
      child: TextFormField(
        controller: emailController,
        validator: (String? email) {
          if (email == null || email.isEmpty) {
            return "Por favor, digite seu e-mail";
          } else if (!validarEmail(email)) {
            return "Por favor, digite um e-mail válido";
          }
          return null;
        },
        decoration: inputDec(Icons.email, 'Email'),
      ),
    );
  }

  SizedBox _buildSenha() {
    return SizedBox(
      width: largura,
      child: TextFormField(
        controller: senhaController,
        validator: (senha) {
          if (senha == null || senha.isEmpty) {
            return "Por favor, digite sua senha";
          } else if (senha.length < 6) {
            return "A senha deve ter pelo menos 6 caracteres";
          }
          return null;
        },
        obscureText: obscureText,
        decoration: InputDecoration(
          border: const UnderlineInputBorder(
            borderSide: BorderSide(),
          ),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(
              color: Color.fromARGB(255, 175, 173, 173),
            ),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(
              color: Color.fromARGB(174, 7, 7, 7),
            ),
          ),
          hintText: "Digite sua senha",
          prefixIcon: const Icon(Icons.lock_outline_rounded),
          suffixIcon: IconButton(
            icon: obscureText
                ? const Icon(Icons.visibility_outlined)
                : const Icon(Icons.visibility_off_outlined),
            onPressed: () {
              setState(() {
                obscureText = !obscureText;
              });
            },
          ),
        ),
      ),
    );
  }

  Widget _buildEsqueceuSenha() {
    return TextButton(
      onPressed: () {
        Navigator.pushReplacementNamed(context, "/esqueceu-senha");
      },
      style: TextButton.styleFrom(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.transparent,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        splashFactory: NoSplash.splashFactory,
        enableFeedback: false
      ),
      child: const Text(
        'Esqueceu a senha?',
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w600,
          fontSize: 18,
        ),
      ),
    );
  }

  Widget _buildRegistrar() {
    return GestureDetector(
      onTap: () {
        Navigator.pushReplacementNamed(context, "/registrar");
      },
      child: RichText(
          text: TextSpan(children: <InlineSpan>[
            const TextSpan(
              text: "Não tem uma conta?",
              style: TextStyle(
                  color: Color.fromARGB(255, 87, 88, 90),
                  fontSize: 16,
                  fontWeight: FontWeight.w400),
            ),
            TextSpan(
              text: ' ',
              style: TextStyle(
                  color: Colors.indigo.shade300,
                  fontSize: 16,
                  fontWeight: FontWeight.w700),
            ),
            TextSpan(
              text: "Registrar-se",
              style: TextStyle(
                  color: Colors.lightBlue.shade300,
                  fontSize: 16,
                  fontWeight: FontWeight.w700),
            )
          ]),
          textAlign: TextAlign.center),
    );
  }

  Widget _buildButton() {
    return BotaoWidget(
      text: 'Login',
      onPress: () {
        onTapBtnLogar();
      },
    );
  }

  void onTapBtnLogar() async {
    if (_key.currentState!.validate()) {
      User? usuario = await authService
          .logarUsuario(emailController.text, senhaController.text)
          .catchError(
            // ignore: argument_type_not_assignable_to_error_handler
            (FirebaseAuthException e) =>
                // ignore: invalid_return_type_for_catch_error
                _exibirMensagem("E-mail ou senha inválidos"),
          );
      if (usuario != null) {
        // ignore: use_build_context_synchronously
        Navigator.pushReplacementNamed(
          context,
          "/home",
          arguments: usuario,
        );
      } else {
        _exibirMensagem("E-mail ou senha inválidos");
      }
    } else {
      _exibirMensagem("Preencha todos os campos");
    }
  }

  void _exibirMensagem(String mensagem) {
    final snackbar = SnackBar(content: Text(mensagem));
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  bool validarEmail(String email) {
    const pattern = r'(^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$)';
    final regExp = RegExp(pattern);
    return regExp.hasMatch(email);
  }
}