import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../controllers/otopark_controller/otopark_controller.dart';
import '../../../../controllers/theme_contoller.dart';
import '../../../../core/api/otopark_api/otopark_api_model.dart';
import 'otopark_detail_screen.dart'; // Detay ekranını import et

class OtoparkHomeScreen extends StatelessWidget {
  OtoparkHomeScreen({Key? key}) : super(key: key);
  final ThemeController themeController = Get.find<ThemeController>();

  final ParkingController parkingController = Get.put(ParkingController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Otopark'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Obx(() => Icon(
                  themeController.isDarkTheme.value
                      ? Icons.dark_mode
                      : Icons.light_mode,
                  color: Get.theme.colorScheme.onPrimary,

                  //color: Theme.of(context).colorScheme.onPrimary,
                )),
            onPressed: themeController.toggleTheme,
          ),
        ],
      ),
      body: Obx(() {
        if (parkingController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        } else if (parkingController.parkingList.isEmpty) {
          return const Center(child: Text('Mevcut otopark bulunamadı.'));
        }

        return ListView.builder(
          itemCount: parkingController.parkingList.length,
          itemBuilder: (context, index) {
            ParkingModel otopark = parkingController.parkingList[index];

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    ListTile(
                      leading: const FaIcon(
                        FontAwesomeIcons.squareParking,
                        color: Colors.blueAccent,
                        size: 36,
                      ),
                      title: Text(
                        otopark.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      subtitle: Text(' ${otopark.provider}'),
                      trailing: const FaIcon(
                        FontAwesomeIcons.arrowRight,
                        color: Colors.grey,
                      ),
                      onTap: () {
                        // Otopark detay ekranına yönlendir
                        Get.to(() => OtoparkDetailScreen(otopark: otopark));
                      },
                    ),
                    const Divider(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildInfoTile(
                            icon: FontAwesomeIcons.carRear,
                            label: 'Boş Alan',
                            value: '${otopark.occupancy.total.free}',
                          ),
                          _buildInfoTile(
                            icon: FontAwesomeIcons.solidCircleCheck,
                            label: 'Durum',
                            value:
                                otopark.status == 'Opened' ? 'Açık' : 'Kapalı',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }

  Widget _buildInfoTile(
      {required IconData icon, required String label, required String value}) {
    return Column(
      children: [
        FaIcon(icon, color: Colors.teal),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(fontSize: 14, color: Colors.grey),
        ),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ],
    );
  }
}
