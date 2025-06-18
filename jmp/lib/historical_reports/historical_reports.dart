import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/report.dart';
import '../services/report_service.dart';

class HistoricalReports extends StatelessWidget {
  final ReportService _reportService = ReportService();

  HistoricalReports({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Center(child: Text('Please log in to view reports'));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Historical Reports'),
      ),
      body: StreamBuilder<List<Report>>(
        stream: _reportService.getReports(user.uid),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final reports = snapshot.data ?? [];

          if (reports.isEmpty) {
            return const Center(child: Text('No reports found'));
          }

          return ListView.builder(
            itemCount: reports.length,
            itemBuilder: (context, index) {
              final report = reports[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text(
                    report.data['report'] ?? 'No report found',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Created: ${report.createdAt.toString().split('.')[0]}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      Text(
                        'Skills: ${(report.data['skills'] as List<dynamic>?)?.join(', ') ?? '-'}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      Text(
                        'Areas: ${(report.data['areas'] as List<dynamic>?)?.join(', ') ?? '-'}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _deleteReport(context, report.id),
                  ),
                  onTap: () => _showReportDetails(context, report),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _deleteReport(BuildContext context, String reportId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Report'),
        content: const Text('Are you sure you want to delete this report?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              _reportService.deleteReport(reportId);
              Navigator.pop(context);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showReportDetails(BuildContext context, Report report) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(report.title),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Created: ${report.createdAt.toString().split('.')[0]}'),
              const SizedBox(height: 8),
              Text('Skills: ${(report.data['skills'] as List<dynamic>?)?.join(', ') ?? '-'}'),
              const SizedBox(height: 8),
              Text('Areas: ${(report.data['areas'] as List<dynamic>?)?.join(', ') ?? '-'}'),
              const SizedBox(height: 16),
              const Text('Report:'),
              const SizedBox(height: 8),
              Text(report.data['report'] ?? 'No report found'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
