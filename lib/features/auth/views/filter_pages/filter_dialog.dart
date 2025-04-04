import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_city_app/controllers/filter_controllers/filter_controller.dart';

class FilterDialog extends StatelessWidget {
  final FilterDialogController controller = Get.put(FilterDialogController());
  final ValueChanged<String?> onLocationSelected;
  final ValueChanged<String?> onTypeSelected;
  final ValueChanged<DateTimeRange?> onDateRangeSelected;

  FilterDialog({
    Key? key,
    required this.onLocationSelected,
    required this.onTypeSelected,
    required this.onDateRangeSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Dialog(
      backgroundColor: theme.scaffoldBackgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeader(theme, context),
            const SizedBox(height: 16),
            _buildFilterSection(context, 'Konum', _buildLocationDropdown(theme)),
            const SizedBox(height: 20),
            _buildFilterSection(context, 'Tür', _buildTypeDropdown(theme)),
            const SizedBox(height: 20),
            _buildFilterSection(context, 'Tarih Aralığı', _buildDateRange(context, theme)),
            const SizedBox(height: 24),
            Obx(() => controller.hasError.value 
              ? Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text(
                    'Seçilen kriterlere uygun etkinlik bulunamadı',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.red,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                )
              : const SizedBox.shrink()
            ),
            _buildActionButtons(context, theme),
          ],
        ),
      ),
    );
  }



  Widget _buildHeader(ThemeData theme, BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Filtrele',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.iconTheme.color,
              ),
            ),
            IconButton(
              icon: Icon(Icons.close, color: theme.iconTheme.color),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
        Divider(color: theme.primaryColor),
      ],
    );
  }

  Widget _buildFilterSection(BuildContext context, String title, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }

  Widget _buildLocationDropdown(ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.primaryColor),
        color: theme.cardColor,
      ),
      child: Obx(() {
        return DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            isExpanded: true,
            value: controller.selectedLocation.value,
            hint: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text('Konum seçiniz',
                style: theme.textTheme.bodyLarge?.copyWith(color: theme.hintColor),
              ),
            ),
            dropdownColor: theme.cardColor,
            items: controller.etkinlikController.getUniqueLocations().map((location) {
              return DropdownMenuItem<String>(
                value: location,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(location, style: theme.textTheme.bodyLarge),
                ),
              );
            }).toList(),
            onChanged: (value) => controller.selectedLocation.value = value,
          ),
        );
      }),
    );
  }

  Widget _buildTypeDropdown(ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.primaryColor),
        color: theme.cardColor,
      ),
      child: Obx(() {
        return DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            isExpanded: true,
            value: controller.selectedType.value,
            hint: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text('Tür seçiniz',
                style: theme.textTheme.bodyLarge?.copyWith(color: theme.hintColor),
              ),
            ),
            dropdownColor: theme.cardColor,
            items: controller.etkinlikController.getUniqueTypes().map((type) {
              return DropdownMenuItem<String>(
                value: type,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(type, style: theme.textTheme.bodyLarge),
                ),
              );
            }).toList(),
            onChanged: (value) => controller.selectedType.value = value,
          ),
        );
      }),
    );
  }

  Widget _buildDateRange(BuildContext context, ThemeData theme) {
    return Row(
      children: [
        Expanded(child: _buildDateButton('Başlangıç', controller.startDate, context, theme)),
        const SizedBox(width: 12),
        Expanded(
          child: _buildDateButton(
            'Bitiş',
            controller.endDate,
            context,
            theme,
            minDate: controller.startDate.value,
          ),
        ),
      ],
    );
  }

  Widget _buildDateButton(
    String label,
    Rxn<DateTime> date,
    BuildContext context,
    ThemeData theme, {
    DateTime? minDate,
  }) {
    return Obx(() {
      return InkWell(
        onTap: () => controller.showDatePickerDialog(context, label, date, theme, minDate: minDate),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: theme.primaryColor),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor),
              ),
              const SizedBox(height: 4),
              Text(
                date.value != null
                    ? '${date.value!.day}/${date.value!.month}/${date.value!.year}'
                    : 'Seçiniz',
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: date.value != null ? FontWeight.w500 : null,
                  color: date.value != null ? theme.textTheme.bodyLarge?.color : theme.hintColor,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildActionButtons(BuildContext context, ThemeData theme) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              side: BorderSide(color: theme.primaryColor),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              controller.resetFilters();
              onLocationSelected(null);
              onTypeSelected(null);
              onDateRangeSelected(null);
            },
            child: Text('Temizle', style: theme.textTheme.titleMedium?.copyWith(
                color: theme.iconTheme.color,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: theme.primaryColor,
              foregroundColor: theme.colorScheme.onPrimary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              if (controller.validateDates()) {
                onLocationSelected(controller.selectedLocation.value);
                onTypeSelected(controller.selectedType.value);
                onDateRangeSelected(controller.dateRange);
                Navigator.of(context).pop();
              }
            },
            child: Text(
              'Uygula',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onPrimary,
              ),
            ),
          ),
        ),
      ],
    );
  }

}