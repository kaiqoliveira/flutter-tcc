import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:health_care/models/reuniao.dart';
import 'package:health_care/models/usuario.dart';

class DatabaseReunioesService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Reuniao>> listarReunioes() async {
    try {
      QuerySnapshot querySnapshot =
          await _firestore.collection('reunioes').get();
      List<Reuniao> reunioes = querySnapshot.docs
          .map((doc) => Reuniao.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
      return reunioes;
    } catch (error) {
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
          reunioes.add(Reuniao.fromJson(data));
        }
      }

      return reunioes;
    } catch (e) {
      return reunioes;
    }
  }
}
