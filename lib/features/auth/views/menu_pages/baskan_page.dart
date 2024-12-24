import 'package:flutter/material.dart';

class BaskanPage extends StatelessWidget {
  const BaskanPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('BAŞKAN', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: SingleChildScrollView(
        child: Container(
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
          child: Column(
            children: [
              const SizedBox(height: 30),
              // Profil Resmi
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage('assets/images/cihathoca.jpeg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // İsim
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Dr. Öğr. Üyesi Cihat ÇETİNKAYA',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 30),
              // Özgeçmiş Metni
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  'Muğla Sıtkı Koçman Üniversitesi Mühendislik Fakültesi Yazılım Mühendisliği Bölümü\'nde öğretim üyesi olarak görev yapmaktadır. Lisans eğitimini 2008 yılında Pamukkale Üniversitesi Bilgisayar Mühendisliği Bölümü\'nde tamamladı. 2011 yılında Ege Üniversitesi Fen Bilimleri Enstitüsü Uluslararası Bilgisayar alanında yüksek lisansını ve 2017 yılında aynı kurumda doktorasını tamamladı. Yazılım Mühendisliği Anabilim Dalı\'nda akademik çalışmalarını sürdürmektedir.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.justify,
                ),
              ),
              const SizedBox(height: 30),
              // İletişim Bilgileri
              Container(
                margin: const EdgeInsets.all(24),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.email, color: Colors.white),
                        const SizedBox(width: 12),
                        Text(
                          'cihat@mu.edu.tr',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Icon(Icons.phone, color: Colors.white),
                        const SizedBox(width: 12),
                        Text(
                          '0252 2112066',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
