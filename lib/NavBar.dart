import 'package:flutter/material.dart';

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
            title: Text('Ana Sayfa'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.monetization_on_outlined),
            title: Text('Döviz Kurları'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.check),
            title: Text('To-Do'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.note_alt_sharp),
            title: Text('Not Defteri'),
            onTap: () {},
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Ayarlar'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.description),
            title: Text('Hakkında'),
            onTap: () {},
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Çıkış'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
