import 'package:flutter/material.dart';

class DeliveryDetailsPage extends StatefulWidget {
  final Map<String, dynamic>? existingDetails;
  
  const DeliveryDetailsPage({super.key, this.existingDetails});

  @override
  State<DeliveryDetailsPage> createState() => _DeliveryDetailsPageState();
}

class _DeliveryDetailsPageState extends State<DeliveryDetailsPage> {
  String selectedDeliveryTime = "Standard";
  String deliveryLocation = "V5A";
  String deliveryInstructions = "Ground Floor";
  String phoneNumber = "(+60) 11 234-4567";
  bool leaveAtDoor = true;
  String promoCode = "";

  @override
  void initState() {
    super.initState();
    // Load existing details if available
    if (widget.existingDetails != null) {
      selectedDeliveryTime = widget.existingDetails!['deliveryTime'] ?? "Standard";
      deliveryLocation = widget.existingDetails!['location'] ?? "V5A";
      deliveryInstructions = widget.existingDetails!['instructions'] ?? "Ground Floor";
      phoneNumber = widget.existingDetails!['phone'] ?? "(+60) 11 234-4567";
      leaveAtDoor = widget.existingDetails!['leaveAtDoor'] ?? true;
      promoCode = widget.existingDetails!['promoCode'] ?? "";
    }
  }

  void _editLocation() {
    showDialog(
      context: context,
      builder: (context) {
        String tempLocation = deliveryLocation;
        String tempInstructions = deliveryInstructions;
        
        return AlertDialog(
          title: const Text("Edit Delivery Location"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: TextEditingController(text: tempLocation),
                decoration: const InputDecoration(
                  labelText: "Location",
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) => tempLocation = value,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: TextEditingController(text: tempInstructions),
                decoration: const InputDecoration(
                  labelText: "Instructions",
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) => tempInstructions = value,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  deliveryLocation = tempLocation.isEmpty ? deliveryLocation : tempLocation;
                  deliveryInstructions = tempInstructions.isEmpty ? deliveryInstructions : tempInstructions;
                });
                Navigator.pop(context);
              },
              child: const Text(
                "Save",
                style: TextStyle(color: Color(0xFF002D72)),
              ),
            ),
          ],
        );
      },
    );
  }

  void _editPhoneNumber() {
    showDialog(
      context: context,
      builder: (context) {
        String tempPhone = phoneNumber;
        
        return AlertDialog(
          title: const Text("Edit Phone Number"),
          content: TextField(
            controller: TextEditingController(text: tempPhone),
            decoration: const InputDecoration(
              labelText: "Phone Number",
              border: OutlineInputBorder(),
              prefixText: "(+60) ",
            ),
            keyboardType: TextInputType.phone,
            onChanged: (value) => tempPhone = "(+60) $value",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  phoneNumber = tempPhone.isEmpty ? phoneNumber : tempPhone;
                });
                Navigator.pop(context);
              },
              child: const Text(
                "Save",
                style: TextStyle(color: Color(0xFF002D72)),
              ),
            ),
          ],
        );
      },
    );
  }

  void _addPromoCode() {
    showDialog(
      context: context,
      builder: (context) {
        String tempPromo = promoCode;
        
        return AlertDialog(
          title: const Text("Add Promo Code"),
          content: TextField(
            controller: TextEditingController(text: tempPromo),
            decoration: const InputDecoration(
              labelText: "Promo Code",
              border: OutlineInputBorder(),
              hintText: "Enter promo code",
            ),
            textCapitalization: TextCapitalization.characters,
            onChanged: (value) => tempPromo = value,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  promoCode = tempPromo.toUpperCase();
                });
                Navigator.pop(context);
                if (promoCode.isNotEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Promo code "$promoCode" added!'),
                      backgroundColor: const Color(0xFF002D72),
                    ),
                  );
                }
              },
              child: const Text(
                "Apply",
                style: TextStyle(color: Color(0xFF002D72)),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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
          "Checkout",
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),

            // Delivery Time Section
            Row(
              children: [
                const Icon(Icons.access_time, color: Colors.grey),
                const SizedBox(width: 12),
                const Text(
                  "Delivery Time",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                Text(
                  selectedDeliveryTime == "Express" ? "10-15 min" : "20-25 min",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Delivery Time Options
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => selectedDeliveryTime = "Express"),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: selectedDeliveryTime == "Express" 
                              ? const Color(0xFF002D72) 
                              : Colors.grey.shade300,
                          width: selectedDeliveryTime == "Express" ? 2 : 1,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Radio<String>(
                                value: "Express",
                                groupValue: selectedDeliveryTime,
                                onChanged: (value) => setState(() => selectedDeliveryTime = value!),
                                activeColor: const Color(0xFF002D72),
                              ),
                              const Text(
                                "Express",
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                          const Text("10-15 min"),
                          const Text(
                            "+RM2.00",
                            style: TextStyle(
                              color: Color(0xFF002D72),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => selectedDeliveryTime = "Standard"),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: selectedDeliveryTime == "Standard" 
                              ? const Color(0xFF002D72) 
                              : Colors.grey.shade300,
                          width: selectedDeliveryTime == "Standard" ? 2 : 1,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Radio<String>(
                                value: "Standard",
                                groupValue: selectedDeliveryTime,
                                onChanged: (value) => setState(() => selectedDeliveryTime = value!),
                                activeColor: const Color(0xFF002D72),
                              ),
                              const Text(
                                "Standard",
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                          const Text("20-25 min"),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Delivery Location - Interactive
            ListTile(
              leading: const Icon(Icons.location_on, color: Colors.grey),
              title: Text(
                deliveryLocation,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              subtitle: Text(deliveryInstructions),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: _editLocation,
            ),

            const Divider(),

            // Leave at door option - Interactive
            ListTile(
              leading: const Icon(Icons.door_front_door, color: Colors.grey),
              title: const Text(
                "Leave it at my door",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              subtitle: Text(leaveAtDoor ? "Driver will leave at door" : "Hand to customer"),
              trailing: Switch(
                value: leaveAtDoor,
                onChanged: (value) => setState(() => leaveAtDoor = value),
                activeColor: const Color(0xFF002D72),
              ),
            ),

            const Divider(),

            // Phone number - Interactive
            ListTile(
              leading: const Icon(Icons.phone, color: Colors.grey),
              title: Text(
                phoneNumber,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: _editPhoneNumber,
            ),

            const Divider(),

            // Add promo - Interactive
            ListTile(
              leading: const Icon(Icons.local_offer, color: Colors.grey),
              title: Text(
                promoCode.isEmpty ? "Add promo" : "Promo: $promoCode",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: promoCode.isEmpty ? Colors.black : const Color(0xFF002D72),
                ),
              ),
              subtitle: promoCode.isEmpty ? null : const Text("Tap to change"),
              trailing: promoCode.isEmpty 
                  ? const Icon(Icons.arrow_forward_ios, size: 16)
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () => setState(() => promoCode = ""),
                          icon: const Icon(Icons.close, size: 20, color: Colors.red),
                        ),
                        const Icon(Icons.arrow_forward_ios, size: 16),
                      ],
                    ),
              onTap: _addPromoCode,
            ),

            const SizedBox(height: 40),

            // Confirm button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Go back to cart with delivery details confirmed
                  Navigator.pop(context, {
                    'deliveryTime': selectedDeliveryTime,
                    'location': deliveryLocation,
                    'instructions': deliveryInstructions,
                    'phone': phoneNumber,
                    'leaveAtDoor': leaveAtDoor,
                    'promoCode': promoCode,
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF002D72),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Confirm Delivery Details",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}