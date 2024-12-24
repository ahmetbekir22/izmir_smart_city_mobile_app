import 'package:get/get.dart';
import 'package:smart_city_app/controllers/antik_yerler_controllers/antik_controller.dart';
import 'package:smart_city_app/core/api/antik_api/antik_model.dart';
import 'package:smart_city_app/features/auth/views/base_list.dart';

class AntikList extends BaseListPage<Onemliyer> {
  AntikList()
      : super(
          title: 'Antik Kentler',
          items: Get.put(AntikController()).antikList,
          extractIlce: (antik) => antik.iLCE ?? '',
          extractMahalle: (antik) => antik.mAHALLE ?? '',
          extractAdi: (antik) => antik.aDI,
          extractEnlem: (antik) => antik.eNLEM,
          extractBoylam: (antik) => antik.bOYLAM,
        );
}