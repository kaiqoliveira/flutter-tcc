import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:health_care/models/reuniao.dart';
import 'package:health_care/models/usuario.dart';
import 'package:health_care/services/database_service.dart';
import 'package:health_care/shared/constants.dart';

class DetalhesReuniaoPage extends StatelessWidget {
  const DetalhesReuniaoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushReplacementNamed('/reunioes');
        return false;
      },
      child: const DetalhesReuniaoContent(),
    );
  }
}

class DetalhesReuniaoContent extends StatefulWidget {
  const DetalhesReuniaoContent({Key? key}) : super(key: key);

  @override
  _DetalhesReuniaoContentState createState() => _DetalhesReuniaoContentState();
}

class _DetalhesReuniaoContentState extends State<DetalhesReuniaoContent> {
  late Reuniao reuniao;
  late Usuario usuario;
  Usuario? _selectedCliente;
  List<Usuario> _clientes = [];
  final TextEditingController _dataHoraController = TextEditingController();
  final TextEditingController _horaFimController = TextEditingController();
  final TextEditingController _assuntoController = TextEditingController();
  final DatabaseService databaseService = DatabaseService();
  bool novaReuniao = false;

  @override
  void initState() {
    super.initState();
    _carregarClientes().then((_) {
      Future.delayed(Duration.zero, () {
        final Map<String, dynamic>? args =
            ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
        setState(() {
          reuniao = (args?['reuniao'] as Reuniao?)!;
          usuario = args?['usuario'] as Usuario;
          _selectedCliente = _clientes.firstWhere(
              (cliente) => cliente.id == usuario.id,
              orElse: () => usuario);
        });
      });
    });
  }

  Future<void> _carregarClientes() async {
    List<Usuario> clientes = await databaseService.listarUsuarios();
    setState(() {
      _clientes = clientes;
    });
  }

  @override
  void dispose() {
    _dataHoraController.dispose();
    _horaFimController.dispose();
    _assuntoController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final Map<String, dynamic>? args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    reuniao = args?['reuniao'] as Reuniao;
    usuario = args?['usuario'] as Usuario;
  }

  @override
  Widget build(BuildContext context) {
    final DateFormat dateFormatter = DateFormat('dd/MM/yyyy HH:mm');
    final String dataReuniao = dateFormatter.format(reuniao.dataHora);
    final String horaFimReuniao =
        '${reuniao.horaFim.hour.toString().padLeft(2, '0')}:${reuniao.horaFim.minute.toString().padLeft(2, '0')}';
    final String descricao = reuniao.assunto;

    // Calculando a duração
    final DateTime horaFimDateTime = DateTime(
      reuniao.dataHora.year,
      reuniao.dataHora.month,
      reuniao.dataHora.day,
      reuniao.horaFim.hour,
      reuniao.horaFim.minute,
    );

    final Duration duracao = horaFimDateTime.difference(reuniao.dataHora);
    final String duracaoFormatada =
        '${duracao.inHours.toString().padLeft(2, '0')}:${(duracao.inMinutes % 60).toString().padLeft(2, '0')}';

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/reunioes');
          },
        ),
        title: const Text(
          'Reunião',
          style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.w700),
        ),
        surfaceTintColor: Colors.transparent,
      ),
      body: SafeArea(
        top: false,
        bottom: false,
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
              child: Column(
                children: <Widget>[
                  const SizedBox(
                    height: 30,
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[],
                  ),
                  const SizedBox(height: 20),
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          child: DropdownButtonFormField<Usuario>(
                            isExpanded: true,
                            hint: const Text('Selecione um cliente'),
                            value: _selectedCliente,
                            items: _clientes
                                .map((Usuario cliente) =>
                                    DropdownMenuItem<Usuario>(
                                      value: cliente,
                                      child: Text(cliente.nome!),
                                    ))
                                .toList(),
                            onChanged: (Usuario? newValue) {
                              setState(() {
                                _selectedCliente = newValue;
                              });
                            },
                            decoration: const InputDecoration(
                              labelText: 'Cliente',
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            const CircleAvatar(
                              radius: 25.0,
                              backgroundColor: LightColors.kLuedkeBrown,
                              child: Icon(
                                Icons.calendar_today,
                                size: 20.0,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: Text(
                                'Data reunião: $dataReuniao',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            const CircleAvatar(
                              radius: 25.0,
                              backgroundColor: LightColors.kLuedkeBrown,
                              child: Icon(
                                Icons.access_time,
                                size: 20.0,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: Text(
                                'Hora Fim: $horaFimReuniao',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            const CircleAvatar(
                              radius: 25.0,
                              backgroundColor: LightColors.kLuedkeBrown,
                              child: Icon(
                                Icons.timer_outlined,
                                size: 20.0,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: Text(
                                'Duração: $duracaoFormatada',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: <Widget>[
                    const SizedBox(height: 40),
                    const Text(
                      'Descrição',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Flexible(child: Text(descricao)),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
