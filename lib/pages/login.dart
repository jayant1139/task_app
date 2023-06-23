import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:task_app/common/theme_helper.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
// import 'profile_page.dart';

import 'registration.dart';
import 'widget/header_widget.dart';
import 'package:task_app/pages/create_task.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final double _headerHeight = 250;
  Key _formKey = GlobalKey<FormState>();
  // final Color _accentColor = HexColor('#2838C2');

  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  Future<void> _login() async {
    final String email = _usernameController.text.trim();
    final String password = _passwordController.text.trim();

    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    final String? storedUsersJson = sharedPreferences.getString('users');

    List<RegisteredUser> users = [];
    if (storedUsersJson != null) {
      final List<dynamic> decodedList = json.decode(storedUsersJson);
      users = decodedList
          .map((dynamic json) => RegisteredUser.fromJson(json))
          .toList();
    }

    final authenticatedUser = users.firstWhere(
      (user) => user.email == email && user.password == password,
      orElse: () => RegisteredUser(email: '', password: ''),
    );

    if (authenticatedUser.email.isNotEmpty &&
        authenticatedUser.password.isNotEmpty) {
      final List<Task> tasks =[]; // Replace this with the actual list of tasks
      final tasksJson = tasks.map((task) => task.toJson()).toList();
      sharedPreferences.setString('tasks_${authenticatedUser.email}', json.encode(tasksJson));
     
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TasksPage(),
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Invalid username or password.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: _headerHeight,
              child: HeaderWidget(_headerHeight, true, Icons.login_rounded),
            ),
            SafeArea(
              child: Container(
                padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: Column(
                  children: [
                    Text(
                      'Hello',
                      style:
                          TextStyle(fontSize: 60, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Sign in to your account',
                      style: TextStyle(color: Colors.grey),
                    ),
                    SizedBox(height: 30.0),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Container(
                            child: TextField(
                              controller: _usernameController,
                              decoration: ThemeHelper().textInputDecoration(
                                'Email',
                                'Enter your email address',
                              ),
                            ),
                            decoration:
                                ThemeHelper().inputBoxDecorationShaddow(),
                          ),
                          SizedBox(height: 30.0),
                          Container(
                            child: TextField(
                              controller: _passwordController,
                              obscureText: true,
                              decoration: ThemeHelper().textInputDecoration(
                                'Password',
                                'Enter your password',
                              ),
                            ),
                            decoration:
                                ThemeHelper().inputBoxDecorationShaddow(),
                          ),
                          SizedBox(height: 15.0),
                          Container(
                            margin: EdgeInsets.fromLTRB(10, 0, 10, 20),
                            alignment: Alignment.topRight,
                            child: GestureDetector(
                              onTap: () {
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //     builder: (context) => ForgotPasswordPage(),
                                //   ),
                                // );
                              },
                              child: Text(
                                "Forgot your password?",
                                style: TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            decoration:
                                ThemeHelper().buttonBoxDecoration(context),
                            child: ElevatedButton(
                              style: ThemeHelper().buttonStyle(),
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
                                child: Text(
                                  'Sign In'.toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              onPressed: _login,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(10, 20, 10, 20),
                            child: Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: "Don\'t have an account? ",
                                  ),
                                  TextSpan(
                                    text: 'Create',
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                RegistrationPage(),
                                          ),
                                        );
                                      },
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(255, 133, 7, 244),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
