import 'package:flutter/material.dart';
import '../widgets/feature_card.dart';
import 'medication_screen.dart';
import 'ai_assistant_screen.dart';
import 'fall_detection_screen.dart';
import 'emergency_contacts_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatelessWidget {
  // Define our dark theme colors
  final Color primaryDark = const Color(0xFF1A1A2E);
  final Color surfaceDark = const Color(0xFF242438);
  final Color accentDark = const Color(0xFF4B7BF5);

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryDark,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: primaryDark,
        title: const Text(
          'Elder Care',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.5,
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: surfaceDark,
              borderRadius: BorderRadius.circular(14),
            ),
            child: IconButton(
              icon: const Icon(Icons.settings_outlined, color: Colors.white70),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => SettingsScreen()),
              ),
            ),
          ),
        ],
      ),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: accentDark.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: accentDark.withOpacity(0.2)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: accentDark.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.notifications_none_rounded,
                            color: accentDark,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Good evening, Sarah',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Next medication in 2 hours',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    'Quick Actions',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.85,
              ),
              delegate: SliverChildListDelegate([
                _buildFeatureCard(
                  title: 'Medication',
                  subtitle: 'Track & Remind',
                  icon: Icons.medication_rounded,
                  gradient: [const Color(0xFF4A90E2), const Color(0xFF357ABD)],
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => MedicationScreen()),
                  ),
                ),
                _buildFeatureCard(
                  title: 'AI Assistant',
                  subtitle: 'Get Help 24/7',
                  icon: Icons.smart_toy_rounded,
                  gradient: [const Color(0xFF50C878), const Color(0xFF3AA064)],
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AIAssistantScreen()),
                  ),
                ),
                _buildFeatureCard(
                  title: 'Fall Detection',
                  subtitle: 'Stay Protected',
                  icon: Icons.health_and_safety_rounded,
                  gradient: [const Color(0xFFFFB75E), const Color(0xFFED8F03)],
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => FallDetectionScreen()),
                  ),
                ),
                _buildFeatureCard(
                  title: 'Emergency',
                  subtitle: 'Quick Access',
                  icon: Icons.emergency_rounded,
                  gradient: [const Color(0xFFFF6B6B), const Color(0xFFEE5253)],
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const EmergencyContactsScreen()),
                  ),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required List<Color> gradient,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [surfaceDark, surfaceDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: gradient),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
                const Spacer(),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
