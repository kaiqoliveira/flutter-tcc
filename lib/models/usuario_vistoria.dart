import 'package:health_care/models/usuario.dart';
import 'package:health_care/models/vistoria.dart';

class UsuarioVistoria {
  final Usuario usuario;
  final Vistoria vistoria;

  UsuarioVistoria({
    required this.usuario,
    required this.vistoria,
  });
}