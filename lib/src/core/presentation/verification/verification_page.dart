import 'package:flutter/material.dart';

class VerificationPage extends StatefulWidget {
  const VerificationPage({Key? key}) : super(key: key);

  @override
  _VerificationPageState createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  bool _isUserLoggedIn = false;
  Map<String, bool> _moduleVerificationStatus = {
    'email': false,
    'phone': false,
    'identity': false,
    // Add more modules as needed
  };

  @override
  void initState() {
    super.initState();
    _checkVerificationStatus();
  }

  Future<void> _checkVerificationStatus() async {
    // TODO: Implement actual checks, possibly involving API calls
    // For now, we'll use mock data
    await Future.delayed(
        const Duration(seconds: 1)); // Simulating network delay

    setState(() {
      _isUserLoggedIn = true; // Mock status
      _moduleVerificationStatus = {
        'email': true,
        'phone': false,
        'identity': false,
      };
    });
  }

  Widget _buildVerificationStatus() {
    if (!_isUserLoggedIn) {
      return const Center(
          child: Text('Please log in to continue verification.'));
    }

    return ListView(
      children: [
        const Text(
          'Verification Status',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        ..._moduleVerificationStatus.entries.map((entry) {
          return ListTile(
            title: Text(entry.key.capitalize()),
            trailing: entry.value
                ? const Icon(Icons.check_circle, color: Colors.green)
                : const Icon(Icons.warning, color: Colors.orange),
            onTap: () => _handleModuleVerification(entry.key),
          );
        }).toList(),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: _isAllVerified() ? _completeVerification : null,
          child: const Text('Complete Verification'),
        ),
      ],
    );
  }

  void _handleModuleVerification(String module) {
    // TODO: Implement module-specific verification logic
    print('Verifying $module');
    // Navigate to specific verification page or show dialog
  }

  bool _isAllVerified() {
    return _moduleVerificationStatus.values.every((status) => status);
  }

  void _completeVerification() {
    // TODO: Implement final verification steps
    print('All modules verified. Completing verification process.');
    // Navigate to the next page or show completion dialog
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verification'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _buildVerificationStatus(),
      ),
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}
