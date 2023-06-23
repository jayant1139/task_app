import 'package:flutter/material.dart';
import 'package:task_app/pages/create_task.dart';
import 'package:intl/intl.dart';

class TaskDetailsPage extends StatefulWidget {
  final Task task;

  const TaskDetailsPage({Key? key, required this.task}) : super(key: key);

  @override
  _TaskDetailsPageState createState() => _TaskDetailsPageState();
}

class _TaskDetailsPageState extends State<TaskDetailsPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MMMM dd, yyyy');

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task.title),
        backgroundColor: Color.fromARGB(255, 47, 0, 255),
      ),
      backgroundColor: Color.fromARGB(255, 255, 255, 255), // Set the background color to purple
      body: FadeTransition(
        opacity: _opacityAnimation,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      widget.task.title,
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 0, 0, 0).withOpacity(0.5),
                      ),
                    ),
                  ),
                  Text(
                    'Due Date - ${dateFormat.format(widget.task.dueDate)}',
                    style: TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0).withOpacity(0.8),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        'Priority - ',
                        style: TextStyle(
                          color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.8),
                         
                        ),
                      ),
                      Text(
                        widget.task.priority.toString().split('.').last,
                        style: TextStyle(
                          color: const Color.fromARGB(255, 47, 0, 255).withOpacity(0.6),
                           fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        'Category - ',
                        style: TextStyle(
                          color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.8),
                          
                        ),
                      ),
                      Text(
                        widget.task.category.toString().split('.').last,
                        style: TextStyle(
                          color:const Color.fromARGB(255, 47, 0, 255).withOpacity(0.6),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 30),
              Container(
                margin: EdgeInsets.only(top: 16.0),
                child: Text(
                  '${widget.task.description}',
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
