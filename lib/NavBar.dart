import 'package:flutter/material.dart';
import 'package:mobileproject/screens/currency_page.dart';
import 'package:mobileproject/screens/login_page.dart';

import 'controllers/auth_controller.dart';
import 'main.dart';

class NavBar extends StatelessWidget {
  const NavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
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
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () {
              Navigator.pop(context); // Drawer'ı kapat
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyApp()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.chat),
            title: Text('Chatting'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.monetization_on),
            title: Text('Crypto Market'),
            onTap: () {
              Navigator.pop(context); // Drawer'ı kapat
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CurrencyPage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.check_box),
            title: Text('To-Do List'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.note_alt_sharp),
            title: Text('NotePad'),
            onTap: () {},
          ),

          Divider(),
          Container(height: MediaQuery.of(context).size.height * 0.2),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.description),
            title: Text('About'),
            onTap: () {},
          ),
          Divider(),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Quit'),
            onTap: () async {
              AuthController authController = AuthController();
              String? errorMessage = await authController.logout();

              if (errorMessage == null) {
                print('Oturum başarıyla kapatıldı.');
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
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
