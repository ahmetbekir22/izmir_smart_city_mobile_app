import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'baskan_page.dart';
import 'communication_page.dart';
import 'hakkinda_page.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({Key? key}) : super(key: key);

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'URL açılamadı: $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.secondary,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildMenuButton(
                    context,
                    'BAŞKAN',
                    Icons.person,
                    () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BaskanPage()));
                    },
                  ),
                  const SizedBox(height: 20),
                  _buildMenuButton(
                    context,
                    'HAKKINDA',
                    Icons.info,
                    () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HakkindaPage()));
                    },
                  ),
                  const SizedBox(height: 20),
                  _buildMenuButton(
                    context,
                    'İLETİŞİM',
                    Icons.contact_mail,
                    () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => IletisimPage()));
                    },
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.all(32.0),
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(30),
                border:
                    Border.all(color: Colors.white, width: 2), 
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: ImageIcon(
                      AssetImage('assets/images/facebook.png'),
                      color: Colors.white,
                      size: 30,
                    ),
                    onPressed: () => _launchURL(
                        'https://www.facebook.com/izmirbuyuksehirbel/?locale=tr_TR'),
                  ),
                  IconButton(
                    icon: ImageIcon(
                      AssetImage('assets/images/instagram.png'),
                      color: Colors.white,
                      size: 30,
                    ),
                    onPressed: () => _launchURL(
                        'https://www.instagram.com/izmirbuyuksehirbelediyesi/'),
                  ),
                  IconButton(
                    icon: ImageIcon(
                      AssetImage('assets/images/twitter.png'),
                      color: Colors.white,
                      size: 30,
                    ),
                    onPressed: () => _launchURL('https://x.com/izmirbld'),
                  ),
                  IconButton(
                    icon: ImageIcon(
                      AssetImage('assets/images/youtube.png'),
                      color: Colors.white,
                      size: 30,
                    ),
                    onPressed: () => _launchURL(
                        'https://www.youtube.com/@IZMIRBUYUKSEHIRBLD'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuButton(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onPressed,
  ) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1), 
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextButton.icon(
        icon: Icon(icon, color: Colors.white, size: 24),
        label: Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        onPressed: onPressed,
        style: TextButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
    );
  }
}
