import 'package:flutter/material.dart';

import '../../../core/api/events_model.dart';
import '../../../utils/data_cleaning_utility.dart';
import '../../../utils/generic_functions.dart'; // EventUtils dosyasını import ettik

class DetailEventScreen extends StatelessWidget {
  final Etkinlik etkinlik;

  const DetailEventScreen({super.key, required this.etkinlik});

  @override
  Widget build(BuildContext context) {
    // Etkinlik açıklamasını temizleyelim
    String cleanedDescription = DataCleaningUtility.cleanHtmlText(etkinlik.kisaAciklama);

    return Scaffold(
      appBar: AppBar(
        title: Text(etkinlik.adi),
        backgroundColor: const Color.fromARGB(255, 144, 117, 190),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Etkinlik Resmi
            ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: Image.network(
                etkinlik.resim,
                fit: BoxFit.cover,
                width: double.infinity,
                height: 300,
                loadingBuilder:
                    (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  } else {
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                (loadingProgress.expectedTotalBytes ?? 1)
                            : null,
                      ),
                    );
                  }
                },
                errorBuilder: (context, error, stackTrace) {
                  return const Center(child: Icon(Icons.error, color: Colors.red, size: 50));
                },
              ),
            ),
            const SizedBox(height: 20),

            // Etkinlik Başlığı ve Kısa Açıklama
            Text(
              etkinlik.adi,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              cleanedDescription, // Temizlenmiş açıklama burada gösterilecek
              style: const TextStyle(
                fontSize: 18,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 20),

            // Etkinlik Detayları Kartı
            Card(
              margin: EdgeInsets.zero,
              elevation: 8,
              shadowColor: Colors.grey.withOpacity(0.3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Tür
                    _buildDetailRow(Icons.category, 'Etkinlik Türü', etkinlik.tur),

                    // Başlangıç ve Bitiş Tarihi (Tek Row)
                    _buildDetailRow(
                      Icons.date_range,
                      'Tarih Aralığı',
                      '${EventUtils.formatDate(etkinlik.etkinlikBaslamaTarihi)} - ${EventUtils.formatDate(etkinlik.etkinlikBitisTarihi)}',
                    ),

                    // Ücret Durumu
                    _buildDetailRow(
                      Icons.money_off,
                      'Ücret Durumu',
                      etkinlik.ucretsizMi ? 'Ücretsiz' : 'Ücretli',
                    ),

                    // Konum Bilgisi (Tıklanabilir Row)
                    GestureDetector(
                      onTap: () {
                        EventUtils.launchMap(
                            etkinlik.etkinlikMerkezi); // Harita fonksiyonunu çağırdık
                      },
                      child: _buildDetailRow(
                        Icons.location_on,
                        'Etkinlik Merkezi',
                        etkinlik.etkinlikMerkezi,
                        isLink: true,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Tek bir bilgi satırı için oluşturulan widget
  Widget _buildDetailRow(IconData icon, String label, String value, {bool isLink = false}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 3,
            offset: const Offset(0, 1), // gölgeleme etkisi
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color.fromARGB(255, 124, 116, 126), size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              '$label: $value',
              style: TextStyle(
                fontSize: 16,
                color: isLink ? const Color.fromARGB(255, 103, 122, 139) : Colors.black87,
                decoration: isLink ? TextDecoration.underline : TextDecoration.none,
                fontWeight: isLink ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
