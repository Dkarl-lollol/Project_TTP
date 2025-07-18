import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hellodekal/models/profile_management.dart';
import 'package:hellodekal/pages/customer_login_page.dart';
import 'package:hellodekal/pages/home_page.dart';
//import 'package:hellodekal/models/user_model.dart';
import 'package:provider/provider.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // User is logged in
          if (snapshot.hasData) {
            // Load user data when authenticated
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Provider.of<UserModel>(context, listen: false).loadUserData();
            });
            return const HomePage();
          }
          // User is NOT logged in
          else {
            return const CustomerLoginPage();
          }
        },
      ),
    );
  }
}