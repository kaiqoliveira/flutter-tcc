import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:health_care/firebase_options.dart';
import 'package:health_care/services/messaging_service.dart';
import 'package:health_care/shared/constants.dart';
import 'package:health_care/models/usuario.dart';
import 'package:health_care/pages/alterar_senha_page.dart';
import 'package:health_care/pages/arquivos_page.dart';
import 'package:health_care/pages/cadastro_page.dart';
import 'package:health_care/pages/clientes_page.dart';
import 'package:health_care/pages/configuracoes_page.dart';
import 'package:health_care/pages/cronograma_page.dart';
import 'package:health_care/pages/detalhes_arquivos_page.dart';
import 'package:health_care/pages/detalhes_reunioes_page.dart';
import 'package:health_care/pages/detalhes_vistorias_page.dart';
import 'package:health_care/pages/edit_clientes.dart';
import 'package:health_care/pages/edit_reunioes_page.dart';
import 'package:health_care/pages/edit_vistorias_page.dart';
import 'package:health_care/pages/esqueceu_senha_page.dart';
import 'package:health_care/pages/home_page.dart';
import 'package:health_care/pages/login_page.dart';
import 'package:health_care/pages/reunioes_page.dart';
import 'package:health_care/pages/vistorias_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await FirebaseAppCheck.instance.activate(
    webProvider: ReCaptchaV3Provider('sua-chave-do-site-recaptcha-v3'),
    androidProvider: AndroidProvider.playIntegrity, 
    appleProvider: AppleProvider.appAttest,
  );

  await FirebaseApi().initNotifications();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Health Care',
      debugShowCheckedModeBanner: false,
      theme: KTextTheme,
      routes: {
        "/": (context) => const HomePage(),
        "/login": (context) => const LoginPage(),
        "/registrar": (context) => const CadastroPage(),
        "/clientes": (context) => const ClientesPage(),
        "/reunioes": (context) => const ReunioesPage(),
        "/vistorias": (context) => const VistoriasPage(),
        "/arquivos": (context) => const ArquivosPage(),
        "/detalhe-vistoria": (context) => const DetalhesVistoriaPage(),
        "/edit-vistoria": (context) => const EditVistoriaPage(),
        "/detalhe-reuniao": (context) => const DetalhesReuniaoPage(),
        "/edit-reuniao": (context) => const EditReuniaoPage(),
        "/detalhe-clientes": (context) => EditClientes(),
        "/detalhe-arquivo": (context) => const DetalhesArquivoPage(),
        "/alterar-senha": (context) => const AlterarSenhaPage(),
        "/esqueceu-senha": (context) => const EsqueceuSenhaPage(),
        "/configuracoes": (context) => const ConfiguracoesPage(),
        '/cronograma': (context) => CronogramaPage(usuario: ModalRoute.of(context)!.settings.arguments as Usuario)
      },
      initialRoute: '/',
    );
  }
}