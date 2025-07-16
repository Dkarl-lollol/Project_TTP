import 'package:flutter/material.dart';

class PhoneAuthenticationService extends ChangeNotifier {
  String? _phoneNumber;
  bool _isLoading = false;

  bool get isLoading => _isLoading;
  String? get phoneNumber => _phoneNumber;

  // Set phone number (without Firebase verification)
  void setPhoneNumber(String phone) {
    _isLoading = true;
    notifyListeners();

    // Simulate processing delay if needed
    Future.delayed(Duration(milliseconds: 500), () {
      _phoneNumber = phone;
      _isLoading = false;
      notifyListeners();
    });
  }

  // Simulate submit or continue to next screen
  Future<void> submitPhoneNumber() async {
    if (_phoneNumber == null || _phoneNumber!.isEmpty) {
      throw Exception('Phone number is empty');
    }

    _isLoading = true;
    notifyListeners();

    try {
      // You can write this to Firestore/Realtime DB if needed
      // Example (Firestore):
      // await FirebaseFirestore.instance.collection('users').add({
      //   'phone': _phoneNumber,
      //   'timestamp': Timestamp.now(),
      // });

      await Future.delayed(Duration(milliseconds: 500)); // Simulate processing
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      throw e;
    }
  }
}
