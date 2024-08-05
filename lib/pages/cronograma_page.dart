import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:health_care/components/clientes_component.dart';
import 'package:health_care/components/slider_linear_percent_indicator.dart';
import 'package:health_care/models/usuario.dart';
import 'package:health_care/pages/obra_page.dart';
import 'package:health_care/services/database_service.dart';
import 'package:health_care/shared/constants.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/percent_indicator.dart'; // Importe o pacote percent_indicator

class CronogramaPage extends StatefulWidget {
  final Usuario usuario;

  const CronogramaPage({Key? key, required this.usuario}) : super(key: key);

  @override
  _CronogramaPageState createState() => _CronogramaPageState();
}

class _CronogramaPageState extends State<CronogramaPage> {
  late List<Usuario> clientes = [];
  late List<Usuario> filteredClientes = [];
  DatabaseService databaseService = DatabaseService();
  final pesquisaController = TextEditingController();
  bool isAdmin = false;

  @override
  void initState() {
    super.initState();
    if (widget.usuario.tipoUsuario == TipoUsuario.Administrador) {
      isAdmin = true;
      _fetchClientes();
    }
  }

  Future<void> _fetchClientes() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      List<Usuario> todosClientes = await databaseService.listarUsuarios();
      setState(() {
        clientes = todosClientes;
        filteredClientes = todosClientes;
      });
    } else {
      print('Nenhum usuário autenticado encontrado.');
    }
  }

  void _filterClientes(String query) {
    List<Usuario> filteredList = clientes
        .where((cliente) =>
            cliente.nome!.toLowerCase().contains(query.toLowerCase()))
        .toList();
    setState(() {
      filteredClientes = filteredList;
    });
  }

  double _calculateAveragePercentual() {
    if (widget.usuario.cronograma == null ||
        widget.usuario.cronograma!.fases.isEmpty) {
      return 0.0;
    }
    double totalPercentual = 0.0;
    for (var fase in widget.usuario.cronograma!.fases) {
      totalPercentual += fase.percentual;
    }
    return totalPercentual / widget.usuario.cronograma!.fases.length;
  }

  @override
  Widget build(BuildContext context) {
    double averagePercentual = _calculateAveragePercentual();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            FocusScope.of(context).unfocus();
            Navigator.pushReplacementNamed(context, '/home');
          },
        ),
        title: widget.usuario.tipoUsuario == TipoUsuario.Administrador
            ? const Text('Clientes')
            : const Column(
                children: [
                  Text('Cronograma'),
                ],
              ),
      ),
      body: widget.usuario.tipoUsuario == TipoUsuario.Administrador
          ? _buildAdminView()
          : _buildUserView(averagePercentual),
    );
  }

  Widget _buildAdminView() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 30.0, right: 30.0, bottom: 12.0),
          child: TextField(
            controller: pesquisaController,
            decoration: inputDec(
              Icons.search,
              'Digite o nome do cliente',
              'Pesquisar',
            ),
            onChanged: (text) {
              _filterClientes(text);
            },
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: filteredClientes.length,
            itemBuilder: (context, index) {
              return ClientesComponent(
                usuario: filteredClientes[index],
                onPress: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ObraPage(
                        usuario: filteredClientes[index],
                        isAdmin: isAdmin,
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildUserView(double averagePercentual) {
    return Column(
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
                style: TextStyle(fontSize: 20.0),
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 35.0, bottom: 5.0),
            child: ListView.builder(
              itemCount: widget.usuario.cronograma!.fases.length,
              itemBuilder: (context, index) {
                var fase = widget.usuario.cronograma!.fases[index];
                return ListTile(
                  title: Text(fase.fase.toString()),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SliderLinearPercentIndicator(
                        percent: fase.percentual,
                        onChanged: (value) {
                          setState(() {
                            fase.percentual = value;
                          });
                        },
                        usuario: widget.usuario,
                        isAdmin: isAdmin,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
