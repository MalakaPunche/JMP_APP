import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/skill_visualization.dart';

class JMPDashboard extends StatefulWidget {
  const JMPDashboard({super.key});

  @override
  State<JMPDashboard> createState() => _JMPDashboardState();
}

class _JMPDashboardState extends State<JMPDashboard> {
  SkillVisualization? _visualizationData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadVisualizationData();
  }

  Future<void> _loadVisualizationData() async {
    try {
      final String jsonString = await rootBundle.loadString('assets/visualization_data.json');
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      setState(() {
        _visualizationData = SkillVisualization.fromJson(jsonData);
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading visualization data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _buildVisualizationSection(String title, String imagePath) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 24),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.ubuntu(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              imagePath,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
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
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Your Dashboard',
                          style: GoogleFonts.ubuntu(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 24),
                        
                        _buildVisualizationSection(
                          'Skill Trends',
                          'assets/charts/visualizations/skill_trends.png',
                        ),
                        
                        _buildVisualizationSection(
                          'Top 10 Programming Skills',
                          'assets/charts/visualizations/top_10_programming_skills.png',
                        ),
                        
                        _buildVisualizationSection(
                          'Programming Skills Required',
                          'assets/charts/visualizations/programming_skills_required.png',
                        ),
                        
                        _buildVisualizationSection(
                          'Skill Categories',
                          'assets/charts/visualizations/skill_categories.png',
                        ),
                        
                        _buildVisualizationSection(
                          'Skill Combinations',
                          'assets/charts/visualizations/skill_combinations.png',
                        ),
                        
                        _buildVisualizationSection(
                          'Skills by Category',
                          'assets/charts/visualizations/skills_by_category.png',
                        ),
                        
                        _buildVisualizationSection(
                          'Top Skills',
                          'assets/charts/visualizations/top_skills.png',
                        ),
                        
                        _buildVisualizationSection(
                          'Job Types',
                          'assets/charts/visualizations/job_types.png',
                        ),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
