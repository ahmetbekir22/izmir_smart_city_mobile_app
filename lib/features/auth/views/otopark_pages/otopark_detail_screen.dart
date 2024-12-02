import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:smart_city_app/core/coordiantes_calculations.dart';
import '../../../../controllers/theme_contoller.dart';
import '../../../../core/api/otopark_api/otopark_api_model.dart';

class OtoparkDetailScreen extends StatelessWidget {
  final ThemeController themeController = Get.find<ThemeController>();

  final ParkingModel otopark;

  OtoparkDetailScreen({Key? key, required this.otopark}) : super(key: key);

  final TextStyle _headerStyle =
      const TextStyle(fontWeight: FontWeight.bold, fontSize: 18);
  final TextStyle _infoStyle = const TextStyle(fontSize: 16);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          otopark.name, // Burada otopark adını doğrudan gösteriyoruz
          overflow: TextOverflow.ellipsis, // Başlık uzun olursa kesilir
          style: const TextStyle(fontSize: 18),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Obx(() => Icon(
                  themeController.isDarkTheme.value
                      ? Icons.dark_mode
                      : Icons.light_mode,
                  color: Get.theme.colorScheme.onPrimary,
                )),
            onPressed: themeController.toggleTheme,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildSectionWithIcon(
              icon: FontAwesomeIcons.squareParking,
              title: 'Genel Bilgiler',
              child: _buildHeader(),
            ),
            _buildSectionWithIcon(
              icon: FontAwesomeIcons.clock,
              title: 'Açılış Saatleri',
              child: _buildOpeningHours(),
            ),
            _buildSectionWithIcon(
              icon: FontAwesomeIcons.moneyCheckDollar,
              title: 'Ödeme Seçenekleri',
              child: _buildPaymentOptions(),
            ),
            _buildSectionWithIcon(
              icon: FontAwesomeIcons.universalAccess,
              title: 'Erişilebilirlik',
              child: _buildAccessibilityInfo(),
            ),
            _buildSectionWithIcon(
              icon: FontAwesomeIcons.car,
              title: 'Otopark Durumu',
              child: _buildOccupancyInfo(),
            ),
            _buildSectionWithIcon(
              icon: FontAwesomeIcons.bus,
              title: 'Ulaşım Bağlantıları',
              child: _buildTransportationInfo(),
            ),
            const SizedBox(height: 20),
            _buildMapButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          otopark.name,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(otopark.provider,
                style: _infoStyle.copyWith(color: Colors.grey)),
            Text(
              otopark.status == 'Opened' ? 'Açık' : 'Kapalı',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: otopark.status == 'Opened' ? Colors.green : Colors.red,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildOpeningHours() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: otopark.openingHours.toMap().entries.map((entry) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            children: [
              const FaIcon(FontAwesomeIcons.clock,
                  size: 18, color: Colors.blue),
              const SizedBox(width: 8),
              Text('${entry.key}: ${entry.value}', style: _infoStyle),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildPaymentOptions() {
    return Wrap(
      spacing: 20,
      runSpacing: 10,
      children: [
        if (otopark.payment.cash)
          _buildIconLabel(FontAwesomeIcons.moneyBillWave, 'Nakit'),
        if (otopark.payment.card)
          _buildIconLabel(FontAwesomeIcons.creditCard, 'Kart'),
        if (otopark.payment.sms)
          _buildIconLabel(FontAwesomeIcons.commentSms, 'SMS'),
      ],
    );
  }

  Widget _buildAccessibilityInfo() {
    return Column(
      children: [
        _buildInfoRow(FontAwesomeIcons.wheelchair, 'Engelli Erişimi',
            otopark.accessibility.disabled ? 'Var' : 'Yok'),
        _buildInfoRow(FontAwesomeIcons.gasPump, 'LPG Kabul',
            otopark.accessibility.lpgAllowed ? 'Evet' : 'Hayır'),
        _buildInfoRow(
          FontAwesomeIcons.leftRight,
          'Maks Genişlik',
          '${otopark.accessibility.maxWidth / 100} m',
        ),
      ],
    );
  }

  Widget _buildOccupancyInfo() {
    return Column(
      children: [
        _buildInfoRow(FontAwesomeIcons.circleCheck, 'Boş Alan',
            '${otopark.occupancy.total.free}'),
        _buildInfoRow(FontAwesomeIcons.circleXmark, 'Dolu Alan',
            '${otopark.occupancy.total.occupied}'),
      ],
    );
  }

  Widget _buildTransportationInfo() {
    return Column(
      children: [
        _buildInfoRow(FontAwesomeIcons.bus, 'Otobüs Durağı',
            otopark.poi.busStation ? 'Var' : 'Yok'),
        _buildInfoRow(FontAwesomeIcons.train, 'Metro Durağı',
            otopark.poi.metroStation ? 'Var' : 'Yok'),
      ],
    );
  }

  Widget _buildMapButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () {
          openMapWithCoordinates(
              otopark.lat.toString(), otopark.lng.toString());
        },
        icon: const FaIcon(FontAwesomeIcons.locationDot,
            color: Colors.black, size: 18),
        label: const Text('Haritada Gör',
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black)),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }

  Widget _buildSectionWithIcon({
    required IconData icon,
    required String title,
    required Widget child,
  }) {
    return Column(
      children: [
        Row(
          children: [
            FaIcon(icon, color: Colors.blue),
            const SizedBox(width: 10),
            Text(title, style: _headerStyle),
          ],
        ),
        const SizedBox(height: 16),
        child,
        const SizedBox(height: 20),
        const Divider(thickness: 1, color: Colors.grey),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildIconLabel(IconData icon, String label) {
    return Column(
      children: [
        FaIcon(icon, color: Colors.blue, size: 24),
        const SizedBox(height: 6),
        Text(label, style: _infoStyle),
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          FaIcon(icon, color: Colors.blue, size: 20),
          const SizedBox(width: 10),
          Expanded(child: Text(title, style: _infoStyle)),
          Text(
            value,
            style: _infoStyle.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
