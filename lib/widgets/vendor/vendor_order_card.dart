// lib/widgets/vendor/vendor_order_card.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class VendorOrderCard extends StatelessWidget {
  final DocumentSnapshot order;
  final Function(String, String) onStatusUpdate;
  final String currentStatus;

  const VendorOrderCard({
    Key? key,
    required this.order,
    required this.onStatusUpdate,
    required this.currentStatus,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> data = order.data() as Map<String, dynamic>;
    
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildOrderHeader(data),
            SizedBox(height: 12),
            _buildCustomerInfo(data),
            SizedBox(height: 12),
            _buildOrderItems(data),
            SizedBox(height: 12),
            _buildOrderFooter(data, context),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderHeader(Map<String, dynamic> data) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order #${order.id.substring(0, 8).toUpperCase()}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4),
            Text(
              _formatDateTime(data['created_at']),
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Color(0xFF002D72),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            'RM ${data['total']?.toStringAsFixed(2) ?? '0.00'}',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCustomerInfo(Map<String, dynamic> data) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(Icons.person, size: 20, color: Colors.grey[600]),
          SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data['customer_name'] ?? 'Unknown Customer',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                if (data['customer_phone'] != null) ...[
                  SizedBox(height: 2),
                  Row(
                    children: [
                      Icon(Icons.phone, size: 14, color: Colors.grey[600]),
                      SizedBox(width: 4),
                      Text(
                        data['customer_phone'],
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          if (data['customer_phone'] != null)
            IconButton(
              onPressed: () => _callCustomer(data['customer_phone']),
              icon: Icon(Icons.call, color: Color(0xFF002D72)),
              tooltip: 'Call Customer',
            ),
        ],
      ),
    );
  }

  Widget _buildOrderItems(Map<String, dynamic> data) {
    List<dynamic> items = data['items'] ?? [];
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.restaurant_menu, size: 18, color: Color(0xFF002D72)),
            SizedBox(width: 8),
            Text(
              'Order Items (${items.length})',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        ...items.map((item) => _buildOrderItem(item)).toList(),
      ],
    );
  }

  Widget _buildOrderItem(Map<String, dynamic> item) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: Color(0xFF002D72),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '${item['quantity'] ?? 1}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              item['name'] ?? 'Unknown Item',
              style: TextStyle(fontSize: 14),
            ),
          ),
          Text(
            'RM ${(item['price'] ?? 0.0).toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF002D72),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderFooter(Map<String, dynamic> data, BuildContext context) {
    return Column(
      children: [
        if (data['special_instructions'] != null && 
            data['special_instructions'].toString().isNotEmpty) ...[
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.orange[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.orange[200]!),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.note, size: 16, color: Colors.orange[700]),
                    SizedBox(width: 8),
                    Text(
                      'Special Instructions:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: Colors.orange[700],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4),
                Text(
                  data['special_instructions'],
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.orange[800],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 12),
        ],
        _buildActionButton(context),
      ],
    );
  }

  Widget _buildActionButton(BuildContext context) {
    String nextStatus = _getNextStatus(currentStatus);
    String buttonText = _getButtonText(currentStatus);
    Color buttonColor = _getButtonColor(currentStatus);
    IconData buttonIcon = _getButtonIcon(currentStatus);

    if (currentStatus == 'completed') {
      return Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.green[50],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.green[200]!),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle, color: Colors.green[700], size: 20),
            SizedBox(width: 8),
            Text(
              'Order Completed',
              style: TextStyle(
                color: Colors.green[700],
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
    }

    return SizedBox(
      width: double.infinity,
      height: 45,
      child: ElevatedButton.icon(
        onPressed: () => _showConfirmationDialog(context, nextStatus, buttonText),
        icon: Icon(buttonIcon),
        label: Text(
          buttonText,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 2,
        ),
      ),
    );
  }

  String _getNextStatus(String currentStatus) {
    switch (currentStatus) {
      case 'pending':
        return 'preparing';
      case 'preparing':
        return 'ready';
      case 'ready':
        return 'completed';
      default:
        return currentStatus;
    }
  }

  String _getButtonText(String currentStatus) {
    switch (currentStatus) {
      case 'pending':
        return 'Start Preparing';
      case 'preparing':
        return 'Mark as Ready';
      case 'ready':
        return 'Complete Order';
      default:
        return 'Update Status';
    }
  }

  Color _getButtonColor(String currentStatus) {
    switch (currentStatus) {
      case 'pending':
        return Colors.orange;
      case 'preparing':
        return Colors.blue;
      case 'ready':
        return Colors.green;
      default:
        return Color(0xFF002D72);
    }
  }

  IconData _getButtonIcon(String currentStatus) {
    switch (currentStatus) {
      case 'pending':
        return Icons.restaurant;
      case 'preparing':
        return Icons.check;
      case 'ready':
        return Icons.done_all;
      default:
        return Icons.update;
    }
  }

  String _formatDateTime(dynamic timestamp) {
    if (timestamp == null) return 'Unknown time';
    
    DateTime dateTime;
    if (timestamp is Timestamp) {
      dateTime = timestamp.toDate();
    } else if (timestamp is DateTime) {
      dateTime = timestamp;
    } else {
      return 'Unknown time';
    }

    return DateFormat('MMM dd, yyyy • hh:mm a').format(dateTime);
  }

  void _showConfirmationDialog(BuildContext context, String nextStatus, String actionText) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirm Action'),
        content: Text('Are you sure you want to $actionText?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              onStatusUpdate(order.id, nextStatus);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: _getButtonColor(currentStatus),
            ),
            child: Text('Confirm'),
          ),
        ],
      ),
    );
  }

  void _callCustomer(String phoneNumber) {
    // Implement phone call functionality
    // You might want to use url_launcher package
    // launch('tel:$phoneNumber');
  }
}