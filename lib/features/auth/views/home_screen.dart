// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// import '../../../controllers/category_controller.dart';

// class HomeScreen extends StatelessWidget {
//   final CategoryController categoryController = Get.put(CategoryController());

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Kategori Listesi"),
//       ),
//       body: Obx(() {
//         return GridView.builder(
//           padding: const EdgeInsets.all(16.0),
//           gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//             crossAxisCount: 2,
//             childAspectRatio: 3 / 2,
//             crossAxisSpacing: 10,
//             mainAxisSpacing: 10,
//           ),
//           itemCount: categoryController.categories.length,
//           itemBuilder: (context, index) {
//             final category = categoryController.categories[index];
//             return GestureDetector(
//               onTap: () => categoryController.onCategoryTap(category['name']!),
//               child: Card(
//                 elevation: 4,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Image.asset(
//                       category['image']!,
//                       height: 40,
//                       width: 40,
//                       fit: BoxFit.cover,
//                     ),
//                     const SizedBox(height: 8),
//                     Text(
//                       category['name']!,
//                       style: const TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           },
//         );
//       }),
//     );
//   }
// }
