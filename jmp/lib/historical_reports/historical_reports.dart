import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/report.dart';
import '../services/report_service.dart';
import '../common/jmp_theme.dart';
import '../common/jmp_widgets.dart';
import '../common/jmp_util.dart';

class HistoricalReports extends StatelessWidget {
  final ReportService _reportService = ReportService();

  HistoricalReports({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF4A90E2), Color(0xFF50E3C2)],
            ),
          ),
          child: const Center(
            child: Text(
              'Please log in to view reports',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          'Historical Reports',
          style: JMPTheme.title1.override(
            color: Colors.white,
            useGoogleFonts: false,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF4A90E2), Color(0xFF50E3C2)],
          ),
        ),
        child: SafeArea(
          child: StreamBuilder<List<Report>>(
            stream: _reportService.getReports(user.uid),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 64,
                        color: Colors.white.withOpacity(0.7),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Error loading reports',
                        style: JMPTheme.title2.override(
                          color: Colors.white,
                          useGoogleFonts: false,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${snapshot.error}',
                        style: JMPTheme.bodyText1.override(
                          color: Colors.white.withOpacity(0.8),
                          useGoogleFonts: false,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Loading reports...',
                        style: JMPTheme.subtitle1.override(
                          color: Colors.white,
                          useGoogleFonts: false,
                        ),
                      ),
                    ],
                  ),
                );
              }

              final reports = snapshot.data ?? [];

              if (reports.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.description_outlined,
                        size: 80,
                        color: Colors.white.withOpacity(0.6),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'No Reports Found',
                        style: JMPTheme.title1.override(
                          color: Colors.white,
                          useGoogleFonts: false,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Generate your first career report to see it here',
                        style: JMPTheme.bodyText1.override(
                          color: Colors.white.withOpacity(0.8),
                          useGoogleFonts: false,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),
                      FFButtonWidget(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        text: 'Generate Report',
                        options: FFButtonOptions(
                          width: 200,
                          height: 50,
                          color: Colors.white,
                          textStyle: JMPTheme.subtitle2.override(
                            color: JMPTheme.primaryColor,
                            fontWeight: FontWeight.w600,
                            useGoogleFonts: false,
                          ),
                          borderRadius: 25,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Text(
                      '${reports.length} report${reports.length == 1 ? '' : 's'} generated',
                      style: JMPTheme.bodyText1.override(
                        color: Colors.white.withOpacity(0.8),
                        useGoogleFonts: false,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Expanded(
                      child: ListView.builder(
                        itemCount: reports.length,
                        itemBuilder: (context, index) {
                          final report = reports[index];
                          return _buildReportCard(context, report, index);
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildReportCard(BuildContext context, Report report, int index) {
    final reportData = report.data;
    final skills = (reportData['skills'] as List<dynamic>?)?.cast<String>() ?? [];
    final areas = (reportData['areas'] as List<dynamic>?)?.cast<String>() ?? [];
    final reportText = reportData['report'] as String? ?? 'No report content available';
    
    // Create a preview of the report (first 100 characters)
    final preview = reportText.length > 100 
        ? '${reportText.substring(0, 100)}...' 
        : reportText;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _showReportDetails(context, report),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: JMPTheme.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.analytics_outlined,
                        color: JMPTheme.primaryColor,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Career Report #${index + 1}',
                            style: JMPTheme.subtitle1.override(
                              color: JMPTheme.primaryColor,
                              fontWeight: FontWeight.w600,
                              useGoogleFonts: false,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _formatDate(report.createdAt),
                            style: JMPTheme.bodyText2.override(
                              color: Colors.grey[600],
                              useGoogleFonts: false,
                            ),
                          ),
                        ],
                      ),
                    ),
                    PopupMenuButton<String>(
                      icon: Icon(
                        Icons.more_vert,
                        color: Colors.grey[600],
                      ),
                      onSelected: (value) {
                        if (value == 'delete') {
                          _deleteReport(context, report.id);
                        } else if (value == 'view') {
                          _showReportDetails(context, report);
                        }
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'view',
                          child: Row(
                            children: [
                              Icon(Icons.visibility, size: 20),
                              SizedBox(width: 8),
                              Text('View Full Report'),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(Icons.delete, size: 20, color: Colors.red),
                              SizedBox(width: 8),
                              Text('Delete Report', style: TextStyle(color: Colors.red)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  preview,
                  style: JMPTheme.bodyText1.override(
                    color: Colors.grey[800],
                    useGoogleFonts: false,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 16),
                if (skills.isNotEmpty || areas.isNotEmpty) ...[
                  const Divider(height: 1),
                  const SizedBox(height: 12),
                  if (skills.isNotEmpty) ...[
                    _buildTagsSection('Skills', skills),
                    const SizedBox(height: 8),
                  ],
                  if (areas.isNotEmpty) ...[
                    _buildTagsSection('Areas', areas),
                  ],
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTagsSection(String title, List<String> tags) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: JMPTheme.bodyText2.override(
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
            useGoogleFonts: false,
          ),
        ),
        const SizedBox(height: 6),
        Wrap(
          spacing: 6,
          runSpacing: 4,
          children: tags.take(3).map((tag) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: JMPTheme.secondaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              tag,
              style: JMPTheme.bodyText2.override(
                color: JMPTheme.secondaryColor,
                fontSize: 12,
                useGoogleFonts: false,
              ),
            ),
          )).toList(),
        ),
        if (tags.length > 3) ...[
          const SizedBox(height: 4),
          Text(
            '+${tags.length - 3} more',
            style: JMPTheme.bodyText2.override(
              color: Colors.grey[500],
              fontSize: 12,
              useGoogleFonts: false,
            ),
          ),
        ],
      ],
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        return '${difference.inMinutes} minutes ago';
      }
      return '${difference.inHours} hours ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  void _deleteReport(BuildContext context, String reportId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          'Delete Report',
          style: JMPTheme.title3.override(
            color: Colors.red,
            useGoogleFonts: false,
          ),
        ),
        content: Text(
          'Are you sure you want to delete this report? This action cannot be undone.',
          style: JMPTheme.bodyText1.override(
            useGoogleFonts: false,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: JMPTheme.subtitle2.override(
                color: Colors.grey[600],
                useGoogleFonts: false,
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              _reportService.deleteReport(reportId);
              Navigator.pop(context);
              showSnackbar(context, 'Report deleted successfully');
            },
            child: Text(
              'Delete',
              style: JMPTheme.subtitle2.override(
                color: Colors.white,
                useGoogleFonts: false,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showReportDetails(BuildContext context, Report report) {
    final reportData = report.data;
    final skills = (reportData['skills'] as List<dynamic>?)?.cast<String>() ?? [];
    final areas = (reportData['areas'] as List<dynamic>?)?.cast<String>() ?? [];
    final reportText = reportData['report'] as String? ?? 'No report content available';

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.8,
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF4A90E2), Color(0xFF50E3C2)],
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.analytics_outlined,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Career Report',
                            style: JMPTheme.title2.override(
                              color: Colors.white,
                              useGoogleFonts: false,
                            ),
                          ),
                          Text(
                            _formatDate(report.createdAt),
                            style: JMPTheme.bodyText1.override(
                              color: Colors.white.withOpacity(0.8),
                              useGoogleFonts: false,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.close,
                        color: Colors.white,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (skills.isNotEmpty) ...[
                        Text(
                          'Skills Analyzed',
                          style: JMPTheme.subtitle1.override(
                            color: JMPTheme.primaryColor,
                            fontWeight: FontWeight.w600,
                            useGoogleFonts: false,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 4,
                          children: skills.map((skill) => Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: JMPTheme.primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              skill,
                              style: JMPTheme.bodyText2.override(
                                color: JMPTheme.primaryColor,
                                useGoogleFonts: false,
                              ),
                            ),
                          )).toList(),
                        ),
                        const SizedBox(height: 20),
                      ],
                      if (areas.isNotEmpty) ...[
                        Text(
                          'Areas of Interest',
                          style: JMPTheme.subtitle1.override(
                            color: JMPTheme.primaryColor,
                            fontWeight: FontWeight.w600,
                            useGoogleFonts: false,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 4,
                          children: areas.map((area) => Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: JMPTheme.secondaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              area,
                              style: JMPTheme.bodyText2.override(
                                color: JMPTheme.secondaryColor,
                                useGoogleFonts: false,
                              ),
                            ),
                          )).toList(),
                        ),
                        const SizedBox(height: 20),
                      ],
                      Text(
                        'Career Analysis Report',
                        style: JMPTheme.subtitle1.override(
                          color: JMPTheme.primaryColor,
                          fontWeight: FontWeight.w600,
                          useGoogleFonts: false,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.grey[200]!,
                          ),
                        ),
                        child: Text(
                          reportText,
                          style: JMPTheme.bodyText1.override(
                            color: Colors.grey[800],
                            lineHeight: 1.5,
                            useGoogleFonts: false,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
