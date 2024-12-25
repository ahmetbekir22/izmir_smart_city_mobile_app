import 'package:get/get.dart';
import 'package:smart_city_app/controllers/afet_controllers/afet_controller.dart';
import 'package:smart_city_app/core/api/afet_api/afet_model.dart';
import 'package:smart_city_app/features/auth/views/base_list.dart';

class AfetList extends BaseListPage<Onemliyer> {
  AfetList()
      : super(
          title: 'Afet Toplanma Alanları',
          items: Get.put(AfetController()).afetList,
          extractIlce: (afet) => afet.iLCE ?? '',
          extractMahalle: (afet) => afet.mAHALLE ?? '',
          extractAdi: (afet) => afet.aDI,
          extractEnlem: (afet) => afet.eNLEM,
          extractBoylam: (afet) => afet.bOYLAM,
        );
}