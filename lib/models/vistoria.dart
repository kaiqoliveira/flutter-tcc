class Vistoria {
  String? id;
  String? observacoes;
  DateTime? data;

  Vistoria({
    this.id,
    this.observacoes,
    this.data,
  });

  factory Vistoria.fromJson(Map<String, dynamic> json) {
    return Vistoria(
      id: json['id'] ?? '',
      observacoes: json['observacoes'] ?? '',
      data:
          json['data'] != null ? DateTime.parse(json['data']) : DateTime.now(),
    );
  }

  factory Vistoria.empty(String userId) {
    return Vistoria(
      id: '',
      observacoes: '',
      data: DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'observacoes': observacoes,
      'data': data!.toIso8601String(),
    };
  }
}
