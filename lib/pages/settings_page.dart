import 'package:flutter/material.dart';
import 'package:hellodekal/components/profile_menu_item.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

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
        title: const Text(
          'Settings',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          ProfileMenuItem(
            icon: Icons.notifications,
            title: 'Notifications',
            onTap: () {
              // TODO: Implement notifications settings
            },
          ),
          ProfileMenuItem(
            icon: Icons.security,
            title: 'Privacy & Security',
            onTap: () {
              // TODO: Implement privacy settings
            },
          ),
          ProfileMenuItem(
            icon: Icons.language,
            title: 'Language',
            onTap: () {
              // TODO: Implement language settings
            },
          ),
          ProfileMenuItem(
            icon: Icons.info,
            title: 'About',
            onTap: () {
              // TODO: Implement about page
            },
          ),
        ],
      ),
    );
  }
}