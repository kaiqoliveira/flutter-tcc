// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:health_care/models/usuario.dart';
import 'package:health_care/services/database_service.dart';

import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseService _databaseService = DatabaseService();
  static const String _authTokenKey = 'auth_token';

  Future<UserCredential?> cadastrarUsuario(
      Usuario usuario, String senha) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
          email: usuario.email!, password: senha);
      return credential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('Senha muito fraca.');
      } else if (e.code == 'email-already-in-use') {
        print('Já existe conta neste e-mail.');
      }
      return null; // Retorna null em caso de erro
    } catch (e) {
      print(e);
      return null; // Retorna null em caso de erro
    }
  }

  Future<User?> logarUsuario(String emailAddress, String senha) async {
    User? user;
    try {
      final userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: emailAddress, password: senha);
      print("Login bem-sucedido!");
      print("User: ${userCredential.user}");
      user = userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        print('Email ou senha incorretos.');
      } else {
        print('Erro desconhecido: ${e.message}');
      }
    } catch (e) {
      print('Erro geral: $e');
    }
    return user;
  }

  Future<void> deletarUsuario() async {
    User? user = _auth.currentUser;
    if (user != null) {
      await user.delete();
    }
  }

  Future<void> alterarSenha(
    String oldPassword,
    String newPassword,
  ) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Reautentica o usuário para verificar a senha anterior
        AuthCredential credential = EmailAuthProvider.credential(
          email: user.email!,
          password: oldPassword,
        );
        await user.reauthenticateWithCredential(credential);

        // Altera a senha
        await user.updatePassword(newPassword);
      } else {
        throw Exception('Usuário não encontrado.');
      }
    } catch (error) {
      throw Exception(error);
    }
  }

  Future<Usuario?> validaUsuarioLogado() async {
    User? currentUser = _auth.currentUser;
    Usuario? usuario;
    if (currentUser != null) {
      usuario = await _databaseService
          .getUserById(currentUser.uid); // Aguarde a conclusão da Future
    }
    return usuario;
  }

  // Métodos para manipulação do token de autenticação
  Future<String?> getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_authTokenKey);
  }

  Future<void> saveAuthToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_authTokenKey, token);
  }

  Future<void> removeAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_authTokenKey);
  }

  Future<void> logout() async {
    await _auth.signOut();
    await removeAuthToken();
  }
}
