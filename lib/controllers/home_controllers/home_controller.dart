import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_city_app/features/auth/views/eczane_pages/eczane_home_screen.dart';
import 'package:smart_city_app/features/auth/views/pazar_yeri_pages/pazar_yeri_home_screen.dart';
import 'package:smart_city_app/features/auth/views/toilet_view.dart';
import '../../features/auth/views/bisiklet_home_pages/bisiklet_home_screen.dart';
import '../../features/auth/views/afet_pages/afet_list.dart';
import '../../features/auth/views/event_pages/event_list.dart';
import '../../features/auth/views/otopark_pages/otopark_home_screen.dart';
import '../../features/auth/views/plaj_pages/plaj_list.dart';
import '../../features/auth/views/veteriner_pages/veteriner_list.dart';
import '../../features/auth/views/wifi_pages/wifi_list.dart';
import '../../features/auth/views/galeri_salonu_pages/galeri_list.dart';
import '../../features/auth/views/tarihi_yerler_pages/tarihi_list.dart';
import '../../features/auth/views/antik_kent_pages/antik_list.dart';
import '../../features/auth/views/kütüphane_pages/kutuphane_list.dart';
import '../toilet_binding.dart';



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
        Get.to(() => EtkinlikListesiSayfasi());
        break;
      case 'NOBETCI_ECZANE_API':
        Get.to(() => const EczaneHomeScreen());
      case 'SEMT_PAZAR_API':
        Get.to(() => PazarYeriHomeScreen());
      case 'BISIKLET_ISTASYONLARI':
        Get.to(() => BisikletHomeScreen());
      case 'OTOPARK_API':
        Get.to(() => OtoparkHomeScreen());
      case 'PLAJLAR_API':
        Get.to(() => PlajList());
        break;
      case 'WIFI_API':
        Get.to(() => WifiList());
        break;
      case 'VETERINER_API':
        Get.to(() => VeterinerList());
        break;
      case 'GALERI_SALONLAR': 
        Get.to(() => GaleriList());
        break;
      case 'TARIHI_YAPILAR': 
        Get.to(() => TarihiList());
        break;
      case 'ANTIK_KENTLER':
        Get.to(() => AntikList());
        break;
      case 'KUTUPHANE_API':
        Get.to(() => KutuphaneList());
        break;
      case 'AFET_TOPLANMA_YERLERI_API':
        Get.to(() => AfetList());
        break;
         case 'TUVALET_API':
        Get.to(
          () => const ToiletView(),
          binding: ToiletBinding(), // Binding'i burada ekliyoruz
        );
        break;
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
