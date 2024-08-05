import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:health_care/components/botao_component.dart';
import 'package:health_care/models/usuario.dart';
import 'package:health_care/models/reuniao.dart';
import 'package:health_care/services/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:health_care/shared/constants.dart';

class EditReuniaoPage extends StatelessWidget {
  const EditReuniaoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Navigator.of(context).pushReplacementNamed('/reunioes');
          },
        ),
      ),
      body: const EditReuniaoContent(),
    );
  }
}

class EditReuniaoContent extends StatefulWidget {
  const EditReuniaoContent({Key? key}) : super(key: key);

  @override
  _EditReuniaoContentState createState() => _EditReuniaoContentState();
}

class _EditReuniaoContentState extends State<EditReuniaoContent> {
  final TextEditingController _dataHoraController = TextEditingController();
  final TextEditingController _horaFimController = TextEditingController();
  final TextEditingController _assuntoController = TextEditingController();
  final DatabaseService databaseService = DatabaseService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  bool novaReuniao = false;
  late Usuario usuario;
  Reuniao? reuniao;
  DateTime? _selectedDateTime;
  TimeOfDay? _selectedHoraFim;
  bool _isLoading = true;
  Usuario? _selectedCliente;
  List<Usuario> _clientes = [];

  @override
  void initState() {
    super.initState();
    _carregarClientes().then((_) {
      Future.delayed(Duration.zero, () {
        final Map<String, dynamic>? args =
            ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
        novaReuniao = args?['novaReuniao'] as bool;
        if (novaReuniao == true) {
          setState(() {
            _isLoading = false;
            reuniao = Reuniao(
                id: '',
                assunto: '',
                dataHora: DateTime.now(),
                horaFim: TimeOfDay.now());
            _dataHoraController.text = '';
            _horaFimController.text = '';
            _assuntoController.text = '';
          });
        } else {
          setState(() {
            reuniao = (args?['reuniao'] as Reuniao?)!;
            usuario = args?['usuario'] as Usuario;
            _selectedCliente = _clientes.firstWhere(
                (cliente) => cliente.id == usuario.id,
                orElse: () => usuario);
          });
          _carregarDadosReuniao();
        }
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

  void _carregarDadosReuniao() {
    if (reuniao != null) {
      _selectedDateTime = reuniao!.dataHora;
      _selectedHoraFim = reuniao!.horaFim;
      _dataHoraController.text =
          DateFormat('dd/MM/yyyy HH:mm').format(reuniao!.dataHora);
      _horaFimController.text = reuniao!.horaFim.format(context);
      _assuntoController.text = reuniao!.assunto;
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        top: false,
        bottom: false,
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.05),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Editar Reunião',
                              style: TextStyle(
                                fontSize: screenWidth * 0.05,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: screenWidth * 0.02),
                            DropdownButtonFormField<Usuario>(
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
                            SizedBox(height: screenWidth * 0.02),
                            GestureDetector(
                              onTap: () {
                                _selectDateTime(context);
                              },
                              child: AbsorbPointer(
                                child: TextFormField(
                                  controller: _dataHoraController,
                                  keyboardType: TextInputType.datetime,
                                  decoration: const InputDecoration(
                                    labelText: 'Data e Hora',
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: screenWidth * 0.02),
                            GestureDetector(
                              onTap: () {
                                _selectHoraFim(context);
                              },
                              child: AbsorbPointer(
                                child: TextFormField(
                                  controller: _horaFimController,
                                  keyboardType: TextInputType.datetime,
                                  decoration: const InputDecoration(
                                    labelText: 'Hora Fim',
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: screenWidth * 0.02),
                            TextFormField(
                              controller: _assuntoController,
                              keyboardType: TextInputType.text,
                              maxLines: null,
                              decoration: const InputDecoration(
                                labelText: 'Assunto',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: BotaoWidget(
                      onPress: () {
                        _salvarReuniao();
                      },
                      text: 'Salvar',
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Future<void> _selectDateTime(BuildContext context) async {
    DateTime now = DateTime.now();
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime ?? now,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: KDateTimePickerTheme,
          child: child!,
        );
      },
    );

    if (selectedDate != null) {
      TimeOfDay? selectedTime = await showTimePicker(
        context: context,
        initialTime: _selectedDateTime != null
            ? TimeOfDay.fromDateTime(_selectedDateTime!)
            : TimeOfDay.now(),
        builder: (BuildContext context, Widget? child) {
          return Theme(
            data: KDateTimePickerTheme,
            child: child!,
          );
        },
      );

      if (selectedTime != null) {
        setState(() {
          _selectedDateTime = DateTime(
            selectedDate.year,
            selectedDate.month,
            selectedDate.day,
            selectedTime.hour,
            selectedTime.minute,
          );
          _dataHoraController.text =
              DateFormat('dd/MM/yyyy HH:mm').format(_selectedDateTime!);
        });
      }
    }
  }

  Future<void> _selectHoraFim(BuildContext context) async {
    TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: _selectedHoraFim ?? TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: KDateTimePickerTheme,
          child: child!,
        );
      },
    );

    if (selectedTime != null) {
      setState(() {
        _selectedHoraFim = selectedTime;
        _horaFimController.text = selectedTime.format(context);
      });
    }
  }

  Future<void> _salvarReuniao() async {
    if (novaReuniao) {
      String novoId = await _obterProximoIdReuniao();

      Reuniao novaReuniao = Reuniao(
        id: novoId,
        assunto: _assuntoController.text,
        dataHora: _selectedDateTime ?? DateTime.now(),
        horaFim: _selectedHoraFim ?? TimeOfDay.now(),
      );

      await databaseService.adicionarReuniao(
          _selectedCliente!.id!, novaReuniao);

      _exibirMensagem("Reunião salva com sucesso");
    } else {
      reuniao!.assunto = _assuntoController.text;
      reuniao!.dataHora = _selectedDateTime ?? reuniao!.dataHora;
      reuniao!.horaFim = _selectedHoraFim ?? reuniao!.horaFim;

      await databaseService.atualizarReuniao(_selectedCliente!.id!, reuniao!);

      _exibirMensagem("Reunião atualizada com sucesso");
    }

    Navigator.of(context).pushReplacementNamed('/reunioes');
  }

  Future<String> _obterProximoIdReuniao() async {
    List<Reuniao> reunioes =
        await databaseService.listarReunioes(_selectedCliente!.id!);
    if (reunioes.isEmpty) {
      return '1';
    }

    List<int> ids =
        reunioes.map((reuniao) => int.tryParse(reuniao.id!) ?? 0).toList();
    int ultimoId = ids.reduce((a, b) => a > b ? a : b);
    return (ultimoId + 1).toString();
  }

  void _exibirMensagem(String mensagem) {
    final snackbar = SnackBar(content: Text(mensagem));
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }
}
