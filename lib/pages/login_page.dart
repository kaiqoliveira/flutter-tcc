import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:health_care/services/auth_service.dart';



import 'package:health_care/components/login_component.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({Key? key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final _key = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final senhaController = TextEditingController();
  bool obscureText = true;
  double largura = 300;
  double tamanhoFonte = 30;
  AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return _buildTela();
  }

  Widget _buildTela() {
    if (!kIsWeb) {
      return const Scaffold(
        body: LoginComponent(),
      );
    } else {
      return Scaffold(
        body: Container(
          // decoration: const BoxDecoration(
          //   image: DecorationImage(
          //     image: AssetImage('assets/images/fundologin.png'),
          //     fit: BoxFit.cover,
          //   ),
          // ),
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 3,
              sigmaY: 3,
            ),
            child: Container(
              color: Colors.black.withOpacity(0.1),
              child: const Center(
                child: SizedBox(
                  width: 700,
                  height: 700,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Color.fromARGB(220, 255, 255, 255),
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    child: LoginComponent(),
                  ),
                ),
              ),
            ),
          ),
        ),

      );
    }
  }
}