import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_city_app/core/categorize_apis.dart';

import '../../../controllers/home_controller.dart';
import '../../../controllers/theme_contoller.dart';
import '../widgets/custom_category_buttom.dart';
import '../widgets/custom_category_card.dart';
import 'latest_events_screen.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.put(ThemeController());
    final HomeController homeController = Get.put(HomeController());

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text('İzmir Smart City'),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Obx(() => Icon(
                  themeController.isDarkTheme.value ? Icons.dark_mode : Icons.light_mode,
                  color: themeController.isDarkTheme.value ? Colors.white : Colors.black,
                )),
            onPressed: themeController.toggleTheme,
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: LatestEventsScreen(),
              ),
            ],
          ),
          // Sürüklenebilir alan
          DraggableScrollableSheet(
            controller: homeController.draggableController,
            initialChildSize: 0.6,
            minChildSize: 0.1,
            maxChildSize: 0.9,
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: themeController.isDarkTheme.value
                      ? const Color.fromARGB(255, 30, 30, 30)
                      : const Color.fromARGB(255, 242, 245, 250),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: themeController.isDarkTheme.value
                          ? Colors.black.withOpacity(0.5)
                          : Colors.grey.withOpacity(0.5),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  controller: scrollController,
                  physics: const ClampingScrollPhysics(),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: homeController.expandDraggableSheet,
                        child: Padding(
                          padding: EdgeInsets.only(top: screenHeight * 0.01),
                          child: Obx(() => Icon(
                                homeController.isExpanded.value
                                    ? Icons.keyboard_arrow_down
                                    : Icons.keyboard_arrow_up,
                                color:
                                    themeController.isDarkTheme.value ? Colors.white : Colors.black,
                              )),
                        ),
                      ),
                      if (!homeController.isExpanded.value)
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
                          child: Text(
                            "Hayatı Kolaylaştıran Hizmetler...",
                            style: TextStyle(
                                fontSize: 25,
                                color: themeController.isDarkTheme.value
                                    ? Colors.white
                                    : Colors.black),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      SizedBox(
                        height: screenHeight * 0.045,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: categorizedApis.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.01),
                              child: Obx(() {
                                bool isSelected =
                                    homeController.selectedCategoryIndex.value == index;
                                return CategoryButton(
                                  label: categoryKeys[index],
                                  icon: Icons.place,
                                  backgroundColor: isSelected
                                      ? const Color.fromARGB(255, 118, 165, 247)
                                      : themeController.isDarkTheme.value
                                          ? Colors.grey[700]!
                                          : Colors.grey[300]!,
                                  textColor: isSelected
                                      ? Colors.white
                                      : themeController.isDarkTheme.value
                                          ? Colors.white
                                          : Colors.black,
                                  onPressed: () {
                                    homeController.onCategorySelected(index);
                                  },
                                );
                              }),
                            );
                          },
                        ),
                      ),
                      // GridView for displaying category items
                      // SizedBox(
                      //   height: screenHeight * 0.60,
                      //   child: Obx(() {
                      //     var selectedCategory = categoryKeys[
                      //         homeController.selectedCategoryIndex.value];
                      //     var items = categorizedApis[selectedCategory] ?? [];
                      //     return GridView.builder(
                      //       padding: EdgeInsets.symmetric(
                      //         horizontal: screenWidth * 0.03,
                      //         vertical: screenHeight * 0.03,
                      //       ),
                      //       gridDelegate:
                      //           const SliverGridDelegateWithFixedCrossAxisCount(
                      //         crossAxisCount: 2,
                      //         crossAxisSpacing: 40,
                      //         mainAxisSpacing: 40,
                      //         childAspectRatio: 12 / 14,
                      //       ),
                      //       itemCount: items.length,
                      //       itemBuilder: (context, index) {
                      //         // Her API için başlık gösterimi
                      //         var itemTitle = items[index].values.first;
                      //         return Card(
                      //           shape: RoundedRectangleBorder(
                      //             borderRadius: BorderRadius.circular(12),
                      //           ),
                      //           elevation: 10,
                      //           color: themeController.isDarkTheme.value
                      //               ? Colors.grey[800]
                      //               : Colors.white,
                      //           child: Center(
                      //             child: Padding(
                      //               padding: EdgeInsets.symmetric(
                      //                 horizontal: screenWidth * 0.03,
                      //                 vertical: screenHeight * 0.02,
                      //               ),
                      //               child: Column(
                      //                 mainAxisAlignment:
                      //                     MainAxisAlignment.center,
                      //                 children: [
                      //                   Icon(
                      //                     Icons.place,
                      //                     size: 48,
                      //                     color:
                      //                         themeController.isDarkTheme.value
                      //                             ? Colors.white
                      //                             : Colors.black,
                      //                   ),
                      //                   SizedBox(
                      //                     height: screenHeight * 0.01,
                      //                   ),
                      //                   Text(
                      //                     itemTitle,
                      //                     style: TextStyle(
                      //                       fontSize: 16,
                      //                       fontWeight: FontWeight.w600,
                      //                       color: themeController
                      //                               .isDarkTheme.value
                      //                           ? Colors.white
                      //                           : Colors.black,
                      //                     ),
                      //                     textAlign: TextAlign.center,
                      //                   ),
                      //                 ],
                      //               ),
                      //             ),
                      //           ),
                      //         );
                      //       },
                      //     );
                      //   }),
                      // ),
                      SizedBox(
                        height: screenHeight * 0.60,
                        child: Obx(() {
                          var selectedCategory =
                              categoryKeys[homeController.selectedCategoryIndex.value];
                          var items = categorizedApis[selectedCategory] ?? [];

                          return GridView.builder(
                            padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.03,
                              vertical: screenHeight * 0.03,
                            ),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 40,
                              mainAxisSpacing: 40,
                              childAspectRatio: 12 / 14,
                            ),
                            itemCount: items.length,
                            itemBuilder: (context, index) {
                              return CustomCategoryCard(
                                title: items[index]
                                    .values
                                    .first, // API adını göstermemek için uygun bir isim
                                imagePath:
                                    'assets/images/eczane.png', // Her API'ye uygun bir resim yolu ayarlayabilirsiniz
                                onTap: () {
                                  homeController.handleApiTap(items[index].keys.first);
                                },
                              );
                            },
                          );
                        }),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
