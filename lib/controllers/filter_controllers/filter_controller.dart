import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart' as custom_picker;
import 'package:smart_city_app/controllers/etkinlik_api_controllers/event_controller.dart';

class FilterDialogController extends GetxController {
  final EtkinlikController etkinlikController = Get.find<EtkinlikController>();
  final RxnString selectedLocation = RxnString(null);
  final RxnString selectedType = RxnString(null);
  final Rxn<DateTime> startDate = Rxn<DateTime>(null);
  final Rxn<DateTime> endDate = Rxn<DateTime>(null);
  final RxBool hasError = false.obs;

  void resetFilters() {
    selectedLocation.value = null;
    selectedType.value = null;
    startDate.value = null;
    endDate.value = null;
    hasError.value = false;
  }

  bool validateDates() {
    if (startDate.value != null && endDate.value != null) {
      if (startDate.value!.isAfter(endDate.value!)) {
        Get.snackbar(
          'Hata',
          'Başlangıç tarihi bitiş tarihinden sonra olamaz',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
        return false;
      }
    }
    return true;
  }

  DateTimeRange? get dateRange {
    if (startDate.value == null && endDate.value == null) return null;
    
    return DateTimeRange(
      start: startDate.value ?? DateTime(2023, 1, 1),
      end: endDate.value ?? DateTime(2030, 12, 31)
    );
  }

  Future<void> showDatePickerDialog(
    BuildContext context,
    String label,
    Rxn<DateTime> date,
    ThemeData theme, {
    DateTime? minDate,
  }) async {
    final selectedDate = await custom_picker.DatePicker.showDatePicker(
      context,
      showTitleActions: true,
      minTime: minDate ?? DateTime(2023, 1, 1),
      maxTime: DateTime(2030, 12, 31),
      currentTime: date.value ?? DateTime.now(),
      locale: custom_picker.LocaleType.tr,
      theme: custom_picker.DatePickerTheme(
        backgroundColor: theme.scaffoldBackgroundColor,
        headerColor: theme.primaryColor,
        itemStyle: theme.textTheme.bodyLarge!,
        doneStyle: theme.textTheme.labelLarge!.copyWith(color: Colors.white),
        cancelStyle: theme.textTheme.labelLarge!.copyWith(color: Colors.white),
      ),
    );
    if (selectedDate != null) {
      date.value = selectedDate;
      hasError.value = false;
    }
  }
}