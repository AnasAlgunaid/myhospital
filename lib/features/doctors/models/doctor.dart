import 'package:myhospital/features/doctors/models/speciality.dart';

class Doctor {
  final String id;
  final String doctorId; // Unique identifier for the doctor
  final String name;
  final String photoUrl;
  final String profile;
  final Specialty specialty; // Specialty object instead of specialtyId
  final Map<String, List<Slot>> slots;
  final WorkingHours workingHours;

  Doctor({
    required this.id,
    required this.doctorId,
    required this.name,
    required this.photoUrl,
    required this.profile,
    required this.specialty,
    required this.slots,
    required this.workingHours,
  });

  factory Doctor.fromMap(
      String id, Map<String, dynamic> map, Specialty specialty) {
    return Doctor(
      id: id,
      doctorId: map['doctorId'] ?? '',
      name: map['name'] ?? '',
      photoUrl: map['photoUrl'] ?? '',
      profile: map['profile'] ?? '',
      specialty: specialty, // Pass the full Specialty object
      slots: (map['slots'] as Map<String, dynamic>).map(
        (date, slotList) => MapEntry(
          date,
          (slotList as List<dynamic>)
              .map((slot) => Slot.fromMap(slot))
              .toList(),
        ),
      ),
      workingHours: WorkingHours.fromMap(map['workingHours']),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'doctorId': doctorId,
      'name': name,
      'photoUrl': photoUrl,
      'profile': profile,
      'specialtyId': specialty.id, // Only store the specialtyId in Firestore
      'slots': slots.map((date, slotList) => MapEntry(
            date,
            slotList.map((slot) => slot.toFirestore()).toList(),
          )),
      'workingHours': workingHours.toFirestore(),
    };
  }
}

class Slot {
  final String time;
  final bool available;

  Slot({required this.time, required this.available});

  factory Slot.fromMap(Map<String, dynamic> map) {
    return Slot(
      time: map['time'] ?? '',
      available: map['available'] ?? false,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'time': time,
      'available': available,
    };
  }
}

class WorkingHours {
  final String start;
  final String end;

  WorkingHours({required this.start, required this.end});

  factory WorkingHours.fromMap(Map<String, dynamic> map) {
    return WorkingHours(
      start: map['start'] ?? '',
      end: map['end'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'start': start,
      'end': end,
    };
  }
}
