// lib/screens/vendor/vendor_profile_page.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class VendorProfilePage extends StatefulWidget {
  final String vendorId;

  VendorProfilePage({required this.vendorId});

  @override
  _VendorProfilePageState createState() => _VendorProfilePageState();
}

class _VendorProfilePageState extends State<VendorProfilePage> {
  // Hardcoded vendor data (no Firebase)
  Map<String, dynamic> vendorData = {
    'name': 'V6 Cafe',
    'description': 'University Cafe Vendor',
    'operating_hours': '8:00 AM - 10:00 PM',
    'menu_items_count': 1,
    'orders_today': 1,
  };

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          _buildProfileHeader(),
          SizedBox(height: 24),
          _buildStatsCards(),
          SizedBox(height: 24),
          _buildProfileOptions(),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Color(0xFF002D72), // Updated to your color scheme
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF002D72).withOpacity(0.3),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.white,
            child: Icon(
              Icons.store,
              size: 50,
              color: Color(0xFF002D72),
            ),
          ),
          SizedBox(height: 16),
          Text(
            vendorData['name'] ?? 'Your Cafe',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 4),
          Text(
            vendorData['description'] ?? 'University Cafe Vendor',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
          if (vendorData['operating_hours'] != null) ...[
            SizedBox(height: 8),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                vendorData['operating_hours'],
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatsCards() {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            'Total Menu Items',
            Icons.restaurant_menu,
            Colors.orange,
            Text(
              '${vendorData['menu_items_count']}',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            'Orders Today',
            Icons.shopping_cart,
            Colors.green,
            Text(
              '${vendorData['orders_today']}',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, IconData icon, Color color, Widget countWidget) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: color,
              size: 24,
            ),
          ),
          SizedBox(height: 12),
          countWidget,
          SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildProfileOptions() {
    return Column(
      children: [
        _buildProfileOption(
          icon: Icons.edit,
          title: 'Edit Profile',
          subtitle: 'Update your cafe information',
          onTap: () => _showEditProfileDialog(),
        ),
        _buildProfileOption(
          icon: Icons.schedule,
          title: 'Operating Hours',
          subtitle: 'Set your opening and closing times',
          onTap: () => _showOperatingHoursDialog(),
        ),
        _buildProfileOption(
          icon: Icons.analytics,
          title: 'Analytics',
          subtitle: 'View sales and performance data',
          onTap: () => _showAnalyticsPage(),
        ),
        _buildProfileOption(
          icon: Icons.help_outline,
          title: 'Help & Support',
          subtitle: 'Get help and contact UniCafe support',
          onTap: () => _showHelpPage(),
        ),
        _buildProfileOption(
          icon: Icons.logout,
          title: 'Logout',
          subtitle: 'Sign out of your account',
          onTap: () => _showLogoutDialog(),
          isDestructive: true,
        ),
      ],
    );
  }

  Widget _buildProfileOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isDestructive 
                ? Colors.red.withOpacity(0.1)
                : Color(0xFF002D72).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: isDestructive ? Colors.red : Color(0xFF002D72),
            size: 20,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isDestructive ? Colors.red : null,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(fontSize: 12),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios, 
          size: 16,
          color: Colors.grey[400],
        ),
        onTap: onTap,
      ),
    );
  }

  void _showEditProfileDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Profile'),
        content: Text('Profile editing feature will be implemented here.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              foregroundColor: Color(0xFF002D72),
            ),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showOperatingHoursDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Operating Hours'),
        content: Text('Operating hours setting will be implemented here.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              foregroundColor: Color(0xFF002D72),
            ),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showAnalyticsPage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Analytics feature coming soon!'),
        backgroundColor: Color(0xFF002D72),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showHelpPage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Help & Support coming soon!'),
        backgroundColor: Color(0xFF002D72),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Logout',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              foregroundColor: Colors.grey[600],
            ),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => _performLogout(),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: Text('Logout'),
          ),
        ],
      ),
    );
  }

  void _performLogout() async {
    try {
      // Close the logout dialog
      Navigator.pop(context);
      
      // Show loading overlay
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => WillPopScope(
          onWillPop: () async => false,
          child: Center(
            child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF002D72)),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Logging out...',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      // Wait a moment for user feedback
      await Future.delayed(Duration(milliseconds: 500));

      // Sign out from Firebase
      await FirebaseAuth.instance.signOut();
      
      // Close loading dialog
      Navigator.pop(context);
      
      // Method 1: Try to navigate to root route
      try {
        Navigator.pushNamedAndRemoveUntil(
          context, 
          '/', 
          (route) => false,
        );
      } catch (e) {
        // Method 2: If named route doesn't work, pop until root
        Navigator.popUntil(context, (route) => route.isFirst);
      }
      
    } catch (e) {
      // Close loading dialog if it's open
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error logging out: ${e.toString()}'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}