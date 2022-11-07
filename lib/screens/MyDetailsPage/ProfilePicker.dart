// import 'dart:io';

// import 'package:flutter/src/widgets/container.dart';
// import 'package:flutter/src/widgets/framework.dart';

// import 'ProfilePicture.dart';

// class ProfilePIcker extends StatefulWidget {
//  final File image;

//   const ProfilePIcker({super.key, required this.image});

//   @override
//   State<ProfilePIcker> createState() => _ProfilePIckerState();
// }

// class _ProfilePIckerState extends State<ProfilePIcker> {
//   @override
//   Widget build(BuildContext context) {
//     return  Container(
//           child: widget.image.isAbsolute
//               ? ProfilePicture(image: widget.image!, onReset: onReset)
//               : GestureDetector(
//                   onTap: () => onReset(),
//                   child: Container(
//                     width: 110,
//                     height: 115,
//                     child: Stack(children: [
//                       Center(
//                         child: Container(
//                           // margin: EdgeInsets.only(top: 5, bottom: 5),
//                           decoration: BoxDecoration(
//                               color: Colors.white,
//                               border: Border.all(width: 2, color: Colors.white),
//                               borderRadius: const BorderRadius.all(
//                                 Radius.circular(50),
//                               ),
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: Colors.grey.shade400.withOpacity(.6),
//                                   blurRadius: 5.0,
//                                 ),
//                               ]),
//                           child: ClipOval(
//                             // borderRadius: BorderRadius.all(
//                             //   Radius.circular(15),
//                             // ),
//                             child: profileUrlKey.isEmpty
//                                 ? Image.asset(
//                                     "assets/images/depositphotos_137014128-stock-illustration-user-profile-icon.jpg",
//                                     width: 95,
//                                     height: 95,
//                                     fit: BoxFit.cover,
//                                   )
//                                 : Image.network(
//                                     "h${globals.url}/images/$profileUrlKey",
//                                     width: 95,
//                                     height: 95,
//                                     fit: BoxFit.cover,
//                                   ),
//                           ),
//                         ),
//                       ),
//                       Positioned(
//                           right: 8,
//                           bottom: 0,
//                           child: Container(
//                               width: 30,
//                               height: 30,
//                               decoration: BoxDecoration(
//                                 boxShadow: [
//                                   BoxShadow(
//                                     color: Colors.grey.shade400.withOpacity(.6),
//                                     blurRadius: 5.0,
//                                   ),
//                                 ],
//                                 color: const Color.fromARGB(255, 159, 222, 249),
//                                 border:
//                                     Border.all(width: 2, color: Colors.white),
//                                 borderRadius: const BorderRadius.all(
//                                   Radius.circular(20),
//                                 ),
//                               ),
//                               child: const Center(
//                                   child: Icon(
//                                 Icons.camera_alt_rounded,
//                                 size: 20,
//                                 color: Color.fromARGB(255, 255, 255, 255),
//                               ))))
//                     ]),
//                   )),
//         ),
//   }
// }
