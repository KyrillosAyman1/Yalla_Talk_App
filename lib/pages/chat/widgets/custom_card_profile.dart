import 'package:flutter/material.dart';

class CustomCardProfile extends StatelessWidget {
  const CustomCardProfile({super.key, required this.title, required this.subtitle, required this.icon});
  final String title;
  final String subtitle;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.primaryContainer,
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        subtitle: Text(subtitle, style: TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }
}
