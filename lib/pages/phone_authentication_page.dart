import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:hellodekal/services/auth/phone_authentication_service.dart';
import 'package:provider/provider.dart';
import 'package:hellodekal/pages/login_page.dart';

class PhoneAuthPage extends StatefulWidget {
  const PhoneAuthPage({super.key});

  @override
  State<PhoneAuthPage> createState() => _PhoneAuthPageState();
}

class _PhoneAuthPageState extends State<PhoneAuthPage> {
  final TextEditingController phoneController = TextEditingController();
  String countryCode = '+60'; 
  bool isLoading = false;

    void navigateToVendorLogin() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LoginPage(
          onTap: () {
            Navigator.pop(context); // Go back if needed
          },
        ),
      ),
    );
  }

void handlePhoneSubmit() async {
  if (phoneController.text.isEmpty) {
    if (mounted) {  // Add mounted check
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your phone number')),
      );
    }
    return;
  }

  setState(() => isLoading = true);

  try {
    final phoneAuthService = Provider.of<PhoneAuthenticationService>(context, listen: false);
    
    String rawPhone = phoneController.text.trim();

    if (rawPhone.startsWith('0')) {
      rawPhone = rawPhone.substring(1); // remove the '0'
    }

    // Add validation check
    if (!RegExp(r'^[1-9]\d{6,10}$').hasMatch(rawPhone)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter a valid phone number')),
        );
      }
      return;
    }

    final fullPhone = '$countryCode$rawPhone'; // Now safe
    phoneAuthService.setPhoneNumber(fullPhone);
    await phoneAuthService.submitPhoneNumber();


    // FIXED: Proper mounted check before using context
    if (mounted) {
      Navigator.pushNamed(context, '/home');
    }
  } catch (e) {
    // FIXED: Proper mounted check before using context
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  } finally {
    // FIXED: Proper mounted check before setState
    if (mounted) {
      setState(() => isLoading = false);
    }
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('lib/images/bg/foodbg.jpeg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          // Overlay gradient and logo
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * 0.6,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    const Color(0xFF002D72).withAlpha(77),
                    const Color(0xFF002D72).withAlpha(204),
                  ],
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // UniCafe logo with rounded border
                    Container(
                      width: 140,
                      height: 140,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25), // Rounded border
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(25),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(25), // Match container border radius
                        child: Padding(
                          padding: const EdgeInsets.all(12), // Add padding inside the container
                          child: Image.asset(
                            'lib/images/logo/logocafe.jpg',
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: const Center(
                                  child: Text(
                                    'Image\nNot Found',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Bottom content
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.5,
              decoration: const BoxDecoration(
                color: Color(0xFF002D72),
              ),
              child: Padding(
                padding: const EdgeInsets.all(30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text(
                      'Your cravings delivered\nto you',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      '\nEnter your phone number to get started',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Phone input
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(25),
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(color: Colors.white30),
                      ),
                      child: Row(
                        children: [
                          CountryCodePicker(
                            onChanged: (code) => countryCode = code.dialCode!,
                            initialSelection: 'MY',
                            favorite: const ['+60', 'MY'],
                            textStyle: const TextStyle(color: Colors.white),
                            dialogTextStyle: const TextStyle(color: Colors.black),
                            searchStyle: const TextStyle(color: Colors.black),
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                          ),
                          Expanded(
                            child: TextField(
                              controller: phoneController,
                              keyboardType: TextInputType.phone,
                              style: const TextStyle(color: Colors.white),
                              decoration: const InputDecoration(
                                hintText: '12 345-6789',
                                hintStyle: TextStyle(color: Colors.white54),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                    // Continue button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : handlePhoneSubmit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFF002D72),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          elevation: 0,
                        ),
                        child: isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Color(0xFF002D72),
                                  ),
                                ),
                              )
                            : const Text(
                                'Continue',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),

                    const SizedBox(height: 20),

                  // Simple vendor login link
Center(
  child: Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      const Icon(
        Icons.business,
        color: Colors.white70,
        size: 16,
      ),
      const SizedBox(width: 8),
      Text.rich(
        TextSpan(
          children: [
            const TextSpan(
              text: 'Are you a vendor? ',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            TextSpan(
              text: 'Login here',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
                decoration: TextDecoration.underline,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  // Handle only "Login" tap
                   navigateToVendorLogin();
                },
            ),
          ],
        ),
      ),
    ],
  ),
),
                  ],
                ),
              ),
            ),
          ),
          
          ],
        ),
      );
    }
  }