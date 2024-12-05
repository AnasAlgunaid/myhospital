import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/image_banner_model.dart';

class BannerRepository {
  final FirebaseFirestore _firestore;

  BannerRepository(this._firestore);

  Future<List<ImageBannerModel>> fetchBanners() async {
    try {
      final snapshot = await _firestore.collection('banners').get();
      return snapshot.docs.map((doc) {
        return ImageBannerModel.fromFirestore(doc.data(), doc.id);
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch banners: $e');
    }
  }
}
