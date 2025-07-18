import 'package:flutter/material.dart';
import 'package:hellodekal/models/restaurant.dart';
import 'package:provider/provider.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String selectedPaymentMethod = '';
  
  final List<Map<String, dynamic>> paymentMethods = [
    {
      'id': 'qr_code',
      'title': 'QR Code',
      'subtitle': 'Scan QR code to pay via banking app',
      'icon': Icons.qr_code,
      'color': Colors.indigo,
    },
    {
      'id': 'online_banking',
      'title': 'Online Banking',
      'subtitle': 'Pay securely through your bank',
      'icon': Icons.account_balance,
      'color': Colors.blue,
    },
    {
      'id': 'ewallet',
      'title': 'E-Wallet',
      'subtitle': 'Touch \'n Go, GrabPay, Boost, ShopeePay',
      'icon': Icons.phone_android,
      'color': Colors.purple,
    },
    {
      'id': 'card_debit',
      'title': 'Debit Card',
      'subtitle': 'Visa, Mastercard, and more',
      'icon': Icons.credit_card,
      'color': Colors.orange,
    },
  ];

  void _processPayment() {
    if (selectedPaymentMethod.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a payment method'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    switch (selectedPaymentMethod) {
      case 'qr_code':
        _showQRCodeDialog();
        break;
      case 'online_banking':
        _showComingSoonDialog('Online Banking');
        break;
      case 'ewallet':
        _showComingSoonDialog('E-Wallet');
        break;
      case 'card_debit':
        _processDebitCardPayment();
        break;
    }
  }

  void _showQRCodeDialog() {
    final orderTotal = Provider.of<Restaurant>(context, listen: false).getTotalPrice();
    const deliveryFee = 2.50;
    const feesAndTaxes = 1.50;
    const discount = 2.00;
    final subtotal = orderTotal + deliveryFee + feesAndTaxes - discount;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text(
          'Scan QR Code to Pay',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF002D72),
          ),
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // QR Code placeholder - you can replace this with actual QR code widget
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.qr_code,
                    size: 100,
                    color: Color(0xFF002D72),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'QR Code',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Amount: RM${subtotal.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF002D72),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Scan this QR code with your banking app to complete payment',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close QR dialog
            },
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.grey),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Close QR dialog
              _simulateQRPayment();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF002D72),
              foregroundColor: Colors.white,
            ),
            child: const Text('Payment Completed'),
          ),
        ],
      ),
    );
  }

  void _simulateQRPayment() {
    // Show processing dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(
              color: Color(0xFF002D72),
            ),
            SizedBox(height: 16),
            Text(
              'Verifying payment...',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );

    // Simulate payment verification
    Future.delayed(const Duration(seconds: 2), () {
      // Check if widget is still mounted before navigation
      if (mounted) {
        Navigator.pop(context); // Close processing dialog
        // Add small delay to ensure dialog is properly closed
        Future.delayed(const Duration(milliseconds: 100), () {
          if (mounted) {
            _navigateToOrderPreparation();
          }
        });
      }
    });
  }

  void _showComingSoonDialog(String paymentType) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        icon: const Icon(
          Icons.info_outline,
          color: Color(0xFF002D72),
          size: 48,
        ),
        title: Text(
          '$paymentType Coming Soon!',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF002D72),
          ),
          textAlign: TextAlign.center,
        ),
        content: Text(
          'We\'re working hard to bring $paymentType integration to our app. Stay tuned for updates!',
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'OK',
              style: TextStyle(
                color: Color(0xFF002D72),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _processDebitCardPayment() {
    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(
              color: Color(0xFF002D72),
            ),
            SizedBox(height: 16),
            Text(
              'Preparing secure payment...',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );

    // Simulate preparation then navigate to debit payment page
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pop(context); // Close loading dialog
      _navigateToDebitPayment();
    });
  }

  void _navigateToOrderPreparation() {
    try {
      // Navigate to order preparation page - using same method as debit payment
      Navigator.pushNamed(context, '/order_preparation');
    } catch (e) {
      // If named route fails, show error and go back to home
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Navigation error: $e'),
          backgroundColor: Colors.red,
        ),
      );
      // Navigate back to home as fallback
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
  }

  void _navigateToDebitPayment() {
    // Navigate to debit payment page
    // Using named route - make sure this route is defined in your main.dart
    Navigator.pushNamed(context, '/debit_payment');
  }

  String _getProcessingMessage() {
    switch (selectedPaymentMethod) {
      case 'qr_code':
        return 'Verifying QR payment...';
      case 'online_banking':
        return 'Redirecting to your bank...';
      case 'ewallet':
        return 'Opening e-wallet app...';
      case 'card_debit':
        return 'Processing card payment...';
      default:
        return 'Processing payment...';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Restaurant>(
      builder: (context, restaurant, child) {
        final orderTotal = restaurant.getTotalPrice();
        const deliveryFee = 2.50;
        const feesAndTaxes = 1.50;
        const discount = 2.00;
        final subtotal = orderTotal + deliveryFee + feesAndTaxes - discount;

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
              'Payment',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          body: Column(
            children: [
              // Order Summary Section
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Order Summary',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildSummaryRow('Order Total', 'RM${orderTotal.toStringAsFixed(2)}'),
                    _buildSummaryRow('Delivery Fee', 'RM${deliveryFee.toStringAsFixed(2)}'),
                    _buildSummaryRow('Fees & Taxes', 'RM${feesAndTaxes.toStringAsFixed(2)}'),
                    _buildSummaryRow('Discount', '-RM${discount.toStringAsFixed(2)}', 
                                   color: Colors.orange),
                    const Divider(color: Color(0xFF002D72)),
                    _buildSummaryRow('Total Amount', 'RM${subtotal.toStringAsFixed(2)}', 
                                   bold: true, color: const Color(0xFF002D72)),
                  ],
                ),
              ),

              // Payment Methods Section
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Select Payment Method',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      Expanded(
                        child: ListView.builder(
                          itemCount: paymentMethods.length,
                          itemBuilder: (context, index) {
                            final method = paymentMethods[index];
                            final isSelected = selectedPaymentMethod == method['id'];
                            
                            return Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    selectedPaymentMethod = method['id'];
                                  });
                                },
                                borderRadius: BorderRadius.circular(12),
                                child: Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: isSelected 
                                          ? const Color(0xFF002D72) 
                                          : Colors.grey.shade300,
                                      width: isSelected ? 2 : 1,
                                    ),
                                    color: isSelected 
                                        ? const Color(0xFF002D72).withOpacity(0.05) 
                                        : Colors.white,
                                  ),
                                  child: Row(
                                    children: [
                                      // Payment method icon
                                      Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: method['color'].withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Icon(
                                          method['icon'],
                                          color: method['color'],
                                          size: 24,
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      
                                      // Payment method details
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              method['title'],
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                color: isSelected 
                                                    ? const Color(0xFF002D72) 
                                                    : Colors.black,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              method['subtitle'],
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey.shade600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      
                                      // Selection indicator
                                      Radio<String>(
                                        value: method['id'],
                                        groupValue: selectedPaymentMethod,
                                        onChanged: (value) {
                                          setState(() {
                                            selectedPaymentMethod = value!;
                                          });
                                        },
                                        activeColor: const Color(0xFF002D72),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Pay Now Button
              Container(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _processPayment,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF002D72),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                    ),
                    child: Text(
                      _getButtonText(subtotal),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _getButtonText(double subtotal) {
    switch (selectedPaymentMethod) {
      case 'qr_code':
        return 'Generate QR Code - RM${subtotal.toStringAsFixed(2)}';
      case 'online_banking':
      case 'ewallet':
        return 'Coming Soon - RM${subtotal.toStringAsFixed(2)}';
      case 'card_debit':
        return 'Pay with Card - RM${subtotal.toStringAsFixed(2)}';
      default:
        return 'Pay Now - RM${subtotal.toStringAsFixed(2)}';
    }
  }

  Widget _buildSummaryRow(String label, String amount, {Color? color, bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: color ?? Colors.black87,
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
              fontSize: bold ? 16 : 14,
            ),
          ),
          Text(
            amount,
            style: TextStyle(
              color: color ?? Colors.black87,
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
              fontSize: bold ? 16 : 14,
            ),
          ),
        ],
      ),
    );
  }
}