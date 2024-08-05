class Fase {
  FaseObra fase;
  double percentual;

  Fase({
    required this.fase,
    required this.percentual,
  });

  Map<String, dynamic> toJson() {
    return {
      'fase': fase.name,
      'percentual': percentual,
    };
  }

  factory Fase.fromJson(Map<String, dynamic> json) {
    return Fase(
      fase: FaseObraExtension.fromString(json['fase']),
      percentual: json['percentual'].toDouble(),
    );
  }
}

enum FaseObra {
  Demolicoes,
  InfraEletrica,
  InfraArCondicionado,
  InfraHidraulicaGas,
  InfrasComplementares,
  InstalacoesRevestimentos,
  EmassamentoPintura,
  MarmorariaTampos,
  Marcenaria,
  ItensComplementares,
  AcabamentosGerais,
  InstalacoesFinais,
  LimpezaFina,
}

extension FaseObraExtension on FaseObra {
  String get name {
    switch (this) {
      case FaseObra.Demolicoes:
        return "Demolições";
      case FaseObra.InfraEletrica:
        return "Infra Elétrica";
      case FaseObra.InfraArCondicionado:
        return "Infra de Ar condicionado";
      case FaseObra.InfraHidraulicaGas:
        return "Infra de hidráulica e gás";
      case FaseObra.InfrasComplementares:
        return "Infras complementares";
      case FaseObra.InstalacoesRevestimentos:
        return "Instalações Revestimentos";
      case FaseObra.EmassamentoPintura:
        return "Emassamento e Pintura";
      case FaseObra.MarmorariaTampos:
        return "Marmoraria / tampos";
      case FaseObra.Marcenaria:
        return "Marcenaria";
      case FaseObra.ItensComplementares:
        return "Itens complementares";
      case FaseObra.AcabamentosGerais:
        return "Acabamentos gerais";
      case FaseObra.InstalacoesFinais:
        return "Instalações finais";
      case FaseObra.LimpezaFina:
        return "Limpeza fina";
      default:
        throw Exception("Invalid FaseObra value");
    }
  }

  static FaseObra fromString(String name) {
    switch (name) {
      case "Demolições":
        return FaseObra.Demolicoes;
      case "Infra Elétrica":
        return FaseObra.InfraEletrica;
      case "Infra de Ar condicionado":
        return FaseObra.InfraArCondicionado;
      case "Infra de hidráulica e gás":
        return FaseObra.InfraHidraulicaGas;
      case "Infras complementares":
        return FaseObra.InfrasComplementares;
      case "Instalações Revestimentos":
        return FaseObra.InstalacoesRevestimentos;
      case "Emassamento e Pintura":
        return FaseObra.EmassamentoPintura;
      case "Marmoraria / tampos":
        return FaseObra.MarmorariaTampos;
      case "Marcenaria":
        return FaseObra.Marcenaria;
      case "Itens complementares":
        return FaseObra.ItensComplementares;
      case "Acabamentos gerais":
        return FaseObra.AcabamentosGerais;
      case "Instalações finais":
        return FaseObra.InstalacoesFinais;
      case "Limpeza fina":
        return FaseObra.LimpezaFina;
      default:
        throw Exception("Invalid FaseObra value");
    }
  }
}
