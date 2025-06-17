import 'package:flutter/material.dart';
import '../home_screen/home_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth
import 'dart:ui';
import '../splash/splash.dart';
import '../report_generate/report_generate.dart';
import '../historical_reports/historical_reports.dart';


class HomePage extends StatefulWidget {
  final int? initialIndex;
  const HomePage({super.key, this.initialIndex});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex ?? 0;
  }

  final List<Widget> _screens = [
    const JMPDashboard(),
    const ReportGenerate(),
    HistoricalReports(),
  ];

  final List<String> _titles = [
    'Dashboard',
    'Career Report Generator',
    'Historical Reports',
  ];

  final List<Map<String, dynamic>> _drawerItems = [
    {'icon': Icons.dashboard, 'title': 'Dashboard', 'index': 0},
    {'icon': Icons.assessment, 'title': 'Career Report', 'index': 1},
    {'icon': Icons.history, 'title': 'Historical Reports', 'index': 2},
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const SplashWidget(),
          ),
        );
      }
    } catch (e) {
      String errorMessage;
      if (e is FirebaseAuthException) {
        errorMessage = 'Firebase Error: ${e.message}';
      } else {
        errorMessage = 'Logout failed: $e';
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _titles[_selectedIndex],
          style: GoogleFonts.ubuntu(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF4A90E2),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Color(0xFF4A90E2),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.person,
                      size: 40,
                      color: Color(0xFF4A90E2),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Welcome',
                    style: GoogleFonts.ubuntu(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
            ..._drawerItems.map((item) => ListTile(
                  leading: Icon(item['icon']),
                  title: Text(item['title']),
                  selected: _selectedIndex == item['index'],
                  onTap: () => _onItemTapped(item['index']),
                )),
          ],
        ),
      ),
      body: _screens[_selectedIndex],
    );
  }
}
