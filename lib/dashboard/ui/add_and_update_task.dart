import 'package:flutter/material.dart';

import '../../models/task_model.dart';




// Callback for submit
typedef OnTaskFormSubmit = void Function(String title, String description, DateTime dueDate);

// SRP: Separate widget only responsible for rendering the form
class TaskForm extends StatefulWidget {
  final TaskFormData? initialData;
  final OnTaskFormSubmit onSubmit;
  final String formTitle; // e.g. "Add Task" or "Edit Task"

  const TaskForm({
    Key? key,
    this.initialData,
    required this.onSubmit,
    required this.formTitle,
  }) : super(key: key);

  @override
  State<TaskForm> createState() => _TaskFormState();
}

class _TaskFormState extends State<TaskForm> {
  late TextEditingController _titleController;
  late TextEditingController _descController;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    print(widget.initialData);
    _titleController = TextEditingController(text: widget.initialData?.title ?? "");
    _descController = TextEditingController(text: widget.initialData?.description ?? "");
    _selectedDate = widget.initialData?.dueDate;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  // Function to pick date
  Future<void> _selectDueDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.light(
            primary: Colors.indigoAccent,
            onPrimary: Colors.white,
            onSurface: Colors.indigo,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.formTitle),
        backgroundColor: Colors.indigoAccent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Card(
          color: Colors.white,
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedContainer(
                  duration: Duration(milliseconds: 600),
                  curve: Curves.easeOutBack,
                  child: Icon(Icons.add_task, size: 46, color: Colors.indigoAccent),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: "Title",
                    labelStyle: TextStyle(color: Colors.indigoAccent),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.indigoAccent),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.indigoAccent, width: 2),
                    ),
                  ),
                ),
                SizedBox(height: 14),
                TextField(
                  controller: _descController,
                  maxLines: 2,
                  decoration: InputDecoration(
                    labelText: "Description",
                    labelStyle: TextStyle(color: Colors.indigo),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.indigo),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.indigoAccent, width: 2),
                    ),
                  ),
                ),
                SizedBox(height: 14),
                ListTile(
                  dense: true,
                  tileColor: Colors.indigoAccent.withOpacity(0.05),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  leading: Icon(Icons.calendar_today, color: Colors.indigoAccent),
                  title: Text(
                    _selectedDate == null
                        ? "Select Due Date"
                        : "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}",
                    style: TextStyle(
                      color: _selectedDate == null ? Colors.grey : Colors.indigoAccent,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  onTap: () => _selectDueDate(context),
                ),
                SizedBox(height: 22),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigoAccent,
                      elevation: 2,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: () {
                      widget.onSubmit(
                        _titleController.text,
                        _descController.text,
                        _selectedDate ?? DateTime.now(),
                      );

                      Navigator.pop(context);
                    },
                    child: Text(
                      widget.formTitle,
                      style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
