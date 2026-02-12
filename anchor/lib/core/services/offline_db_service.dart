// import 'package:isar/isar.dart';
// import 'package:path_provider/path_provider.dart';

// // --- IMPORT YOUR SCHEMAS HERE ---
// // You must import the generated files for every model you create.
// import '../../features/tasks/models/task_model.dart';
// // import '../../features/journal/models/journal_model.dart';

// class OfflineDbService {
//   late Isar _isar;

//   // Singleton Pattern (Ensures only one instance exists)
//   static final OfflineDbService _instance = OfflineDbService._internal();
//   factory OfflineDbService() => _instance;
//   OfflineDbService._internal();

//   /// Initialize the Local Database
//   Future<void> init() async {
//     final dir = await getApplicationDocumentsDirectory();
    
//     _isar = await Isar.open(
//       [
//         TaskSchema, 
//         // Add other schemas here: JournalSchema, HabitSchema
//       ], 
//       directory: dir.path,
//     );
//   }

//   // ====================================================================
//   // CRUD FUNCTIONS
//   // ====================================================================

//   /// CREATE / UPDATE
//   /// Isar uses 'put' for both. If the ID exists, it updates. If not, it creates.
//   /// 
//   /// Usage: await offlineDb.save('tasks', myTaskObject);
//   Future<void> save(String table, dynamic item) async {
//     await _isar.writeTxn(() async {
//       switch (table) {
//         case 'tasks':
//           await _isar.tasks.put(item as Task);
//           break;
        
//         // case 'journal':
//         //   await _isar.journal.put(item as JournalEntry);
//         //   break;
          
//         default:
//           throw Exception("Table '$table' not registered in OfflineDbService");
//       }
//     });
//   }

//   /// READ (All items in a table)
//   /// Usage: final allTasks = await offlineDb.readAll('tasks');
//   Future<List<dynamic>> readAll(String table) async {
//     switch (table) {
//       case 'tasks':
//         return await _isar.tasks.where().findAll();
      
//       // case 'journal':
//       //   return await _isar.journal.where().findAll();
        
//       default:
//         throw Exception("Table '$table' not registered in OfflineDbService");
//     }
//   }

//   /// READ (Single item by ID)
//   /// Usage: final task = await offlineDb.readById('tasks', 123);
//   Future<dynamic> readById(String table, int id) async {
//     switch (table) {
//       case 'tasks':
//         return await _isar.tasks.get(id);
      
//       default:
//         throw Exception("Table '$table' not registered in OfflineDbService");
//     }
//   }

//   /// DELETE
//   /// Usage: await offlineDb.delete('tasks', 123);
//   Future<void> delete(String table, int id) async {
//     await _isar.writeTxn(() async {
//       switch (table) {
//         case 'tasks':
//           await _isar.tasks.delete(id);
//           break;
          
//         default:
//           throw Exception("Table '$table' not registered in OfflineDbService");
//       }
//     });
//   }
  
//   /// CLEAR TABLE (Dangerous: Deletes everything in a table)
//   Future<void> clearTable(String table) async {
//     await _isar.writeTxn(() async {
//       switch (table) {
//         case 'tasks':
//           await _isar.tasks.clear();
//           break;
//         default:
//           throw Exception("Table '$table' not registered");
//       }
//     });
//   }
// }