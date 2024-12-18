import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'afet_list.dart';
import 'harita_view.dart';

class DisasterAreasBeachesPage extends StatelessWidget {
  const DisasterAreasBeachesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Afet ve Plaj Bilgileri'),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.warning), text: 'Toplanma Alanları'),
              Tab(icon: Icon(Icons.beach_access), text: 'Plajlar Haritası'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            AfetList(),
            const PlajMapsView(),
          ],
        ),
      ),
    );
  }
}