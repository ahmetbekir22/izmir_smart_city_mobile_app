import 'package:get/get.dart';

class CategoryController extends GetxController {
  // Kategorilerimizi bir liste olarak tanımlıyoruz.
  final categories = [
    {
      'name': 'Kategori 1',
      'image': 'assets/Izmir-Rehberi-Gezilecek-Yerler.jpg'
    },
    {
      'name': 'Kategori 2',
      'image': 'assets/Izmir-Rehberi-Gezilecek-Yerler.jpg'
    },
    {
      'name': 'Kategori 3',
      'image': 'assets/Izmir-Rehberi-Gezilecek-Yerler.jpg'
    },
    {
      'name': 'Kategori 4',
      'image': 'assets/Izmir-Rehberi-Gezilecek-Yerler.jpg'
    },
    {
      'name': 'Kategori 5',
      'image': 'assets/Izmir-Rehberi-Gezilecek-Yerler.jpg'
    },
    {
      'name': 'Kategori 6',
      'image': 'assets/Izmir-Rehberi-Gezilecek-Yerler.jpg'
    },
  ].obs;

  // Kategoriye tıklandığında yapılacak işlemi tanımlayabilirsiniz.
  void onCategoryTap(String categoryName) {
    // Örnek olarak konsola yazdırma işlemi yapılabilir
    print('$categoryName kategorisine tıklandı.');
  }
}
