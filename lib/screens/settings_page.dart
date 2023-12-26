import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text('Settings', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepOrange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            _buildThemeOption(context),
            const Divider(thickness: 2),
            // Add more settings widgets here as needed
          ],
        ),
      ),
    );
  }

  Widget _buildThemeOption(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    return InkWell(
      onTap: () {
        themeProvider.toggleTheme();
        _saveThemePreference(
            themeProvider.themeData == darkMode ? 'dark' : 'light');
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
                _saveThemePreference(value ? 'dark' : 'light');
              },
            ),
          ],
        ),
      ),
    );
  }

  void _saveThemePreference(String theme) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('theme_preference', theme);
  }
}
