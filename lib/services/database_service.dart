import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:health_care/models/cronograma.dart';
import 'package:health_care/models/usuario.dart';
import 'package:health_care/models/usuario_vistoria.dart';
import 'package:health_care/models/vistoria.dart';
import 'package:health_care/models/reuniao.dart';
import 'package:health_care/models/usuario_reuniao.dart';

class DatabaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createUser(Usuario usuario, String idPersonalizado) async {
    try {
      await _firestore
          .collection('usuarios')
          .doc(idPersonalizado)
          .set(usuario.toJson());
      print('Usuário criado com sucesso!');
    } catch (e) {
      print('Erro ao criar usuário: $e');
    }
  }

  Future<List<Object?>> getUsers() async {
    try {
      final QuerySnapshot snapshot =
          await _firestore.collection('usuarios').get();
      final List<Object?> usuarios =
          snapshot.docs.map((doc) => doc.data()).toList();
      return usuarios;
    } catch (e) {
      print('Erro ao obter usuários: $e');
      return [];
    }
  }

  Future<Usuario?> getUserById(String userId) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('usuarios').doc(userId).get();

      if (doc.exists) {
        return Usuario.fromJson(doc.data() as Map<String, dynamic>);
      } else {
        return null;
      }
    } catch (e) {
      print('Erro ao buscar usuário por ID: $e');
      return null;
    }
  }

  Future<List<UsuarioVistoria>> listarTodasVistorias() async {
    List<UsuarioVistoria> todasVistorias = [];

    try {
      List<Usuario> usuarios = await listarUsuarios();

      for (Usuario usuario in usuarios) {
        List<Vistoria> vistoriasUsuario =
            await listarVistoriasDoUsuario(usuario);

        for (Vistoria vistoria in vistoriasUsuario) {
          todasVistorias
              .add(UsuarioVistoria(usuario: usuario, vistoria: vistoria));
        }
      }

      return todasVistorias;
    } catch (error) {
      print('Erro ao buscar todas as vistorias: $error');
      return [];
    }
  }

  Future<List<Usuario>> listarUsuarios() async {
    try {
      final QuerySnapshot<Map<String, dynamic>> snapshot =
          await _firestore.collection('usuarios').get();
      final List<Usuario> usuarios =
          snapshot.docs.map((doc) => Usuario.fromJson(doc.data())).toList();
      return usuarios;
    } catch (error) {
      print('Erro ao buscar usuários: $error');
      return [];
    }
  }

  Future<List<Vistoria>> listarVistoriasDoUsuario(Usuario usuario) async {
    List<Vistoria> vistorias = [];

    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('usuarios')
          .doc(usuario.id)
          .collection('vistorias')
          .get();

      for (var doc in querySnapshot.docs) {
        if (doc.exists) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          Vistoria vistoria = Vistoria.fromJson(data);
          vistorias.add(vistoria);
        }
      }

      return vistorias;
    } catch (e) {
      print('Erro ao buscar vistorias do usuário: $e');
      return [];
    }
  }

  Future<Usuario> obterUsuario(String userId) async {
    try {
      DocumentSnapshot userSnapshot =
          await _firestore.collection('usuarios').doc(userId).get();

      if (userSnapshot.exists) {
        Map<String, dynamic>? userData =
            userSnapshot.data() as Map<String, dynamic>?;

        if (userData != null) {
          Usuario usuario = Usuario.fromJson(userData);
          return usuario;
        } else {
          throw Exception('Dados do usuário são nulos');
        }
      } else {
        throw Exception('Usuário não encontrado');
      }
    } catch (e) {
      print('Erro ao obter usuário do banco de dados: $e');
      rethrow;
    }
  }

  Future<void> salvarVistoria(String userId, Vistoria vistoria) async {
    try {
      DocumentReference userDocRef =
          _firestore.collection('usuarios').doc(userId);

      await userDocRef.collection('vistorias').add(vistoria.toJson());
    } catch (error) {
      print('Erro ao salvar vistoria: $error');
      rethrow;
    }
  }

  Future<void> adicionarVistoria(String userId, Vistoria vistoria) async {
    try {
      await _firestore
          .collection('usuarios')
          .doc(userId)
          .collection('vistorias')
          .add(vistoria.toJson());
    } catch (error) {
      print('Erro ao adicionar vistoria: $error');
      throw error;
    }
  }

  Future<void> atualizarVistoria(String userId, Vistoria vistoria) async {
    try {
      await _firestore
          .collection('usuarios')
          .doc(userId)
          .collection('vistorias')
          .doc(vistoria.id)
          .update(vistoria.toJson());
    } catch (error) {
      print('Erro ao atualizar vistoria: $error');
      throw error;
    }
  }

  Future<List<Vistoria>> listarVistorias(String usuarioId) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('usuarios')
          .doc(usuarioId)
          .collection('vistorias')
          .get();

      return querySnapshot.docs.map((doc) {
        return Vistoria.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      print('Erro ao listar vistorias: $e');
      return [];
    }
  }

  // Métodos para reuniões
  Future<List<UsuarioReuniao>> listarTodasReunioes() async {
    List<UsuarioReuniao> todasReunioes = [];

    try {
      List<Usuario> usuarios = await listarUsuarios();

      for (Usuario usuario in usuarios) {
        List<Reuniao> reunioesUsuario =
            await listarReunioesDoUsuario(usuario);

        for (Reuniao reuniao in reunioesUsuario) {
          todasReunioes
              .add(UsuarioReuniao(usuario: usuario, reuniao: reuniao));
        }
      }

      return todasReunioes;
    } catch (error) {
      print('Erro ao buscar todas as reuniões: $error');
      return [];
    }
  }

  Future<List<Reuniao>> listarReunioesDoUsuario(Usuario usuario) async {
    List<Reuniao> reunioes = [];

    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('usuarios')
          .doc(usuario.id)
          .collection('reunioes')
          .get();

      for (var doc in querySnapshot.docs) {
        if (doc.exists) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          Reuniao reuniao = Reuniao.fromJson(data);
          reunioes.add(reuniao);
        }
      }

      return reunioes;
    } catch (e) {
      print('Erro ao buscar reuniões do usuário: $e');
      return [];
    }
  }

  Future<void> adicionarReuniao(String userId, Reuniao reuniao) async {
    try {
      await _firestore
          .collection('usuarios')
          .doc(userId)
          .collection('reunioes')
          .add(reuniao.toJson());
    } catch (error) {
      print('Erro ao adicionar reunião: $error');
      throw error;
    }
  }

  Future<void> atualizarReuniao(String userId, Reuniao reuniao) async {
    try {
      await _firestore
          .collection('usuarios')
          .doc(userId)
          .collection('reunioes')
          .doc(reuniao.id)
          .update(reuniao.toJson());
    } catch (error) {
      print('Erro ao atualizar reunião: $error');
      throw error;
    }
  }

  Future<List<Reuniao>> listarReunioes(String usuarioId) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('usuarios')
          .doc(usuarioId)
          .collection('reunioes')
          .get();

      return querySnapshot.docs.map((doc) {
        return Reuniao.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      print('Erro ao listar reuniões: $e');
      return [];
    }
  }

  Future<void> salvarCronograma(String userId, Cronograma cronograma) async {
    try {
      await _firestore
          .collection('usuarios')
          .doc(userId)
          .collection('cronograma')
          .add(cronograma.toJson());
      print('Cronograma salvo com sucesso!');
    } catch (e) {
      print('Erro ao salvar cronograma: $e');
    }
  }

  Future<void> updateCronograma(Usuario usuario) async {
    try {
      await _firestore.collection('usuarios').doc(usuario.id).update({
        'cronograma': usuario.cronograma!.toJson(),
      });
    } catch (e) {
      throw Exception('Erro ao atualizar cronograma: $e');
    }
  }
}
