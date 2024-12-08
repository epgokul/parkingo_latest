import 'package:cloud_firestore/cloud_firestore.dart';

class MarkerData {
  final String id; // Document ID from Firestore
  final double latitude;
  final double longitude;
  final String description;
  final String addedBy;
  final bool approved;

  MarkerData({
    required this.id,
    required this.latitude,
    required this.longitude,
    required this.description,
    required this.addedBy,
    required this.approved,
  });

  // Factory method to create MarkerData from Firestore document
  factory MarkerData.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return MarkerData(
      id: doc.id,
      latitude: data['latitude'],
      longitude: data['longitude'],
      description: data['description'],
      addedBy: data['addedBy'],
      approved: data['approved'],
    );
  }

  // Convert MarkerData to a map for Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'description': description,
      'addedBy': addedBy,
      'approved': approved,
    };
  }
}
