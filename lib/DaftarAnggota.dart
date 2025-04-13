import 'package:flutter/material.dart';
import 'main.dart'; // Add this import

class TeamMember {
  final String name;
  final String nim;
  final String imageUrl;
  final String role;

  TeamMember({
    required this.name,
    required this.nim,
    required this.imageUrl,
    required this.role,
  });
}

class DaftarAnggotaPage extends StatelessWidget {
  const DaftarAnggotaPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<TeamMember> teamMembers = [
      TeamMember(
        name: 'Febrian Chrisna Ardianto',
        nim: '123220051',
        imageUrl: 'assets/febrian.jpg',
        role: 'Anggota',
      ),
      TeamMember(
        name: 'Nurma Intan Harianja',
        nim: '123220046',
        imageUrl: 'assets/intan.jpg',
        role: 'Anggota',
      ),
      TeamMember(
        name: 'Arditho Damas K.',
        nim: '123220048',
        imageUrl: 'assets/dito.jpg',
        role: 'Anggota',
      ),
      TeamMember(
        name: 'Vinsensius Johan',
        nim: '123220113',
        imageUrl: 'assets/Johan.png',
        role: 'Anggota',
      ),
    ];

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppTheme.primaryColor,
            Color(0xFF102E40), // Slightly lighter deep blue-teal
            AppTheme.scaffoldBackgroundColor,
          ],
          stops: [0.0, 0.5, 1.0], // Smooth transition points
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Our Team',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Meet the amazing team behind this app',
              style: TextStyle(fontSize: 14, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: teamMembers.length,
                itemBuilder: (context, index) {
                  final member = teamMembers[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    elevation: 5,
                    color: AppTheme.cardColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundImage: AssetImage(member.imageUrl),
                            backgroundColor: Colors.grey[800],
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  member.name,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'NIM: ${member.nim}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[400],
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.deepPurple[400]!.withOpacity(
                                      0.2,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    member.role,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.deepPurple[300],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 3,
              color: AppTheme.cardColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    const Text(
                      'About Team',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'This team was formed to complete the TPM course assignment. We worked together to design and develop this mobile application with Flutter.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
