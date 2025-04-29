import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';

class JMPDashboard extends StatelessWidget {
  const JMPDashboard({super.key});

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
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Text(
                    'Your Dashboard',
                    style: GoogleFonts.ubuntu(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Personalized Recommendations Section
                  Container(
                    padding: const EdgeInsets.all(16),
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
                          'Personalized Recommendations',
                          style: GoogleFonts.ubuntu(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildRecommendationCard(
                          'Digital Skills Course',
                          'Based on current market trends',
                          Icons.computer,
                        ),
                        const SizedBox(height: 12),
                        _buildRecommendationCard(
                          'Technical Job Opportunity',
                          'Matches your experience',
                          Icons.build,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Market Trends Section
                  Container(
                    padding: const EdgeInsets.all(16),
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
                          'Market Trends',
                          style: GoogleFonts.ubuntu(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 200,
                          child: LineChart(
                            _createLineChartData(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Quick Statistics Section
                  Container(
                    padding: const EdgeInsets.all(16),
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
                          'Quick Statistics',
                          style: GoogleFonts.ubuntu(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildStatisticCard(
                          'Most In-Demand Skills',
                          'Information Technology',
                          Icons.trending_up,
                          Colors.green,
                        ),
                        const SizedBox(height: 12),
                        _buildStatisticCard(
                          'Average Monthly Salary For Your Qualification',
                          'RM 3,500',
                          Icons.attach_money,
                          Colors.blue,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRecommendationCard(String title, String subtitle, IconData icon) {
    return Card(
      elevation: 0,
      color: const Color(0xFF4A90E2).withOpacity(0.1),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF4A90E2)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      ),
    );
  }

  Widget _buildStatisticCard(
      String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  LineChartData _createLineChartData() {
    return LineChartData(
      gridData: FlGridData(show: false),
      titlesData: FlTitlesData(
        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      ),
      borderData: FlBorderData(show: false),
      lineBarsData: [
        LineChartBarData(
          spots: [
            const FlSpot(0, 3),
            const FlSpot(2.6, 2),
            const FlSpot(4.9, 5),
            const FlSpot(6.8, 3.1),
            const FlSpot(8, 4),
            const FlSpot(9.5, 3),
            const FlSpot(11, 4),
          ],
          isCurved: true,
          color: const Color(0xFF4A90E2),
          barWidth: 3,
          dotData: FlDotData(show: false),
          belowBarData: BarAreaData(
            show: true,
            color: const Color(0xFF4A90E2).withOpacity(0.1),
          ),
        ),
      ],
    );
  }
}
