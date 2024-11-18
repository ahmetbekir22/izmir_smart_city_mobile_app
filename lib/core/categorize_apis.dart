// final Map<String, List<Map<String, String>>> categorizedApis = {
//   'ACİL': [
//     {'NOBETCI_ECZANE_API': 'Nöbetçi Eczaneler', 'imagePath': 'assets/images/eczane.png'},
//     {'AFET_TOPLANMA_YERLERI_API': 'Afet Toplanma Alanları'},
//   ],
//   'Seyahat': [
//     {'BISIKLET_ISTASYONLARI': 'Bisiklet İstasyonları'},
//     {'OTOPARK_API': 'Otoparklar'},
//     {'PLAJLAR_API': 'Plajlar'},
//   ],
//   'İhtiyaç': [
//     {'WIFI_API': 'Ücretsiz Wi-Fi Alanları'},
//     {'SEMT_PAZAR_API': 'Semt Pazarları'},
//   ],
//   'Kültür&Sanat': [
//     {'KULTUR_SANAT_ETKINLILERI_API': 'Kültür ve Sanat Etkinlikleri'},
//     {'GALERI_SALONLAR': 'Galeri Salonları'},
//   ],
//   'Tarihi Alanlar': [
//     {'TARIHI_YAPILAR': 'Tarihi Yapılar'},
//     {'ANTIK_KENTLER': 'Antik Kentler'},
//   ],
//   'Sağlık': [
//     {'VETERINER_API': 'Veteriner Klinikler'},
//   ],
// };

// final List<String> categoryKeys = categorizedApis.keys.toList();

final Map<String, List<Map<String, String>>> categorizedApis = {
  'ACİL': [
    {
      'NOBETCI_ECZANE_API': 'Nöbetçi Eczaneler',
      'imagePath': 'assets/images/eczane.png'
    },
    {
      'AFET_TOPLANMA_YERLERI_API': 'Afet Toplanma Alanları',
      'imagePath': 'assets/images/acil.png'
    },
  ],
  'Seyahat': [
    {
      'BISIKLET_ISTASYONLARI': 'Bisiklet İstasyonları',
      'imagePath': 'assets/images/bisiklet.png'
    },
    {'OTOPARK_API': 'Otoparklar', 'imagePath': 'assets/images/otopark.png'},
    {'PLAJLAR_API': 'Plajlar', 'imagePath': 'assets/images/plaj.png'},
  ],
  'İhtiyaç': [
    {
      'WIFI_API': 'Ücretsiz Wi-Fi Alanları',
      'imagePath': 'assets/images/wifi.jpg'
    },
    {
      'SEMT_PAZAR_API': 'Semt Pazarları',
      'imagePath': 'assets/images/semtpazarı.jpg'
    },
  ],
  'Kültür&Sanat': [
    {
      'KULTUR_SANAT_ETKINLILERI_API': 'Kültür ve Sanat Etkinlikleri',
      'imagePath': 'assets/images/4136007.jpg'
    },
    {
      'GALERI_SALONLAR': 'Galeri Salonları',
      'imagePath': 'assets/images/sanatgalerisi.png',
    },
  ],
  'Tarihi Alanlar': [
    {
      'TARIHI_YAPILAR': 'Tarihi Yapılar',
      'imagePath': 'assets/images/tarihiyapılar.png'
    },
    {
      'ANTIK_KENTLER': 'Antik Kentler',
      'imagePath': 'assets/images/antikkent.png'
    },
  ],
  'Sağlık': [
    {
      'VETERINER_API': 'Veteriner Klinikler',
      'imagePath': 'assets/images/veteriner.png'
    },
  ],
};

final List<String> categoryKeys = categorizedApis.keys.toList();
