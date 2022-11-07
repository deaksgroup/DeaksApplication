import 'dart:io';

import 'package:flutter/material.dart';

class ProfilePicture extends StatefulWidget {
  final File image;
  final VoidCallback onReset;
  const ProfilePicture({super.key, required this.image, required this.onReset});

  @override
  State<ProfilePicture> createState() => _ProfilePictureState();
}

class _ProfilePictureState extends State<ProfilePicture> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => widget.onReset(),
        child: SizedBox(
          width: 110,
          height: 115,
          child: Stack(children: [
            Center(
              child: Container(
                // margin: EdgeInsets.only(top: 5, bottom: 5),
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(width: 2, color: Colors.white),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(50),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade400.withOpacity(.6),
                        blurRadius: 5.0,
                      ),
                    ]),
                child: ClipOval(
                  // borderRadius: BorderRadius.all(
                  //   Radius.circular(15),
                  // ),
                  child: Image.file(
                    widget.image,
                    width: 95,
                    height: 95,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Positioned(
                right: 8,
                bottom: 0,
                child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade400.withOpacity(.6),
                          blurRadius: 5.0,
                        ),
                      ],
                      color: const Color.fromARGB(255, 159, 222, 249),
                      border: Border.all(width: 2, color: Colors.white),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(20),
                      ),
                    ),
                    child: const Center(
                        child: Icon(
                      Icons.camera_alt_rounded,
                      size: 20,
                      color: Color.fromARGB(255, 255, 255, 255),
                    ))))
          ]),
        ));
  }
}
