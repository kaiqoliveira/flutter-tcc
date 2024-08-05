class Arquivo {
  final String id;
  final String nome;
  final String tipo;

  Arquivo({
    required this.id,
    required this.nome,
    required this.tipo,
  });

  factory Arquivo.fromJson(Map<String, dynamic> json) {
    return Arquivo(
      id: json['id'],
      nome: json['nome'],
      tipo: json['tipo'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'tipo': tipo,
    };
  }
}
