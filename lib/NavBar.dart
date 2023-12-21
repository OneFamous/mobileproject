import 'package:flutter/material.dart';
import 'package:mobileproject/screens/about_page.dart';
import 'package:mobileproject/screens/auth/login_page.dart';
import 'package:mobileproject/screens/chat/chat_main_page.dart';
import 'package:mobileproject/screens/currency_page.dart';
import 'package:mobileproject/screens/notes/home_page.dart';
import 'package:mobileproject/screens/settings_page.dart';
import 'package:mobileproject/screens/todo/todo_main.dart';

import 'controllers/auth/login_controller.dart';
import 'main.dart';

class NavBar extends StatelessWidget {
  const NavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.background,
      child: ListView(
        children: [
          const UserAccountsDrawerHeader(
            accountName: Text('Fatih Ateş'),
            accountEmail: Text('fatihates@aaaaa.com'),
            currentAccountPicture: CircleAvatar(
              backgroundImage: NetworkImage(
                  'https://freepngimg.com/thumb/dishonored/11-2-dishonored-free-png-image.png'),
            ),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                    'https://unblast.com/wp-content/uploads/2021/01/Space-Background-Image-3.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              Navigator.pop(context); // Drawer'ı kapat
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MyApp()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.chat),
            title: const Text('Chatting'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ChatHomePageWidget()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.monetization_on),
            title: const Text('Crypto Market'),
            onTap: () {
              Navigator.pop(context); // Drawer'ı kapat
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CurrencyPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.check_box),
            title: const Text('To-Do List'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => homePageTodo()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.note_alt_sharp),
            title: const Text('NotePad'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
              );
            },
          ),
          const Divider(),
          Container(height: MediaQuery.of(context).size.height * 0.2),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.description),
            title: const Text('About'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AboutPage()),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Quit'),
            onTap: () async {
              LoginController loginController = LoginController();
              String? errorMessage = await loginController.logout();
              if (errorMessage == null) {
                print('Oturum başarıyla kapatıldı.');
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              } else {
                print('error: $errorMessage');
              }
            },
          ),
        ],
      ),
    );
  }
}
