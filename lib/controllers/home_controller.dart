import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  var isExpanded = false.obs;
  var selectedCategoryIndex = 0.obs;
  double initialChildSize = 0.3;

  final DraggableScrollableController draggableController =
      DraggableScrollableController();
  final PageController pageController = PageController();

  @override
  void onInit() {
    super.onInit();
    draggableController.addListener(_handleScrollChange);
    pageController.addListener(_handlePageChange);
  }

  void _handleScrollChange() {
    isExpanded.value = draggableController.size >= 0.5;
  }

  void _handlePageChange() {
    int newIndex = pageController.page?.round() ?? 0;
    if (newIndex != selectedCategoryIndex.value) {
      selectedCategoryIndex.value = newIndex;
    }
  }

  void expandDraggableSheet() {
    draggableController.animateTo(
      isExpanded.value ? initialChildSize : 0.8,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void onCategorySelected(int index) {
    selectedCategoryIndex.value = index;
    pageController.jumpToPage(index);
  }
}
