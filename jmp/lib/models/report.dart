import 'package:cloud_firestore/cloud_firestore.dart';

class Report {
  final String id;
  final String title;
  final String description;
  final DateTime createdAt;
  final String userId;
  final Map<String, dynamic> data;

  Report({
    required this.id,
    required this.title,
    required this.description,
    required this.createdAt,
    required this.userId,
    required this.data,
  });

  factory Report.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Report(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      userId: data['userId'] ?? '',
      data: data,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'createdAt': Timestamp.fromDate(createdAt),
      'userId': userId,
      'data': data,
    };
  }
} 