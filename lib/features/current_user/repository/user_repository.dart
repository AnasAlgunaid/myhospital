import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myhospital/features/current_user/models/user_model.dart';

class UserRepository {
  final FirebaseFirestore _firestore;

  UserRepository(this._firestore);

  Future<void> updateUser(String userId, UserModel updatedUser) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .update(updatedUser.toFirestore());
    } catch (e) {
      throw Exception('Failed to update user data: $e');
    }
  }

  Future<UserModel?> fetchUser(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      if (!doc.exists || doc.data() == null) return null;
      return UserModel.fromFirestore(doc.data()!);
    } catch (e) {
      // Log or handle the error as needed
      print('Error fetching user: $e');
      return null;
    }
  }
}
