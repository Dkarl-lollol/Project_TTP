import 'package:flutter/material.dart';
import 'package:hellodekal/components/my_button.dart';
import 'package:hellodekal/components/my_textfield.dart';
import 'package:hellodekal/services/auth/auth_service.dart';

class LoginPage extends StatefulWidget{
  final void Function()? onTap;

  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //text editing controllers
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  //login method
  void login() async {
    // get instance of auth service
    final _authService = AuthService();

// tr sign in
 try{
  await _authService.signInWithEmailPassword(emailController.text, passwordController.text,);

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
    

  // forgot password
  
  void forgotPw() {
    showDialog(
      context: context, 
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: const Text("User enter the wrong password."),
      ),
    );
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
    backgroundColor: Theme.of(context).colorScheme.surface,
    body: Center(
      child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        //logo
        /*
       Icon(
         Icons.lock_open_rounded,
          size: 100,
          color: Theme.of(context).colorScheme.inversePrimary,
          ),
          */

          Image.asset(
        'lib/images/utklogo/logocafe.jpg',
        width: 100,
        height: 100,
        fit: BoxFit.contain,
      ),

        const SizedBox(height: 25),
        //message, app slogan
        Text(
          "Uni Cafes Food Delivering System",
          style: TextStyle(
            fontSize: 16,
            color: Theme.of(context).colorScheme.inversePrimary
          ),
        ),

        const SizedBox(height: 25),
      
        //email textfield
        MyTextField(
          controller: emailController, 
          hintText: "Email", 
          obscureText: false,
          ),

        const SizedBox(height: 10),

        //password textfield
          MyTextField(
          controller: passwordController, 
          hintText: "Password", 
          obscureText: true,
          ),

        const SizedBox(height: 25),


        //sign in button
        MyButton(
          text: "Log In",
         onTap: login,
        ),

        const SizedBox(height: 25),

        //not a member? register now
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Not a member?", 
              style: TextStyle(
              color:Theme.of(context).colorScheme.inversePrimary),
            ),
              const SizedBox(width: 4),
              GestureDetector(
                onTap: widget.onTap,
                child: Text(
                  "Register now",
                  style: TextStyle(
                  color:Theme.of(context).colorScheme.inversePrimary,
                  fontWeight: FontWeight.bold,
                  ),
                            ),
              ),
          ],
        )
      ],
     ),)
    );
  }
}