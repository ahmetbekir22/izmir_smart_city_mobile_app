import 'package:flutter/material.dart';

class CustomDescription extends StatelessWidget {
  final String? description;
  final int maxLength;
  final TextStyle? textStyle;

  const CustomDescription({
    Key? key,
    this.description,
    this.maxLength = 20,
    this.textStyle,
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

    if (description == null || description!.isEmpty) {
      return const SizedBox.shrink();
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.description, size: 16, color: theme.iconTheme.color),
        const SizedBox(width: 10),
        Text(
          'Açıklama: ',
          style: theme.textTheme.bodyMedium,
        ),
        Expanded(
          child: description!.length > maxLength
              ? GestureDetector(
                  onTap: () => _showDescriptionDialog(context, description!),
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '${description!.substring(0, maxLength)}... ',
                          style: theme.textTheme.bodyMedium,
                        ),
                        TextSpan(
                          text: 'Detayına Git...',
                          style: (textStyle ?? theme.textTheme.bodyMedium)
                              ?.copyWith(
                            color: theme.primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : Text(
                  description!,
                  style: textStyle ?? theme.textTheme.bodyMedium,
                ),
        ),
      ],
    );
  }
}
