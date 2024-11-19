import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' show parse;

class DataCleaningUtility {
  // HTML etiketlerinden ve özel karakterlerden temizler
  static String cleanHtmlText(String text) {
    // HTML etiketlerini temizle
    dom.Document document = parse(text);
    String cleanText = document.body?.text ?? "";

    // HTML karakterlerini düzgün hale getirme (örneğin, \u003C => < gibi)
    cleanText = _decodeHtmlEntities(cleanText);

    // Gereksiz satır başı ve sonu boşluklarını temizle
    cleanText = cleanText.trim();

    cleanText = cleanText.replaceAll(RegExp(r'\r\n|\r|\n'), ' ');

    return cleanText;
  }

  // HTML özel karakterlerini düzgün hale getirmek için yardımcı fonksiyon
  static String _decodeHtmlEntities(String text) {
    // Bu fonksiyon HTML karakter kodlarını decode eder
    return text.replaceAllMapped(RegExp(r'\\u([0-9A-Fa-f]{4})'), (match) {
      return String.fromCharCode(int.parse(match.group(1)!, radix: 16));
    });
  }

  // Tarih biçimlendirme (dd-MM-yyyy -> ISO format)
}
