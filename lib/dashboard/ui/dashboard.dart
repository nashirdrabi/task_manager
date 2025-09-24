import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager_app/commons.dart';
import 'package:task_manager_app/constants/constants.dart';
import 'package:task_manager_app/dashboard/navigator/dashboard_navigator.dart';
import 'package:task_manager_app/dashboard/ui/add_and_update_task.dart';
import 'package:task_manager_app/dashboard/viewmodel/dashboard_viewmodel.dart';
import 'package:task_manager_app/dashboard/widgets/task_card.dart';

import '../../base/base_state.dart';
import '../../models/task_model.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends BaseState<Dashboard, DashboardViewModel, DashboardNavigator>
    with SingleTickerProviderStateMixin
    implements DashboardNavigator {

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      // Refresh data when tab changes
      if (!_tabController.indexIsChanging) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Helper method to get pending tasks
  List<Map<String, dynamic>> getPendingTasks(List<Map<String, dynamic>> allTasks) {
    return allTasks.where((task) => !(task['completed'] == true || task['completed'] == 'true')).toList();
  }

  // Helper method to get completed tasks
  List<Map<String, dynamic>> getCompletedTasks(List<Map<String, dynamic>> allTasks) {
    return allTasks.where((task) => task['completed'] == true || task['completed'] == 'true').toList();
  }

  @override
  Widget buildBody() {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: getAssetImage('logo.png'),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1,
        title: const Text(
          'Task Manager',
          style: TextStyle(
            color: Colors.indigoAccent,
            fontWeight: FontWeight.bold,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              indicatorColor: Colors.indigoAccent,
              indicatorWeight: 3,
              labelColor: Colors.indigoAccent,
              unselectedLabelColor: Colors.grey.shade600,
              labelStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              unselectedLabelStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.normal,
              ),
              tabs: const [
                Tab(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.pending_actions, size: 20),
                      SizedBox(width: 8),
                      Text('Pending'),
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.check_circle, size: 20),
                      SizedBox(width: 8),
                      Text('Completed'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Consumer<DashboardViewModel>(
        builder: (context, vm, child) {
          final pendingTasks = getPendingTasks(vm.tasks);
          final completedTasks = getCompletedTasks(vm.tasks);

          return TabBarView(
            controller: _tabController,
            children: [
              // Pending Tasks Tab
              pendingTasks.isNotEmpty
                  ? RefreshIndicator(
                onRefresh: () async {
                  await viewModel.getAllTasks();
                },
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: pendingTasks.length,
                  itemBuilder: (context, index) => TaskCard(
                    taskId: pendingTasks[index]['id'],
                    title: pendingTasks[index]['title'] ?? '',
                    description: pendingTasks[index]['description'] ?? '',
                    status: pendingTasks[index]['completed'] ?? false,
                    dueDate: pendingTasks[index]['dueDate'] ?? '',
                    onComplete: (value) async {
                      await viewModel.toggleTaskCompletion(pendingTasks[index]['id']);
                      // Refresh the tasks after completion toggle
                      await viewModel.getAllTasks();
                    },
                    onEdit: (id) async {
          push(
          widget: TaskForm(
            initialData: TaskFormData(
              description: pendingTasks[index]['description'],
              dueDate: DateTime.parse(pendingTasks[index]['dueDate']),
              title: pendingTasks[index]['title']
            ),
          onSubmit: (String title, String description, DateTime dueDate) async {
          await viewModel.updateTask(
         pendingTasks[index]['id'].toString(),{
          'title': title,
          'description': description,
          'dueDate': dueDate.toIso8601String(),
          'completed': false
          });
                    }, formTitle: 'Edit Task',
                  ));})))


                  : const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.pending_actions,
                      size: 64,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'No pending tasks',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Add a new task to get started!',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),

              // Completed Tasks Tab
              completedTasks.isNotEmpty
                  ? RefreshIndicator(
                onRefresh: () async {
                  await viewModel.getAllTasks();
                },
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: completedTasks.length,
                  itemBuilder: (context, index) => TaskCard(
                    taskId: completedTasks[index]['id'],
                    title: completedTasks[index]['title'] ?? '',
                    description: completedTasks[index]['description'] ?? '',
                    status: completedTasks[index]['completed'] ?? false,
                    dueDate: completedTasks[index]['dueDate'] ?? '',
                    onComplete: (value) async {
                      await viewModel.toggleTaskCompletion(completedTasks[index]['id']);
                      // Refresh the tasks after completion toggle
                      await viewModel.getAllTasks();
                    },
                    onEdit: (id)  {

                    },
                  ),
                ),
              )
                  : const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.check_circle_outline,
                      size: 64,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'No completed tasks yet',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Complete some tasks to see them here!',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.indigoAccent,
        onPressed: () {
          push(
              widget: TaskForm(
                  onSubmit: (String title, String description, DateTime dueDate) async {
                    await viewModel.saveTask({
                      'title': title,
                      'description': description,
                      'dueDate': dueDate.toIso8601String(),
                      'completed': false
                    });
                    // Refresh tasks after adding
                    await viewModel.getAllTasks();
                  },
                  formTitle: 'Add Task'
              )
          );
        },
        tooltip: 'Add new task',
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  @override
  DashboardNavigator getNavigator() {
    return this;
  }

  @override
  PageIdentifier getPageIdentifier() {
    return PageIdentifier.dashboard;
  }

  @override
  void loadPageData({value}) {
    viewModel.getAllTasks();
  }
}