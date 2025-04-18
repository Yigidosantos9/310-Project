import 'package:flutter/material.dart';

class PopUpFolderMenu extends StatelessWidget {
  const PopUpFolderMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
    icon: const Icon(Icons.more_vert, color: Colors.white),
    onSelected: (value) {
      print("Selected: $value");
    },
    itemBuilder: (context) => [
      const PopupMenuItem(value: 'ns102', child: Text('NS102'),),
      const PopupMenuItem(value: 'ns101', child: Text('NS101')),
      const PopupMenuItem(value: 'math101', child: Text('MATH101')),
      const PopupMenuItem(value: 'math102', child: Text('MATH102')),
      const PopupMenuItem(value: 'hist191', child: Text('HIST191')),
      const PopupMenuItem(value: 'hist192', child: Text('HIST192')),
    ],
  );
  }
}