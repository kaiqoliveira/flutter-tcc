import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:health_care/models/usuario.dart';
import 'package:health_care/shared/constants.dart';

class VistoriaComponent extends StatefulWidget {
  final DateTime data;
  final Usuario usuario;
  final Usuario usuarioAuth;
  final void Function()? onPress;
  final void Function()? onCardPress;

  const VistoriaComponent({
    Key? key,
    required this.data,
    required this.usuario,
    required this.usuarioAuth,
    this.onPress,
    this.onCardPress,
  }) : super(key: key);

  @override
  State<VistoriaComponent> createState() => _VistoriaComponentState();
}

class _VistoriaComponentState extends State<VistoriaComponent> {
  double largura = 0;
  double altura = 60;
  @override
  Widget build(BuildContext context) {
    final DateFormat formatter = DateFormat('dd/MM/yyyy');
    final String formatted = formatter.format(widget.data);
    largura = MediaQuery.of(context).size.width - 30;
    if (MediaQuery.of(context).size.width >= 600) {
      largura = MediaQuery.of(context).size.width * 0.8;
      altura = MediaQuery.of(context).size.height * 0.07;
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: GestureDetector(
        onTap: widget.onCardPress,
        child: Center(
          child: Card(
            color: kCardColor,
            child: SizedBox(
              width: largura,
              height: altura,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(formatted),
                    const Spacer(),
                    Text(
                      widget.usuario.nome!,
                    ),
                    const Spacer(),
                    if (widget.usuarioAuth.tipoUsuario ==
                        TipoUsuario.Administrador)
                      IconButton(
                        icon: const Icon(Icons.edit_note_rounded),
                        onPressed: widget.onPress,
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
