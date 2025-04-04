import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../custom_description.dart';

class GeneralCard extends StatelessWidget {
  final String adi;
  final String ilce;
  final String mahalle;
  final String? gun;
  final String? aciklama;
  final String? telefon;
  final VoidCallback? onLocationTap;

  const GeneralCard({
    Key? key,
    required this.adi,
    required this.ilce,
    required this.mahalle,
    this.gun,
    this.aciklama,
    this.telefon,
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        child: Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10.0), // Köşelerin kavisli olmasını sağlar
    ),
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
                      Expanded(
                        child: Text(
                        'Mahalle: $mahalle',
                        style: theme.textTheme.bodyMedium,
                        overflow: TextOverflow.visible,
                        ),
                      ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    if (aciklama != null && aciklama!.isNotEmpty) ...[
                      CustomDescription(
                        description: aciklama,
                        textStyle: theme.textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 4),
                    ],
                    if (gun != null && gun!.isNotEmpty) ...[
                      Row(
                      children: [
                        Icon(FontAwesomeIcons.calendarDay, size: 16, color: theme.iconTheme.color),
                        const SizedBox(width: 10),
                        Text(
                        'Gün: $gun',
                        style: theme.textTheme.bodyMedium,
                        ),
                      ],
                      ),
                    ],
                    if (telefon != null && telefon!.isNotEmpty) ...[
                      GestureDetector(
                      onTap: () {
                        if (telefon != null && telefon!.isNotEmpty) {
                        launchUrl(Uri.parse('tel:$telefon'));
                        }
                      },
                      child: Row(
                        children: [
                        Icon(FontAwesomeIcons.phone, size: 16, color: theme.iconTheme.color),
                        const SizedBox(width: 10),
                        Text(
                          'Telefon: $telefon',
                          style: theme.textTheme.bodyLarge,
                        ),
                        ],
                      ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      ),
    );
  }
}
