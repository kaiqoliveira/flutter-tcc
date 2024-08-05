import 'package:flutter/material.dart';
import 'package:health_care/models/usuario.dart';
import 'package:health_care/shared/constants.dart';

class ClientesComponent extends StatelessWidget {
  final Usuario usuario;
  final void Function()? onPress;

  const ClientesComponent({
    Key? key,
    required this.usuario,
    this.onPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Center(
        child: GestureDetector(
          onTap: onPress,
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
                    Expanded(
                      child: Text(
                        usuario.nome!,
                        overflow: TextOverflow.fade,
                      ),
                    ),
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
