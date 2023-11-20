import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

final CollectionReference _products =
    FirebaseFirestore.instance.collection('products');

final TextEditingController _nameController = TextEditingController();
final TextEditingController _priceController = TextEditingController();

class Database {
  static Stream<QuerySnapshot> getData() {
    return _products.snapshots();
  }

  static Future<void> create(BuildContext context) async {
    _nameController.clear();
    _priceController.clear();

    await showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            top: 20,
            left: 20,
            right: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'name'),
              ),
              TextField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'price'),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                  onPressed: () async {
                    final String name = _nameController.text;
                    final double? price =
                        double.tryParse(_priceController.text);
                    if (price != null) {
                      await _products.add({'name': name, 'price': price});
                    }
                  },
                  child: const Text('Create')),
            ],
          ),
        );
      },
    );
  }

  static Future<void> update(
      DocumentSnapshot? snapshot, BuildContext context) async {
    if (snapshot != null) {
      _nameController.text = snapshot['name'];
      _priceController.text = snapshot['price'].toString();
    }

    await showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            top: 20,
            left: 20,
            right: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'name'),
              ),
              TextField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'price'),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                  onPressed: () async {
                    final String name = _nameController.text;
                    final double? price =
                        double.tryParse(_priceController.text);
                    if (price != null) {
                      await _products
                          .doc(snapshot?.id)
                          .update({'name': name, 'price': price});
                    }
                  },
                  child: const Text('Update')),
            ],
          ),
        );
      },
    );
  }

  static Future<void> delete(
      DocumentSnapshot snapshot, BuildContext context) async {
    await _products.doc(snapshot.id).delete();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Product deleted'),
        duration: Duration(seconds: 1),
      ),
    );
  }
}
