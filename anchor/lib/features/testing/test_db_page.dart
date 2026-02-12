// import 'package:flutter/material.dart';
// import '../../core/services/online_db_service.dart';

// class TestDbPage extends StatefulWidget {
//   const TestDbPage({super.key});

//   @override
//   State<TestDbPage> createState() => _TestDbPageState();
// }

// class _TestDbPageState extends State<TestDbPage> {
//   final OnlineDbService _db = OnlineDbService();
//   String _status = "Ready to test";
//   List<Map<String, dynamic>> _data = [];
//   String? _lastCreatedUuid; // To track the item we create

//   // 1. CREATE
//   void _testCreate() async {
//     setState(() => _status = "Creating...");
//     try {
//       // Create a dummy task
//       final newUuid = DateTime.now().millisecondsSinceEpoch.toString(); // Simple unique ID
//       await _db.create('tasks', {
//         'uuid': newUuid,
//         'title': 'Test Task $newUuid',
//         'is_completed': false,
//       });
      
//       setState(() {
//         _status = "Created Task: $newUuid";
//         _lastCreatedUuid = newUuid;
//       });
//       _testRead(); // Refresh list
//     } catch (e) {
//       setState(() => _status = "Error: $e");
//     }
//   }

//   // 2. READ
//   void _testRead() async {
//     setState(() => _status = "Reading...");
//     try {
//       final data = await _db.read('tasks');
//       setState(() {
//         _data = data;
//         _status = "Read ${data.length} items";
//       });
//     } catch (e) {
//       setState(() => _status = "Error: $e");
//     }
//   }

//   // 3. UPDATE
//   void _testUpdate() async {
//     if (_lastCreatedUuid == null) {
//       setState(() => _status = "Create an item first!");
//       return;
//     }

//     setState(() => _status = "Updating...");
//     try {
//       await _db.update('tasks', _lastCreatedUuid!, {
//         'title': 'UPDATED Task!',
//         'is_completed': true,
//       });
//       setState(() => _status = "Updated $_lastCreatedUuid");
//       _testRead(); // Refresh
//     } catch (e) {
//       setState(() => _status = "Error: $e");
//     }
//   }

//   // 4. DELETE
//   void _testDelete() async {
//     if (_lastCreatedUuid == null) {
//       setState(() => _status = "Create an item first!");
//       return;
//     }

//     setState(() => _status = "Deleting...");
//     try {
//       await _db.delete('tasks', _lastCreatedUuid!);
//       setState(() {
//         _status = "Deleted $_lastCreatedUuid";
//         _lastCreatedUuid = null;
//       });
//       _testRead(); // Refresh
//     } catch (e) {
//       setState(() => _status = "Error: $e");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Supabase Test Console")),
//       body: Column(
//         children: [
//           // STATUS BOX
//           Container(
//             width: double.infinity,
//             padding: const EdgeInsets.all(20),
//             color: Colors.black12,
//             child: Text(
//               _status,
//               style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//               textAlign: TextAlign.center,
//             ),
//           ),

//           const SizedBox(height: 20),

//           // BUTTONS
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               ElevatedButton(onPressed: _testCreate, child: const Text("Create")),
//               ElevatedButton(onPressed: _testRead, child: const Text("Read")),
//               ElevatedButton(onPressed: _testUpdate, child: const Text("Update")),
//               ElevatedButton(
//                 onPressed: _testDelete, 
//                 style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade100),
//                 child: const Text("Delete"),
//               ),
//             ],
//           ),

//           const Divider(height: 40),

//           // DATA LIST
//           Expanded(
//             child: ListView.builder(
//               itemCount: _data.length,
//               itemBuilder: (context, index) {
//                 final item = _data[index];
//                 return ListTile(
//                   title: Text(item['title'] ?? 'No Title'),
//                   subtitle: Text("UUID: ${item['uuid']}"),
//                   trailing: Icon(
//                     item['is_completed'] == true ? Icons.check_circle : Icons.circle_outlined,
//                     color: item['is_completed'] == true ? Colors.green : Colors.grey,
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }