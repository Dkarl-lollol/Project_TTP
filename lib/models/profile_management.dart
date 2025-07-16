import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserModel extends ChangeNotifier {
  String? _name;
  String? _email;
  String? _phone;
  String? _profileImage;
  String? _address;

  // Getters
  String? get name => _name;
  String? get email => _email;
  String? get phone => _phone;
  String? get profileImage => _profileImage;
  String? get address => _address;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Load user data from Firestore
  Future<void> loadUserData() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        DocumentSnapshot doc = await _firestore.collection('users').doc(user.uid).get();
        if (doc.exists) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          _name = data['name'] ?? '';
          _email = data['email'] ?? user.email;
          _phone = data['phone'] ?? user.phoneNumber;
          _profileImage = data['profileImage'] ?? '';
          _address = data['address'] ?? '';
          notifyListeners();
        }
      }
    } catch (e) {
      print('Error loading user data: $e');
    }
  }

  // Update user data
  Future<void> updateUserData({
    String? name,
    String? email,
    String? phone,
    String? address,
    String? profileImage,
  }) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        Map<String, dynamic> updates = {};
        
        if (name != null) {
          _name = name;
          updates['name'] = name;
        }
        if (email != null) {
          _email = email;
          updates['email'] = email;
        }
        if (phone != null) {
          _phone = phone;
          updates['phone'] = phone;
        }
        if (address != null) {
          _address = address;
          updates['address'] = address;
        }
        if (profileImage != null) {
          _profileImage = profileImage;
          updates['profileImage'] = profileImage;
        }

        await _firestore.collection('users').doc(user.uid).set(updates, SetOptions(merge: true));
        notifyListeners();
      }
    } catch (e) {
      print('Error updating user data: $e');
      throw e;
    }
  }

  // Clear user data on logout
  void clearUserData() {
    _name = null;
    _email = null;
    _phone = null;
    _profileImage = null;
    _address = null;
    notifyListeners();
  }
}