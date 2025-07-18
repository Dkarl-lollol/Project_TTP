import 'package:flutter/material.dart';
import 'package:hellodekal/components/profile_menu_item.dart';
import 'package:hellodekal/models/profile_management.dart';
import 'package:hellodekal/pages/customer_login_page.dart';
//import 'package:hellodekal/models/user_model.dart';
import 'package:hellodekal/pages/edit_profile_page.dart';
import 'package:hellodekal/pages/settings_page.dart';
import 'package:hellodekal/services/auth/auth_service.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final AuthService _authService = AuthService();

void logout() async {
  await _authService.signOut();
  
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(
      builder: (context) => const CustomerLoginPage(),
    ),
    (route) => false,
  );
}

  void editProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const EditProfilePage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.black),
            onPressed: editProfile,
          ),
        ],
      ),
      body: Consumer<UserModel>(
        builder: (context, userModel, child) {
          return Column(
            children: [
              const SizedBox(height: 20),
              // Profile image and name
              Column(
                children: [
                  // Profile image
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey.shade200,
                    backgroundImage: userModel.profileImage != null
                        ? NetworkImage(userModel.profileImage!)
                        : null,
                    child: userModel.profileImage == null
                        ? const Icon(
                            Icons.person,
                            size: 50,
                            color: Colors.grey,
                          )
                        : null,
                  ),
                  const SizedBox(height: 16),
                  // Name
                  Text(
                    userModel.name ?? 'Jane Doe',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Phone number
                  Text(
                    userModel.phone ?? '+60 12 345-6789',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              // Menu items
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    ProfileMenuItem(
                      icon: Icons.settings,
                      title: 'Settings',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SettingsPage(),
                          ),
                        );
                      },
                    ),
                    ProfileMenuItem(
                      icon: Icons.chat,
                      title: 'Contact us',
                      onTap: () {
                        // TODO: Implement contact us
                      },
                    ),
                    ProfileMenuItem(
                      icon: Icons.help,
                      title: 'Help center',
                      onTap: () {
                        // TODO: Implement help center
                      },
                    ),
                    const SizedBox(height: 30),
                    // Logout button
                    Container(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: logout,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Logout',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}