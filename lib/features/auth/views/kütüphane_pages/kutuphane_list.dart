import 'package:get/get.dart';
import 'package:smart_city_app/controllers/k%C3%BCt%C3%BCphane_controllers/kutuphane_controller.dart';
import 'package:smart_city_app/core/api/kütüphane_api/kutuphane_model.dart';
import 'package:smart_city_app/features/auth/views/base_list.dart';

class KutuphaneList extends BaseListPage<Onemliyer> {
  KutuphaneList()
      : super(
          title: 'Kütüphaneler',
          items: Get.put(KutuphaneController()).kutuphaneList,
          extractIlce: (kutuphane) => kutuphane.iLCE ?? '',
          extractMahalle: (kutuphane) => kutuphane.mAHALLE ?? '',
          extractAdi: (kutuphane) => kutuphane.aDI,
          extractEnlem: (kutuphane) => kutuphane.eNLEM,
          extractBoylam: (kutuphane) => kutuphane.bOYLAM,
        );
}
