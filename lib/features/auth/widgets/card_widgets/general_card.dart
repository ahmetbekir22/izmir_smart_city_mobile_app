import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../custom_description.dart';

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

    return GestureDetector(
      onTap: onLocationTap,
      child: Card(
        color: theme.cardTheme.color,
        shadowColor: theme.cardTheme.shadowColor,
        elevation: theme.cardTheme.elevation,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
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
                    Row(
                      children: [
                        Icon(Icons.location_city, size: 16, color: theme.iconTheme.color),
                        const SizedBox(width: 10),
                        Text(
                          'İlçe: $ilce',
                          style: theme.textTheme.bodyMedium,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(FontAwesomeIcons.mapLocationDot, size: 16, color: theme.iconTheme.color),
                        const SizedBox(width: 10),
                        Text(
                          'Mahalle: $mahalle',
                          style: theme.textTheme.bodyMedium,
                        ),
                      ],
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
            ],
          ),
        ),
      ),
    );
  }
}
