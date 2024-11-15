import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_city_app/features/auth/widgets/category_card.dart';

import '../../../controllers/home_controller.dart';
import '../../../controllers/theme_contoller.dart';
import '../../../core/categorize_apis.dart';
import '../widgets/custom_category_buttom.dart';
import '../widgets/category_card.dart';

class DraggableSheetPage extends StatelessWidget {
  final HomeController homeController;
  final ThemeController themeController;

  const DraggableSheetPage({
    super.key,
    required this.homeController,
    required this.themeController,
  });

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
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).colorScheme.shadow.withOpacity(0.5),
                blurRadius: 10,
              ),
            ],
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            physics: const ClampingScrollPhysics(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: homeController.expandDraggableSheet,
                  child: Padding(
                    padding: EdgeInsets.only(top: screenHeight * 0.01),
                    child: Obx(() => Icon(
                          homeController.isExpanded.value
                              ? Icons.keyboard_arrow_down
                              : Icons.keyboard_arrow_up,
                          color: Theme.of(context).colorScheme.onSurface,
                        )),
                  ),
                ),
                if (!homeController.isExpanded.value)
                  Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: screenHeight * 0.01),
                    child: Text(
                      "Hayatı Kolaylaştıran Hizmetler...",
                      style: TextStyle(
                        fontSize: 25,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
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
                        padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.01),
                        child: Obx(() {
                          bool isSelected =
                              homeController.selectedCategoryIndex.value ==
                                  index;
                          return CategoryButton(
                            label: categoryKeys[index],
                            backgroundColor: isSelected
                                ? Get.theme.colorScheme.primary
                                : Get.theme.colorScheme.surface,
                            textColor: isSelected
                                ? Get.theme.colorScheme.onPrimary
                                : Theme.of(context).colorScheme.onSurface,
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
                    var selectedCategory = categoryKeys[
                        homeController.selectedCategoryIndex.value];
                    var items = categorizedApis[selectedCategory] ?? [];

                    return GridView.builder(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.03,
                        vertical: screenHeight * 0.03,
                      ),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 20,
                        childAspectRatio: 12 / 14,
                      ),
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        return Flexible(
                          child: CategoryCard(
                            title: items[index].values.first,
                            imagePath: items[index]['imagePath'],
                            onTap: () {
                              homeController
                                  .handleApiTap(items[index].keys.first);
                            },
                          ),
                        );
                      },
                    );
                  }),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
