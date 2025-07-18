import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:hellodekal/components/my_button.dart';
import 'package:hellodekal/pages/delivery_progress_page.dart';

class DebitPaymentPage extends StatefulWidget {
  const DebitPaymentPage({super.key});

  @override
  State<DebitPaymentPage> createState() => _DebitPaymentPageState();
}

class _DebitPaymentPageState extends State<DebitPaymentPage> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;

  // user wants to pay
  void userTappedPay() {
    if (formKey.currentState!.validate()){
      //only show dialog if form is valid
      showDialog(
        context: context, 
        builder: (context) => AlertDialog(
          title: const Text("Confirm payment"),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Text("Card Number: $cardNumber"),
                Text("Expirt Date: $expiryDate"),
                Text("Card Holder name: $cardHolderName"),
                Text("CVV: $cvvCode"),

              ],
            ),
          ),
          actions: [
            // cancel button
             TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
             ),

            // yes button
             TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                context, 
                MaterialPageRoute(
                  builder: (context) => DeliveryProgressPage(),
                ),
              );
              },
              child: const Text("Yes"),
            )
          ],
        ),
      );
    }
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Theme.of(context).colorScheme.surface,
    appBar: AppBar(
      backgroundColor: Colors.transparent,
      foregroundColor: Theme.of(context).colorScheme.inversePrimary,
      title: const Text("Checkout"),
    ),
    body: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Credit card preview
            CreditCardWidget(
              cardNumber: cardNumber,
              expiryDate: expiryDate,
              cardHolderName: cardHolderName,
              cvvCode: cvvCode,
              showBackView: isCvvFocused,
              onCreditCardWidgetChange: (p0) {},
            ),

            const SizedBox(height: 20),

            // Credit card form
            CreditCardForm(
              cardNumber: cardNumber,
              expiryDate: expiryDate,
              cardHolderName: cardHolderName,
              cvvCode: cvvCode,
              onCreditCardModelChange: (data) {
                setState(() {
                  cardNumber = data.cardNumber;
                  expiryDate = data.expiryDate;
                  cardHolderName = data.cardHolderName;
                  cvvCode = data.cvvCode;
                });
              },
              formKey: formKey,
            ),

            const SizedBox(height: 30),

            // Pay button
            MyButton(
              onTap: userTappedPay,
              text: "Pay Now",
            ),

            const SizedBox(height: 25),
          ],
        ),
      ),
    ),
  );
}
}