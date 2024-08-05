import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:health_care/components/botao_component.dart';
import 'package:health_care/models/usuario.dart';
import 'package:health_care/services/auth_service.dart';
import 'package:health_care/services/database_service.dart';
import 'package:health_care/shared/arguments.dart';
import 'package:health_care/shared/constants.dart';
import 'package:validadores/Validador.dart';

class CadastroComponent extends StatefulWidget {
  const CadastroComponent({super.key});

  @override
  State<CadastroComponent> createState() => _CadastroComponentState();
}

class _CadastroComponentState extends State<CadastroComponent> {
  final _key = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final senhaController = TextEditingController();
  final confirmarSenhaController = TextEditingController();
  final nomeController = TextEditingController();
  final cpfController = TextEditingController();
  final celularController = TextEditingController();
  bool obscureText = true;
  double largura = 400;
  double tamanhoFonte = 30;

  @override
  Widget build(BuildContext context) {
    double tamanhoTela = MediaQuery.of(context).size.width;
    if (tamanhoTela < 1000) {
      largura = 400;
    } else if (tamanhoTela < 1600) {
      largura = tamanhoTela / 2;
      tamanhoFonte = 35;
    } else {
      largura = tamanhoTela / 2.5;
      tamanhoFonte = 40;
    }
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          surfaceTintColor: Colors.transparent,
          backgroundColor: Colors.transparent,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios_new),
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/login');
                },
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          reverse: true,
          child: Padding(
            padding: const EdgeInsets.only(top: 15.0, left: 25.0, right: 25.0),
            child: Form(
              key: _key,
              child: Column(
                children: [
                  Text(
                    'Dados da conta',
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: tamanhoFonte,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildEmail(),
                  const SizedBox(height: 20),
                  _buildSenha(),
                  const SizedBox(height: 20),
                  _buildConfirmarSenha(),
                  const SizedBox(height: 20),
                  _buildNome(),
                  const SizedBox(height: 20),
                  _buildCpf(),
                  const SizedBox(height: 20),
                  _buildCelular(),
                  const SizedBox(height: 150),
                  _buildButton(),
                  Padding(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                  ),
                ],
              ),
            ),
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

  SizedBox _buildNome() {
    return SizedBox(
      width: largura,
      child: TextFormField(
        textAlign: TextAlign.center,
        controller: nomeController,
        validator: (String? nome) {
          if (nome == null || nome.isEmpty) {
            return "Por favor, digite seu nome";
          }
          return null;
        },
        decoration: inputDec(null, 'Nome'),
      ),
    );
  }

  SizedBox _buildCpf() {
    return SizedBox(
      width: largura,
      child: TextFormField(
        textAlign: TextAlign.center,
        controller: cpfController,
        validator: (value) {
          // Aqui entram as validações
          return Validador()
              .add(Validar.CPF, msg: 'CPF Inválido')
              .add(Validar.OBRIGATORIO, msg: 'Campo obrigatório')
              .minLength(11)
              .maxLength(11)
              .valido(value, clearNoNumber: true);
        },
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          CpfInputFormatter(),
        ],
        decoration: inputDec(null, 'CPF'),
      ),
    );
  }

  SizedBox _buildCelular() {
    return SizedBox(
      width: largura,
      child: TextFormField(
        textAlign: TextAlign.center,
        controller: celularController,
        validator: (celular) {
          if (celular == null || celular.isEmpty) {
            return "Por favor, digite um número valido";
          }
          return null;
        },
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          TelefoneInputFormatter(),
        ],
        decoration: inputDec(null, 'Celular'),
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

  SizedBox _buildConfirmarSenha() {
    return SizedBox(
      width: largura,
      child: TextFormField(
        controller: confirmarSenhaController,
        validator: (confSenha) {
          if (confSenha == null || confSenha.isEmpty) {
            return "Por favor, digite sua senha";
          }
          if (confSenha != senhaController.text) {
            return "As senhas não coincidem";
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
          hintText: "Confirmar senha",
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

  Widget _buildButton() {
    return BotaoWidget(
        text: 'Próximo',
        onPress: () async {
          if (_key.currentState!.validate()) {
            // final service = AuthService();
            Usuario usuario = Usuario(
                email: emailController.text,
                nome: nomeController.text,
                cpf: cpfController.text,
                celular: celularController.text,
                tipoUsuario: TipoUsuario.Cliente,
                messageToken: '');

            final credential =
                await AuthService().cadastrarUsuario(usuario, senhaController.text);

            await DatabaseService().createUser(usuario, credential!.user!.uid);

            // ignore: use_build_context_synchronously
            Navigator.pushReplacementNamed(
              context,
              "/login",
            );

            Navigator.pushReplacementNamed(
              context,
              "/cadastro-endereco-atual",
              arguments: RouteArguments(usuario, senhaController.text),
            );
          } else {
            _exibirMensagem("Preencha todos os campos");
          }
        });
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
