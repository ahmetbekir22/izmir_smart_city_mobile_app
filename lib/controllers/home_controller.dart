import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_city_app/features/auth/views/eczane_pages/eczane_home_screen.dart';
import 'package:smart_city_app/features/auth/views/pazar_yeri_pages/pazar_yeri_home_screen.dart';
import '../features/auth/views/bisiklet_home_pages/bisiklet_home_screen.dart';
import '../features/auth/views/event_list.dart';
import '../features/auth/views/otopark_pages/otopark_home_screen.dart';

class HomeController extends GetxController {
  // Observables for UI state management
  var isExpanded = false.obs;
  var selectedCategoryIndex = 0.obs;
  double initialChildSize = 0.3; // Initial size for the draggable sheet

  // Controllers
  final DraggableScrollableController draggableController =
      DraggableScrollableController();
  final PageController pageController = PageController();

  @override
  void onInit() {
    super.onInit();
    draggableController.addListener(_handleScrollChange);
    pageController.addListener(_handlePageChange);
  }

  // Handles changes in the draggable sheet size
  void _handleScrollChange() {
    isExpanded.value = draggableController.size >= 0.5;
  }

  // Handles page change to update the selected category index
  void _handlePageChange() {
    int newIndex = pageController.page?.round() ?? 0;
    if (newIndex != selectedCategoryIndex.value) {
      selectedCategoryIndex.value = newIndex;
    }
  }

  // Expands or collapses the draggable sheet
  void expandDraggableSheet() {
    draggableController.animateTo(
      isExpanded.value ? initialChildSize : 0.8,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  // Updates the selected category and scrolls to the corresponding page
  void onCategorySelected(int index) {
    selectedCategoryIndex.value = index;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (pageController.hasClients) {
        pageController.jumpToPage(index); // Ensures smooth navigation
      }
    });
  }

  // Handles API item tap based on the API key
  void handleApiTap(String apiKey) {
    switch (apiKey) {
      case 'KULTUR_SANAT_ETKINLILERI_API':
        // Navigate to the event list page
        Get.to(() => EtkinlikListesiSayfasi());
        break;
      case 'NOBETCI_ECZANE_API':
        Get.to(() => const EczaneHomeScreen());
      case 'SEMT_PAZAR_API':
        Get.to(() => const PazarYeriHomeScreen());
      case 'BISIKLET_ISTASYONLARI':
        Get.to(() => BisikletHomeScreen());
      case 'OTOPARK_API':
        Get.to(() => OtoparkHomeScreen());

      default:
        // Handle undefined API key (display placeholder page)
        Get.to(() => PlaceholderPage());
        break;
    }
  }
}

// Placeholder page for unimplemented API keys
class PlaceholderPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Placeholder Sayfası"),
      ),
      body: const Center(
        child: Text(
          "Bu sayfa henüz geliştirilmedi.",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
