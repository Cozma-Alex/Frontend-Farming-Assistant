// // lib/widgets/map_overview.dart
// import 'package:flutter/material.dart';
// import 'property_map_view.dart';
//
// class MapOverview extends StatelessWidget {
//   const MapOverview({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(16.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text(
//             'My farm map',
//             style: TextStyle(
//               fontSize: 24,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           const SizedBox(height: 16),
//
//           // Map Preview Container
//           InkWell(
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => const PropertyMapView()),
//               );
//             },
//             child: Container(
//               width: double.infinity,
//               height: 300, // Adjust as needed
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(20),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.1),
//                     blurRadius: 10,
//                     offset: const Offset(0, 4),
//                   ),
//                 ],
//               ),
//               // You can either show a static preview of the map here
//               // or a simplified version of PropertyMapView
//               child: const PropertyMapView(isPreview: true),
//             ),
//           ),
//
//           const SizedBox(height: 20),
//           // Legend
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               _buildLegendItem(Icons.grass, 'Field'),
//               _buildLegendItem(Icons.warehouse, 'Barn'),
//               _buildLegendItem(Icons.storage, 'Storage'),
//               _buildLegendItem(Icons.handyman, 'Tools'),
//             ],
//           ),
//           const SizedBox(height: 20),
//           // Location list
//           _buildLocationButton('Location 1'),
//           _buildLocationButton('Location 2'),
//           _buildLocationButton('Location 3'),
//           _buildLocationButton('Location 4'),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildLegendItem(IconData icon, String label) {
//     return Column(
//       children: [
//         Container(
//           padding: const EdgeInsets.all(8),
//           decoration: const BoxDecoration(
//             color: Color(0xFF31511E),
//             shape: BoxShape.circle,
//           ),
//           child: Icon(
//             icon,
//             color: Colors.white,
//             size: 20,
//           ),
//         ),
//         const SizedBox(height: 4),
//         Text(label),
//       ],
//     );
//   }
//
//   Widget _buildLocationButton(String label) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 12),
//       child: Container(
//         width: double.infinity,
//         height: 50,
//         decoration: BoxDecoration(
//           color: const Color(0xFF31511E),
//           borderRadius: BorderRadius.circular(25),
//         ),
//         child: Center(
//           child: Text(
//             label,
//             style: const TextStyle(
//               color: Colors.white,
//               fontSize: 16,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }