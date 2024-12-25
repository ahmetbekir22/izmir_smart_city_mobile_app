import 'package:get/get.dart';
import 'package:smart_city_app/controllers/plaj_controllers/plaj_controller.dart';
import 'package:smart_city_app/core/api/plaj_api/plaj_model.dart';
import 'package:smart_city_app/features/auth/views/base_list.dart';

class PlajList extends BaseListPage<Onemliyer> {
  PlajList()
      : super(
          title: 'Plajlar',
          items: Get.put(PlajController()).plajList,
          extractIlce: (plaj) => plaj.iLCE ?? '',
          extractMahalle: (plaj) => plaj.mAHALLE ?? '',
          extractAdi: (plaj) => plaj.aDI,
          extractEnlem: (plaj) => plaj.eNLEM,
          extractBoylam: (plaj) => plaj.bOYLAM,
        );
}
