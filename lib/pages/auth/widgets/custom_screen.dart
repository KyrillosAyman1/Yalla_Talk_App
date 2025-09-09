
import 'package:flutter/material.dart';
import 'package:yalla_talk_app/pages/auth/widgets/custom_background.dart';


class CustomScreen extends StatefulWidget {
const  CustomScreen({super.key, required this.title, required this.widgetData});

  final String title;
  final Widget widgetData;
  @override
  State<CustomScreen> createState() => _CustomScreenState();
}

class _CustomScreenState extends State<CustomScreen> {

  @override
  Widget build(BuildContext context) {
    return Stack(
  alignment: Alignment.bottomCenter,
  children: [
     CustomBackground(title: widget.title ), // الباكجراوند المخصص

    Positioned(
      bottom: 0,
      right: 0,
      left: 0,
      top: MediaQuery.of(context).size.height * 0.23,
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(0, -3),
              blurRadius: 20,
            ),
          ],
          borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
          color: Colors.white,
          //.withAlpha((0.7 * 255).round()),
        ),
        height: MediaQuery.of(context).size.height * 0.75,
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: widget.widgetData,
        ),
      ),
    ),
  ],
);

  }
}
