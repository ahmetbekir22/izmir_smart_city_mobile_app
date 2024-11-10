import 'package:flutter/material.dart';

import '../../../core/api/events_model.dart';
import '../../../utils/data_cleaning_utility.dart';
import '../../../utils/generic_functions.dart';

class DetailEventScreen extends StatelessWidget {
  final Etkinlik etkinlik;
  const DetailEventScreen({super.key, required this.etkinlik});

  @override
  Widget build(BuildContext context) {
    String cleanedDescription = DataCleaningUtility.cleanHtmlText(etkinlik.kisaAciklama);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          etkinlik.adi,
          style: Theme.of(context).textTheme.titleLarge, // Temadan başlık stili
        ),
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
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              (loadingProgress.expectedTotalBytes ?? 1)
                          : null,
                    ),
                  );
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
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 10),
            Text(
              cleanedDescription,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 20),

            // Etkinlik Detayları Kartı
            Card(
              margin: EdgeInsets.zero,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Tür
                    _buildDetailRow(Icons.category, 'Etkinlik Türü', etkinlik.tur, context),

                    // Başlangıç ve Bitiş Tarihi (Tek Row)
                    _buildDetailRow(
                      Icons.date_range,
                      'Tarih Aralığı',
                      '${EventUtils.formatDate(etkinlik.etkinlikBaslamaTarihi)} - ${EventUtils.formatDate(etkinlik.etkinlikBitisTarihi)}',
                      context,
                    ),

                    // Ücret Durumu
                    _buildDetailRow(
                      Icons.money_off,
                      'Ücret Durumu',
                      etkinlik.ucretsizMi ? 'Ücretsiz' : 'Ücretli',
                      context,
                    ),

                    // Konum Bilgisi (Tıklanabilir Row)
                    GestureDetector(
                      onTap: () {
                        EventUtils.launchMap(etkinlik.etkinlikMerkezi);
                      },
                      child: _buildDetailRow(
                        Icons.location_on,
                        'Etkinlik Merkezi',
                        etkinlik.etkinlikMerkezi,
                        context,
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

  Widget _buildDetailRow(IconData icon, String label, String value, BuildContext context,
      {bool isLink = false}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.primary, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              '$label: $value',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: isLink ? Theme.of(context).colorScheme.secondary : null,
                    decoration: isLink ? TextDecoration.underline : null,
                    fontWeight: isLink ? FontWeight.w600 : FontWeight.normal,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
