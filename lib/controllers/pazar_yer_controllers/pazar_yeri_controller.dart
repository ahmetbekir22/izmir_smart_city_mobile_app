// import 'package:get/get.dart';
// import 'package:smart_city_app/controllers/map_controllers/map_controller.dart';

// import '../../core/api/pazarYeri/pazar_yeri_api_model.dart';
// import '../../core/api/pazarYeri/pazar_yeri_api_service.dart';

// class PazarYeriController extends GetxController {
//   var pazarYerleri = <Onemliyer>[].obs;
//   var filteredPazarYerleri = <Onemliyer>[].obs; // Filtrelenmiş pazar yerleri

//   var isLoading = false.obs;
//   final mapController = Get.put(MapController());

//   @override
//   void onInit() {
//     super.onInit();
//     fetchPazarYerleri();
//   }

//   void fetchPazarYerleri() async {
//     try {
//       isLoading(true);
//       var pazarYerleri = await PazarYeriApiService().getPazarYerleri();
//       this.pazarYerleri.value = pazarYerleri;
//       // Haritaya marker'ları ekle
//       mapController.addMarkers(
//         locations: pazarYerleri,
//         getLatitude: (location) => location.eNLEM ?? 0,
//         getLongitude: (location) => location.bOYLAM ?? 0,
//         getTitle: (location) => location.aDI ?? 'Bilinmeyen Konum',
//         getSnippet: (location) =>
//             '${location.mAHALLE ?? ''}, ${location.iLCE ?? ''}',
//       );
//     } finally {
//       isLoading(false);
//     }
//   }

//   String extractDay(String? description) {
//     if (description == null) return "Gün Bilinmiyor";

//     description = description.toLowerCase();

//     final days = [
//       "pazartesi",
//       "salı",
//       "çarşamba",
//       "perşembe",
//       "cuma",
//       "cumartesi",
//       "pazar"
//     ];

//     // Gün listesinden bir eşleşme ara
//     for (var day in days) {
//       if (description.contains(day)) {
//         return day[0].toUpperCase() + day.substring(1); // İlk harfi büyük yap
//       }
//     }

//     return "Gün Bilinmiyor"; // Hiçbir gün bulunamazsa
//   }

//   void filterByIlce(String region) {
//     filteredPazarYerleri.value =
//         pazarYerleri.where((pazar) => pazar.iLCE == region).toList();
//   }
// }

// // import 'package:get/get.dart';
// // import '../../core/api/pazarYeri/pazar_yeri_api_model.dart';
// // import '../../core/api/pazarYeri/pazar_yeri_api_service.dart';
// // import 'package:smart_city_app/controllers/map_controllers/map_controller.dart';

// // class PazarYeriController extends GetxController {
// //   final PazarYeriApiService apiService;
// //   final MapController mapController;

// //   /// Allow injecting mocks; fall back to real service & controller otherwise.
// //   PazarYeriController({
// //     PazarYeriApiService? apiService,
// //     MapController? mapController,
// //   })  : apiService = apiService ?? PazarYeriApiService(),
// //         mapController = mapController ?? Get.put(MapController());

// //   var pazarYerleri = <Onemliyer>[].obs;
// //   var filteredPazarYerleri = <Onemliyer>[].obs;
// //   var isLoading = false.obs;

// //   @override
// //   void onInit() {
// //     super.onInit();
// //     fetchPazarYerleri();
// //   }

// //   Future<void> fetchPazarYerleri() async {
// //     // 1) flip loading flag right away
// //     isLoading(true);

// //     try {
// //       // 2) attempt fetch
// //       final data = await apiService.getPazarYerleri();
// //       pazarYerleri.value = data;

// //       // 3) only on success do we add markers
// //       mapController.addMarkers(
// //         locations: data,
// //         getLatitude: (loc) => loc.eNLEM ?? 0,
// //         getLongitude: (loc) => loc.bOYLAM ?? 0,
// //         getTitle: (loc) => loc.aDI ?? 'Bilinmeyen Konum',
// //         getSnippet: (loc) => '${loc.mAHALLE ?? ''}, ${loc.iLCE ?? ''}',
// //       );
// //     } catch (e) {
// //       // swallow the exception so that future completes normally
// //       // (tests will see isLoading go back to false and pazarYerleri stay empty)
// //     } finally {
// //       // 4) always reset loading
// //       isLoading(false);
// //     }
// //   }

// //   String extractDay(String? description) {
// //     if (description == null) return "Gün Bilinmiyor";

// //     final lower = description.toLowerCase();
// //     const days = [
// //       "pazartesi",
// //       "salı",
// //       "çarşamba",
// //       "perşembe",
// //       "cuma",
// //       "cumartesi",
// //       "pazar"
// //     ];

// //     for (var day in days) {
// //       if (lower.contains(day)) {
// //         return day[0].toUpperCase() + day.substring(1);
// //       }
// //     }
// //     return "Gün Bilinmiyor";
// //   }

// //   void filterByIlce(String region) {
// //     filteredPazarYerleri.value =
// //         pazarYerleri.where((p) => p.iLCE == region).toList();
// //   }
// // }

// // import 'package:get/get.dart';
// // import 'package:smart_city_app/controllers/map_controllers/map_controller.dart';
// // import '../../core/api/pazarYeri/pazar_yeri_api_model.dart';
// // import '../../core/api/pazarYeri/pazar_yeri_api_service.dart';

// // class PazarYeriController extends GetxController {
// //   // 1) Dependencies injected so tests can pass mocks:
// //   final PazarYeriApiService _apiService;
// //   final MapController _mapController;

// //   PazarYeriController({
// //     PazarYeriApiService? apiService,
// //     MapController? mapController,
// //   })  : _apiService = apiService ?? PazarYeriApiService(),
// //         _mapController = mapController ?? Get.put(MapController());

// //   // 2) Observable state
// //   final pazarYerleri = <Onemliyer>[].obs;
// //   final filteredPazarYerleri = <Onemliyer>[].obs;
// //   final isLoading = false.obs;

// //   @override
// //   void onInit() {
// //     super.onInit();
// //     // ⚠️ Disabled automatic fetch here so tests stay in control:
// //     // fetchPazarYerleri();
// //   }

// //   /// Clears any old data, flips [isLoading], tries the (mockable)
// //   /// API call, then on success adds markers. Swallows errors.
// //   Future<void> fetchPazarYerleri() async {
// //     pazarYerleri.clear();
// //     isLoading(true);

// //     try {
// //       final data = await _apiService.getPazarYerleri();
// //       pazarYerleri.value = data;

// //       _mapController.addMarkers(
// //         locations: data,
// //         getLatitude: (loc) => loc.eNLEM ?? 0,
// //         getLongitude: (loc) => loc.bOYLAM ?? 0,
// //         getTitle: (loc) => loc.aDI ?? 'Bilinmeyen Konum',
// //         getSnippet: (loc) => '${loc.mAHALLE ?? ''}, ${loc.iLCE ?? ''}',
// //       );
// //     } catch (_) {
// //       // swallow so Future completes normally, and list stays empty
// //     } finally {
// //       isLoading(false);
// //     }
// //   }

// //   String extractDay(String? description) {
// //     if (description == null) return "Gün Bilinmiyor";
// //     final lower = description.toLowerCase();
// //     const days = [
// //       "pazartesi",
// //       "salı",
// //       "çarşamba",
// //       "perşembe",
// //       "cuma",
// //       "cumartesi",
// //       "pazar"
// //     ];
// //     for (var day in days) {
// //       if (lower.contains(day)) {
// //         return day[0].toUpperCase() + day.substring(1);
// //       }
// //     }
// //     return "Gün Bilinmiyor";
// //   }

// //   void filterByIlce(String region) {
// //     filteredPazarYerleri.value =
// //         pazarYerleri.where((p) => p.iLCE == region).toList();
// //   }
// // }

import 'package:get/get.dart';
import 'package:smart_city_app/controllers/map_controllers/map_controller.dart';
import '../../core/api/pazarYeri/pazar_yeri_api_model.dart';
import '../../core/api/pazarYeri/pazar_yeri_api_service.dart';

class PazarYeriController extends GetxController {
  // 1) Dependencies injected here; defaults preserve existing behavior.
  final PazarYeriApiService _apiService;
  final MapController _mapController;
  final bool _autoFetchOnInit;

  PazarYeriController({
    PazarYeriApiService? apiService,
    MapController? mapController,
    bool autoFetchOnInit = true,
  })  : _apiService = apiService ?? PazarYeriApiService(),
        _mapController = mapController ?? Get.put(MapController()),
        _autoFetchOnInit = autoFetchOnInit;

  // 2) Observable state
  final pazarYerleri = <Onemliyer>[].obs;
  final filteredPazarYerleri = <Onemliyer>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    // only auto‐fetch when we haven’t explicitly disabled it:
    if (_autoFetchOnInit) {
      fetchPazarYerleri();
    }
  }

  /// Clears any old data, sets loading, calls the (mockable) API,
  /// adds markers on success, swallows errors, and always stops loading.
  Future<void> fetchPazarYerleri() async {
    pazarYerleri.clear();
    isLoading(true);

    try {
      final data = await _apiService.getPazarYerleri();
      pazarYerleri.value = data;

      _mapController.addMarkers(
        locations: data,
        getLatitude: (loc) => loc.eNLEM ?? 0,
        getLongitude: (loc) => loc.bOYLAM ?? 0,
        getTitle: (loc) => loc.aDI ?? 'Bilinmeyen Konum',
        getSnippet: (loc) => '${loc.mAHALLE ?? ''}, ${loc.iLCE ?? ''}',
      );
    } catch (_) {
      // swallow: leave pazarYerleri empty and no exception escapes
    } finally {
      isLoading(false);
    }
  }

  String extractDay(String? description) {
    if (description == null) return "Gün Bilinmiyor";
    final lower = description.toLowerCase();
    const days = [
      "pazartesi",
      "salı",
      "çarşamba",
      "perşembe",
      "cuma",
      "cumartesi",
      "pazar"
    ];
    for (var day in days) {
      if (lower.contains(day)) {
        return day[0].toUpperCase() + day.substring(1);
      }
    }
    return "Gün Bilinmiyor";
  }

  void filterByIlce(String region) {
    filteredPazarYerleri.value =
        pazarYerleri.where((p) => p.iLCE == region).toList();
  }
}
