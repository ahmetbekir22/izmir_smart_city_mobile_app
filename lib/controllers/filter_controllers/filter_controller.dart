// FilterDialogController updates
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class FilterDialogController extends GetxController {
  final RxnString selectedLocation = RxnString(null);
  final RxnString selectedType = RxnString(null);
  final Rxn<DateTime> startDate = Rxn<DateTime>(null);
  final Rxn<DateTime> endDate = Rxn<DateTime>(null);

  void resetFilters() {
    selectedLocation.value = null;
    selectedType.value = null;
    startDate.value = null;
    endDate.value = null;
  }

  DateTimeRange? get dateRange {
    if (startDate.value != null && endDate.value != null) {
      return DateTimeRange(start: startDate.value!, end: endDate.value!);
    }
    return null;
  }
}