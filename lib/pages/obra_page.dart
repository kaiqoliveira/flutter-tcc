// ignore_for_file: sized_box_for_whitespace, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:health_care/models/fase.dart';
import 'package:health_care/models/usuario.dart';
import 'package:health_care/components/slider_linear_percent_indicator.dart';
import 'package:health_care/services/database_service.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class ObraPage extends StatefulWidget {
  final Usuario usuario;
  final bool isAdmin;
  const ObraPage({
    super.key,
    required this.usuario,
    required this.isAdmin,
  });

  @override
  _ObraPageState createState() => _ObraPageState();
}

class _ObraPageState extends State<ObraPage> {
  late Usuario usuario;

  @override
  void initState() {
    super.initState();
    usuario = widget.usuario;
  }

  double _calculateAveragePercentual() {
    if (usuario.cronograma == null || usuario.cronograma!.fases.isEmpty) {
      return 0.0;
    }
    double totalPercentual = 0.0;
    for (var fase in usuario.cronograma!.fases) {
      totalPercentual += fase.percentual;
    }
    return totalPercentual / usuario.cronograma!.fases.length;
  }

  Future<void> _saveProgress() async {
    try {
      await DatabaseService().updateCronograma(usuario);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Progresso salvo com sucesso!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao salvar progresso: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double averagePercentual = _calculateAveragePercentual();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cronograma'),
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 200,
            child: Center(
              child: CircularPercentIndicator(
                radius: 80,
                lineWidth: 25,
                backgroundColor: const Color.fromARGB(68, 175, 164, 160),
                progressColor: const Color.fromARGB(255, 175, 164, 160),
                circularStrokeCap: CircularStrokeCap.round,
                percent: averagePercentual / 100,
                center: Text(
                  '${averagePercentual.toStringAsFixed(1)}%',
                  style: const TextStyle(
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 175, 164, 160)),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: usuario.cronograma!.fases.length,
              itemBuilder: (context, index) {
                var faseBanco = usuario.cronograma!.fases[index];
                Fase fase = Fase.fromJson(faseBanco.toJson());
                return ListTile(
                    title: Text(fase.fase.name),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SliderLinearPercentIndicator(
                          percent: faseBanco.percentual,
                          onChanged: widget.isAdmin
                              ? (value) {
                                  setState(() {
                                    faseBanco.percentual = value;
                                  });
                                }
                              : null,
                          usuario: usuario,
                          isAdmin: widget.isAdmin,
                        ),
                      ],
                    ));
              },
            ),
          ),
        ],
      ),
      floatingActionButton: widget.isAdmin
          ? FloatingActionButton(
              onPressed: _saveProgress,
              backgroundColor: const Color.fromARGB(255, 175, 164, 160),
              foregroundColor: Colors.white,
              child: const Icon(Icons.save),
            )
          : null,
    );
  }
}
