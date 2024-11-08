import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smart_city_app/core/api/events_model.dart';

class DetailEventScreen extends StatelessWidget {
  final Etkinlik etkinlik;

  DetailEventScreen({required this.etkinlik});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(etkinlik.adi),
        backgroundColor: const Color.fromARGB(255, 144, 117, 190),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Etkinlik Resmi
            ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: Image.network(
                etkinlik.resim,
                fit: BoxFit.cover,
                width: double.infinity,
                height: 250,
              ),
            ),
            const SizedBox(height: 20),

            // Kısa Açıklama
            Text(
              etkinlik.kisaAciklama,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 20),

            // Etkinlik Detayları Kartı
            Card(
              margin: EdgeInsets.zero,
              elevation: 3,
              shadowColor: Colors.grey.withOpacity(0.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Tür
                    _buildDetailRow(
                        Icons.category, 'Etkinlik Türü', etkinlik.tur),

                    // Başlangıç ve Bitiş Tarihi (Tek Row)
                    _buildDetailRow(
                      Icons.date_range,
                      'Tarih Aralığı',
                      '${_formatDate(etkinlik.etkinlikBaslamaTarihi)} - ${_formatDate(etkinlik.etkinlikBitisTarihi)}',
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
                        // onTap fonksiyonu burada tanımlanabilir
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

  // Tarih formatlama fonksiyonu
  String _formatDate(String date) {
    try {
      final DateTime parsedDate = DateTime.parse(date);
      final DateFormat formatter = DateFormat('dd MMMM yyyy - HH:mm');
      return formatter.format(parsedDate);
    } catch (e) {
      return date; // Hata durumunda orijinal tarihi döndür
    }
  }

  // Tek bir bilgi satırı için oluşturulan widget
  Widget _buildDetailRow(IconData icon, String label, String value,
      {bool isLink = false}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3), // gölgeleme etkisi
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
                color: isLink
                    ? const Color.fromARGB(255, 103, 122, 139)
                    : Colors.black87,
                decoration:
                    isLink ? TextDecoration.underline : TextDecoration.none,
                fontWeight: isLink ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
