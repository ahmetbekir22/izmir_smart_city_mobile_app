final Map<String, List<Map<String, String>>> categorizedApis = {
  'ACİL': [
    {'NOBETCI_ECZANE_API': 'Nöbetçi Eczaneler'},
    {'AFET_TOPLANMA_YERLERI_API': 'Afet Toplanma Alanları'},
  ],
  'Seyahat': [
    {'BISIKLET_ISTASYONLARI': 'Bisiklet İstasyonları'},
    {'OTOPARK_API': 'Otoparklar'},
    {'PLAJLAR_API': 'Plajlar'},
  ],
  'İhtiyaç': [
    {'WIFI_API': 'Ücretsiz Wi-Fi Alanları'},
    {'SEMT_PAZAR_API': 'Semt Pazarları'},
  ],
  'Kültür&Sanat': [
    {'KULTUR_SANAT_ETKINLILERI_API': 'Kültür ve Sanat Etkinlikleri'},
    {'GALERI_SALONLAR': 'Galeri Salonları'},
  ],
  'Tarihi Alanlar': [
    {'TARIHI_YAPILAR': 'Tarihi Yapılar'},
    {'ANTIK_KENTLER': 'Antik Kentler'},
  ],
  'Sağlık': [
    {'VETERINER_API': 'Veteriner Klinikler'},
  ],
};

final List<String> categoryKeys = categorizedApis.keys.toList();
