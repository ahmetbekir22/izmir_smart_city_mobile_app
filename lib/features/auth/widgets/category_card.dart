// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// import '../../../controllers/theme_contoller.dart';

// class CategoryCard extends StatelessWidget {
//   final String title;
//   final String? imagePath;
//   final String? location;
//   final String? date;
//   final String? time;
//   final VoidCallback onTap;
//   final bool isNetworkImage;
//   final String? category;
//   final double? height;

//   const CategoryCard({
//     super.key,
//     required this.title,
//     required this.imagePath,
//     this.location,
//     this.date,
//     this.time,
//     required this.onTap,
//     this.isNetworkImage = false,
//     this.category,
//     this.height,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final ThemeController themeController = Get.find<ThemeController>();

//     return GestureDetector(
//       onTap: onTap,
//       child: Card(
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(12),
//         ),
//         elevation: 10,
//         clipBehavior: Clip.antiAlias,
//         child: Padding(
//           padding: EdgeInsets.symmetric(
//               horizontal: Get.width * 0.02,
//               vertical:
//                   Get.height * 0.01), // Daha fazla boşluk için padding ekledik
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               // Küçültülmüş Resim
//               isNetworkImage
//                   ? Image.network(
//                       imagePath ?? '',
//                       fit: BoxFit.cover,
//                       width: 110, // Resmin genişliğini belirttik
//                       height: 110, // Resmin yüksekliğini belirttik
//                     )
//                   : Image.asset(
//                       imagePath ??
//                           'assets/images/Izmir-Rehberi-Gezilecek-Yerler.jpg',
//                       fit: BoxFit.cover,
//                       width: 110,
//                       height: 110,
//                     ),
//               const SizedBox(height: 16), // Resim ve metin arasında boşluk
//               // Metin Bilgileri (Alt kısma ve ortalı yerleştirildi)
//               Text(
//                 title,
//                 textAlign: TextAlign.center, // Ortalanmış metin
//                 style: TextStyle(
//                   color: themeController.isDarkTheme.value
//                       ? Colors.white
//                       : Colors.black,
//                   fontWeight: FontWeight.bold,
//                   fontSize: 18,
//                 ),
//               ),
//               if (date != null)
//                 Padding(
//                   padding: const EdgeInsets.only(top: 4.0),
//                   child: Text(
//                     date!,
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                       color: themeController.isDarkTheme.value
//                           ? Colors.white70
//                           : Colors.black87,
//                       fontSize: 14,
//                     ),
//                   ),
//                 ),
//               if (location != null)
//                 Padding(
//                   padding: const EdgeInsets.only(top: 4.0),
//                   child: Text(
//                     location!,
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                       color: themeController.isDarkTheme.value
//                           ? Colors.white70
//                           : Colors.black87,
//                       fontSize: 14,
//                     ),
//                   ),
//                 ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/theme_contoller.dart';

class CategoryCard extends StatelessWidget {
  final String title;
  final String? imagePath;
  final VoidCallback onTap;
  final bool isNetworkImage;
  final Widget? customContent; // Özel içerik için parametre
  final double? height;

  const CategoryCard({
    super.key,
    required this.title,
    required this.imagePath,
    required this.onTap,
    this.isNetworkImage = false,
    this.customContent, // Özel içerik parametresi
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find<ThemeController>();

    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 10,
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: Get.width * 0.02, vertical: Get.height * 0.01),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              isNetworkImage
                  ? Image.network(
                      imagePath ?? '',
                      fit: BoxFit.cover,
                      width: 110,
                      height: 110,
                    )
                  : Image.asset(
                      imagePath ?? 'assets/images/placeholder.jpg',
                      fit: BoxFit.cover,
                      width: 110,
                      height: 110,
                    ),
              SizedBox(height: Get.height * 0.015),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: themeController.isDarkTheme.value
                      ? Colors.white
                      : Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              if (customContent != null) ...[
                const SizedBox(height: 12),
                customContent!, // Özel içerik burada yer alacak
              ],
            ],
          ),
        ),
      ),
    );
  }
}
