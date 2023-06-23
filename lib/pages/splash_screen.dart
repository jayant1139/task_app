// import 'dart:async';

// import 'dart:developer';

// import 'package:hexcolor/hexcolor.dart';
// import 'package:flutter/material.dart';
// import 'package:task_app/pages/create_task.dart';

// import 'package:get/get.dart';
// import 'login.dart';
// import 'package:hive/hive.dart';
// class SplashScreen extends StatefulWidget {
//   SplashScreen({Key? key, required this.title}) : super(key: key);

//   final String title;

//   @override
//   _SplashScreenState createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> {
//   // bool _isVisible = false;
//   String finalEmail='';
//   _SplashScreenState() {
//     //   Timer(Duration(milliseconds: 1), () {
//     //   setState(() {
//     //     _isVisible =
//     //         true; // Now it is showing fade effect and navigating to Login page
//     //   });
//     // });
//    Timer(const Duration(milliseconds: 1), () {
//       setState(() {
//         Navigator.of(context).pushAndRemoveUntil(
//             MaterialPageRoute(builder: (context) => LoginPage()),
//             (route) => false,);
//         getValidationData().then((Value) async {
//            log('getValidationData completed');
//            log('Final Email: $finalEmail'); 
         
//            Timer(Duration(seconds: 2), () => Get.to(TasksPage())); //logged_in_user_email: finalEmail//changed Homepage to Myhomepage
        
//         });
//       });
//     });

   
//   }
//   final Color _accentColor = HexColor('#8A02AE');

// Future<void> getValidationData() async {
//   final Box<String> sharedPreferencesBox = Hive.box<String>('user_credentials');
//   final obtainedEmail = sharedPreferencesBox.get('email');
//   setState(() {
//     finalEmail = obtainedEmail ?? '';
//   });
//   log('Final Email: $finalEmail');
//   // Add your desired logic here
// }


//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration:  BoxDecoration(
//         gradient:  LinearGradient(
//           colors: [_accentColor, Theme.of(context).primaryColor],
//           begin: const FractionalOffset(0, 0),
//           end: const FractionalOffset(1.0, 0.0),
//           stops:const [0.0, 1.0],
//           tileMode: TileMode.clamp,
//         ),
//       ),
//       child: AnimatedOpacity(
//         opacity: /*_isVisible ? 1 :*/ 0,
//         duration:const Duration(milliseconds: 1),
//         child: Center(
//           child: Container(
//             height: 140.0,
//             width: 140.0,
//             child: Center(
//               child: ClipOval(
//                 child: Image.asset(
//                   "images/prf.jpg",
//                   width: 900,
//                   height: 900,
//                 ),

//                 // )
//                 // child: Icon(Icons.android_outlined, size: 128,), //put your logo here
//               ),
//             ),
//             decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: Colors.white,
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.3),
//                     blurRadius: 2.0,
//                     offset: Offset(5.0, 3.0),
//                     spreadRadius: 2.0,
//                   )
//                 ]),
//           ),
//         ),
//       ),
//     );
//   }
// }
