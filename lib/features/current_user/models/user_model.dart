class UserModel {
  final String uid;
  final String name;
  final String phoneNumber;
  final String nationalId;
  final String dateOfBirth;
  final String gender;

  UserModel({
    required this.uid,
    required this.name,
    required this.phoneNumber,
    required this.nationalId,
    required this.dateOfBirth,
    required this.gender,
  });

  // Convert Firestore Document to UserModel
  factory UserModel.fromFirestore(Map<String, dynamic> data) {
    return UserModel(
      uid: data['uid'] as String,
      name: data['name'] as String,
      phoneNumber: data['phoneNumber'] as String,
      nationalId: data['nationalId'] as String,
      dateOfBirth: data['dateOfBirth'] as String,
      gender: data['gender'] as String,
    );
  }

  // Convert UserModel to Map for Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'uid': uid,
      'name': name,
      'phoneNumber': phoneNumber,
      'nationalId': nationalId,
      'dateOfBirth': dateOfBirth,
      'gender': gender,
    };
  }
}
