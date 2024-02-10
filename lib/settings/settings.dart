import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  final int currentDisplayCount;
  final Function(int) onChanged;

  const SettingsPage({
    Key? key,
    required this.currentDisplayCount,
    required this.onChanged,
  }) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late int _displayCount;

  @override
  void initState() {
    super.initState();
    _displayCount = widget.currentDisplayCount;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Number of Users to Display:',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Slider(
              value: _displayCount.toDouble(),
              min: 1,
              max: 100,
              divisions: 99,
              label: _displayCount.toString(),
              onChanged: (value) {
                setState(() {
                  _displayCount = value.round();
                });
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                widget.onChanged(_displayCount);
                Navigator.pop(context);
              },
              child: const Text('Apply'),
            ),
          ],
        ),
      ),
    );
  }
}
