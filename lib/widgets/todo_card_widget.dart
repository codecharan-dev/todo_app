// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// Widget todoCard(
//   BuildContext context, {
//   required int index,
//   required Map item,
//   required Function(Map) navigateToEditPage,
//   required Function(String) deleteById,
// }) {
//   final id = item["_id"] as String;
//   return Card(
//     margin: const EdgeInsets.all(8),
//     color: Colors.yellow.shade300,
//     child: ListTile(
//       leading: CircleAvatar(
//         backgroundColor: Colors.black,
//         child: Text(
//           "${index + 1}",
//           style: const TextStyle(color: Colors.white),
//         ),
//       ),
//       title: Text(
//         item["title"],
//         style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
//       ),
//       subtitle: Text(
//         item["description"],
//         style: TextStyle(fontSize: 15.sp, color: Colors.black),
//       ),
//       trailing: PopupMenuButton(
//         iconColor: Colors.black,
//         onSelected: (value) {
//           if (value == "edit") {
//             // Open the edit page
//             navigateToEditPage(item);
//           } else if (value == "delete") {
//             // Delete and remove the item
//             deleteById(id);
//           }
//         },
//         color: Colors.black,
//         itemBuilder: (context) {
//           return [
//             const PopupMenuItem(
//               value: "edit",
//               child: Text("Edit", style: TextStyle(color: Colors.white)),
//             ),
//             const PopupMenuItem(
//               value: "delete",
//               child: Text("Delete", style: TextStyle(color: Colors.white)),
//             ),
//           ];
//         },
//       ),
//     ),
//   );
// }
