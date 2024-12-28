// lib/pages/task_page.dart
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:task_management/ui/widgets/text_widget.dart';
import '../bloc/bloc_task.dart';
import '../model/task_model.dart';
import '../my_theme.dart';
import '../theme_provider.dart';
import '../utility/colors.dart';
import '../utility/utils.dart';

class TaskPage extends StatefulWidget {
  @override
  _TaskPageState createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  final BlocTask _taskBloc = BlocTask();

  final TextEditingController _searchController = TextEditingController();
  String? _selectedStatusString;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _taskBloc.taskStream.listen((tasks) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _taskBloc.close();
    super.dispose();
  }

  Future<void> _selectDueDate(BuildContext context, DateTime _dueDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dueDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _dueDate) {
      setState(() {
        _dueDate = picked;
      });
    }
  }

  void _filterTasks() {
    setState(() {
      _searchQuery = _searchController.text.toLowerCase();
    });
  }

  void _applyColorFilter(String? status) {
      setState(() {
        _selectedStatusString = status;
      });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Management'),
        actions: [
          IconButton(
            icon: Icon(
              Provider.of<ThemeProvider>(context).isDarkMode
                  ? Icons.dark_mode
                  : Icons.light_mode,
            ),
            onPressed: () {
              Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
            },
          ),
          const SizedBox(height: 8),
          // Color Filter Dropdown
          DropdownButton<String>(
            value: _selectedStatusString,
            hint: const Text('Filter'),
            onChanged: _applyColorFilter,
            items: ['all', 'Pending', 'inProgress', 'Completed']
                .map((status) => DropdownMenuItem(
              value: status,
              child: Text(status),
            ))
                .toList(),
          ),
          const SizedBox(width: 8),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(80.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                // Search Bar
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search tasks',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onChanged: (value) => _filterTasks(),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ValueListenableBuilder<Box<TaskModel>>(
              valueListenable: Hive.box<TaskModel>('tasks').listenable(),
              builder: (context, box, _) {
                // Get all tasks from Hive
                final allTasks = box.values.toList().cast<TaskModel>();

                // Apply search filter
                final filteredTasks = allTasks.where((task) {
                  final matchesQuery = task.title
                      .toLowerCase()
                      .contains(_searchQuery.toLowerCase());
                  final matchesStatus = _selectedStatusString == null ||
                      _selectedStatusString == 'all' ||
                      task.status == _selectedStatusString.toString().toLowerCase();
                  return matchesQuery && matchesStatus;
                }).toList();

                return filteredTasks.isEmpty
                    ? const Center(
                  child: Text('No tasks found.'),
                )
                    : ListView.builder(
                  itemCount: filteredTasks.length,
                  itemBuilder: (context, index) {
                    final task = filteredTasks[index];
                    return ListTile(
                      title: Text(task.title),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Due: ${DateFormat('yyyy-MM-dd').format(task.dueDate)}'),
                          Text('Status: ${task.status}'),
                        ],
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => _taskBloc.deleteTask(task),
                      ),
                      onTap: () {
                        // Handle task editing or viewing
                        _showTaskForm(task);
                      },
                    );
                  },
                );
              },
            ),
          ),
          Container(
            margin: EdgeInsets.all(16),
            width: MediaQuery.of(context).size.width,
            child: ElevatedButtonTheme(
              data: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(MediaQuery.of(context).size.width, 50),
                ),
              ),
              child: ElevatedButton(
                child: TextWidget(
                  txt: "Add Task",
                  color: Colors.white,
                  txtSize: 16,
                  weight: FontWeight.w700,
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: MyTheme.text_color_4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                onPressed: _addTaskForm,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _addTaskForm() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        final TextEditingController _titleController = TextEditingController();
        final TextEditingController _descriptionController = TextEditingController();
        DateTime _dueDate = DateTime.now();
        TaskStatus _selectedStatus = TaskStatus.pending; // Default to 'Pending'
        return Padding(
          padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom, top: 20),
          child: SingleChildScrollView(
            child:Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Add Skills",
                    style: TextStyle(
                      fontSize: 20,
                      color: MyTheme.text_color_1,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent, width: 0.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: MyTheme.text_color_5, width: 1.0),
                        ),
                        contentPadding: EdgeInsets.fromLTRB(20, 10, 10, 10),
                        filled: true,
                        hintStyle: TextStyle(color: MyTheme.text_color_1, fontSize: 16, fontWeight: FontWeight.w400),
                        labelStyle: TextStyle(color: MyTheme.text_color_3, fontSize: 14),
                        labelText: "Title",
                        fillColor: MyTheme.bg
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _descriptionController,
                    minLines: 3,
                    maxLines: 10,
                    decoration: const InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent, width: 0.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: MyTheme.text_color_5, width: 1.0),
                        ),
                        contentPadding: EdgeInsets.fromLTRB(20, 10, 10, 10),
                        filled: true,
                        hintStyle: TextStyle(color: MyTheme.text_color_1, fontSize: 16, fontWeight: FontWeight.w400),
                        labelStyle: TextStyle(color: MyTheme.text_color_3, fontSize: 14),
                        labelText: "Description",
                        fillColor: MyTheme.bg
                    ),
                    // decoration: InputDecoration(labelText: 'Description'),
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () => _selectDueDate(context, _dueDate),
                    child: InputDecorator(
                      decoration: const InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent, width: 0.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: MyTheme.text_color_5, width: 1.0),
                          ),
                          contentPadding: EdgeInsets.fromLTRB(20, 10, 10, 10),
                          filled: true,
                          hintStyle: TextStyle(color: MyTheme.text_color_1, fontSize: 16, fontWeight: FontWeight.w400),
                          labelStyle: TextStyle(color: MyTheme.text_color_3, fontSize: 14),
                          labelText: "Due Date",
                          fillColor: MyTheme.bg
                      ),
                      child: Text(DateFormat('yyyy-MM-dd').format(_dueDate)),
                    ),
                  ),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<TaskStatus>(
                    value: _selectedStatus,
                    decoration: const InputDecoration(
                      labelText: "Status",
                      filled: true,
                      fillColor: MyTheme.bg,
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent, width: 0.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: MyTheme.text_color_5, width: 1.0),
                      ),
                      contentPadding: EdgeInsets.fromLTRB(20, 10, 10, 10),
                    ),
                    items: TaskStatus.values.map((TaskStatus status) {
                      return DropdownMenuItem<TaskStatus>(
                        value: status,
                        child: Text(
                          status.toString().split('.').last.replaceAll(RegExp(r'_'), ' '),
                          style: const TextStyle(fontSize: 16),
                        ),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      if (newValue != null) {
                        _selectedStatus = newValue;
                      }
                    },
                  ),
                  Container(
                      padding: EdgeInsets.only(top: 20),
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButtonTheme(
                          data: ElevatedButtonThemeData(
                              style: ElevatedButton.styleFrom(
                                  minimumSize: Size(MediaQuery.of(context).size.width, 50)
                              )
                          ),
                          child: ElevatedButton(
                            child: TextWidget(
                              txt: "Save",
                              color: Colors.white,
                              txtSize: 16,
                              weight:FontWeight.w700,
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: MyTheme.text_color_4,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6)
                              ),
                            ),
                            onPressed: () {

                              if (_titleController.text.isEmpty || _titleController.text.length > 50) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Title is required and must be at most 50 characters.'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                                return;
                              }

                              if (_dueDate == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Due Date is required.'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                                return;
                              }

                              final newTask = TaskModel(
                                title: _titleController.text,
                                description: _descriptionController.text,
                                dueDate: _dueDate,
                                status: _selectedStatus,
                              );

                              _taskBloc.createTask(newTask);
                              Navigator.of(context).pop();
                            },
                          )
                      )
                  ),
                ],
              ),
            )
          )
        );
      },
    );
  }

  void _showTaskForm(TaskModel task) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        print("Task Key: ${task.key}");  // This should print a valid key after the task is saved
        final TextEditingController _titleController = TextEditingController(text: task.title);
        final TextEditingController _descriptionController = TextEditingController(text: task.description);
        DateTime _dueDate = task.dueDate;
        TaskStatus _selectedStatus = task.status; // Set initial status from the task

        return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom, top: 20),
            child: SingleChildScrollView(
            child:Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Add Skills",
                    style: TextStyle(
                      fontSize: 20,
                      color: MyTheme.text_color_1,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent, width: 0.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: MyTheme.text_color_5, width: 1.0),
                        ),
                        contentPadding: EdgeInsets.fromLTRB(20, 10, 10, 10),
                        filled: true,
                        hintStyle: TextStyle(color: MyTheme.text_color_1, fontSize: 16, fontWeight: FontWeight.w400),
                        labelStyle: TextStyle(color: MyTheme.text_color_3, fontSize: 14),
                        labelText: "Title",
                        fillColor: MyTheme.bg
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _descriptionController,
                    minLines: 3,
                    maxLines: 10,
                    decoration: const InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent, width: 0.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: MyTheme.text_color_5, width: 1.0),
                        ),
                        contentPadding: EdgeInsets.fromLTRB(20, 10, 10, 10),
                        filled: true,
                        hintStyle: TextStyle(color: MyTheme.text_color_1, fontSize: 16, fontWeight: FontWeight.w400),
                        labelStyle: TextStyle(color: MyTheme.text_color_3, fontSize: 14),
                        labelText: "Description",
                        fillColor: MyTheme.bg
                    ),
                    // decoration: InputDecoration(labelText: 'Description'),
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () => _selectDueDate(context, _dueDate),
                    child: InputDecorator(
                      decoration: const InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent, width: 0.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: MyTheme.text_color_5, width: 1.0),
                          ),
                          contentPadding: EdgeInsets.fromLTRB(20, 10, 10, 10),
                          filled: true,
                          hintStyle: TextStyle(color: MyTheme.text_color_1, fontSize: 16, fontWeight: FontWeight.w400),
                          labelStyle: TextStyle(color: MyTheme.text_color_3, fontSize: 14),
                          labelText: "Due Date",
                          fillColor: MyTheme.bg
                      ),
                      child: Text(DateFormat('yyyy-MM-dd').format(_dueDate)),
                    ),
                  ),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<TaskStatus>(
                    value: _selectedStatus,
                    decoration: const InputDecoration(
                      labelText: "Status",
                      filled: true,
                      fillColor: MyTheme.bg,
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent, width: 0.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: MyTheme.text_color_5, width: 1.0),
                      ),
                      contentPadding: EdgeInsets.fromLTRB(20, 10, 10, 10),
                    ),
                    items: TaskStatus.values.map((TaskStatus status) {
                      return DropdownMenuItem<TaskStatus>(
                        value: status,
                        child: Text(
                          status.toString().split('.').last.replaceAll(RegExp(r'_'), ' '),
                          style: const TextStyle(fontSize: 16),
                        ),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      if (newValue != null) {
                        _selectedStatus = newValue;
                      }
                    },
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 20),
                    width: MediaQuery.of(context).size.width,
                    child: ElevatedButtonTheme(
                      data: ElevatedButtonThemeData(
                          style: ElevatedButton.styleFrom(
                              minimumSize: Size(MediaQuery.of(context).size.width, 50)
                          )
                      ),
                      child: ElevatedButton(
                        child: TextWidget(
                          txt: "Save",
                          color: Colors.white,
                          txtSize: 16,
                          weight:FontWeight.w700,
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: MyTheme.text_color_4,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6)
                          ),
                        ),
                        onPressed: () {
                          if (_titleController.text.isEmpty || _titleController.text.length > 50) {
                            showMessage(
                              context,
                              "Failed",
                              "Title is required and must be at most 50 characters.",
                              backgroundColor: redColor,
                              buttonColor: redColor,
                              buttonTextColor: whiteColor,
                              onClick: () {
                                Navigator.of(context).pop();
                              },
                            );
                            return;
                          }

                          task.title = _titleController.text;
                          task.description =  _descriptionController.text;
                          task.dueDate = _dueDate;
                          task.status = _selectedStatus;
                          bloc.updateTask(task);
                          Navigator.of(context).pop();
                        },
                      )
                    )
                  ),
                ],
              ),
            )
          )
        );
      },
    );
  }
}
