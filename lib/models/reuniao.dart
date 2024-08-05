import 'package:flutter/material.dart';

class Reuniao {
  final String? id;
  late final String assunto;
  late final DateTime dataHora;
  late final TimeOfDay horaFim;

  Reuniao({
    this.id,
    required this.assunto,
    required this.dataHora,
    required this.horaFim,
  });

  factory Reuniao.fromJson(Map<String, dynamic> json) {
    return Reuniao(
      id: json['id'],
      assunto: json['assunto'],
      dataHora: DateTime.parse(json['dataHora']),
      horaFim: TimeOfDay(
        hour: int.parse(json['horaFim'].split(':')[0]),
        minute: int.parse(json['horaFim'].split(':')[1]),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'assunto': assunto,
      'dataHora': dataHora.toIso8601String(),
      'horaFim': '${horaFim.hour}:${horaFim.minute}',
    };
  }
}
