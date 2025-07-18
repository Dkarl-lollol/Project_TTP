import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hellodekal/models/profile_management.dart';
import 'package:hellodekal/pages/cart_page.dart';
import 'package:hellodekal/pages/customer_login_page.dart';
import 'package:hellodekal/pages/debit_payment.dart';
import 'package:hellodekal/pages/delivery_progress_page.dart';
import 'package:hellodekal/pages/home_page.dart';
import 'package:hellodekal/pages/initial_page.dart';
import 'package:hellodekal/pages/order_page.dart';
import 'package:hellodekal/pages/order_preparation_page.dart';
import 'package:hellodekal/pages/profile_page.dart';
import 'package:hellodekal/pages/search_page.dart';
import 'package:hellodekal/services/auth/auth_gate.dart';
import 'package:hellodekal/firebase_options.dart';
import 'package:hellodekal/models/restaurant.dart';
import 'package:hellodekal/services/auth/phone_authentication_service.dart';
import 'package:hellodekal/themes/theme_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    if (e is FirebaseException && e.code == 'duplicate-app') {
      print('Firebase already initialized');
    } else {
      rethrow;
    }
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => Restaurant()),
        ChangeNotifierProvider(create: (context) => UserModel()),
        ChangeNotifierProvider(create: (context) => PhoneAuthenticationService()), // ✅ ADDED
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'UniCafe',
      home: const InitialPage(),
      theme: Provider.of<ThemeProvider>(context).themeData.copyWith(
        primaryColor: const Color(0xFF002D72),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF002D72),
          primary: const Color(0xFF002D72),
          secondary: const Color(0xFF4A90E2),
          surface: Colors.white,
          background: const Color(0xFFF8F9FA),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF002D72),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
      ),
      routes: {
        '/home': (context) => const HomePage(),
        '/search': (context) => const SearchPage(),
        '/profile': (context) => const ProfilePage(),
        '/orders': (context) => const CartPage(),
        '/order_preparation': (context) => const OrderPreparationPage(),
        '/debit_payment': (context) => const DebitPaymentPage(),
        '/phone-auth': (context) => const CustomerLoginPage(),
        '/delivery_progress': (context) => const DeliveryProgressPage(),
      },
    );
  }
}
