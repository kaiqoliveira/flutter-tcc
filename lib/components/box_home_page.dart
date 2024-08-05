import 'package:flutter/material.dart';
import 'package:health_care/components/customcard_component.dart';
import 'package:health_care/components/icon_content_component.dart';
import 'package:health_care/models/usuario.dart';
import 'package:health_care/services/auth_service.dart';

class BoxHomeWidget extends StatefulWidget {
  final Usuario usuario;
  const BoxHomeWidget({super.key, required this.usuario});

  @override
  State<BoxHomeWidget> createState() => _BoxHomeWidgetState();
}

class _BoxHomeWidgetState extends State<BoxHomeWidget> {
  AuthService authService = AuthService();
  String rotaReunioes = '/reunioes';
  String rotaVistorias = '/vistorias';
  String rotaArquivos = '/arquivos';
  String rotaCronograma = '/cronograma';
  bool admin = true;
  double largura = 0;
  double altura = 0;

  @override
  void initState() {
    super.initState();
    if (widget.usuario.tipoUsuario == TipoUsuario.Cliente) {
      admin = false;
      rotaReunioes = '/reunioes';
      rotaArquivos = '/detalhe-arquivo';
    }
  }

  @override
  Widget build(BuildContext context) {
    double tamanhoTela = MediaQuery.of(context).size.width;
    if (tamanhoTela < 1000) {
      largura = tamanhoTela;
      altura = 130;
    } else if (tamanhoTela < 1600) {
      largura = tamanhoTela / 1.3;
      altura = 150;
    } else {
      largura = tamanhoTela / 1.2;
      altura = 170;
    }
    List<Widget> children = [
      if (admin)
        SizedBox(
          width: largura,
          height: altura,
          child: CustomCard(
            color: const Color.fromARGB(255, 230, 230, 230),
            child: const IconContent(
              icon: Icons.groups,
              label: 'Clientes',
            ),
            onPress: () {
              Navigator.pushReplacementNamed(
                context,
                "/clientes",
                arguments: widget.usuario,
              );
            },
          ),
        ),
      SizedBox(
        width: largura,
        height: altura,
        child: CustomCard(
          color: const Color.fromARGB(255, 230, 230, 230),
          child: const IconContent(
            icon: Icons.schedule,
            label: 'Cronograma',
          ),
          onPress: () {
            Navigator.pushReplacementNamed(
              context,
              rotaCronograma,
              arguments: widget.usuario,
            );
          },
        ),
      ),
      SizedBox(
        width: largura,
        height: altura,
        child: CustomCard(
          color: const Color.fromARGB(255, 230, 230, 230),
          child: const IconContent(
            icon: Icons.event,
            label: 'Reuniões',
          ),
          onPress: () {
            Navigator.pushReplacementNamed(
              context,
              rotaReunioes,
              arguments: widget.usuario,
            );
          },
        ),
      ),
      SizedBox(
        width: largura,
        height: altura,
        child: CustomCard(
          color: const Color.fromARGB(255, 230, 230, 230),
          child: const IconContent(
            icon: Icons.add_home_work_rounded,
            label: 'Vistorias',
          ),
          onPress: () {
            Navigator.pushReplacementNamed(context, rotaVistorias,
                arguments: widget.usuario);
          },
        ),
      ),
      // SizedBox(
      //   width: largura,
      //   height: altura,
      //   child: CustomCard(
      //     color: const Color.fromARGB(255, 230, 230, 230),
      //     child: const IconContent(
      //       icon: Icons.cloud_upload,
      //       label: 'Arquivos',
      //     ),
      //     onPress: () {
      //       Navigator.pushReplacementNamed(
      //         context,
      //         rotaArquivos,
      //         arguments: widget.usuario,
      //       );
      //     },
      //   ),
      // ),
    ];

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: children,
    );
  }
}
