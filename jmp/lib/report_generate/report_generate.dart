import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ReportGenerate extends StatefulWidget {
  const ReportGenerate({super.key});

  @override
  State<ReportGenerate> createState() => _ReportGenerateState();
}

class _ReportGenerateState extends State<ReportGenerate> {
  final _formKey = GlobalKey<FormState>();
  
  // Form fields
  String _degree = '';
  String _major = '';
  String _university = '';
  String _graduationYear = '';
  String _workExperience = '';
  String _skills = '';
  
  // Preview toggle
  bool _showPreview = false;

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
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  setState(() => _showPreview = true);
                                }
                              },
                              child: const Text(
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
                                'Career Report Preview',
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
                          
                          // Sample AI-Generated Report
                          Text(
                            'Career Analysis Report',
                            style: GoogleFonts.ubuntu(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Based on your $_degree in $_major from $_university, here\'s your personalized career analysis:',
                            style: const TextStyle(fontSize: 14),
                          ),
                          const SizedBox(height: 20),
                          
                          // Market Fit Section
                          _buildReportSection(
                            'Market Fit',
                            'Your degree and skills align well with current market demands. '
                            'There is a growing need for $_major professionals in the technology sector.',
                          ),
                          
                          // Career Opportunities
                          _buildReportSection(
                            'Career Opportunities',
                            '• Senior Developer Roles\n'
                            '• Technical Project Manager\n'
                            '• Solutions Architect\n'
                            '• Technical Consultant',
                          ),
                          
                          // Skill Gap Analysis
                          _buildReportSection(
                            'Skill Gap Analysis',
                            'Consider developing these additional skills:\n'
                            '• Cloud Computing\n'
                            '• Machine Learning\n'
                            '• Agile Project Management',
                          ),
                          
                          // Salary Insights
                          _buildReportSection(
                            'Salary Insights',
                            'Based on your experience and skills:\n'
                            '• Entry Level: RM 3,500 - RM 5,000\n'
                            '• Mid Level: RM 5,000 - RM 8,000\n'
                            '• Senior Level: RM 8,000+',
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

  Widget _buildReportSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.ubuntu(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF4A90E2),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: const TextStyle(fontSize: 14),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
