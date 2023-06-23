import 'package:flutter/material.dart';
import 'package:task_app/pages/create_task.dart';

// import 'package:hive_flutter/hive_flutter.dart';
import 'package:task_app/pages/login.dart';
// import 'package:task_app/pages/profile_page.dart';
import 'pages/splash_screen.dart';
import 'package:flutter/services.dart';
// import 'package:hexcolor/hexcolor.dart';
import 'package:task_app/pages/widget/constant.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:timezone/data/latest.dart' as tz;
// import 'package:timezone/timezone.dart' as tz;

 
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
    // Get the application documents directory


  runApp(LoginUiApp());

  // Close Hive when the app is disposed
  
}


class HexColor extends Color {
  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));

  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }
}
final Color _accentColor = HexColor('#2838C2');
final MaterialColor customSwatch = MaterialColor(
    _accentColor.value,
    <int, Color>{
      50: _accentColor.withOpacity(0.1),
      100: _accentColor.withOpacity(0.2),
      200: _accentColor.withOpacity(0.3),
      300: _accentColor.withOpacity(0.4),
      400: _accentColor.withOpacity(0.5),
      500: _accentColor.withOpacity(0.6),
      600: _accentColor.withOpacity(0.7),
      700: _accentColor.withOpacity(0.8),
      800: _accentColor.withOpacity(0.9),
      900: _accentColor.withOpacity(1.0),
    },
  );
class LoginUiApp extends StatelessWidget {


  // final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  //     FlutterLocalNotificationsPlugin();

  // Future<void> initializeNotifications() async {
  //   const AndroidInitializationSettings androidInitializationSettings =
  //       AndroidInitializationSettings('app_icon');
  //   final IOSInitializationSettings iosInitializationSettings =
  //       IOSInitializationSettings();
  //   final InitializationSettings initializationSettings =
  //       InitializationSettings(
  //     android: androidInitializationSettings,
  //     iOS: iosInitializationSettings,
  //   );
  //   await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  // }

  
  // Future<void> _showReminderNotification(
  //     String title, String body, DateTime scheduledDateTime) async {
  //   const AndroidNotificationDetails androidPlatformChannelSpecifics =
  //       AndroidNotificationDetails(
  //     'reminder_channel', // Replace with your channel ID
  //     'Reminder Channel', // Replace with your channel name
  //     'Channel for task reminders', // Replace with your channel description
  //     importance: Importance.high,
  //     priority: Priority.high,
  //   );
  //   const IOSNotificationDetails iosPlatformChannelSpecifics =
  //       IOSNotificationDetails();
  //   const NotificationDetails platformChannelSpecifics = NotificationDetails(
  //     android: androidPlatformChannelSpecifics,
  //     iOS: iosPlatformChannelSpecifics,
  //   );

  //   tz.initializeTimeZones();
  //   final location = tz.getLocation('Asia/Kolkata'); // Indian Standard Time (IST)
  //   final currentTimeZone = await tz.TZDateTime.now(location);
  //   final utcOffset = currentTimeZone.timeZoneOffset;
  //   final scheduledTime = tz.TZDateTime.from(scheduledDateTime, location).add(utcOffset);

  //   await flutterLocalNotificationsPlugin.zonedSchedule(
  //     0, // Notification ID
  //     title,
  //     body,
  //     scheduledTime,
  //     platformChannelSpecifics,
  //     payload: 'reminder', // Optional payload value
  //     uiLocalNotificationDateInterpretation:
  //         UILocalNotificationDateInterpretation.absoluteTime,
  //     androidAllowWhileIdle: true,
  //     matchDateTimeComponents: DateTimeComponents.time,
  //   );
  // }

  // This widget is the root of your application.
 
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark));
    return MaterialApp(
        title: 'Flutter Login UI',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          // primaryColor: _primaryColor,
          primaryColor: _accentColor,
          scaffoldBackgroundColor: kwhite,
          // colorScheme: Color.fromARGB(131, 255, 200, 3),
          // scaffoldBackgroundColor: Colors.grey.shade100,
          primarySwatch: customSwatch,
        ),
        // home: SplashScreen(title: 'Flutter Login UI'),
         home: LoginPage(), //showReminderNotification: _showReminderNotification
        routes: {
          '/login': (context) => LoginPage(),
          // '/profile': (context) => ProfilePage(),
    //       '/home': (context){
    //           // final logged_in_user_email = getLoggedInUserEmail(); // Call the method to retrieve the logged-in user's email
    // return TasksPage(authenticatedUser:aut); //logged_in_user_email: logged_in_user_email
    //       },
        });
  }
}
