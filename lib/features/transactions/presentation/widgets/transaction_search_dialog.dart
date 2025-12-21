import 'package:flutter/material.dart';

/// Dialog for searching transactions by description or notes
///
/// Returns a search query string when Apply is pressed
class TransactionSearchDialog extends StatefulWidget {
  const TransactionSearchDialog({super.key});

  @override
  State<TransactionSearchDialog> createState() =>
      _TransactionSearchDialogState();
}

class _TransactionSearchDialogState extends State<TransactionSearchDialog> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _applySearch() {
    final query = _searchController.text.trim();
    if (query.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a search query')),
      );
      return;
    }
    Navigator.of(context).pop(query);
  }

  void _clearSearch() {
    setState(() {
      _searchController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Search Transactions'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Search by description or notes',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _searchController,
              autofocus: true,
              decoration: const InputDecoration(
                labelText: 'Search query',
                hintText: 'Enter description or notes...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.search,
              onSubmitted: (_) => _applySearch(),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _clearSearch,
          child: const Text('Clear'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _applySearch,
          child: const Text('Search'),
        ),
      ],
    );
  }
}
