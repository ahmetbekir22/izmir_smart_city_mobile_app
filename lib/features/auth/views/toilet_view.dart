// toilet_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_city_app/controllers/toilet_controller.dart';
import 'package:smart_city_app/core/api/toilet_model.dart';
import 'package:smart_city_app/features/auth/views/base_list.dart';


class ToiletListPage extends BaseListPage<Records> {
  ToiletListPage({Key? key}) : super(
    key: key,
    title: 'Akıllı Tuvaletler',
    items: Get.find<ToiletController>().toilets,
    extractIlce: (toilet) => toilet.iLCE ?? '',
    extractMahalle: (toilet) => toilet.mAHALLE ?? '',
    extractAdi: (toilet) => toilet.tESISADI,
    extractEnlem: (toilet) => toilet.eNLEM,
    extractBoylam: (toilet) => toilet.bOYLAM,
  );
}