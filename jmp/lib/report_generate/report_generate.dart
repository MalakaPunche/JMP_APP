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
  
  // Selected skills and areas
  final Map<String, bool> _selectedSkills = {};
  final Map<String, bool> _selectedAreas = {};
  
  // Preview toggle
  bool _showPreview = false;
  bool _isLoading = false;
  String _generatedReport = '';

  // Define skill categories and their skills
  final Map<String, List<String>> _skillCategories = {
    'Programming Languages': ['python', 'java', 'javascript', 'sql', 'r', 'swift', 'kotlin', 'php', 'typescript'],
    'Frameworks': ['react', 'node.js', 'express', '.net', 'asp.net'],
    'Databases': ['mysql', 'mongodb', 'oracle', 'sql server'],
    'Cloud & DevOps': ['aws', 'azure', 'gcp', 'kubernetes', 'docker', 'ci/cd', 'jenkins'],
    'Soft Skills': ['communication', 'leadership', 'teamwork', 'problem solving', 'time management', 'project management', 'analytical', 'collaboration', 'agile'],
  };

  // Define areas of interest
  final List<String> _areasOfInterest = [
    'Data Science',
    'Cybersecurity',
    'Web Development',
    'Cloud Computing',
    'Mobile Development',
  ];

  @override
  void initState() {
    super.initState();
    // Initialize all skills as unselected
    for (var category in _skillCategories.values) {
      for (var skill in category) {
        _selectedSkills[skill] = false;
      }
    }
    // Initialize all areas as unselected
    for (var area in _areasOfInterest) {
      _selectedAreas[area] = false;
    }
  }

  Future<void> _generateReport() async {
    try {
      setState(() => _isLoading = true);
      
      // Get selected skills
      final selectedSkills = _selectedSkills.entries
          .where((entry) => entry.value)
          .map((entry) => entry.key)
          .toList();
      
      // Get selected areas
      final selectedAreas = _selectedAreas.entries
          .where((entry) => entry.value)
          .map((entry) => entry.key)
          .toList();

      // Generate report using the API
      final report = await _apiService.generateReport(
        skills: selectedSkills.join(','),
        areas: selectedAreas.join(','),
      );

      // Save to Firestore
      await _firestore.collection('career_reports').add({
        'degree': _degree,
        'major': _major,
        'university': _university,
        'graduationYear': _graduationYear,
        'workExperience': _workExperience,
        'skills': selectedSkills,
        'areas': selectedAreas,
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

  Widget _buildSkillCategory(String category, List<String> skills) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          category,
          style: GoogleFonts.ubuntu(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: skills.map((skill) {
            return FilterChip(
              label: Text(skill),
              selected: _selectedSkills[skill] ?? false,
              onSelected: (bool selected) {
                setState(() {
                  _selectedSkills[skill] = selected;
                });
              },
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildAreaOfInterest() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Areas of Interest',
          style: GoogleFonts.ubuntu(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: _areasOfInterest.map((area) {
            return FilterChip(
              label: Text(area),
              selected: _selectedAreas[area] ?? false,
              onSelected: (bool selected) {
                setState(() {
                  _selectedAreas[area] = selected;
                });
              },
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
      ],
    );
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
                          
                          // Basic Information Fields
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
                          const SizedBox(height: 24),
                          
                          // Skills Selection
                          Text(
                            'Select Your Skills',
                            style: GoogleFonts.ubuntu(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          
                          // Build skill categories
                          ..._skillCategories.entries.map(
                            (entry) => _buildSkillCategory(entry.key, entry.value),
                          ),
                          
                          // Areas of Interest
                          _buildAreaOfInterest(),
                          
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
