import 'package:get/get.dart';

class GenericFilterController<T> extends GetxController {
  // List to store the original unfiltered items
  final RxList<T> originalList = <T>[].obs;
  
  // List to store filtered items
  final RxList<T> filteredList = <T>[].obs;
  
  // Lists to store unique filter options
  final RxList<String> ilceler = <String>[].obs;
  final RxList<String> mahalleler = <String>[].obs;
  
  // Selected filter values
  final RxString selectedIlce = ''.obs;
  final RxString selectedMahalle = ''.obs;
  
  // Function to extract ilce from an item
  String Function(T item) extractIlce;
  
  // Function to extract mahalle from an item
  String Function(T item) extractMahalle;

  // Constructor with required extraction functions
  GenericFilterController({
    required this.extractIlce,
    required this.extractMahalle,
  });

  // Initialize filter data
  void initializeFilterData(List<T> data) {
    originalList.assignAll(data);
    
    // Extract unique ilçeler and mahalleler
    ilceler.assignAll(
      data.map((item) => extractIlce(item)).toSet().toList()
    );
    
    mahalleler.assignAll(
      data.map((item) => extractMahalle(item)).toSet().toList()
    );
  }

  // Filter list based on selected ilce and mahalle
  void filterList() {
    if (selectedIlce.value.isEmpty && selectedMahalle.value.isEmpty) {
      filteredList.assignAll(originalList);
      return;
    }
    
    filteredList.assignAll(
      originalList.where((item) {
        final matchesIlce = selectedIlce.value.isEmpty || 
            extractIlce(item) == selectedIlce.value;
        
        final matchesMahalle = selectedMahalle.value.isEmpty || 
            extractMahalle(item) == selectedMahalle.value;
        
        return matchesIlce && matchesMahalle;
      }).toList()
    );
  }

  // Reset filter to initial state
  void resetFilter() {
    selectedIlce.value = '';
    selectedMahalle.value = '';
    filteredList.assignAll(originalList);
  }

  // Update mahalle list based on selected ilce
  void updateMahalleList(List<T> allItems) {
    mahalleler.assignAll(
      allItems
        .where((item) => extractIlce(item) == selectedIlce.value)
        .map((item) => extractMahalle(item))
        .toSet()
        .toList()
    );
    selectedMahalle.value = '';
  }
}