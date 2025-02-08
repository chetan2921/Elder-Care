class EmergencyContact {
  final String name;
  final String phoneNumber;
  final String relationship;
  final String? notes;

  EmergencyContact({
    required this.name,
    required this.phoneNumber,
    required this.relationship,
    this.notes,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phoneNumber': phoneNumber,
      'relationship': relationship,
      'notes': notes,
    };
  }

  factory EmergencyContact.fromJson(Map<String, dynamic> json) {
    return EmergencyContact(
      name: json['name'],
      phoneNumber: json['phoneNumber'],
      relationship: json['relationship'],
      notes: json['notes'],
    );
  }
}