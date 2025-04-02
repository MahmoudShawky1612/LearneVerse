import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../widgets/contribution_header.dart';
import '../widgets/user_contribution_comments.dart';
import '../widgets/user_contribution_posts.dart';
import '../widgets/user_joined_communities.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // APP BAR WITH PROFILE HEADER
          _buildProfileHeader(),

          // CONTRIBUTION STATS CARD & TAB BUTTONS
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverToBoxAdapter(
              child: Column(
                children: [
                  // Contribution Stats Card
                  Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    color: Colors.grey.shade50,
                    child: const Padding(
                      padding: EdgeInsets.all(16),
                      child: ContributionHeader(),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Tab Buttons
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildTabButton(
                            "Contributions",
                            0,
                            Icons.edit_note,
                          ),
                        ),
                        Expanded(
                          child: _buildTabButton(
                            "Communities",
                            1,
                            Icons.people,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),

          // CONTENT BASED ON SELECTED TAB
          if (selectedIndex == 0)
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverToBoxAdapter(
                child: Column(
                  children: [
                    UserComments(),
                    UserPosts(),
                  ],
                ),
              ),
            )
          else if (selectedIndex == 1)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SizedBox(
                  height: 600,
                  child: VerticalCommunityList(),
                ),
              ),
            ),
          const SliverToBoxAdapter(
            child: SizedBox(height: 40),
          ),
        ],
      ),
    );
  }

  // APP BAR WITH PROFILE HEADER
  SliverAppBar _buildProfileHeader() {
    return SliverAppBar(
      expandedHeight: 380,
      pinned: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      actions: [
        // Edit profile button
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: IconButton(
            icon: const Icon(Icons.edit, color: Colors.white),
            onPressed: () {
              // Navigate to edit profile screen
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Edit Profile')),
              );
            },
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            // Background gradient
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF4158D0),
                    Color(0xFFC850C0),
                    Color(0xFFFFCC70),
                  ],
                ),
              ),
            ),

            // Curved white section at bottom
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 20,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(30),
                  ),
                ),
              ),
            ),

            // Profile Content
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),

                    // Avatar and Name Row
                    _buildProfileAvatarAndName(),

                    const SizedBox(height: 16),

                    // Bio Quote Container
                    _buildBioQuote(),

                    const SizedBox(height: 16),

                    // User Stats Row
                    _buildUserStatsRow(),

                    const SizedBox(height: 20),

                    // Social Links Row
                    _buildSocialLinksRow(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // PROFILE AVATAR AND NAME
  Row _buildProfileAvatarAndName() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Avatar with  indicator
        Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 4),
                borderRadius: BorderRadius.circular(50),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: const CircleAvatar(
                backgroundImage: AssetImage('assets/images/avatar.jpg'),
                radius: 40,
              ),
            ),
            // Online indicator dot
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: Colors.green,
                  border: Border.all(color: Colors.white, width: 3),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(width: 20),
        // Name and other info
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Dodje Shawky",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: -0.5,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 4),
            ],
          ),
        ),
      ],
    );
  }

  // BIO QUOTE CONTAINER
  Container _buildBioQuote() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Row(
        children: [
          Icon(
            Icons.format_quote,
            color: Colors.white70,
            size: 20,
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              "كَلَّا إِنَّ مَعِيَ رَبِّي سَيَهْدِينِ",
              style: TextStyle(
                fontSize: 16,
                fontStyle: FontStyle.italic,
                color: Colors.white,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  SingleChildScrollView _buildUserStatsRow() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          const SizedBox(width: 10),
          _buildUserStat(
              context, "Mar 31, 2025", Icons.calendar_today, "Joined"),
          const SizedBox(width: 10),
          _buildUserStat(context, "42", Icons.people, "Communities"),
          const SizedBox(width: 10),
          _buildUserStat(context, "156", Icons.edit_note, "Contributions"),
          const SizedBox(width: 10),
        ],
      ),
    );
  }

  Padding _buildSocialLinksRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildSocialButton(FontAwesomeIcons.github, Colors.white, () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('GitHub Profile')),
            );
          }),
          const SizedBox(width: 20),
          _buildSocialButton(FontAwesomeIcons.linkedin, Colors.white, () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('LinkedIn Profile')),
            );
          }),
          const SizedBox(width: 20),
          _buildSocialButton(FontAwesomeIcons.facebook, Colors.white, () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Facebook Profile')),
            );
          }),
          const SizedBox(width: 20),
          _buildSocialButton(FontAwesomeIcons.twitter, Colors.white, () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Twitter Profile')),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildTabButton(String title, int index, IconData icon) {
    final isSelected = selectedIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    spreadRadius: 0,
                    offset: const Offset(0, 3),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected ? const Color(0xFF4158D0) : Colors.grey,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? const Color(0xFF4158D0) : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserStat(
      BuildContext context, String value, IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.25),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 14, color: Colors.white),
              const SizedBox(width: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialButton(
      IconData icon, Color color, VoidCallback onPressed) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(30),
        ),
        child: FaIcon(
          icon,
          color: color,
          size: 20,
        ),
      ),
    );
  }
}
