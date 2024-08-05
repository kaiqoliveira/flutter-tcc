import 'dart:io';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';

import 'package:flutter/widgets.dart';

import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:health_care/models/endereco.dart';
import 'package:health_care/models/usuario.dart';

class EditClientes extends StatelessWidget {
  EditClientes({Key? key}) : super(key: key);
  double largura = 400;
  double tamanhoFonte = 15;

  @override
  Widget build(BuildContext context) {
    final usuario = ModalRoute.of(context)!.settings.arguments as Usuario;
    double tamanhoTela = MediaQuery.of(context).size.width;
    if (tamanhoTela < 1000) {
      largura = 400;
      tamanhoFonte = 15;
    } else if (tamanhoTela < 1600) {
      largura = tamanhoTela / 2;
      tamanhoFonte = 17;
    } else {
      largura = tamanhoTela / 2.5;
      tamanhoFonte = 23;
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        surfaceTintColor: const Color.fromARGB(0, 0, 0, 0),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            FocusScope.of(context).unfocus();
            Navigator.pushReplacementNamed(
              context,
              '/clientes',
              arguments: usuario,
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () async {
              await _generateAndDownloadPdf(usuario);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField('Nome', usuario.nome!),
              _buildTextField('E-mail', usuario.email!),
              _buildTextField('CPF', usuario.cpf!),
              _buildTextField('Celular', usuario.celular!),
              const SizedBox(height: 16.0),
              Text(
                'Endereço Atual:',
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: tamanhoFonte),
              ),
              const SizedBox(height: 16.0),
              Text(
                'Endereço da Obra:',
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: tamanhoFonte),
              ),
            ],
          ),
        ),
      ),
    );
  }

  SizedBox _buildTextField(String label, String value) {
    return SizedBox(
      width: largura,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: TextFormField(
          initialValue: value,
          readOnly: true,
          decoration: InputDecoration(
            labelText: label,
            border: const OutlineInputBorder(),
          ),
        ),
      ),
    );
  }

  Widget _buildAddressFields(Endereco endereco) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTextField('CEP', endereco.cep),
        _buildTextField('Logradouro', endereco.logradouro),
        _buildTextField('Número', endereco.numero),
        _buildTextField('Complemento', endereco.complemento),
        _buildTextField('Bairro', endereco.bairro),
        _buildTextField('Cidade', endereco.cidade),
        _buildTextField('Estado', endereco.estado),
      ],
    );
  }

  Future<void> _generateAndDownloadPdf(Usuario usuario) async {
    final pdf = pw.Document();

    pdf.addPage(pw.Page(
      build: (pw.Context context) {
        return pw.Column(
          children: [
            pw.Text('Dados do Cliente'),
            pw.SizedBox(height: 12),
            pw.Row(
              children: [
                pw.Text('Nome: ${usuario.nome}'),
                pw.SizedBox(width: 12),
                pw.Text('E-mail: ${usuario.email}'),
              ],
            ),
            pw.Row(
              children: [
                pw.Text('CPF: ${usuario.cpf}'),
                pw.SizedBox(width: 12),
                pw.Text('Celular: ${usuario.celular}'),
              ],
            ),
            pw.SizedBox(height: 12),
            pw.Text('Endereço Atual:'),
            pw.SizedBox(height: 8),
            pw.SizedBox(height: 12),
            pw.Text('Endereço da Obra:'),
            pw.SizedBox(height: 8),
          ],
        );
      },
    ));

    // Salve o PDF no dispositivo
    final path = await getExternalStorageDirectory();
    final file = File('${path!.path}/dados_cliente.pdf');
    await file.writeAsBytes(await pdf.save());

    // Abra o PDF
    await OpenFile.open('${path.path}/dados_cliente.pdf');
  }

  pw.Widget _buildPdfAddressFields(Endereco endereco) {
    return pw.Column(
      children: [
        pw.Row(
          children: [
            pw.Text('CEP: ${endereco.cep}'),
            pw.SizedBox(width: 12),
            pw.Text('Logradouro: ${endereco.logradouro}'),
          ],
        ),
        pw.Row(
          children: [
            pw.Text('Número: ${endereco.numero}'),
            pw.SizedBox(width: 12),
            pw.Text('Complemento: ${endereco.complemento}'),
          ],
        ),
        pw.Row(
          children: [
            pw.Text('Bairro: ${endereco.bairro}'),
            pw.SizedBox(width: 12),
            pw.Text('Cidade: ${endereco.cidade}'),
          ],
        ),
        pw.Row(
          children: [
            pw.Text('Estado: ${endereco.estado}'),
          ],
        ),
      ],
    );
  }
}
