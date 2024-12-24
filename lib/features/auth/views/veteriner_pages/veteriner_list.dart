import 'package:get/get.dart';
import 'package:smart_city_app/controllers/veteriner_controllers/veteriner_controller.dart';
import 'package:smart_city_app/core/api/veteriner_api/veteriner_model.dart';
import 'package:smart_city_app/features/auth/views/base_list.dart';

class VeterinerList extends BaseListPage<Onemliyer> {
  VeterinerList()
      : super(
          title: 'Veterinerler',
          items: Get.put(VeterinerController()).veterinerList,
          extractIlce: (veteriner) => veteriner.iLCE ?? '',
          extractMahalle: (veteriner) => veteriner.mAHALLE ?? '',
          extractAdi: (veteriner) => veteriner.aDI,
          extractEnlem: (veteriner) => veteriner.eNLEM,
          extractBoylam: (veteriner) => veteriner.bOYLAM,
        );
}