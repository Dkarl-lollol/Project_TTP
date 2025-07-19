// lib/screens/vendor/vendor_order_page.dart
import 'package:flutter/material.dart';

class VendorOrderPage extends StatefulWidget {
  final String vendorId;

  VendorOrderPage({required this.vendorId});

  @override
  _VendorOrderPageState createState() => _VendorOrderPageState();
}

class _VendorOrderPageState extends State<VendorOrderPage> {
  String _selectedFilter = 'pending';
  
  final Map<String, String> _filterLabels = {
    'pending': 'Pending',
    'preparing': 'Preparing',
    'ready': 'Ready',
    'completed': 'Completed',
  };

  final Map<String, Color> _statusColors = {
    'pending': Colors.orange,
    'preparing': Colors.blue,
    'ready': Colors.green,
    'completed': Colors.grey,
  };

  // Hardcoded orders data
  final List<Map<String, dynamic>> _orders = [
    // Completed order
    {
      'id': '2',
      'customer_phone': '+60123456789',
      'items': [
        {
          'name': 'Pattaya Fried Rice',
          'price': 5.50,
          'quantity': 1,
        }
      ],
      'total': 5.50,
      'status': 'completed',
      'special_instructions': '',
      'created_at': DateTime.now().subtract(const Duration(days: 3)),
      'restaurant': 'V6 Cafe',
    },
    // Preparing order
    {
      'id': '3',
      'customer_phone': '+60123456790',
      'items': [
        {
          'name': 'Pattaya Fried Rice + extra rice + no vegetables',
          'price': 11.00,
          'quantity': 1,
        }
      ],
      'total': 11.00,
      'status': 'preparing',
      'special_instructions': 'Extra rice, no vegetables',
      'created_at': DateTime.now().subtract(const Duration(days: 3)),
      'restaurant': 'V6 Cafe',
    },
  ];


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeader(),
        Expanded(
          child: _buildOrdersList(),
        ),
      ],
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
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Orders Management',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              // Order count badge
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  '${_getFilteredOrders().length} orders',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          _buildFilterChips(),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    return Row(
      children: _filterLabels.entries.map((entry) {
        return Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 4),
            child: _buildFilterChip(entry.key, entry.value),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildFilterChip(String value, String label) {
    bool isSelected = _selectedFilter == value;
    int orderCount = _orders.where((order) => order['status'] == value).length;
    
    return GestureDetector(
      onTap: () => setState(() => _selectedFilter = value),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(20),
          border: isSelected 
              ? Border.all(color: Color(0xFF002D72), width: 2)
              : null,
        ),
        child: Column(
          children: [
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isSelected ? Color(0xFF002D72) : Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 11,
              ),
            ),
            Text(
              '($orderCount)',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isSelected ? Color(0xFF002D72) : Colors.white70,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrdersList() {
    List<Map<String, dynamic>> filteredOrders = _getFilteredOrders();

    if (filteredOrders.isEmpty) {
      return _buildEmptyOrdersState();
    }

    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: filteredOrders.length,
      itemBuilder: (context, index) {
        return _buildOrderCard(filteredOrders[index]);
      },
    );
  }

  List<Map<String, dynamic>> _getFilteredOrders() {
    return _orders.where((order) => order['status'] == _selectedFilter).toList();
  }

  Widget _buildOrderCard(Map<String, dynamic> order) {
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
            _buildOrderHeader(order),
            SizedBox(height: 12),
            _buildCustomerInfo(order),
            SizedBox(height: 12),
            _buildOrderItems(order),
            if (order['special_instructions'] != null && 
                order['special_instructions'].toString().isNotEmpty) ...[
              SizedBox(height: 12),
              _buildSpecialInstructions(order),
            ],
            SizedBox(height: 12),
            _buildActionButton(order),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderHeader(Map<String, dynamic> order) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order #${order['id']}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4),
            Text(
              _formatDateTime(order['created_at']),
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
            'RM ${order['total'].toStringAsFixed(2)}',
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

  Widget _buildCustomerInfo(Map<String, dynamic> order) {
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
                  order['customer_name'] ?? 'Unknown Customer',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                if (order['customer_phone'] != null) ...[
                  SizedBox(height: 2),
                  Row(
                    children: [
                      Icon(Icons.phone, size: 14, color: Colors.grey[600]),
                      SizedBox(width: 4),
                      Text(
                        order['customer_phone'],
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
          if (order['customer_phone'] != null)
            IconButton(
              onPressed: () => _showCallDialog(order['customer_phone']),
              icon: Icon(Icons.call, color: Color(0xFF002D72)),
              tooltip: 'Call Customer',
            ),
        ],
      ),
    );
  }

  Widget _buildOrderItems(Map<String, dynamic> order) {
    List<dynamic> items = order['items'] ?? [];
    
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

  Widget _buildSpecialInstructions(Map<String, dynamic> order) {
    return Container(
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
            order['special_instructions'],
            style: TextStyle(
              fontSize: 12,
              color: Colors.orange[800],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(Map<String, dynamic> order) {
    String nextStatus = _getNextStatus(_selectedFilter);
    String buttonText = _getButtonText(_selectedFilter);
    Color buttonColor = _getButtonColor(_selectedFilter);
    IconData buttonIcon = _getButtonIcon(_selectedFilter);

    if (_selectedFilter == 'completed') {
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
        onPressed: () => _updateOrderStatus(order['id'], nextStatus),
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

  Widget _buildEmptyOrdersState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            _getEmptyStateIcon(),
            size: 80,
            color: Colors.grey[300],
          ),
          SizedBox(height: 16),
          Text(
            'No ${_filterLabels[_selectedFilter]?.toLowerCase()} orders',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 8),
          Text(
            _getEmptyStateMessage(),
            style: TextStyle(
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  IconData _getEmptyStateIcon() {
    switch (_selectedFilter) {
      case 'pending':
        return Icons.hourglass_empty;
      case 'preparing':
        return Icons.restaurant;
      case 'ready':
        return Icons.check_circle_outline;
      case 'completed':
        return Icons.done_all;
      default:
        return Icons.shopping_cart_outlined;
    }
  }

  String _getEmptyStateMessage() {
    switch (_selectedFilter) {
      case 'pending':
        return 'New orders will appear here when customers place them';
      case 'preparing':
        return 'Orders you\'re currently preparing will show here';
      case 'ready':
        return 'Orders ready for pickup will appear here';
      case 'completed':
        return 'Completed orders will be listed here';
      default:
        return 'Orders will appear here';
    }
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

  String _formatDateTime(DateTime? dateTime) {
    if (dateTime == null) return 'Unknown time';
    
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
    } else {
      return '${difference.inMinutes} min ago';
    }
  }

  void _updateOrderStatus(String orderId, String newStatus) {
    setState(() {
      int orderIndex = _orders.indexWhere((order) => order['id'] == orderId);
      if (orderIndex != -1) {
        _orders[orderIndex]['status'] = newStatus;
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Order status updated to ${_filterLabels[newStatus]}'),
        backgroundColor: _statusColors[newStatus],
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showCallDialog(String phoneNumber) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Call Customer'),
        content: Text('Do you want to call $phoneNumber?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Implement actual phone call here
              // You can use url_launcher package: launch('tel:$phoneNumber');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF002D72),
            ),
            child: Text('Call'),
          ),
        ],
      ),
    );
  }
}