// lib/screens/vendor/vendor_management_page.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hellodekal/widgets/vendor/add_edit_menu_item.dart';
import '../../widgets/vendor/vendor_menu_card.dart';

class VendorManagementPage extends StatefulWidget {
  final String vendorId;
  
  VendorManagementPage({required this.vendorId});

  @override
  _VendorManagementPageState createState() => _VendorManagementPageState();
}

class _VendorManagementPageState extends State<VendorManagementPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('vendors')
                  .doc(widget.vendorId)
                  .collection('menu_items')
                  .orderBy('created_at', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return _buildEmptyState();
                }

                return ListView.builder(
                  padding: EdgeInsets.all(16),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var item = snapshot.data!.docs[index];
                    return VendorMenuCard(
                      item: item,
                      vendorId: widget.vendorId,
                      onEdit: () => _showEditItemDialog(item),
                      onDelete: () => _deleteItem(item.id),
                      onToggleAvailability: () => _toggleItemAvailability(item),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF002D72),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'My Menu Items',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          ElevatedButton.icon(
            onPressed: () => _showAddItemDialog(),
            icon: Icon(Icons.add),
            label: Text('Add Item'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Color(0xFF002D72),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.restaurant_menu,
            size: 80,
            color: Colors.grey[300],
          ),
          SizedBox(height: 16),
          Text(
            'No menu items yet',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Add your first menu item to get started',
            style: TextStyle(
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  void _showAddItemDialog() {
    showDialog(
      context: context,
      builder: (context) => AddEditMenuItem(
        vendorId: widget.vendorId,
        isEdit: false,
      ),
    );
  }

  void _showEditItemDialog(DocumentSnapshot item) {
    showDialog(
      context: context,
      builder: (context) => AddEditMenuItem(
        vendorId: widget.vendorId,
        isEdit: true,
        itemData: item.data() as Map<String, dynamic>,
        itemId: item.id,
      ),
    );
  }

  void _toggleItemAvailability(DocumentSnapshot item) {
    Map<String, dynamic> data = item.data() as Map<String, dynamic>;
    FirebaseFirestore.instance
        .collection('vendors')
        .doc(widget.vendorId)
        .collection('menu_items')
        .doc(item.id)
        .update({'available': !data['available']});
  }

  void _deleteItem(String itemId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Item'),
        content: Text('Are you sure you want to delete this menu item?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              FirebaseFirestore.instance
                  .collection('vendors')
                  .doc(widget.vendorId)
                  .collection('menu_items')
                  .doc(itemId)
                  .delete();
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }
}