class Specialty {
  final String id; // Unique identifier for the specialty
  final String name;
  final String description;

  Specialty({required this.id, required this.name, required this.description});

  factory Specialty.fromMap(String id, Map<String, dynamic> map) {
    return Specialty(
      id: id,
      name: map['name'] ?? '',
      description: map['description'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'name': name,
      'description': description,
    };
  }
}
