import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/image_banner_model.dart';
import '../repositories/banner_repository.dart';

// Firestore instance provider
final firebaseFirestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

// Banner Repository Provider
final bannerRepositoryProvider = Provider<BannerRepository>((ref) {
  final firestore = ref.watch(firebaseFirestoreProvider);
  return BannerRepository(firestore);
});

// Banner Provider to fetch banners
final bannersProvider = FutureProvider<List<ImageBannerModel>>((ref) async {
  final repository = ref.watch(bannerRepositoryProvider);
  return repository.fetchBanners();
});
