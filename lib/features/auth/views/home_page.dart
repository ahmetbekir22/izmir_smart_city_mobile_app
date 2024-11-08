import 'package:flutter/material.dart';
import 'package:smart_city_app/features/auth/views/latest_events_screen.dart';

import '../widgets/custom_category_buttom.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isExpanded = false;
  int selectedCategoryIndex = 0;
  double initialChildSize = 0.3;
  final DraggableScrollableController _draggableController =
      DraggableScrollableController();
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _draggableController.addListener(_handleScrollChange);
    _pageController.addListener(_handlePageChange);
  }

  void _handleScrollChange() {
    setState(() {
      isExpanded = _draggableController.size >= 0.5;
    });
  }

  void _handlePageChange() {
    int newIndex = _pageController.page?.round() ?? 0;
    if (newIndex != selectedCategoryIndex) {
      setState(() {
        selectedCategoryIndex = newIndex;
      });
    }
  }

  void _expandDraggableSheet() {
    _draggableController.animateTo(
      isExpanded ? initialChildSize : 0.8,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('İzmir Smart City'),
        backgroundColor: const Color.fromARGB(255, 148, 136, 169),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              // Üstteki renkli poster kısmı
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [LatestEventsScreen()],
                ),
              ),
            ],
          ),

          // Sürüklenebilir alan
          DraggableScrollableSheet(
            controller: _draggableController,
            initialChildSize: initialChildSize,
            minChildSize: 0.18,
            maxChildSize: 0.9,
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 242, 245, 250),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromARGB(66, 138, 23, 23),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  controller: scrollController,
                  physics: const ClampingScrollPhysics(),
                  child: Column(
                    children: [
                      // Sürükleme göstergesi (Ok)
                      GestureDetector(
                        onTap: _expandDraggableSheet,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Icon(
                            isExpanded
                                ? Icons.keyboard_arrow_down
                                : Icons.keyboard_arrow_up,
                            color: Colors.grey,
                          ),
                        ),
                      ),

                      if (!isExpanded)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            "Hayatı Kolaylaştıran Hizmetler...",
                            style:
                                TextStyle(fontSize: 25, color: Colors.black54),
                            textAlign: TextAlign.center,
                          ),
                        ),

                      SizedBox(
                        height: 50,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: categories.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: CategoryButton(
                                label: categories[index],
                                icon: Icons.place, // Example icon
                                backgroundColor: selectedCategoryIndex == index
                                    ? const Color(0xFF448AFF)
                                    : Colors.grey[300]!,
                                textColor: selectedCategoryIndex == index
                                    ? Colors.white
                                    : Colors.black,
                                onPressed: () {
                                  setState(() {
                                    selectedCategoryIndex = index;
                                  });
                                  _pageController.jumpToPage(index);
                                },
                              ),
                            );
                          },
                        ),
                      ),

                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.90,
                        child: PageView.builder(
                          controller: _pageController,
                          itemCount: categories.length,
                          onPageChanged: (index) {
                            setState(() {
                              selectedCategoryIndex = index;
                            });
                          },
                          itemBuilder: (context, index) {
                            return GridView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              padding: const EdgeInsets.all(16),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 40,
                                mainAxisSpacing: 40,
                                childAspectRatio: 12 / 14,
                              ),
                              itemCount: 6,
                              itemBuilder: (context, cardIndex) {
                                return Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 10,
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Icon(
                                            Icons.place,
                                            size: 48,
                                            color: Colors.blueAccent,
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            '${categories[selectedCategoryIndex]} Kart $cardIndex',
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

final List<String> categories = [
  'Kategori 1',
  'Kategori 2',
  'Kategori 3',
  'Kategori 4',
  'Kategori 5',
];

final List<Widget> pages = [
  const Text('Sayfa 1'),
  const Text('Sayfa 2'),
  const Text('Sayfa 3'),
  const Text('Sayfa 4'),
  const Text('Sayfa 5'),
];
