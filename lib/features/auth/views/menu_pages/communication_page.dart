import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class IletisimPage extends StatelessWidget {
  const IletisimPage({Key? key}) : super(key: key);

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'URL açılamadı: $url';
    }
  }

  Future<void> _launchPhone(String phoneNumber) async {
    final url = 'tel:$phoneNumber';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Telefon açılamadı: $phoneNumber';
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> contacts = [
      {
        'title': 'İzmir Büyükşehir Belediyesi',
        'address': 'Konak Mahallesi, Cumhuriyet Bulvarı No:1, Konak/İzmir',
        'phone': '(0232) 123 45 67',
        'phone2': '(0232) 293 12 00',
        'fax': '(0232) 293 13 00',
        'whatsapp': '0552 123 45 67',
      },
      {
        'title': 'Acil Durum Hatları',
        'zabita': '(0232) 293 11 11',
        'itfaiye': '110',
        'ambulans': '112',
      },
      {
        'title': 'Hizmet Masası',
        'phone': '444 40 35',
        'email': 'hizmet@izmir.bel.tr',
      }
    ];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('İLETİŞİM', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Container(
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height,
        ),
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
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildMainContactCard(contacts[0]),
                const SizedBox(height: 16),
                _buildEmergencyCard(contacts[1]),
                const SizedBox(height: 16),
                _buildServiceDeskCard(contacts[2]),
                const SizedBox(height: 30),
  
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMainContactCard(Map<String, String> contact) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            contact['title']!,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          _buildInfoRow(Icons.location_on_outlined, contact['address']!),
          const Divider(color: Colors.white24, height: 24),
          _buildPhoneRow('Santral:', contact['phone']!),
          const SizedBox(height: 8),
          _buildPhoneRow('Telefon:', contact['phone2']!),
          const SizedBox(height: 8),
          _buildPhoneRow('Faks:', contact['fax']!),
          const SizedBox(height: 8),
          _buildPhoneRow('WhatsApp:', contact['whatsapp']!),
        ],
      ),
    );
  }

  Widget _buildEmergencyCard(Map<String, String> contact) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            contact['title']!,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          _buildPhoneRow('Zabıta:', contact['zabita']!),
          const SizedBox(height: 8),
          _buildPhoneRow('İtfaiye:', contact['itfaiye']!),
          const SizedBox(height: 8),
          _buildPhoneRow('Ambulans:', contact['ambulans']!),
        ],
      ),
    );
  }

  Widget _buildServiceDeskCard(Map<String, String> contact) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            contact['title']!,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          _buildPhoneRow('Çağrı Merkezi:', contact['phone']!),
          const SizedBox(height: 8),
          _buildInfoRow(Icons.email_outlined, contact['email']!),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.white70, size: 20),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPhoneRow(String label, String phone) {
    return InkWell(
      onTap: () => _launchPhone(phone.replaceAll(RegExp(r'[^\d+]'), '')),
      child: Row(
        children: [
          Icon(Icons.phone_outlined, color: Colors.white70, size: 20),
          const SizedBox(width: 8),
          Text(
            '$label ',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white70,
            ),
          ),
          Text(
            phone,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialButton(IconData icon, VoidCallback onPressed) {
    return IconButton(
      icon: Icon(icon, color: Colors.white, size: 30),
      onPressed: onPressed,
    );
  }
}
