import 'package:get/get.dart';
import 'package:smart_city_app/controllers/galeri%20salonlar%C4%B1_controllers/galeri_controller.dart';
import 'package:smart_city_app/core/api/galeri_api/galeri_model.dart';
import 'package:smart_city_app/features/auth/views/base_list.dart';

class GaleriList extends BaseListPage<Onemliyer> {
  GaleriList()
      : super(
          title: 'Galeri Salonları',
          items: Get.put(GaleriController()).galeriList,
          extractIlce: (galeri) => galeri.iLCE ?? '',
          extractMahalle: (galeri) => galeri.mAHALLE ?? '',
          extractAdi: (galeri) => galeri.aDI,
          extractEnlem: (galeri) => galeri.eNLEM,
          extractBoylam: (galeri) => galeri.bOYLAM,
        );
}