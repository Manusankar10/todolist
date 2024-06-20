
import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading:IconButton(icon:const Icon(Icons.arrow_back_ios,), onPressed: () {   Navigator.pop(context); }, ),
        title: const Text('notify'),
      ),
      );
  }
}