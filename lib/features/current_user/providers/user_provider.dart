import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myhospital/features/current_user/controller/user_controller.dart';
import 'package:myhospital/features/current_user/models/user_model.dart';
import 'package:myhospital/features/current_user/repository/user_repository.dart';

// Firestore instance provider
final firebaseFirestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

// User Repository Provider
final userRepositoryProvider = Provider<UserRepository>((ref) {
  final firestore = ref.watch(firebaseFirestoreProvider);
  return UserRepository(firestore);
});

// User Controller Provider
final userControllerProvider = Provider<UserController>((ref) {
  final repository = ref.watch(userRepositoryProvider);
  return UserController(repository);
});

// User Provider for fetching the logged-in user's details
final userProvider = FutureProvider<UserModel?>((ref) async {
  final userId = ref.watch(userIdProvider);
  if (userId == null) {
    return null;
  }

  final controller = ref.watch(userControllerProvider);
  return controller.fetchUser(userId);
});

// User ID Provider
final userIdProvider = StateProvider<String?>((ref) => null);
