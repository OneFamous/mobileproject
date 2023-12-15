import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text('Settings'),
        backgroundColor: Colors.deepOrange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            _buildThemeOption(false),
            Divider(),
            // Add more settings widgets here as needed
          ],
        ),
      ),
    );
  }

  Widget _buildThemeOption(bool isDarkMode) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    return InkWell(
      onTap: () {
        themeProvider.toggleTheme();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  themeProvider.themeData == darkMode
                      ? Icons.nightlight_round
                      : Icons.wb_sunny,
                  color: Theme.of(context).iconTheme.color,
                ),
                SizedBox(width: 8),
                Text(
                  themeProvider.themeData == darkMode
                      ? 'Dark Mode'
                      : 'Light Mode',
                  style: Theme.of(context).textTheme.headline6,
                ),
              ],
            ),
            Switch(
              value: themeProvider.themeData == darkMode,
              onChanged: (value) {
                themeProvider.toggleTheme();
              },
            ),
          ],
        ),
      ),
    );
  }
}
