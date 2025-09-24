import 'package:task_manager_app/base/base_view_model.dart';
import 'package:task_manager_app/dashboard/navigator/dashboard_navigator.dart';
import 'package:task_manager_app/dashboard/repo/dashboard_repo.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardViewModel extends BaseViewModel<DashboardNavigator, DashboardRepo> {
 static const String _taskPrefix = 'task_';
 static const String _taskIdsKey = 'task_ids';

 Future<List<Map<String, dynamic>>> getAllTasks() async {
  try {
   final prefs = await SharedPreferences.getInstance();
   List<String> taskIds = await _getTaskIds();
   tasks = []; // Create fresh list each time

   for (String taskId in taskIds) {
    String? taskJson = prefs.getString('$_taskPrefix$taskId');

    if (taskJson != null && taskJson.isNotEmpty) {
     try {
      Map<String, dynamic> task = Map<String, dynamic>.from(
          jsonDecode(taskJson)
      );
      tasks.add(task);
     } catch (e) {
      print('Error parsing task $taskId: $e');
      continue;
     }
    }
   }

   print('Loaded ${tasks.length} tasks');

   // Sort tasks by creation time (most recent first)
   tasks.sort((a, b) {
    String aCreated = a['createdAt']?.toString() ?? '';
    String bCreated = b['createdAt']?.toString() ?? '';
    return bCreated.compareTo(aCreated);
   });

   notifyListeners(); // Move this outside the loop
   return tasks;
  } catch (e) {
   print('Error loading all tasks: $e');
   return [];
  }
 }

// 2. Fix the markTaskCompleted method
 Future<bool> markTaskCompleted(String taskId, {bool completed = true}) async {
  try {
   final prefs = await SharedPreferences.getInstance();
   Map<String, dynamic>? existingTask = await getTaskById(taskId);

   if (existingTask == null) {
    getNavigator().showSuccessMessage('Task not found');
    return false;
   }

   existingTask['completed'] = completed;
   existingTask['completedAt'] = completed ? DateTime.now().toIso8601String() : null;
   existingTask['updatedAt'] = DateTime.now().toIso8601String();

   String taskJson = jsonEncode(existingTask);
   bool updated = await prefs.setString('$_taskPrefix$taskId', taskJson);

   if (updated) {
    String message = completed ? 'Task marked as completed' : 'Task marked as incomplete';
    getNavigator().showSuccessMessage(message);

    // Update the local tasks list
    int taskIndex = tasks.indexWhere((task) => task['id'] == taskId);
    if (taskIndex != -1) {
     tasks[taskIndex] = existingTask;
    }

    notifyListeners(); // Notify after updating local data
   }

   return updated;
  } catch (e) {
   print('Error marking task as completed: $e');
   getNavigator().showSuccessMessage('Failed to update task status');
   return false;
  }
 }

// 3. Fix the toggleTaskCompletion method
 Future<bool> toggleTaskCompletion(String taskId) async {
  try {
   Map<String, dynamic>? task = await getTaskById(taskId);

   if (task == null) {
    getNavigator().showSuccessMessage('Task not found');
    return false;
   }

   bool currentStatus = task['completed'] == true || task['completed'] == 'true';
   return await markTaskCompleted(taskId, completed: !currentStatus);
  } catch (e) {
   print('Error toggling task completion: $e');
   getNavigator().showSuccessMessage('Failed to toggle task status');
   return false;
  }
 }

// 4. Fix the saveTask method
 Future<bool> saveTask(Map<String, dynamic> task) async {
  try {
   final prefs = await SharedPreferences.getInstance();

   String taskId;
   if (task.containsKey('id') && task['id'] != null) {
    taskId = task['id'].toString();
   } else {
    taskId = DateTime.now().millisecondsSinceEpoch.toString();
    task['id'] = taskId;
   }

   if (!task.containsKey('title') || task['title'] == null || task['title'].toString().trim().isEmpty) {
    getNavigator().showSuccessMessage('Task title is required');
    return false;
   }

   task['title'] = task['title']?.toString() ?? '';
   task['description'] = task['description']?.toString() ?? '';
   task['dueDate'] = task['dueDate']?.toString() ?? '';
   task['completed'] = task['completed'] ?? false;
   task['createdAt'] = task['createdAt']?.toString() ?? DateTime.now().toIso8601String();

   String taskJson = jsonEncode(task);
   bool taskSaved = await prefs.setString('$_taskPrefix$taskId', taskJson);

   if (taskSaved) {
    await _addTaskIdToList(taskId);
    getNavigator().showSuccessMessage('Task Added Successfully');

    // Add to local tasks list
    tasks.add(task);
    notifyListeners();

    return true;
   }

   return false;
  } catch (e) {
   print('Error saving task: $e');
   getNavigator().showSuccessMessage('Failed to save task');
   return false;
  }
 }

// 5. Fix the deleteTask method
 Future<bool> deleteTask(String taskId) async {
  try {
   final prefs = await SharedPreferences.getInstance();
   bool taskRemoved = await prefs.remove('$_taskPrefix$taskId');

   if (taskRemoved) {
    await _removeTaskIdFromList(taskId);

    // Remove from local tasks list
    tasks.removeWhere((task) => task['id'] == taskId);

    getNavigator().showSuccessMessage('Task Deleted Successfully');
    notifyListeners();
    return true;
   }

   getNavigator().showSuccessMessage('Task not found');
   return false;
  } catch (e) {
   print('Error deleting task: $e');
   getNavigator().showSuccessMessage('Failed to delete task');
   return false;
  }
 }


 // Add task ID to the list of IDs
 Future<void> _addTaskIdToList(String taskId) async {
  try {
   final prefs = await SharedPreferences.getInstance();
   List<String> taskIds = await _getTaskIds();

   // Add ID if it doesn't exist
   if (!taskIds.contains(taskId)) {
    taskIds.add(taskId);
    await prefs.setStringList(_taskIdsKey, taskIds);
   }
  } catch (e) {
   print('Error adding task ID: $e');
  }
 }

 // Remove task ID from the list
 Future<void> _removeTaskIdFromList(String taskId) async {
  try {
   final prefs = await SharedPreferences.getInstance();
   List<String> taskIds = await _getTaskIds();

   taskIds.remove(taskId);
   await prefs.setStringList(_taskIdsKey, taskIds);
  } catch (e) {
   print('Error removing task ID: $e');
  }
 }

 // Get all task IDs
 Future<List<String>> _getTaskIds() async {
  try {
   final prefs = await SharedPreferences.getInstance();
   return prefs.getStringList(_taskIdsKey) ?? [];
  } catch (e) {
   print('Error getting task IDs: $e');
   return [];
  }
 }
 List<Map<String, dynamic>> tasks = [];
 // Fetch all tasks as a list

 // Get a single task by ID
 Future<Map<String, dynamic>?> getTaskById(String taskId) async {
  try {
   final prefs = await SharedPreferences.getInstance();
   String? taskJson = prefs.getString('$_taskPrefix$taskId');

   if (taskJson != null && taskJson.isNotEmpty) {
    return Map<String, dynamic>.from(jsonDecode(taskJson));
   }

   return null;
  } catch (e) {
   print('Error getting task by ID: $e');
   return null;
  }
 }

 // Update a single task
 Future<bool> updateTask(String taskId, Map<String, dynamic> updatedTask) async {
  try {
   final prefs = await SharedPreferences.getInstance();

   // Check if task exists
   if (prefs.containsKey('$_taskPrefix$taskId')) {
    // Ensure the task ID remains the same
    updatedTask['id'] = taskId;

    // Validate required fields
    if (!updatedTask.containsKey('title') || updatedTask['title'] == null || updatedTask['title'].toString().trim().isEmpty) {
     getNavigator().showSuccessMessage('Task title is required');
     return false;
    }

    // Ensure all fields exist
    updatedTask['title'] = updatedTask['title']?.toString() ?? '';
    updatedTask['description'] = updatedTask['description']?.toString() ?? '';
    updatedTask['dueDate'] = updatedTask['dueDate']?.toString() ?? '';
    updatedTask['updatedAt'] = DateTime.now().toIso8601String();

    String taskJson = jsonEncode(updatedTask);
    bool updated = await prefs.setString('$_taskPrefix$taskId', taskJson);

    if (updated) {
     getNavigator().showSuccessMessage('Task Updated Successfully');
    }

    return updated;
   }

   getNavigator().showSuccessMessage('Task not found');
   return false; // Task doesn't exist
  } catch (e) {
   print('Error updating task: $e');
   getNavigator().showSuccessMessage('Failed to update task');
   return false;
  }
 }



 // Clear all tasks
 Future<bool> clearAllTasks() async {
  try {
   final prefs = await SharedPreferences.getInstance();
   List<String> taskIds = await _getTaskIds();

   // Remove all individual tasks
   for (String taskId in taskIds) {
    await prefs.remove('$_taskPrefix$taskId');
   }

   // Clear the task IDs list
   await prefs.remove(_taskIdsKey);

   getNavigator().showSuccessMessage('All tasks cleared');
   return true;
  } catch (e) {
   print('Error clearing all tasks: $e');
   getNavigator().showSuccessMessage('Failed to clear tasks');
   return false;
  }
 }

 // Get total number of tasks
 Future<int> getTaskCount() async {
  List<String> taskIds = await _getTaskIds();
  return taskIds.length;
 }

 // Check if a task exists
 Future<bool> taskExists(String taskId) async {
  try {
   final prefs = await SharedPreferences.getInstance();
   return prefs.containsKey('$_taskPrefix$taskId');
  } catch (e) {
   print('Error checking task existence: $e');
   return false;
  }
 }

 // Helper method to create a new task map with proper structure
 Map<String, dynamic> createTaskMap({
  required String title,
  String? description,
  String? dueDate,
  String? id,
 }) {
  return {
   'id': id ?? DateTime.now().millisecondsSinceEpoch.toString(),
   'title': title,
   'description': description ?? '',
   'dueDate': dueDate ?? '',
   'createdAt': DateTime.now().toIso8601String(),
  };
 }

 // Get tasks filtered by completion status (if you plan to add this field later)
 Future<List<Map<String, dynamic>>> getTasksByStatus({bool? completed}) async {
  List<Map<String, dynamic>> allTasks = await getAllTasks();

  if (completed == null) return allTasks;

  return allTasks.where((task) {
   bool taskCompleted = task['completed'] == true || task['completed'] == 'true';
   return taskCompleted == completed;
  }).toList();
 }


}