import 'package:cloud_firestore/cloud_firestore.dart';
import '../domain/entities/plant.dart';

class PlantsRepository {
  final _db = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _plants =>
      _db.collection('plants');

  Stream<List<Plant>> watchPlants() {
    return _plants
        .snapshots()
        .map((snapshot) => snapshot.docs.map(Plant.fromFirestore).toList());
  }

  Stream<Set<String>> watchFavorites(String uid) {
    return _db.collection('users').doc(uid).snapshots().map((doc) {
      final list = doc.data()?['favorites'] as List? ?? [];
      return Set<String>.from(list);
    });
  }

  Future<void> addPlant(Plant plant) async {
    await _plants.add(plant.toJson());
  }

  Future<void> updatePlant(Plant plant) async {
    await _plants.doc(plant.id).update(plant.toJson());
  }

  Future<void> deletePlant(String id) async {
    await _plants.doc(id).delete();
  }

  Future<void> setFavorite(String uid, String plantId, bool liked) async {
    await _db.collection('users').doc(uid).set({
      'favorites': liked
          ? FieldValue.arrayUnion([plantId])
          : FieldValue.arrayRemove([plantId]),
    }, SetOptions(merge: true));
  }
} 