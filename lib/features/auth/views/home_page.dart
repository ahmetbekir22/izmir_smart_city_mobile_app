// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:smart_city_app/features/auth/views/latest_events_screen.dart';
// import '../../../controllers/theme_contoller.dart';
// import '../widgets/custom_category_buttom.dart';

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   _HomePageState createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   bool isExpanded = false;
//   int selectedCategoryIndex = 0;
//   double initialChildSize = 0.3;
//   final DraggableScrollableController _draggableController =
//       DraggableScrollableController();
//   final PageController _pageController = PageController();

//   @override
//   void initState() {
//     super.initState();
//     _draggableController.addListener(_handleScrollChange);
//     _pageController.addListener(_handlePageChange);
//   }

//   void _handleScrollChange() {
//     setState(() {
//       isExpanded = _draggableController.size >= 0.5;
//     });
//   }

//   void _handlePageChange() {
//     int newIndex = _pageController.page?.round() ?? 0;
//     if (newIndex != selectedCategoryIndex) {
//       setState(() {
//         selectedCategoryIndex = newIndex;
//       });
//     }
//   }

//   void _expandDraggableSheet() {
//     _draggableController.animateTo(
//       isExpanded ? initialChildSize : 0.8,
//       duration: const Duration(milliseconds: 500),
//       curve: Curves.easeInOut,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final ThemeController themeController = Get.put(ThemeController());

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('İzmir Smart City'),
//         backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
//         centerTitle: true,
//         actions: [
//           IconButton(
//             icon: Obx(() => Icon(
//                   themeController.isDarkTheme.value
//                       ? Icons.dark_mode
//                       : Icons.light_mode,
//                   color: themeController.isDarkTheme.value
//                       ? Colors.white
//                       : Colors.black,
//                 )),
//             onPressed: themeController.toggleTheme,
//           ),
//         ],
//       ),
//       body: Stack(
//         children: [
//           Column(
//             children: [
//               // Üstteki renkli poster kısmı
//               Container(
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//                 child: Column(
//                   children: [LatestEventsScreen()],
//                 ),
//               ),
//             ],
//           ),
//           // Sürüklenebilir alan
//           DraggableScrollableSheet(
//             controller: _draggableController,
//             initialChildSize: 0.6, // Default to 60% of the screen
//             minChildSize: 0.1, // Minimum size of 10% of the screen
//             maxChildSize: 0.9,
//             builder: (context, scrollController) {
//               return Container(
//                 decoration: BoxDecoration(
//                   color: themeController.isDarkTheme.value
//                       ? const Color.fromARGB(255, 30, 30, 30)
//                       : const Color.fromARGB(255, 242, 245, 250),
//                   borderRadius: const BorderRadius.only(
//                     topLeft: Radius.circular(20),
//                     topRight: Radius.circular(20),
//                   ),
//                   boxShadow: [
//                     BoxShadow(
//                       color: themeController.isDarkTheme.value
//                           ? Colors.black.withOpacity(0.5)
//                           : Colors.grey.withOpacity(0.5),
//                       blurRadius: 10,
//                     ),
//                   ],
//                 ),
//                 child: SingleChildScrollView(
//                   controller: scrollController,
//                   physics: const ClampingScrollPhysics(),
//                   child: Column(
//                     children: [
//                       GestureDetector(
//                         onTap: _expandDraggableSheet,
//                         child: Padding(
//                           padding: const EdgeInsets.only(top: 8.0),
//                           child: Icon(
//                             isExpanded
//                                 ? Icons.keyboard_arrow_down
//                                 : Icons.keyboard_arrow_up,
//                             color: themeController.isDarkTheme.value
//                                 ? Colors.white
//                                 : Colors.black,
//                           ),
//                         ),
//                       ),
//                       if (!isExpanded)
//                         Padding(
//                           padding: const EdgeInsets.symmetric(vertical: 8.0),
//                           child: Text(
//                             "Hayatı Kolaylaştıran Hizmetler...",
//                             style: TextStyle(
//                                 fontSize: 25,
//                                 color: themeController.isDarkTheme.value
//                                     ? Colors.white
//                                     : Colors.black),
//                             textAlign: TextAlign.center,
//                           ),
//                         ),
//                       SizedBox(
//                         height: 50,
//                         child: ListView.builder(
//                           scrollDirection: Axis.horizontal,
//                           itemCount: categories.length,
//                           itemBuilder: (context, index) {
//                             return Padding(
//                               padding:
//                                   const EdgeInsets.symmetric(horizontal: 8.0),
//                               child: CategoryButton(
//                                 label: categories[index],
//                                 icon: Icons.place,
//                                 backgroundColor: selectedCategoryIndex == index
//                                     ? const Color.fromARGB(255, 118, 165, 247)
//                                     : themeController.isDarkTheme.value
//                                         ? Colors.grey[700]!
//                                         : Colors.grey[300]!,
//                                 textColor: selectedCategoryIndex == index
//                                     ? Colors.white
//                                     : themeController.isDarkTheme.value
//                                         ? Colors.white
//                                         : Colors.black,
//                                 onPressed: () {
//                                   setState(() {
//                                     selectedCategoryIndex = index;
//                                   });
//                                   _pageController.jumpToPage(index);
//                                 },
//                               ),
//                             );
//                           },
//                         ),
//                       ),
//                       SizedBox(
//                         height: MediaQuery.of(context).size.height * 0.90,
//                         child: PageView.builder(
//                           controller: _pageController,
//                           itemCount: categories.length,
//                           onPageChanged: (index) {
//                             setState(() {
//                               selectedCategoryIndex = index;
//                             });
//                           },
//                           itemBuilder: (context, index) {
//                             return GridView.builder(
//                               physics: const NeverScrollableScrollPhysics(),
//                               padding: const EdgeInsets.all(16),
//                               gridDelegate:
//                                   const SliverGridDelegateWithFixedCrossAxisCount(
//                                 crossAxisCount: 2,
//                                 crossAxisSpacing: 40,
//                                 mainAxisSpacing: 40,
//                                 childAspectRatio: 12 / 14,
//                               ),
//                               itemCount: 6,
//                               itemBuilder: (context, cardIndex) {
//                                 return Card(
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(12),
//                                   ),
//                                   elevation: 10,
//                                   color: themeController.isDarkTheme.value
//                                       ? Colors.grey[800]
//                                       : Colors.white,
//                                   child: Center(
//                                     child: Padding(
//                                       padding: const EdgeInsets.all(8.0),
//                                       child: Column(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.center,
//                                         children: [
//                                           Icon(
//                                             Icons.place,
//                                             size: 48,
//                                             color: themeController
//                                                     .isDarkTheme.value
//                                                 ? Colors.white
//                                                 : Colors.black,
//                                           ),
//                                           const SizedBox(height: 8),
//                                           Text(
//                                             '${categories[selectedCategoryIndex]} Kart $cardIndex',
//                                             style: TextStyle(
//                                               fontSize: 16,
//                                               fontWeight: FontWeight.w600,
//                                               color: themeController
//                                                       .isDarkTheme.value
//                                                   ? Colors.white
//                                                   : Colors.black,
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 );
//                               },
//                             );
//                           },
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }

// final List<String> categories = [
//   'Kategori 1',
//   'Kategori 2',
//   'Kategori 3',
//   'Kategori 4',
//   'Kategori 5',
// ];

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:smart_city_app/controllers/home_controller.dart';
// import 'package:smart_city_app/features/auth/views/latest_events_screen.dart';
// import '../../../controllers/theme_contoller.dart';
// import '../widgets/custom_category_buttom.dart';

// class HomePage extends StatelessWidget {
//   const HomePage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final HomeController homeController = Get.put(HomeController());
//     final ThemeController themeController = Get.put(ThemeController());

//     // Get screen size
//     double screenWidth = MediaQuery.of(context).size.width;
//     double screenHeight = MediaQuery.of(context).size.height;

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('İzmir Smart City'),
//         backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
//         centerTitle: true,
//         actions: [
//           IconButton(
//             icon: Obx(() => Icon(
//                   themeController.isDarkTheme.value
//                       ? Icons.dark_mode
//                       : Icons.light_mode,
//                   color: themeController.isDarkTheme.value
//                       ? Colors.white
//                       : Colors.black,
//                 )),
//             onPressed: themeController.toggleTheme,
//           ),
//         ],
//       ),
//       body: Stack(
//         children: [
//           Column(
//             children: [
//               // Üstteki renkli poster kısmı
//               Container(
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//                 child: LatestEventsScreen(),
//               ),
//             ],
//           ),
//           // Sürüklenebilir alan
//           DraggableScrollableSheet(
//             controller: homeController.draggableController,
//             initialChildSize: 0.6, // Default to 60% of the screen
//             minChildSize: 0.1, // Minimum size of 10% of the screen
//             maxChildSize: 0.9,
//             builder: (context, scrollController) {
//               return Container(
//                 decoration: BoxDecoration(
//                   color: themeController.isDarkTheme.value
//                       ? const Color.fromARGB(255, 30, 30, 30)
//                       : const Color.fromARGB(255, 242, 245, 250),
//                   borderRadius: const BorderRadius.only(
//                     topLeft: Radius.circular(20),
//                     topRight: Radius.circular(20),
//                   ),
//                   boxShadow: [
//                     BoxShadow(
//                       color: themeController.isDarkTheme.value
//                           ? Colors.black.withOpacity(0.5)
//                           : Colors.grey.withOpacity(0.5),
//                       blurRadius: 10,
//                     ),
//                   ],
//                 ),
//                 child: SingleChildScrollView(
//                   controller: scrollController,
//                   physics: const ClampingScrollPhysics(),
//                   child: Column(
//                     children: [
//                       GestureDetector(
//                         onTap: homeController.expandDraggableSheet,
//                         child: Padding(
//                           padding: EdgeInsets.only(
//                               top: screenHeight * 0.01), // Dynamic padding
//                           child: Icon(
//                             homeController.isExpanded.value
//                                 ? Icons.keyboard_arrow_down
//                                 : Icons.keyboard_arrow_up,
//                             color: themeController.isDarkTheme.value
//                                 ? Colors.white
//                                 : Colors.black,
//                           ),
//                         ),
//                       ),
//                       if (!homeController.isExpanded.value)
//                         Padding(
//                           padding: EdgeInsets.symmetric(
//                             vertical: screenHeight * 0.02, // Dynamic padding
//                           ),
//                           child: Text(
//                             "Hayatı Kolaylaştıran Hizmetler...",
//                             style: TextStyle(
//                                 fontSize:
//                                     screenWidth * 0.06, // Dynamic font size
//                                 color: themeController.isDarkTheme.value
//                                     ? Colors.white
//                                     : Colors.black),
//                             textAlign: TextAlign.center,
//                           ),
//                         ),
//                       SizedBox(
//                         height:
//                             screenHeight * 0.045, // Dynamic height for ListView
//                         child: ListView.builder(
//                           scrollDirection: Axis.horizontal,
//                           itemCount: categories.length,
//                           itemBuilder: (context, index) {
//                             return Padding(
//                               padding: EdgeInsets.symmetric(
//                                 horizontal:
//                                     screenWidth * 0.02, // Dynamic padding
//                               ),
//                               child: CategoryButton(
//                                 label: categories[index],
//                                 icon: Icons.place,
//                                 backgroundColor: homeController
//                                             .selectedCategoryIndex.value ==
//                                         index
//                                     ? const Color.fromARGB(255, 118, 165, 247)
//                                     : themeController.isDarkTheme.value
//                                         ? Colors.grey[700]!
//                                         : Colors.grey[300]!,
//                                 textColor: homeController
//                                             .selectedCategoryIndex.value ==
//                                         index
//                                     ? Colors.white
//                                     : themeController.isDarkTheme.value
//                                         ? Colors.white
//                                         : Colors.black,
//                                 onPressed: () {
//                                   homeController.selectedCategoryIndex.value =
//                                       index;
//                                   homeController.pageController
//                                       .jumpToPage(index);
//                                 },
//                               ),
//                             );
//                           },
//                         ),
//                       ),
//                       SizedBox(
//                         height:
//                             screenHeight * 0.70, // Dynamic height for PageView
//                         child: PageView.builder(
//                           controller: homeController.pageController,
//                           itemCount: categories.length,
//                           onPageChanged: (index) {
//                             homeController.selectedCategoryIndex.value = index;
//                           },
//                           itemBuilder: (context, index) {
//                             return GridView.builder(
//                               physics: const NeverScrollableScrollPhysics(),
//                               padding: EdgeInsets.all(
//                                   screenWidth * 0.04), // Dynamic padding
//                               gridDelegate:
//                                   SliverGridDelegateWithFixedCrossAxisCount(
//                                 crossAxisCount: 2,
//                                 crossAxisSpacing:
//                                     screenWidth * 0.05, // Dynamic spacing
//                                 mainAxisSpacing:
//                                     screenHeight * 0.05, // Dynamic spacing
//                                 childAspectRatio: 12 / 14,
//                               ),
//                               itemCount: 6,
//                               itemBuilder: (context, cardIndex) {
//                                 return Card(
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(12),
//                                   ),
//                                   elevation: 10,
//                                   color: themeController.isDarkTheme.value
//                                       ? Colors.grey[800]
//                                       : Colors.white,
//                                   child: Center(
//                                     child: Padding(
//                                       padding: EdgeInsets.all(screenWidth *
//                                           0.03), // Dynamic padding
//                                       child: Column(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.center,
//                                         children: [
//                                           Icon(
//                                             Icons.place,
//                                             size: screenWidth *
//                                                 0.12, // Dynamic size
//                                             color: themeController
//                                                     .isDarkTheme.value
//                                                 ? Colors.white
//                                                 : Colors.black,
//                                           ),
//                                           SizedBox(
//                                               height: screenHeight *
//                                                   0.01), // Dynamic spacing
//                                           Text(
//                                             '${categories[homeController.selectedCategoryIndex.value]} Kart $cardIndex',
//                                             style: TextStyle(
//                                               fontSize: screenWidth *
//                                                   0.04, // Dynamic font size
//                                               fontWeight: FontWeight.w600,
//                                               color: themeController
//                                                       .isDarkTheme.value
//                                                   ? Colors.white
//                                                   : Colors.black,
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 );
//                               },
//                             );
//                           },
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }

// final List<String> categories = [
//   'Kategori 1',
//   'Kategori 2',
//   'Kategori 3',
//   'Kategori 4',
//   'Kategori 5',
// ];
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_city_app/features/auth/views/latest_events_screen.dart';
import '../../../controllers/theme_contoller.dart';
import '../widgets/custom_category_buttom.dart';
import '../../../controllers/home_controller.dart'; // Import HomeController

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.put(ThemeController());
    final HomeController homeController =
        Get.put(HomeController()); // Get HomeController

    // Get screen size
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text('İzmir Smart City'),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Obx(() => Icon(
                  themeController.isDarkTheme.value
                      ? Icons.dark_mode
                      : Icons.light_mode,
                  color: themeController.isDarkTheme.value
                      ? Colors.white
                      : Colors.black,
                )),
            onPressed: themeController.toggleTheme,
          ),
        ],
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
                child: LatestEventsScreen(),
              ),
            ],
          ),
          // Sürüklenebilir alan
          DraggableScrollableSheet(
            controller: homeController.draggableController,
            initialChildSize: 0.6, // Default to 60% of the screen
            minChildSize: 0.1, // Minimum size of 10% of the screen
            maxChildSize: 0.9,
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: themeController.isDarkTheme.value
                      ? const Color.fromARGB(255, 30, 30, 30)
                      : const Color.fromARGB(255, 242, 245, 250),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: themeController.isDarkTheme.value
                          ? Colors.black.withOpacity(0.5)
                          : Colors.grey.withOpacity(0.5),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  controller: scrollController,
                  physics: const ClampingScrollPhysics(),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: homeController.expandDraggableSheet,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Obx(() => Icon(
                                homeController.isExpanded.value
                                    ? Icons.keyboard_arrow_down
                                    : Icons.keyboard_arrow_up,
                                color: themeController.isDarkTheme.value
                                    ? Colors.white
                                    : Colors.black,
                              )),
                        ),
                      ),
                      if (!homeController.isExpanded.value)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            "Hayatı Kolaylaştıran Hizmetler...",
                            style: TextStyle(
                                fontSize: 25,
                                color: themeController.isDarkTheme.value
                                    ? Colors.white
                                    : Colors.black),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      SizedBox(
                        height: screenHeight * 0.045,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: categories.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Obx(() {
                                bool isSelected = homeController
                                        .selectedCategoryIndex.value ==
                                    index;
                                return CategoryButton(
                                  label: categories[index],
                                  icon: Icons.place,
                                  backgroundColor: isSelected
                                      ? const Color.fromARGB(255, 118, 165, 247)
                                      : themeController.isDarkTheme.value
                                          ? Colors.grey[700]!
                                          : Colors.grey[300]!,
                                  textColor: isSelected
                                      ? Colors.white
                                      : themeController.isDarkTheme.value
                                          ? Colors.white
                                          : Colors.black,
                                  onPressed: () {
                                    homeController.onCategorySelected(index);
                                  },
                                );
                              }),
                            );
                          },
                        ),
                      ),
                      // GridView'ı kaydırılabilir hale getirme
                      SizedBox(
                        height: screenHeight * 0.60,
                        child: PageView.builder(
                          controller: homeController.pageController,
                          itemCount: categories.length,
                          onPageChanged: (index) {
                            homeController.selectedCategoryIndex.value = index;
                          },
                          itemBuilder: (context, index) {
                            return GridView.builder(
                              physics:
                                  const AlwaysScrollableScrollPhysics(), // Kaydırılabilir yapıyoruz
                              padding: EdgeInsets.symmetric(
                                horizontal: screenWidth * 0.03,
                                vertical: screenHeight * 0.03,
                              ),
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
                                  color: themeController.isDarkTheme.value
                                      ? Colors.grey[800]
                                      : Colors.white,
                                  child: Center(
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: screenWidth * 0.03,
                                        vertical: screenHeight * 0.02,
                                      ), // Dynamic padding
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.place,
                                            size: 48,
                                            color: themeController
                                                    .isDarkTheme.value
                                                ? Colors.white
                                                : Colors.black,
                                          ),
                                          SizedBox(
                                              height: screenHeight *
                                                  0.01), // Dynamic spacing
                                          Text(
                                            '${categories[homeController.selectedCategoryIndex.value]} Kart $cardIndex',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: themeController
                                                      .isDarkTheme.value
                                                  ? Colors.white
                                                  : Colors.black,
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
