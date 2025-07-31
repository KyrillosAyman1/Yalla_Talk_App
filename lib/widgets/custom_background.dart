import 'package:flutter/material.dart';
import 'package:yalla_talk_app/constants.dart';

class CustomBackground extends StatelessWidget {
  const CustomBackground({super.key, required this.title});
  final String title;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: mainGradient,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 70),
        child: Text(
          title,

          style: TextStyle(
            color: Colors.white,
            fontSize: 40,
            fontWeight: FontWeight.bold,
            fontFamily: "lobster",
          ),
        ),
      ),
    );
  }
}
