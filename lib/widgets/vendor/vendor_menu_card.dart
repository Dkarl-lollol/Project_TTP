// lib/widgets/vendor/vendor_menu_card.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class VendorMenuCard extends StatelessWidget {
  final DocumentSnapshot item;
  final String vendorId;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onToggleAvailability;

  const VendorMenuCard({
    Key? key,
    required this.item,
    required this.vendorId,
    required this.onEdit,
    required this.onDelete,
    required this.onToggleAvailability,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> data = item.data() as Map<String, dynamic>;
    
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            _buildItemImage(data),
            SizedBox(width: 16),
            Expanded(
              child: _buildItemDetails(data),
            ),
            _buildPopupMenu(data),
          ],
        ),
      ),
    );
  }

  Widget _buildItemImage(Map<String, dynamic> data) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey[200],
      ),
      child: data['image_url'] != null
          ? ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                data['image_url'],
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.fastfood,
                    size: 40,
                    color: Colors.grey[500],
                  );
                },
              ),
            )
          : Icon(
              Icons.fastfood,
              size: 40,
              color: Colors.grey[500],
            ),
    );
  }

  Widget _buildItemDetails(Map<String, dynamic> data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          data['name'] ?? 'Unknown Item',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 4),
        Text(
          data['description'] ?? '',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: 8),
        Row(
          children: [
            Text(
              'RM ${data['price']?.toStringAsFixed(2) ?? '0.00'}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF002D72),
              ),
            ),
            Spacer(),
            _buildAvailabilityChip(data),
          ],
        ),
      ],
    );
  }

  Widget _buildAvailabilityChip(Map<String, dynamic> data) {
    bool isAvailable = data['available'] == true;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isAvailable ? Colors.green[100] : Colors.red[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        isAvailable ? 'Available' : 'Unavailable',
        style: TextStyle(
          fontSize: 12,
          color: isAvailable ? Colors.green[800] : Colors.red[800],
        ),
      ),
    );
  }

  Widget _buildPopupMenu(Map<String, dynamic> data) {
    return PopupMenuButton(
      icon: Icon(Icons.more_vert),
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'edit',
          child: Row(
            children: [
              Icon(Icons.edit, size: 20),
              SizedBox(width: 8),
              Text('Edit'),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'toggle',
          child: Row(
            children: [
              Icon(
                data['available'] == true
                    ? Icons.visibility_off
                    : Icons.visibility,
                size: 20,
              ),
              SizedBox(width: 8),
              Text(data['available'] == true ? 'Hide' : 'Show'),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'delete',
          child: Row(
            children: [
              Icon(Icons.delete, size: 20, color: Colors.red),
              SizedBox(width: 8),
              Text('Delete', style: TextStyle(color: Colors.red)),
            ],
          ),
        ),
      ],
      onSelected: (value) {
        switch (value) {
          case 'edit':
            onEdit();
            break;
          case 'toggle':
            onToggleAvailability();
            break;
          case 'delete':
            onDelete();
            break;
        }
      },
    );
  }
}