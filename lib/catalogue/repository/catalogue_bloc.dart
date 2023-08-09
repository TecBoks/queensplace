import 'package:bequeen/catalogue/repository/catalogue_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'dart:io';
import 'dart:typed_data';

class CatalogueBloc implements Bloc {
  final _catalogueRepository = CatalogueRepository();

  Stream<QuerySnapshot> getCatalogue() {
    return _catalogueRepository.getCatalogue();
  }

  Stream<QuerySnapshot> getCatalogueDetail(int limit, String catalogueUid) {
    return _catalogueRepository.getCatalogueDetail(limit, catalogueUid);
  }

  Stream<QuerySnapshot> getCatalogueDetailClient(
      int limit, String catalogueUid) {
    return _catalogueRepository.getCatalogueDetailClient(limit, catalogueUid);
  }

  Future<void> createCatalogueWeb(
      String name, String description, Uint8List fileBytes, String fileName) {
    return _catalogueRepository.createCatalogueWeb(
        name, description, fileBytes, fileName);
  }

  Future<void> createCatalogueDetail(String name, String description,
      String price, List fileBytesList, bool kIsWeb, String catalogueUid) {
    return _catalogueRepository.createCatalogueDetail(
        name, description, price, fileBytesList, kIsWeb, catalogueUid);
  }

  Future<void> updateCatalogueDetail(dynamic value) {
    return _catalogueRepository.updateCatalogueDetail(value);
  }

  Future<void> createCatalogueMovil(
      String name, String description, File fileBytes, String fileName) {
    return _catalogueRepository.createCatalogueMovil(
        name, description, fileBytes, fileName);
  }

  Future<void> deleteCatalogue(String uid, path) {
    return _catalogueRepository.deleteCatalogue(uid, path);
  }

  Future<void> deleteCatalogueDetail(String uid, List images) {
    return _catalogueRepository.deleteCatalogueDetail(uid, images);
  }

  @override
  void dispose() {}
}

final catalogueBloc = CatalogueBloc();
