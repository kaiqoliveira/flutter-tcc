import 'dart:io';
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<void> uploadFile(
      String path, String emailAddress, String fileExtension) async {
    String ref;
    File file = File(path);

    try {
      if (fileExtension == '.pdf') {
        ref = _generateFileReference(emailAddress, fileExtension);
        await _uploadPDF(file, ref, emailAddress, fileExtension);
      } else {
        ref = _generateFileReference(emailAddress, fileExtension);
        await _uploadUndefinedFile(file, ref, emailAddress, fileExtension);
      }
    } catch (e) {
      throw Exception('Erro no upload: $e');
    }
  }

  Future<void> uploadImage(String path, String emailAddress,
      String fileExtension, String idVistoria) async {
    String ref;
    File file = File(path);

    try {
      if (_isImageExtension(fileExtension)) {
        ref = _generateImageReference(emailAddress, fileExtension, idVistoria);
        await _uploadImage(file, ref, emailAddress, fileExtension, idVistoria);
      }
    } catch (e) {
      throw Exception('Erro no upload: $e');
    }
  }

  bool _isImageExtension(String fileExtension) {
    List<String> imageExtensions = ['.png', '.jpg', '.jpeg', '.gif', '.bmp'];
    return imageExtensions.contains(fileExtension.toLowerCase());
  }

  String _generateImageReference(
      String emailAddress, String fileExtension, String idVistoria) {
    return 'images/$emailAddress/$idVistoria/img-${DateTime.now().toString()}$fileExtension';
  }

  String _generateFileReference(String emailAddress, String fileExtension) {
    return 'files/$emailAddress/file-${DateTime.now().millisecondsSinceEpoch}$fileExtension';
  }

  Future<void> _uploadImage(File file, String ref, String emailAddress,
      String fileExtension, String idVistoria) async {
    String imageType = fileExtension.substring(1);
    SettableMetadata metadata = SettableMetadata(
      cacheControl: "public, max-age=300",
      contentType: 'image/$imageType',
      customMetadata: {"user": emailAddress},
    );

    await _storage.ref().child(ref).putFile(file, metadata);
  }

  Future<void> _uploadPDF(
      File file, String ref, String emailAddress, String fileExtension) async {
    SettableMetadata metadata = SettableMetadata(
      cacheControl: "public, max-age=300",
      contentType: 'application/pdf',
      customMetadata: {"user": emailAddress},
    );

    await _storage.ref().child(ref).putFile(file, metadata);
  }

  Future<void> _uploadUndefinedFile(
      File file, String ref, String emailAddress, String fileExtension) async {
    SettableMetadata metadata = SettableMetadata(
      cacheControl: "public, max-age=300",
      contentType: 'undefined',
      customMetadata: {"user": emailAddress},
    );

    await _storage.ref().child(ref).putFile(file, metadata);
  }

  Future<ListResult> listFiles(String emailAddress) async {
    final storageRef =
        FirebaseStorage.instance.ref().child("files/$emailAddress/");
    final listResult = await storageRef.listAll();
    return listResult;
  }

  Future<ListResult> listImages(String emailAddress, String idVistoria) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      // Usuário não autenticado, lançar exceção ou lidar com isso de alguma forma
      throw Exception("Usuário não autenticado");
    }

    // Usuário autenticado, continuar com a listagem de imagens
    final storageRef = FirebaseStorage.instance
        .ref()
        .child("images/$emailAddress/$idVistoria/");
    final listResult = await storageRef.listAll();
    return listResult;
  }

  Future<void> deleteImage(String imageUrl) async {
    try {
      Reference reference = _storage.refFromURL(imageUrl);
      await reference.delete();
    } catch (e) {
      throw Exception('Erro ao excluir imagem: $e');
    }
  }
}
