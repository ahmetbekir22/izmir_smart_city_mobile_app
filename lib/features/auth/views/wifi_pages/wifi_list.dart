import 'package:get/get.dart';
import 'package:smart_city_app/controllers/wifi_controllers/wifi_controller.dart';
import 'package:smart_city_app/core/api/wifi_api/wifi_model.dart';
import 'package:smart_city_app/features/auth/views/base_list.dart';

class WifiList extends BaseListPage<Onemliyer> {
  WifiList()
      : super(
          title: 'Wifi Noktaları',
          items: Get.put(WifiController()).wifiList,
          extractIlce: (wifi) => wifi.iLCE ?? '',
          extractMahalle: (wifi) => wifi.mAHALLE ?? '',
          extractAdi: (wifi) => wifi.aDI,
          extractEnlem: (wifi) => wifi.eNLEM,
          extractBoylam: (wifi) => wifi.bOYLAM,
        );
}