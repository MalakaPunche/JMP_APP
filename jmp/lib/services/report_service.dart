import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/report.dart';

class ReportService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'reports';

  Stream<List<Report>> getReports(String userId) {
    return _firestore
        .collection(_collection)
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Report.fromFirestore(doc)).toList();
    });
  }

  Future<void> addReport(Report report) async {
    await _firestore.collection(_collection).add(report.toMap());
  }

  Future<void> deleteReport(String reportId) async {
    await _firestore.collection(_collection).doc(reportId).delete();
  }
} 