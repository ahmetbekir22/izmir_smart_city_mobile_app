import 'package:flutter/material.dart';

class GeneralCard extends StatelessWidget {
  final String adi;
  final String ilce;
  final String mahalle;
  final String? aciklama;
  final VoidCallback? onLocationTap;
  final int maxCharacterLength = 100; 

  const GeneralCard({
    Key? key,
    required this.adi,
    required this.ilce,
    required this.mahalle,
    this.aciklama,
    this.onLocationTap,
  }) : super(key: key);

  void _showDescriptionDialog(BuildContext context, String description) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Detaylı Açıklama'),
          content: SingleChildScrollView(
            child: Text(description),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Kapat'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

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
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Açıklama: ',
                          style: theme.textTheme.bodySmall,
                        ),
                        Expanded(
                          child: aciklama!.length > maxCharacterLength
                              ? GestureDetector(
                                  onTap: () => _showDescriptionDialog(
                                      context, aciklama!),
                                  child: RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text:
                                              '${aciklama!.substring(0, maxCharacterLength)}... ',
                                          style: theme.textTheme.bodySmall,
                                        ),
                                        TextSpan(
                                          text: 'Detayına Git',
                                          style: theme.textTheme.bodySmall
                                              ?.copyWith(
                                            color: theme.primaryColor,
                                            decoration:
                                                TextDecoration.underline,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : Text(
                                  aciklama!,
                                  style: theme.textTheme.bodySmall,
                                ),
                        ),
                      ],
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
