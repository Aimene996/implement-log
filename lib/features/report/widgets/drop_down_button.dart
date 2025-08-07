// import 'package:flutter/material.dart';

// const List<String> list = [
//   'Last 7 Days',
//   'Last 30 Days',
//   'This Month',
//   'Last Month',
//   'Custom',
// ];

// class DropdownButtonExample extends StatefulWidget {
//   const DropdownButtonExample({super.key});

//   @override
//   State<DropdownButtonExample> createState() => _DropdownButtonExampleState();
// }

// class _DropdownButtonExampleState extends State<DropdownButtonExample> {
//   String dropdownValue = list.first;

//   @override
//   Widget build(BuildContext context) {
//     return DropdownButton<String>(
//       value: dropdownValue,
//       // icon: const Icon(Icons.arrow_drop_down_outlined, color: Colors.white),
//       dropdownColor: const Color(0xFF1D2833),
//       underline: const SizedBox(),
//       onChanged: (String? value) {
//         if (value != null) {
//           setState(() {
//             dropdownValue = value;
//           });
//         }
//       },
//       items: list.map((value) {
//         return DropdownMenuItem<String>(
//           value: value,
//           child: Text(
//             value,
//             style: const TextStyle(
//               color: Colors.white,
//               fontSize: 16,
//               fontWeight: FontWeight.w400,
//             ),
//           ),
//         );
//       }).toList(),
//     );
//   }
// }
