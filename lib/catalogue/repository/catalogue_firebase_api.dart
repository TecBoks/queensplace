import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:typed_data';

class FirebaseCatalogueAPI {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getCatalogue() {
    return _firestore.collection('catalogue').snapshots();
  }

  Stream<QuerySnapshot> getCatalogueDetail(int limit, String catalogueUid) {
    return _firestore
        .collection('catalogue_detail')
        .where("catalogueUid", isEqualTo: catalogueUid)
        .limit(limit)
        .snapshots();
  }

  Stream<QuerySnapshot> getCatalogueDetailClient(
      int limit, String catalogueUid) {
    return _firestore
        .collection('catalogue_detail')
        .where("catalogueUid", isEqualTo: catalogueUid)
        .where("state", isEqualTo: true)
        .limit(limit)
        .snapshots();
  }

  Future<void> createCatalogueWeb(String name, String description,
      Uint8List fileBytes, String fileName) async {
    DocumentReference newPost = _firestore.collection('catalogue').doc();
    String photoExtension = fileName.split(".")[fileName.split('.').length - 1];
    String path = 'catalogue/${newPost.id}';
    Reference ref =
        FirebaseStorage.instance.ref().child('$path.$photoExtension');
    await ref.putData(
        fileBytes, SettableMetadata(contentType: 'image/$photoExtension'));
    var downUrl = await ref.getDownloadURL();
    var urlImage = downUrl.toString();
    try {
      return newPost.set({
        'uid': newPost.id,
        'name': name,
        'description': description,
        'photoExtension': photoExtension,
        'pathImage': path,
        'urlImage': urlImage
      });
    } catch (e) {
      return;
    }
  }

  Future<void> createCatalogueMovil(
      String name, String description, File fileBytes, String fileName) async {
    DocumentReference newPost = _firestore.collection('catalogue').doc();
    String photoExtension = fileName.split(".")[fileName.split('.').length - 1];
    String path = 'catalogue/${newPost.id}';
    Reference ref =
        FirebaseStorage.instance.ref().child('$path.$photoExtension');
    await ref.putFile(
        fileBytes, SettableMetadata(contentType: 'image/$photoExtension'));
    var downUrl = await ref.getDownloadURL();
    var urlImage = downUrl.toString();
    try {
      return newPost.set({
        'uid': newPost.id,
        'name': name,
        'description': description,
        'photoExtension': photoExtension,
        'pathImage': path,
        'urlImage': urlImage
      });
    } catch (e) {
      return;
    }
  }

  Future<void> createCatalogueDetail(
      String name,
      String description,
      String price,
      List fileBytesList,
      bool kIsWeb,
      String catalogueUid) async {
    List newFileBytesList = [];
    DocumentReference newPost = _firestore.collection('catalogue_detail').doc();
    for (var i = 0; i < fileBytesList.length; i++) {
      String photoExtension = fileBytesList[i]["fileName"]
          .split(".")[fileBytesList[i]["fileName"].split('.').length - 1];
      String path = 'catalogue/${newPost.id}-$i';
      Reference ref =
          FirebaseStorage.instance.ref().child('$path.$photoExtension');
      if (kIsWeb) {
        await ref.putData(fileBytesList[i]["fileByte"],
            SettableMetadata(contentType: 'image/$photoExtension'));
        var downUrl = await ref.getDownloadURL();
        var urlImage = downUrl.toString();
        newFileBytesList.add({
          'photoExtension': photoExtension,
          'pathImage': path,
          'urlImage': urlImage
        });
      } else {
        await ref.putFile(fileBytesList[i]["fileByte"],
            SettableMetadata(contentType: 'image/$photoExtension'));
        var downUrl = await ref.getDownloadURL();
        var urlImage = downUrl.toString();
        newFileBytesList.add({
          'photoExtension': photoExtension,
          'pathImage': path,
          'urlImage': urlImage
        });
      }
    }
    try {
      return newPost.set({
        'uid': newPost.id,
        'catalogueUid': catalogueUid,
        'name': name,
        'description': description,
        'price': price,
        'state': true,
        'images': newFileBytesList
      });
    } catch (e) {
      return;
    }
  }

  Future<void> updateCatalogueDetail(dynamic value) async {
    DocumentReference newPost =
        _firestore.collection('catalogue_detail').doc(value['uid']);
    try {
      return newPost.update({
        'uid': value['uid'],
        'catalogueUid': value['catalogueUid'],
        'name': value['name'],
        'description': value['description'],
        'price': value['price'],
        'state': value['state'],
        'images': value['images']
      });
    } catch (e) {
      return;
    }
  }

  Future<void> deleteCatalogue(String uid, path) async {
    var desertRef = FirebaseStorage.instance.ref().child(path);
    await desertRef.delete();
    return _firestore.collection('catalogue').doc(uid).delete();
  }

  Future<void> deleteCatalogueDetail(String uid, List images) async {
    for (var e in images) {
      var desertRef = FirebaseStorage.instance
          .ref()
          .child('${e['pathImage']}.${e['photoExtension']}');
      await desertRef.delete();
    }
    return _firestore.collection('catalogue_detail').doc(uid).delete();
  }
}
