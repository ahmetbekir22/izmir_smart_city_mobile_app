import 'package:flutter/material.dart';

class GeneralCard extends StatelessWidget {
  final String adi;
  final String ilce;
  final String mahalle;
  final String? aciklama; // Opsiyonel aciklama alanı
  final VoidCallback? onLocationTap;

  const GeneralCard({
    Key? key,
    required this.adi,
    required this.ilce,
    required this.mahalle,
    this.aciklama,
    this.onLocationTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // Mevcut temayı almak için

    return Card(
      color: theme.cardTheme.color,
      shadowColor: theme.cardTheme.shadowColor,
      elevation: theme.cardTheme.elevation,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center, // Satır içeriğini dikey ortala
          children: [
            // Sol tarafta yer alan metin alanları
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    adi,
                    style: theme.textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'İlçe: $ilce',
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Mahalle: $mahalle',
                    style: theme.textTheme.bodyMedium,
                  ),
                  if (aciklama != null && aciklama!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      aciklama!,
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ],
              ),
            ),

            // Sağ tarafta yer alan konum butonu
            Center( // Sağdaki içeriği dikey ortalamak için
              child: GestureDetector(
                onTap: onLocationTap,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center, // İçeriği kendi ekseninde ortala
                  children: [
                    Icon(
                      Icons.location_on,
                      color: theme.iconTheme.color,
                      size: 29,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Konuma Git',
                      style: theme.textTheme.bodySmall,
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
}
