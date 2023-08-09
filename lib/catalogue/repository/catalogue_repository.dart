import 'package:bequeen/catalogue/repository/catalogue_firebase_api.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:typed_data';

class CatalogueRepository {
  final _firebaseCatalogueAPI = FirebaseCatalogueAPI();

  Stream<QuerySnapshot> getCatalogue() => _firebaseCatalogueAPI.getCatalogue();

  Stream<QuerySnapshot> getCatalogueDetail(int limit, String catalogueUid) =>
      _firebaseCatalogueAPI.getCatalogueDetail(limit, catalogueUid);

  Stream<QuerySnapshot> getCatalogueDetailClient(
          int limit, String catalogueUid) =>
      _firebaseCatalogueAPI.getCatalogueDetailClient(limit, catalogueUid);

  Future<void> createCatalogueWeb(String name, String description,
          Uint8List fileBytes, String fileName) =>
      _firebaseCatalogueAPI.createCatalogueWeb(
          name, description, fileBytes, fileName);

  Future<void> createCatalogueDetail(String name, String description,
          String price, List fileBytesList, bool kIsWeb, String catalogueUid) =>
      _firebaseCatalogueAPI.createCatalogueDetail(
          name, description, price, fileBytesList, kIsWeb, catalogueUid);

  Future<void> updateCatalogueDetail(dynamic value) =>
      _firebaseCatalogueAPI.updateCatalogueDetail(value);

  Future<void> createCatalogueMovil(
          String name, String description, File fileBytes, String fileName) =>
      _firebaseCatalogueAPI.createCatalogueMovil(
          name, description, fileBytes, fileName);

  Future<void> deleteCatalogue(String uid, path) =>
      _firebaseCatalogueAPI.deleteCatalogue(uid, path);

  Future<void> deleteCatalogueDetail(String uid, List images) =>
      _firebaseCatalogueAPI.deleteCatalogueDetail(uid, images);
}
