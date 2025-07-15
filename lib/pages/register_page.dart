// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:hellodekal/services/auth/auth_service.dart';

import '../components/my_button.dart';
import '../components/my_textfield.dart';

class RegisterPage extends StatefulWidget {
    final void Function()? onTap;

  const RegisterPage({super.key,required this.onTap});

  @override
  State <RegisterPage> createState() =>  _RegisterPageState();
}

class  _RegisterPageState extends State<RegisterPage> {
  //text editing controllers
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
    final TextEditingController confirmPasswordController = TextEditingController();

    // register method
    void register() async {
     // get auth service
     final _authService = AuthService();

     // check if passwords match -> create user
     if (passwordController.text == confirmPasswordController.text){
      // try create user
      try {
        await _authService.signUpWithEmailPassword(emailController.text, passwordController.text,);
      }

      // display any errors
      catch (e) {
        showDialog(
          context: context, 
          builder: (context) => AlertDialog(
            title: Text(e.toString()),
            ),
          );
      }
     }

     // if password don't match -> show error
      else{
        showDialog(
          context: context, 
          builder: (context) => const AlertDialog(
            title: Text("Passwords don't match!"),
            ),
          );
      }
     }
    


  @override
  Widget build(BuildContext context){
    return Scaffold(
  backgroundColor: const Color(0xFF002B6C), // Dark blue background
  body: Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'lib/images/logo/logocafe.jpg',
          width: 100,
          height: 100,
          fit: BoxFit.contain,
        ),
        const SizedBox(height: 25),
        Text(
          "Let's create an account",
          style: const TextStyle(
            fontSize: 16,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 25),
        MyTextField(
          controller: emailController,
          hintText: "Email",
          obscureText: false,
        ),
        const SizedBox(height: 10),
        MyTextField(
          controller: passwordController,
          hintText: "Password",
          obscureText: true,
        ),
        const SizedBox(height: 10),
        MyTextField(
          controller: confirmPasswordController,
          hintText: "Reconfirm Password",
          obscureText: true,
        ),
        const SizedBox(height: 25),
        MyButton(
          text: "Sign Up",
          onTap: register,
        ),
        const SizedBox(height: 25),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Already have an account?",
              style: TextStyle(color: Colors.white),
            ),
            const SizedBox(width: 4),
            GestureDetector(
              onTap: widget.onTap,
              child: const Text(
                "Login now",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  ),
);
  }
}