import 'package:flutter/material.dart';

class CustomDescription extends StatelessWidget {
  final String? description;
  final int maxLength;
  final TextStyle? textStyle;

  const CustomDescription({
    Key? key,
    this.description,
    this.maxLength = 100,
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
        Text(
          'Açıklama: ',
          style: textStyle ?? theme.textTheme.bodySmall,
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
                          style: textStyle ?? theme.textTheme.bodySmall,
                        ),
                        TextSpan(
                          text: 'Detayına Git',
                          style: (textStyle ?? theme.textTheme.bodySmall)
                              ?.copyWith(
                            color: theme.primaryColor,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : Text(
                  description!,
                  style: textStyle ?? theme.textTheme.bodySmall,
                ),
        ),
      ],
    );
  }
}
