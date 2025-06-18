import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../common/api_service.dart';
import '../common/jmp_theme.dart';
import '../common/jmp_widgets.dart';
import '../common/jmp_util.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
    'Programming Languages': [
      'sql', 'r', 'python', 'javascript', 'java', 'swift', 'typescript', 'php', 'kotlin', 'c++'
    ],
    'Frameworks & Libraries': [
      'express', '.net', 'asp.net', 'node.js', 'react', 'angular', 'django', 'spring', 'vue.js', 'flask'
    ],
    'Databases': [
      'oracle', 'mysql', 'mongodb', 'sql server', 'postgresql', 'redis', 'sqlite', 'cassandra', 'firebase', 'elasticsearch'
    ],
    'Cloud & DevOps': [
      'azure', 'aws', 'ci/cd', 'jenkins', 'cloud computing', 'kubernetes', 'gcp', 'devops', 'docker', 'git'
    ],
    'Soft Skills': [
      'communication', 'analytical', 'leadership', 'collaboration', 'teamwork', 'time management', 'project management', 'problem solving', 'agile', 'critical thinking'
    ],
    'Data & Analytics': [
      'data analysis', 'statistics', 'machine learning', 'data visualization', 'pandas', 'numpy', 'matplotlib', 'scikit-learn', 'r studio', 'jupyter'
    ],
    'Security & Testing': [
      'cybersecurity', 'unit testing', 'integration testing', 'selenium', 'jest', 'pytest', 'junit', 'penetration testing', 'authentication', 'encryption'
    ],
    'Mobile & Web': [
      'html5', 'css3', 'javascript', 'react native', 'flutter', 'responsive design', 'seo', 'webpack', 'bootstrap', 'jquery'
    ],
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
      
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        // Handle not logged in
        showSnackbar(context, 'You must be logged in to generate a report.');
        setState(() => _isLoading = false);
        return;
      }
      final userId = user.uid;
      
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
      await _firestore.collection('reports').add({
        'degree': _degree,
        'major': _major,
        'university': _university,
        'graduationYear': _graduationYear,
        'workExperience': _workExperience,
        'skills': selectedSkills,
        'areas': selectedAreas,
        'report': report,
        'createdAt': FieldValue.serverTimestamp(),
        'userId': userId,
      });

      if (mounted) {
        setState(() {
          _generatedReport = report;
          _showPreview = true;
        });
        
        showSnackbar(context, 'Report generated successfully!');
      }
    } catch (e) {
      if (mounted) {
        showSnackbar(context, 'Error generating report: $e');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Widget _buildSkillCategory(String category, List<String> skills) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            category,
            style: JMPTheme.subtitle1.override(
              color: JMPTheme.primaryColor,
              fontWeight: FontWeight.w600,
              useGoogleFonts: false,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: skills.map((skill) {
              return FilterChip(
                label: Text(
                  skill,
                  style: JMPTheme.bodyText2.override(
                    useGoogleFonts: false,
                  ),
                ),
                selected: _selectedSkills[skill] ?? false,
                onSelected: (bool selected) {
                  setState(() {
                    _selectedSkills[skill] = selected;
                  });
                },
                selectedColor: JMPTheme.primaryColor.withOpacity(0.2),
                checkmarkColor: JMPTheme.primaryColor,
                backgroundColor: Colors.white,
                side: BorderSide(
                  color: _selectedSkills[skill] ?? false 
                      ? JMPTheme.primaryColor 
                      : Colors.grey[300]!,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildAreaOfInterest() {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Areas of Interest',
            style: JMPTheme.subtitle1.override(
              color: JMPTheme.primaryColor,
              fontWeight: FontWeight.w600,
              useGoogleFonts: false,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _areasOfInterest.map((area) {
              return FilterChip(
                label: Text(
                  area,
                  style: JMPTheme.bodyText2.override(
                    useGoogleFonts: false,
                  ),
                ),
                selected: _selectedAreas[area] ?? false,
                onSelected: (bool selected) {
                  setState(() {
                    _selectedAreas[area] = selected;
                  });
                },
                selectedColor: JMPTheme.secondaryColor.withOpacity(0.2),
                checkmarkColor: JMPTheme.secondaryColor,
                backgroundColor: Colors.white,
                side: BorderSide(
                  color: _selectedAreas[area] ?? false 
                      ? JMPTheme.secondaryColor 
                      : Colors.grey[300]!,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          'Career Report Generator',
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
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                
                // Configuration Form
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Form(
                      key: _formKey,
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
                                  Icons.person_outline,
                                  color: JMPTheme.primaryColor,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'Personal Information',
                                style: JMPTheme.title2.override(
                                  color: JMPTheme.primaryColor,
                                  useGoogleFonts: false,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          
                          // Basic Information Fields
                          _buildTextField(
                            label: 'Degree',
                            onChanged: (value) => setState(() => _degree = value),
                            validator: (value) => value!.isEmpty ? 'Please enter your degree' : null,
                          ),
                          const SizedBox(height: 16),
                          
                          _buildTextField(
                            label: 'Major/Field of Study',
                            onChanged: (value) => setState(() => _major = value),
                            validator: (value) => value!.isEmpty ? 'Please enter your major' : null,
                          ),
                          const SizedBox(height: 16),
                          
                          _buildTextField(
                            label: 'University',
                            onChanged: (value) => setState(() => _university = value),
                            validator: (value) => value!.isEmpty ? 'Please enter your university' : null,
                          ),
                          const SizedBox(height: 16),
                          
                          _buildTextField(
                            label: 'Graduation Year',
                            onChanged: (value) => setState(() => _graduationYear = value),
                            validator: (value) => value!.isEmpty ? 'Please enter your graduation year' : null,
                          ),
                          const SizedBox(height: 16),
                          
                          _buildTextField(
                            label: 'Work Experience (years)',
                            keyboardType: TextInputType.number,
                            onChanged: (value) => setState(() => _workExperience = value),
                          ),
                          const SizedBox(height: 32),
                          
                          // Skills Selection
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: JMPTheme.secondaryColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  Icons.psychology_outlined,
                                  color: JMPTheme.secondaryColor,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'Skills & Expertise',
                                style: JMPTheme.title2.override(
                                  color: JMPTheme.primaryColor,
                                  useGoogleFonts: false,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          
                          // Build skill categories
                          ..._skillCategories.entries.map(
                            (entry) => _buildSkillCategory(entry.key, entry.value),
                          ),
                          
                          // Areas of Interest
                          _buildAreaOfInterest(),
                          
                          const SizedBox(height: 32),
                          
                          // Generate Button
                          SizedBox(
                            width: double.infinity,
                            child: FFButtonWidget(
                              onPressed: () async {
                                if (_isLoading) return;
                                if (_formKey.currentState!.validate()) {
                                  await _generateReport();
                                }
                              },
                              text: _isLoading ? 'Generating Report...' : 'Generate Career Report',
                              options: FFButtonOptions(
                                width: double.infinity,
                                height: 56,
                                color: _isLoading ? Colors.grey[400] : JMPTheme.primaryColor,
                                textStyle: JMPTheme.subtitle1.override(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  useGoogleFonts: false,
                                ),
                                borderRadius: 28,
                                elevation: 4,
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
                  const SizedBox(height: 24),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: JMPTheme.secondaryColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  Icons.analytics_outlined,
                                  color: JMPTheme.secondaryColor,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'Generated Report',
                                  style: JMPTheme.title2.override(
                                    color: JMPTheme.primaryColor,
                                    useGoogleFonts: false,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.download_outlined,
                                  color: JMPTheme.primaryColor,
                                ),
                                onPressed: () {
                                  showSnackbar(context, 'Download feature coming soon!');
                                },
                              ),
                            ],
                          ),
                          const Divider(height: 32),
                          
                          // Display the generated report
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
                              _generatedReport,
                              style: JMPTheme.bodyText1.override(
                                color: Colors.grey[800],
                                lineHeight: 1.6,
                                useGoogleFonts: false,
                              ),
                            ),
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

  Widget _buildTextField({
    required String label,
    TextInputType? keyboardType,
    required Function(String) onChanged,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        labelStyle: JMPTheme.bodyText1.override(
          color: Colors.grey[600],
          useGoogleFonts: false,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: JMPTheme.primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.red[300]!),
        ),
        filled: true,
        fillColor: Colors.grey[50],
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      keyboardType: keyboardType,
      onChanged: onChanged,
      validator: validator,
      style: JMPTheme.bodyText1.override(
        color: Colors.grey[800],
        useGoogleFonts: false,
      ),
    );
  }
}
