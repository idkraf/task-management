import 'package:flutter/material.dart';
import 'package:task_management/my_theme.dart';
import 'package:task_management/utility/colors.dart';
import 'package:task_management/bloc/task_bloc.dart' as task_bloc;
import 'package:provider/provider.dart'; // Import for ThemeProvider

import '../model/standard_list_model.dart';
import '../theme_provider.dart'; // Import your ThemeProvider

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  String? _selectedColor;
  String _searchQuery = '';
  int _currentPage = 1;
  int total_pages = 1;
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _loadInitialTasks();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 6 &&
        !_isLoadingMore) {
      if (_currentPage != total_pages)
        _loadMoreTasks();
    }
  }

  void _loadInitialTasks() {
    task_bloc.bloc.fetchTasks(_currentPage, (models) {
      total_pages = models.total_pages!;
    });
  }

  Future<void> _loadMoreTasks() async {
    if (_isLoadingMore) return;

    setState(() {
      _isLoadingMore = true;
    });

    task_bloc.bloc.fetchTasks(_currentPage + 1, (models) {
      setState(() {
        if (models.data != null) {
          _currentPage++;
        }
        _isLoadingMore = false;
      });
    });
  }

  void _filterTasks() {
    setState(() {
      _searchQuery = _searchController.text.toLowerCase();
    });
  }

  void _applyColorFilter(String? color) {
    setState(() {
      _selectedColor = color;
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
            value: _selectedColor,
            hint: const Text('Filter'),
            onChanged: _applyColorFilter,
            items: ['all', '#D94F70', '#C74375', '#BF1932', '#7BC4C4'] // Example colors
                .map((color) => DropdownMenuItem(
              value: color,
              child: Text(color),
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<StandardListModels>(
                stream: task_bloc.bloc.getMyTask,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting &&
                      !_isLoadingMore) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.data!.isEmpty) {
                    return const Center(child: Text('No tasks found.'));
                  }

                  final tasks = snapshot.data!.data!
                      .where((task) =>
                  (_searchQuery.isEmpty ||
                      task['name']
                          .toLowerCase()
                          .contains(_searchQuery)) &&
                      (_selectedColor == null ||
                          _selectedColor == 'all' ||
                          task['color'] == _selectedColor))
                      .toList();

                  if (tasks.isEmpty) {
                    return const Center(child: Text('No tasks match filters.'));
                  }

                  return ListView.builder(
                    controller: _scrollController,
                    itemCount: tasks.length + 1,
                    itemBuilder: (context, index) {
                      if (index == tasks.length) {
                        return _isLoadingMore
                            ? const Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            child: CircularProgressIndicator(),
                          ),
                        )
                            : const SizedBox.shrink();
                      }

                      return Card(
                        margin: const EdgeInsets.only(top: 16),
                        color: whiteColor,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: ListTile(
                          title: Text(
                            tasks[index]['name'],
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: MyTheme.text_color_1,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Color: ' + tasks[index]['color'],
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: MyTheme.text_color_3,
                                ),
                              ),
                              Text(
                                tasks[index]['pantone_value'],
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: MyTheme.text_color_3,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                tasks[index]['year'].toString(),
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: MyTheme.text_color_1,
                                ),
                              ),
                              const SizedBox(height: 16),
                            ],
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
  }
}
