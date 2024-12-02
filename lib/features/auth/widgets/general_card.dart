import 'package:flutter/material.dart';
import 'custom_description.dart';

class GeneralCard extends StatelessWidget {
  final String adi;
  final String ilce;
  final String mahalle;
  final String? aciklama;
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
    final theme = Theme.of(context);

    return Card(
      color: theme.cardTheme.color,
      shadowColor: theme.cardTheme.shadowColor,
      elevation: theme.cardTheme.elevation,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
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
                    CustomDescription(
                      description: aciklama,
                      textStyle: theme.textTheme.bodySmall,
                    ),
                  ],
                ],
              ),
            ),
            Center(
              child: GestureDetector(
                onTap: onLocationTap,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
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
