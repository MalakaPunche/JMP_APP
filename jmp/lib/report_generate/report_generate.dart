import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../common/api_service.dart';

class ReportGenerate extends StatefulWidget {
  const ReportGenerate({super.key});

  @override
  State<ReportGenerate> createState() => _ReportGenerateState();
}

class _ReportGenerateState extends State<ReportGenerate> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ApiService _apiService = ApiService();
  
  // Form fields
  String _degree = '';
  String _major = '';
  String _university = '';
  String _graduationYear = '';
  String _workExperience = '';
  String _skills = '';
  
  // Preview toggle
  bool _showPreview = false;
  bool _isLoading = false;
  String _generatedReport = '';

  Future<void> _generateReport() async {
    try {
      setState(() => _isLoading = true);
      
      // Generate report using the API
      final report = await _apiService.generateReport(
        degree: _degree,
        major: _major,
        university: _university,
        graduationYear: _graduationYear,
        workExperience: _workExperience,
        skills: _skills,
      );

      // Save to Firestore
      await _firestore.collection('career_reports').add({
        'degree': _degree,
        'major': _major,
        'university': _university,
        'graduationYear': _graduationYear,
        'workExperience': _workExperience,
        'skills': _skills,
        'report': report,
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (mounted) {
        setState(() {
          _generatedReport = report;
          _showPreview = true;
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Report generated successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error generating report: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF4A90E2).withOpacity(0.5),
              const Color(0xFF50E3C2).withOpacity(0.5),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Career Report Generator',
                  style: GoogleFonts.ubuntu(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                
                // Configuration Form
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Enter Your Information',
                            style: GoogleFonts.ubuntu(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20),
                          
                          // Degree Input
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Degree',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              filled: true,
                              fillColor: Colors.grey[100],
                            ),
                            onChanged: (value) => setState(() => _degree = value),
                            validator: (value) =>
                                value!.isEmpty ? 'Please enter your degree' : null,
                          ),
                          const SizedBox(height: 16),
                          
                          // Major Input
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Major/Field of Study',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              filled: true,
                              fillColor: Colors.grey[100],
                            ),
                            onChanged: (value) => setState(() => _major = value),
                            validator: (value) =>
                                value!.isEmpty ? 'Please enter your major' : null,
                          ),
                          const SizedBox(height: 16),
                          
                          // University Input
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'University',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              filled: true,
                              fillColor: Colors.grey[100],
                            ),
                            onChanged: (value) => setState(() => _university = value),
                            validator: (value) =>
                                value!.isEmpty ? 'Please enter your university' : null,
                          ),
                          const SizedBox(height: 16),
                          
                          // Graduation Year Input
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Graduation Year',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              filled: true,
                              fillColor: Colors.grey[100],
                            ),
                            onChanged: (value) => setState(() => _graduationYear = value),
                            validator: (value) =>
                                value!.isEmpty ? 'Please enter your graduation year' : null,
                          ),
                          const SizedBox(height: 16),
                          
                          // Work Experience Input
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Work Experience (years)',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              filled: true,
                              fillColor: Colors.grey[100],
                            ),
                            keyboardType: TextInputType.number,
                            onChanged: (value) => setState(() => _workExperience = value),
                          ),
                          const SizedBox(height: 16),
                          
                          // Skills Input
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Key Skills (comma separated)',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              filled: true,
                              fillColor: Colors.grey[100],
                            ),
                            maxLines: 3,
                            onChanged: (value) => setState(() => _skills = value),
                          ),
                          const SizedBox(height: 20),
                          
                          // Generate Button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF4A90E2),
                                padding: const EdgeInsets.symmetric(vertical: 15),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: _isLoading
                                  ? null
                                  : () async {
                                      if (_formKey.currentState!.validate()) {
                                        await _generateReport();
                                      }
                                    },
                              child: _isLoading
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Text(
                                      'Generate Report',
                                      style: TextStyle(fontSize: 16),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                
                // Report Preview Section
                if (_showPreview) ...[
                  const SizedBox(height: 30),
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Career Report',
                                style: GoogleFonts.ubuntu(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.download),
                                onPressed: () {
                                  // TODO: Implement download functionality
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Download feature coming soon!'),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                          const Divider(),
                          const SizedBox(height: 10),
                          
                          // Display the generated report
                          Text(
                            _generatedReport,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
