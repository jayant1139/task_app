import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:task_app/data/database.dart';
import 'package:task_app/pages/login.dart';

import 'package:task_app/pages/view_tasks.dart';
import 'package:intl/intl.dart';
import 'package:task_app/pages/widget/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:task_app/common/Notification_service.dart';
import 'package:task_app/pages/widget/saveTasks.dart';

enum TaskPriority {
  Low,
  Medium,
  High,
}

enum Categories { work, personal, shopping, health }

class Task {
  final String title;
  final String description;
  final DateTime dueDate;
  final TimeOfDay reminderTime;
  bool isComplete;
  TaskPriority priority;
  Categories category;
  // final String userId;

  // TasksPage userId=TasksPage(userEmail: userEmail;)
  Task({
    required this.title,
    required this.description,
    required this.dueDate,
    required this.reminderTime,
    this.isComplete = false,
    this.priority = TaskPriority.Low,
    this.category = Categories.personal,
  });

  static List<Task> fromJsonList(List<Map<String, dynamic>> jsonList) {
    List<Task> tasks = [];
    for (var json in jsonList) {
      tasks.add(Task.fromJson(json));
    }
    return tasks;
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      title: json["title"],
      description: json["description"],
      dueDate: DateTime.parse(json["dueDate"]),
      reminderTime: TimeOfDay(
        hour: int.parse(json["reminderTime"].split(":")[0]),
        minute: int.parse(json["reminderTime"].split(":")[1]),
      ),
      isComplete: json["isComplete"],
      priority: TaskPriority.values[json["priority"]],
      category: Categories.values[json["category"]],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "description": description,
      "dueDate": dueDate.toString(),
      "reminderTime": "${reminderTime.hour}:${reminderTime.minute}",
      "isComplete": isComplete,
      "priority": priority.toString(),
      "category": category.toString(),
    };
  }

  static int comparePriority(TaskPriority a, TaskPriority b) {
    // Assign priority values to integers for comparison
    final priorityValues = {
      TaskPriority.Low: 2,
      TaskPriority.Medium: 1,
      TaskPriority.High: 0,
    };

    // Compare the priority values of tasks 'a' and 'b'
    return priorityValues[a]!.compareTo(priorityValues[b]!);
  }

  void toggleCompleted() {
    isComplete = !isComplete;
  }
}

void viewTask(BuildContext context, Task task) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => TaskDetailsPage(task: task),
    ),
  );
}

enum TaskSortCriteria {
  dueDate,
  priority,
}

class TasksPage extends StatefulWidget {
  const TasksPage({Key? key}) : super(key: key);

  @override
  _TasksPageState createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  List<Task> filteredTasksByEmail = [];
  bool sortByDueDate = false;
  bool sortByPriority = false;

  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance?.addObserver(this);
    loadTasks();
  }

  void loadTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(prefs.getString('tasks'));
    final storedTasks = prefs.getString('tasks');

    print("Load StoredTasks: $storedTasks");
    if (storedTasks != null) {
      final List<dynamic> tasksJson =
          json.decode(storedTasks); //as List<Map<String, dynamic>>
      final tasksJsonString = jsonEncode(tasksJson);

      // filteredTasksByEmail = tasks.where((task) => task.userId == widget.userEmail).toList();

      print("Decoding tasks: $tasksJsonString");
      setState(() {
        print("tasks PRinting: ");
        for (final task in tasks) {
          print('Task Title: ${task.title}');
          print('Description: ${task.description}');
          print('Due Date: ${task.dueDate}');
          print('Reminder Time: ${task.reminderTime}');
          print('Is Complete: ${task.isComplete}');
          print('Is Complete: ${task.priority}');
          print('Category: ${task.category}');
          print('-------------------');
        }
        tasks = tasksJson.map((json) => Task.fromJson(json)).toList();
        print("Setting tasks: ");
        for (final task in tasks) {
          print('Task Title: ${task.title}');
          print('Description: ${task.description}');
          print('Due Date: ${task.dueDate}');
          print('Reminder Time: ${task.reminderTime}');
          print('Is Complete: ${task.isComplete}');
          print('Is Complete: ${task.priority}');
          print('Category: ${task.category}');
          print('-------------------');
        }
      });
    }
    print("loadtask runned");
  }

  void saveTasks(List<Task> tasks) async {
    print('Running save tasks tasks');
    for (final task in tasks) {
      print('Task Title: ${task.title}');
      print('Description: ${task.description}');
      print('Due Date: ${task.dueDate}');
      print('Reminder Time: ${task.reminderTime}');
      print('Is Complete: ${task.isComplete}');
      print('Is Complete: ${task.priority}');
      print('Category: ${task.category}');
      print('-------------------');
    }
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<Map<String, dynamic>> tasksJson =
          tasks.map((task) => task.toJson()).toList();
      String tasksString = json.encode(tasksJson);
      print("Printing tasksString before Saving: $tasksString");
      await prefs.setString('tasks', tasksString);
      print("after saving");
      print(prefs.getString('tasks'));
      print('Tasks saved to SharedPreferences');
    } catch (e) {
      print('Error saving tasks to SharedPreferences: $e');
    }

    // print(tasksString);
    print("function saveTasks runned");
  }

  void _toggleSortByDueDate() {
    setState(() {
      sortByDueDate = !sortByDueDate;
      sortByPriority = false; // Reset sorting by priority
      // Perform the sorting logic here based on the sortByDueDate value
    });
  }

  void _toggleSortByPriority() {
    setState(() {
      sortByPriority = !sortByPriority;
      sortByDueDate = false; // Reset sorting by due date
      // Perform the sorting logic here based on the sortByPriority value
    });
  }
/* below code is just for passing default task. */
List<Task>tasks=[];
  // List<Task> tasks = [
  //   Task(
  //     title: 'title',
  //     description: 'description',
  //     dueDate: DateTime(2023, 5, 6),
  //     reminderTime: TimeOfDay(hour: 5, minute: 45),
  //     isComplete: false,
  //     priority: TaskPriority.Low,
  //     category: Categories.personal,
  //     // userId: userEmail;
  //   )
  //   //  list of tasks will store here
  // ];

  String selectedCategoryValue = '';
  List<Task> get filteredTasks {
    return tasks
        .where((task) =>
            task.title
                .toLowerCase()
                .contains(selectedCategoryValue.toLowerCase()) ||
            task.description
                .toLowerCase()
                .contains(selectedCategoryValue.toLowerCase()) ||
            task.category
                .toString()
                .contains(selectedCategoryValue.toLowerCase()))
        .toList();
  }

  TaskSortCriteria sortCriteria = TaskSortCriteria.dueDate;

  int activeIndex = 0;
  @override
  Widget build(BuildContext context) {
    _sortTasks();
    return Scaffold(
      appBar: AppBar(
        title: Text('Tasks'),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Sort by:'),
                DropdownButton<TaskSortCriteria>(
                  value: sortCriteria,
                  onChanged: (value) {
                    setState(() {
                      sortCriteria = value!;
                    });
                  },
                  dropdownColor: Colors.black,
                  items: TaskSortCriteria.values.map((criteria) {
                    return DropdownMenuItem<TaskSortCriteria>(
                      value: criteria,
                      child: Container(
                        // color: Colors
                        //     .white, // Set the container background color to black
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            _getSortCriteriaText(criteria),
                            style: TextStyle(
                                color: Color.fromARGB(255, 255, 255, 255)),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              _openSearchDialog(); // Open search functionality
            },
          ),

        ],
      ),
      body: ListView.builder(
        itemCount: filteredTasks.length, //filteredTask for filtering
        itemBuilder: (context, index) {
          final task = filteredTasks[index]; //filteredTasks

          return Container(
            margin: const EdgeInsets.only(
              bottom: 0,
              left: 10,
              right: 10,
              top: 10,
            ),
            decoration: BoxDecoration(
              color: task.isComplete
                  ? Color.fromARGB(255, 151, 255, 153).withOpacity(0.3)
                  : Color.fromARGB(181, 164, 193, 255).withOpacity(1),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Color.fromARGB(186, 137, 136, 136).withOpacity(0.4),

                  blurRadius: 15.0, // soften the shadow
                  spreadRadius: 5, //extend the shadow
                  offset: Offset(
                    5, // Move to right 5  horizontally
                    5, // Move to bottom -5 Vertically
                  ),
                )
              ],
            ),
            child: ListTile(
              leading: Checkbox(
                value: task.isComplete,
                onChanged: (value) {
                  // Handle checkbox onChanged event here

                  setState(() {
                    task.toggleCompleted();
                    saveTasks(tasks);
                    // Save tasks when a checkbox is toggled
                  });
                  // value= task.isComplete,
                },
              ),
              title: DefaultTextStyle(
                style: TextStyle(
                  color: Colors.black,
                ),
                child: Text(task.title),
              ),
              subtitle: Text(trimDescription(task.description, 30)),
              trailing: PopupMenuButton(
                onSelected: (value) {
                  if (value == 'edit') {
                    _editTask(task);
                  } else if (value == 'delete') {
                    _deleteTask(index);
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(value: 'edit', child: Text('Edit')),
                  PopupMenuItem(value: 'delete', child: Text('Delete')),
                ],
              ),
              onTap: () {
                // _editTask(task);
                viewTask(context, task);
              },
              // onLongPress: () {
              //   setState(() {
              //     task.toggleCompleted();
              //     saveTasks(tasks);
              //   });
              // },
              
              // tileColor: task.isComplete
              //     ? Color.fromARGB(255, 151, 255, 153).withOpacity(0.3)
              //     : Color.fromARGB(181, 164, 193, 255).withOpacity(1),
            ),
          );
        },
      ),
      // floatingActionButton: FloatingActionButton(
      //   child: Icon(Icons.add),
      //   onPressed: () {
      //     _createTask();
      //   },
      // ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 10,
              spreadRadius: 5,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),

          child: BottomNavigationBar(
            backgroundColor: kwhite,
            selectedItemColor: Colors.blueAccent,
            unselectedItemColor: Colors.grey,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_rounded, size: 30),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.logout_rounded,
                  size: 30,
                ),
                label: 'Logout',
              ),
            ],
            currentIndex: activeIndex,
            onTap: (index) async {
              // List<String>tasks=
              saveTasks(tasks);

              Navigator.pushNamedAndRemoveUntil(
                context,
                '/login',
                (route) => false,
              );
              setState(() {
                activeIndex = index;
                //   if(index==1){
                saveTasks(tasks);
              });
            },
          ),
          // bottomNavigationBar:
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _createTask();
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        backgroundColor: kdark,
        child: Icon(
          Icons.add,
          color: klgihtgrey,
          size: 35,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  void _sortTasks() {
    tasks.sort((a, b) {
      switch (sortCriteria) {
        case TaskSortCriteria.dueDate:
          return a.dueDate.compareTo(b.dueDate);
        case TaskSortCriteria.priority:
          return Task.comparePriority(a.priority, b.priority);
        // Implement sorting by priority
      }
    });
  }

  String _getSortCriteriaText(TaskSortCriteria criteria) {
    switch (criteria) {
      case TaskSortCriteria.dueDate:
        return 'Due Date';
      case TaskSortCriteria.priority:
        return 'Priority';
    }
  }

  void _createTask() async {
    final newTask = await showDialog<Task>(
      context: context,
      builder: (context) => TaskDialog(),
    );

    if (newTask != null) {
      setState(() {
        tasks.add(newTask);
        saveTasks(tasks);
      });
    }
  }

  void _editTask(Task task) async {
    final editedTask = await showDialog<Task>(
      context: context,
      builder: (context) => TaskDialog(task: task),
    );

    if (editedTask != null) {
      setState(() {
        final index = tasks.indexOf(task);
        tasks[index] = editedTask;
        saveTasks(tasks);
      });
    }
  }

  void _deleteTask(int index) {
    setState(() {
      tasks.removeAt(index);
      saveTasks(tasks);
    });
  }

  void _openSearchDialog() {
    showGeneralDialog(
      context: context,
      pageBuilder: (BuildContext buildContext, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(40)),
          child: AlertDialog(
            title: Text('Search Tasks'),
            content: TextField(
              onChanged: (value) {
                setState(() {
                  selectedCategoryValue = value;
                });
              },
              decoration:const InputDecoration(
                hintText: 'Enter title, description, category',
                border: InputBorder.none,
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.blue,
                    width: 1, // Adjust the width as desired
                  ),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.blue,
                    width: 1.0, // Adjust the width as desired
                  ),
                ),
              ),
            ),
            actions: [
              TextButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text('Search'),
                onPressed: () {
                  setState(() {});

                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
      transitionBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation, Widget child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: Offset(0, 1),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOut,
          )),
          child: child,
        );
      },
      transitionDuration: Duration(milliseconds: 600),
    );
  }

  DateTime _getReminderDateTime(Task task) {
    final now = DateTime.now();
    return DateTime(
      task.dueDate.year,
      task.dueDate.month,
      task.dueDate.day,
      task.reminderTime.hour,
      task.reminderTime.minute,
    ).subtract(Duration(hours: now.hour, minutes: now.minute));
  }
}

class TaskCategory {
  final String name;

  TaskCategory(this.name);
}

class TaskDialog extends StatefulWidget {
  final Task? task;

  const TaskDialog({Key? key, this.task}) : super(key: key);

  @override
  _TaskDialogState createState() => _TaskDialogState();
}

class _TaskDialogState extends State<TaskDialog> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late DateTime _selectedDueDate;
  late TimeOfDay _selectedReminderTime;
  TaskPriority _selectedPriority = TaskPriority.Low;
  Categories _selectedCategory = Categories.personal;
 NotificationServices notificationServices = NotificationServices();
  @override
  void initState() {
    super.initState();
    notificationServices.initialiseNotifications();
    if (widget.task != null) {
      final task = widget.task!;
      _titleController = TextEditingController(text: task.title);
      _descriptionController = TextEditingController(text: task.description);
      _selectedDueDate = task.dueDate;
      _selectedReminderTime = task.reminderTime;
      _selectedPriority = task.priority;
      _selectedCategory = task.category;
    } else {
      _titleController = TextEditingController();
      _descriptionController = TextEditingController();
      _selectedDueDate = DateTime.now();
      _selectedReminderTime = TimeOfDay.now();
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.task != null ? 'Edit Task' : 'Create Task',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 12),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(
              height: 12,
            ),
            DropdownButtonFormField<Categories>(
              value: _selectedCategory,
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value!;
                });
              },
              items: Categories.values.map((category) {
                return DropdownMenuItem<Categories>(
                  value: category,
                  child: Text(category.toString().split('.').last),
                );
              }).toList(),
              decoration: InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 12),
            DropdownButton<TaskPriority>(
              value: _selectedPriority,
              onChanged: (value) {
                setState(() {
                  _selectedPriority = value!;
                });
              },
              items: TaskPriority.values.map((priority) {
                return DropdownMenuItem<TaskPriority>(
                  value: priority,
                  child: Text(priority.toString().split('.').last),
                );
              }).toList(),
            ),
            SizedBox(height: 12),
            ListTile(
              title: Text('Due Date'),
              subtitle: Text(_selectedDueDate.toString().split(' ')[0]),
              onTap: () {
                _selectDueDate();
              },
            ),
            SizedBox(height: 12),
            ListTile(
              title: Text('Reminder Time'),
              subtitle: Text(_selectedReminderTime.format(context)),
              onTap: () {
                _selectReminderTime();
              },
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _saveTask();
                 notificationServices.sendNotification(
                    'Task has been created', 'Task created');
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDueDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDueDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDueDate = pickedDate;
      });
    }
  }

  Future<void> _selectReminderTime() async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: _selectedReminderTime,
    );

    if (pickedTime != null) {
      setState(() {
        _selectedReminderTime = pickedTime;
      });
    }
  }

  void _saveTask() {
    final title = _titleController.text.trim();
    final description = _descriptionController.text.trim();

    if (title.isNotEmpty) {
      final task = Task(
        title: title,
        description: description,
        dueDate: _selectedDueDate,
        reminderTime: _selectedReminderTime,
        priority: _selectedPriority,
        category: _selectedCategory,
        // userId: ;
      );
      print('_saveTask() running');

      List<Task> tasks = [];

      tasks.add(task);
      saveTasks(tasks);
      for (final task in tasks) {
        print('Task Title: ${task.title}');
        print('Description: ${task.description}');
        print('Due Date: ${task.dueDate}');
        print('Reminder Time: ${task.reminderTime}');
        print('Is Complete: ${task.isComplete}');
        print('Category: ${task.category}');
        print('-------------------');
      }

      Navigator.of(context).pop(task);
    }
  }
}

String trimDescription(String description, int maxLength) {

  if (description.length <= maxLength) {
    // If the number of words is already 10 or less, return the original description
    return description;
  } else {
    // If the number of words is more than 10, return the trimmed description
    // final trimmedWords = words.sublist(0, 10);
    final trimmedDescription = description.substring(0, maxLength);
    return '$trimmedDescription...';
  }
}

class MyApp extends StatelessWidget {
  // final String Id;
  @override
  Widget build(BuildContext context) {
    // initializeNotifications();

    return MaterialApp(
      title: 'Task Manager',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TasksPage(
          // userEmail: Id,
          ), //showReminderNotification: _showReminderNotification
    );
  }
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(MyApp());
  });
}
