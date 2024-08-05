import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:health_care/models/reuniao.dart';
import 'package:health_care/models/usuario.dart';
import 'package:health_care/shared/constants.dart';

class ReuniaoComponent extends StatelessWidget {
  final Reuniao reuniao;
  final Usuario usuario;
  final Usuario usuarioAuth;
  final void Function()? onPress;
  final void Function()? onCardPress;

  const ReuniaoComponent({
    Key? key,
    required this.reuniao,
    required this.usuario,
    required this.usuarioAuth,
    this.onPress,
    this.onCardPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DateFormat formatter = DateFormat('dd/MM/yyyy');
    final String dataFormatada = formatter.format(reuniao.dataHora);

    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: GestureDetector(
        onTap: onCardPress,
        child: Center(
          child: Card(
            color: kCardColor,
            child: SizedBox(
              width: MediaQuery.of(context).size.width > 1000
                  ? MediaQuery.of(context).size.width - 500
                  : MediaQuery.of(context).size.width - 50,
              height: 60,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(dataFormatada),
                    const Spacer(),
                    Text(usuario.nome!),
                    const Spacer(),
                    if (usuarioAuth.tipoUsuario == TipoUsuario.Administrador)
                      IconButton(
                        icon: const Icon(Icons.edit_note_rounded),
                        onPressed: onPress,
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
