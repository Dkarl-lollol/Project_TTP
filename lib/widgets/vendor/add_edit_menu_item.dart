// lib/widgets/vendor/add_edit_menu_item_dialog.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddEditMenuItem extends StatefulWidget {
  final String vendorId;
  final bool isEdit;
  final Map<String, dynamic>? itemData;
  final String? itemId;

  AddEditMenuItem({
    required this.vendorId,
    required this.isEdit,
    this.itemData,
    this.itemId,
  });

  @override
  _AddEditMenuItemState createState() => _AddEditMenuItemState();
}

class _AddEditMenuItemState extends State<AddEditMenuItem> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;
  late TextEditingController _categoryController;
  late TextEditingController _imageUrlController;
  bool _available = true;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    _nameController = TextEditingController(
      text: widget.isEdit ? widget.itemData!['name'] : '',
    );
    _descriptionController = TextEditingController(
      text: widget.isEdit ? widget.itemData!['description'] : '',
    );
    _priceController = TextEditingController(
      text: widget.isEdit ? widget.itemData!['price'].toString() : '',
    );
    _categoryController = TextEditingController(
      text: widget.isEdit ? widget.itemData!['category'] : '',
    );
    _imageUrlController = TextEditingController(
      text: widget.isEdit ? widget.itemData!['image_url'] ?? '' : '',
    );
    
    if (widget.isEdit) {
      _available = widget.itemData!['available'] ?? true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.isEdit ? 'Edit Menu Item' : 'Add Menu Item'),
      content: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildNameField(),
                SizedBox(height: 16),
                _buildDescriptionField(),
                SizedBox(height: 16),
                _buildPriceField(),
                SizedBox(height: 16),
                _buildCategoryField(),
                SizedBox(height: 16),
                _buildImageUrlField(),
                SizedBox(height: 16),
                _buildAvailabilitySwitch(),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _loading ? null : () => Navigator.pop(context),
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _loading ? null : _saveItem,
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF1976D2),
          ),
          child: _loading
              ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Text(widget.isEdit ? 'Update' : 'Add'),
        ),
      ],
    );
  }

  Widget _buildNameField() {
    return TextFormField(
      controller: _nameController,
      decoration: InputDecoration(
        labelText: 'Item Name *',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.fastfood),
      ),
      validator: (value) =>
          value?.isEmpty == true ? 'Please enter item name' : null,
    );
  }

  Widget _buildDescriptionField() {
    return TextFormField(
      controller: _descriptionController,
      decoration: InputDecoration(
        labelText: 'Description',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.description),
      ),
      maxLines: 3,
    );
  }

  Widget _buildPriceField() {
    return TextFormField(
      controller: _priceController,
      decoration: InputDecoration(
        labelText: 'Price (RM) *',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.attach_money),
        prefixText: 'RM ',
      ),
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      validator: (value) {
        if (value?.isEmpty == true) return 'Please enter price';
        if (double.tryParse(value!) == null) return 'Invalid price';
        if (double.parse(value) <= 0) return 'Price must be greater than 0';
        return null;
      },
    );
  }

  Widget _buildCategoryField() {
    return TextFormField(
      controller: _categoryController,
      decoration: InputDecoration(
        labelText: 'Category',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.category),
        hintText: 'e.g., Main Course, Beverages, Desserts',
      ),
    );
  }

  Widget _buildImageUrlField() {
    return TextFormField(
      controller: _imageUrlController,
      decoration: InputDecoration(
        labelText: 'Image URL (Optional)',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.image),
        hintText: 'https://example.com/image.jpg',
      ),
      validator: (value) {
        if (value != null && value.isNotEmpty) {
          if (!Uri.tryParse(value)!.hasAbsolutePath == true) {
            return 'Please enter a valid URL';
          }
        }
        return null;
      },
    );
  }

  Widget _buildAvailabilitySwitch() {
    return SwitchListTile(
      title: Text('Available for Sale'),
      subtitle: Text('Toggle item availability'),
      value: _available,
      onChanged: (value) => setState(() => _available = value),
      activeColor: Color(0xFF1976D2),
      secondary: Icon(
        _available ? Icons.visibility : Icons.visibility_off,
        color: _available ? Color(0xFF1976D2) : Colors.grey,
      ),
    );
  }

  void _saveItem() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    try {
      Map<String, dynamic> itemData = {
        'name': _nameController.text.trim(),
        'description': _descriptionController.text.trim(),
        'price': double.parse(_priceController.text),
        'category': _categoryController.text.trim(),
        'available': _available,
        'vendor_id': widget.vendorId,
        'updated_at': FieldValue.serverTimestamp(),
      };

      // Add image URL only if provided
      if (_imageUrlController.text.trim().isNotEmpty) {
        itemData['image_url'] = _imageUrlController.text.trim();
      }

      if (widget.isEdit) {
        await FirebaseFirestore.instance
            .collection('vendors')
            .doc(widget.vendorId)
            .collection('menu_items')
            .doc(widget.itemId)
            .update(itemData);
      } else {
        itemData['created_at'] = FieldValue.serverTimestamp();
        await FirebaseFirestore.instance
            .collection('vendors')
            .doc(widget.vendorId)
            .collection('menu_items')
            .add(itemData);
      }

      Navigator.pop(context);
      _showSuccessMessage();
    } catch (e) {
      _showErrorMessage(e.toString());
    } finally {
      setState(() => _loading = false);
    }
  }

  void _showSuccessMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          widget.isEdit ? 'Item updated successfully!' : 'Item added successfully!',
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showErrorMessage(String error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error: $error'),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _categoryController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }
}