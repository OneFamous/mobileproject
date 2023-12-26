import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatelessWidget {
  final List<Map<String, String>> contributors = [
    {
      'name': 'Fatih Ateş',
      'profile': 'https://www.linkedin.com/in/fatih-ate%C5%9F/',
      'role': 'Leader/Flutter Developer',
      'imagePath': 'images/fatih_ates.png',
    },
    {
      'name': 'Mine Ceyhan',
      'profile': 'https://www.linkedin.com/in/mine-ceyhan/',
      'role': 'Flutter Developer',
      'imagePath': 'images/mine_ceyhan.png',
    },
    {
      'name': 'Yunus Emre Tükel',
      'profile': 'https://www.linkedin.com/in/yunus-emre-t%C3%BCkel-636aba239/',
      'role': 'Flutter Developer',
      'imagePath': 'images/yunus_emre_tukel.png',
    },
    {
      'name': 'Berke Can Peker',
      'profile': 'https://www.linkedin.com/in/berke-can-peker-894739197/',
      'role': 'Flutter Developer',
      'imagePath': 'images/berke_can_peker.png',
    },
    {
      'name': 'Ensar Aydın Kurubacak',
      'profile':
          'https://www.linkedin.com/in/ensar-ayd%C4%B1n-kurubacak-b8a0ab278/',
      'role': 'Flutter Developer',
      'imagePath': 'images/ensar_aydin_kurubacak.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text('Thanks'),
        centerTitle: true,
        backgroundColor: Colors.deepOrange,
      ),
      body: Column(
        children: [
          // ListView.builder ile oluşturulan içerik
          Expanded(
            child: ListView.builder(
              itemCount: contributors.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 5,
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    title: Stack(
                      children: [
                        // Büyük fotoğraf
                        Align(
                          alignment: Alignment.center,
                          child: CircleAvatar(
                            radius: 40,
                            backgroundImage: AssetImage(
                              contributors[index]['imagePath']!,
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: Icon(
                            Icons.work,
                            color: Colors.deepOrange,
                          ),
                        ),
                      ],
                    ),
                    subtitle: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Divider(
                          color: Colors.black,
                          thickness: 0.7,
                          height: 9,
                          indent: 20,
                          endIndent: 20,
                        ),
                        // İsim
                        Text(
                          contributors[index]['name']!,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        // Görevlendirme
                        Text(
                          contributors[index]['role']!,
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ],
                    ),
                    onTap: () {
                      // Doğrudan web sayfasına yönlendirme
                      _launchWebPage(
                        context,
                        contributors[index]['profile']!,
                      );
                    },
                  ),
                );
              },
            ),
          ),
          // Sabit yazı
          Padding(
            padding: EdgeInsets.fromLTRB(8, 2, 8, 2),
            child: Text(
              "All rights reserved. ©",
              style: TextStyle(
                fontSize: 15,
                color: Theme.of(context).colorScheme.tertiary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _launchWebPage(BuildContext context, String url) async {
    try {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    } catch (e, stackTrace) {
      print('Error: $e');
      print('Stack Trace: $stackTrace');
      // Hata durumunda hatayı göster
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Hata'),
            content: Text('URL açılırken bir hata oluştu: $e'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Tamam'),
              ),
            ],
          );
        },
      );
    }
  }
}
