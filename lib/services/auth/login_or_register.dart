import 'package:flutter/material.dart';
import 'package:hellodekal/pages/customer_login_page.dart'; // Updated import
import 'package:hellodekal/pages/register_page.dart';

class LoginOrRegister extends StatefulWidget {
  const LoginOrRegister({super.key});

  @override
  State<LoginOrRegister> createState() => _LoginOrRegisterState();
}

class _LoginOrRegisterState extends State<LoginOrRegister> {
  bool showLoginPage = true;

  void togglePages() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return CustomerLoginPage(); // Updated: No onTap parameter needed
    } else {
      return RegisterPage(onTap: togglePages);
    }
  }
}