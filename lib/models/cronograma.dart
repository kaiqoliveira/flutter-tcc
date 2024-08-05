import 'package:health_care/models/fase.dart';

class Cronograma {
  List<Fase> fases;

  Cronograma({required this.fases});

  Map<String, dynamic> toJson() {
    return {
      'fases': fases.map((fase) => fase.toJson()).toList(),
    };
  }

  factory Cronograma.fromJson(Map<String, dynamic> json) {
    return Cronograma(
      fases: (json['fases'] as List<dynamic>).map((fase) => Fase.fromJson(fase as Map<String, dynamic>)).toList(),
    );
  }

  // Método estático para criar um cronograma com todas as fases pendentes e com percentual em 0
  static Cronograma criarCronogramaInicial() {
    return Cronograma(
      fases: FaseObra.values.map((faseObra) {
        return Fase(
          fase: faseObra,
          percentual: 0.0,
        );
      }).toList(),
    );
  }
}