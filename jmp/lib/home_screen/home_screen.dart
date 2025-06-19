import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/skill_visualization.dart';
import '../common/jmp_theme.dart';
import '../common/jmp_widgets.dart';
import '../common/jmp_util.dart';

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

  Widget _buildVisualizationSection(String title, String imagePath, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with icon and title
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
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: JMPTheme.title2.override(
                      color: Colors.white,
                      useGoogleFonts: false,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Image content
          Padding(
            padding: const EdgeInsets.all(20),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 200,
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.image_not_supported_outlined,
                            size: 48,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Image not available',
                            style: JMPTheme.bodyText1.override(
                              color: Colors.grey[600],
                              useGoogleFonts: false,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStatsCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
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
                Text(
                  'Quick Stats',
                  style: JMPTheme.title2.override(
                    color: JMPTheme.primaryColor,
                    useGoogleFonts: false,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    'Total Skills',
                    '80+',
                    Icons.psychology_outlined,
                    JMPTheme.primaryColor,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildStatItem(
                    'Job Categories',
                    '15+',
                    Icons.work_outline,
                    JMPTheme.secondaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    'Data Points',
                    '300+',
                    Icons.data_usage,
                    JMPTheme.primaryColor,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildStatItem(
                    'Reports can be Generated',
                    'Unlimited',
                    Icons.description_outlined,
                    JMPTheme.secondaryColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.2),
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: 32,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: JMPTheme.title3.override(
              color: color,
              fontWeight: FontWeight.bold,
              useGoogleFonts: false,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: JMPTheme.bodyText2.override(
              color: Colors.grey[600],
              useGoogleFonts: false,
            ),
            textAlign: TextAlign.center,
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
          'JMP',
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
          child: _isLoading
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Loading dashboard...',
                        style: JMPTheme.subtitle1.override(
                          color: Colors.white,
                          useGoogleFonts: false,
                        ),
                      ),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      
                      // Welcome section
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.2),
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.dashboard_outlined,
                                color: Colors.white,
                                size: 28,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Welcome to JMP',
                                    style: JMPTheme.title2.override(
                                      color: Colors.white,
                                      useGoogleFonts: false,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Your career insights and analytics dashboard',
                                    style: JMPTheme.bodyText1.override(
                                      color: Colors.white.withOpacity(0.8),
                                      useGoogleFonts: false,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Quick Stats
                      _buildQuickStatsCard(),
                      
                      // Visualization sections
                      _buildVisualizationSection(
                        'Skill Trends Analysis',
                        'assets/charts/visualizations/skill_trends.png',
                        Icons.trending_up,
                      ),
                      
                      _buildVisualizationSection(
                        'Top Programming Skills',
                        'assets/charts/visualizations/top_10_programming_skills.png',
                        Icons.code,
                      ),
                      
                      _buildVisualizationSection(
                        'Skills in Demand',
                        'assets/charts/visualizations/programming_skills_required.png',
                        Icons.work,
                      ),
                      
                      _buildVisualizationSection(
                        'Skill Categories',
                        'assets/charts/visualizations/skill_categories.png',
                        Icons.category,
                      ),
                      
                      _buildVisualizationSection(
                        'Skill Combinations',
                        'assets/charts/visualizations/skill_combinations.png',
                        Icons.account_tree,
                      ),
                      
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
