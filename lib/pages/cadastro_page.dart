import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:health_care/components/cadastro_component.dart';

class CadastroPage extends StatefulWidget {
  const CadastroPage({super.key});

  @override
  State<CadastroPage> createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  @override
  Widget build(BuildContext context) {
    return _buildTela();
  }

  Widget _buildTela() {
    if (!kIsWeb) {
      return const Scaffold(
        body: CadastroComponent(),
      );
    } else {
      return Scaffold(
        body: Container(
          // decoration: const BoxDecoration(
          //   image: DecorationImage(
          //     image: AssetImage('assets/images/fundocadastro.png'),
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
              child: Center(
                child: SizedBox(
                  width: 900,
                  height: 900,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(220, 255, 255, 255),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const CadastroComponent(),
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
