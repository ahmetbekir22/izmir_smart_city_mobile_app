// draggable_sheet_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/home_controller.dart';
import '../../../controllers/theme_contoller.dart';
import '../widgets/custom_category_buttom.dart';
import '../widgets/custom_category_card.dart';
import '../../../core/categorize_apis.dart';

class DraggableSheetPage extends StatelessWidget {
  final HomeController homeController;
  final ThemeController themeController;

  const DraggableSheetPage({
    Key? key,
    required this.homeController,
    required this.themeController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return DraggableScrollableSheet(
      controller: homeController.draggableController,
      initialChildSize: 0.6,
      minChildSize: 0.1,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: themeController.isDarkTheme.value
                ? Get.theme.colorScheme.surface
                : Get.theme.colorScheme.surface,
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
                          color: themeController.isDarkTheme.value
                              ? Colors.white
                              : Colors.black,
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
                        padding:
                            EdgeInsets.symmetric(horizontal: screenWidth * 0.01),
                        child: Obx(() {
                          bool isSelected =
                              homeController.selectedCategoryIndex.value == index;
                          return CategoryButton(
                            label: categoryKeys[index],
                            icon: Icons.place,
                            backgroundColor: isSelected
                                ? themeController.isDarkTheme.value
                                    ? Get.theme.colorScheme.primary
                                    : Get.theme.colorScheme.secondary
                                : Colors.transparent,
                            textColor: isSelected
                                ? Colors.white
                                : themeController.isDarkTheme.value
                                    ? const Color(0xFF6200EE)
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
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 40,
                        mainAxisSpacing: 40,
                        childAspectRatio: 12 / 14,
                      ),
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        return CustomCard(
                          title: items[index].values.first,
                          imagePath: items[index]['imagePath'] ??
                              'assets/images/Izmir-Rehberi-Gezilecek-Yerler.jpg',
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
    );
  }
}